import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/api/api_exception.dart';
import '../../../design_system/tokens.dart';
import '../../../design_system/widgets/feedback.dart';
import '../../../l10n/app_localizations.dart';
import '../auth_controller.dart';
import 'auth_scaffold.dart';
import 'validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _handle = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  /// Server-side validation errors (e.g. handle taken, breached password).
  Map<String, String> _serverErrors = {};

  @override
  void dispose() {
    for (final c in [_name, _handle, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _serverErrors = {});
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .register(email: _email.text, password: _password.text, displayName: _name.text, handle: _handle.text);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.fieldErrors.isNotEmpty) {
        setState(() => _serverErrors = {for (final f in e.fieldErrors.keys) f: e.fieldError(f)!});
        _form.currentState!.validate();
      } else {
        showErrorSnack(context, e);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String? Function(String?) _with(String field, String? Function(String?) local) =>
      (value) => local(value) ?? _serverErrors[field];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final v = Validators(l);

    return AuthScaffold(
      title: l.registerTitle,
      subtitle: l.loginSubtitle,
      onBack: () => context.go('/login'),
      child: Form(
        key: _form,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('register.name'),
                controller: _name,
                decoration: InputDecoration(labelText: l.displayName),
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                validator: _with('display_name', v.required),
              ),
              const SizedBox(height: FdSpace.md),
              TextFormField(
                key: const Key('register.handle'),
                controller: _handle,
                decoration: InputDecoration(labelText: l.handle, prefixText: '@', helperText: l.handleHelp),
                autofillHints: const [AutofillHints.newUsername],
                textInputAction: TextInputAction.next,
                validator: _with('handle', v.handle),
              ),
              const SizedBox(height: FdSpace.md),
              TextFormField(
                key: const Key('register.email'),
                controller: _email,
                decoration: InputDecoration(labelText: l.email),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: _with('email', v.email),
              ),
              const SizedBox(height: FdSpace.md),
              TextFormField(
                key: const Key('register.password'),
                controller: _password,
                decoration: InputDecoration(labelText: l.password, helperText: l.passwordHelp),
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                onFieldSubmitted: (_) => _submit(),
                validator: _with('password', v.newPassword),
              ),
              const SizedBox(height: FdSpace.xl),
              FilledButton(
                key: const Key('register.submit'),
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
                    : Text(l.createAccount),
              ),
              const SizedBox(height: FdSpace.lg),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(l.haveAccount, style: const TextStyle(color: FdColors.mist)),
                  TextButton(onPressed: () => context.go('/login'), child: Text(l.signIn)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
