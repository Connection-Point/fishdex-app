import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../core/api/api_exception.dart';
import '../../../design_system/tokens.dart';
import '../../../design_system/widgets/feedback.dart';
import '../../../l10n/app_localizations.dart';
import '../auth_controller.dart';
import 'auth_scaffold.dart';
import 'validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await _run(() => ref.read(authControllerProvider.notifier).login(_email.text, _password.text));
  }

  Future<void> _google() => _run(() => ref.read(authControllerProvider.notifier).loginWithGoogle());

  Future<void> _run(Future<Object?> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.isNetwork ? AppLocalizations.of(context).loadError : e.message);
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgot() async {
    final l = AppLocalizations.of(context);
    if (Validators(l).email(_email.text) != null) {
      _form.currentState!.validate();
      return;
    }
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(_email.text);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.resetSent)));
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final v = Validators(l);
    final google = ref.watch(googleAuthProvider);

    return AuthScaffold(
      title: l.loginTitle,
      subtitle: l.loginSubtitle,
      child: Form(
        key: _form,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('login.email'),
                controller: _email,
                decoration: InputDecoration(labelText: l.email, prefixIcon: const Icon(Icons.alternate_email_rounded)),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: v.email,
              ),
              const SizedBox(height: FdSpace.md),
              TextFormField(
                key: const Key('login.password'),
                controller: _password,
                decoration: InputDecoration(labelText: l.password, prefixIcon: const Icon(Icons.lock_outline_rounded)),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                validator: v.required,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _busy ? null : _forgot, child: Text(l.forgotPassword)),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: FdSpace.md),
                  child: Text(
                    _error!,
                    key: const Key('login.error'),
                    style: const TextStyle(color: FdColors.coral),
                  ),
                ),
              FilledButton(
                key: const Key('login.submit'),
                onPressed: _busy ? null : _submit,
                child: _busy ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.4)) : Text(l.signIn),
              ),
              if (google.isAvailable) ...[
                const SizedBox(height: FdSpace.lg),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: FdSpace.md),
                      child: Text(l.or, style: const TextStyle(color: FdColors.mist)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: FdSpace.lg),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _google,
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 30),
                  label: Text(l.continueWithGoogle),
                ),
              ],
              const SizedBox(height: FdSpace.xl),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(l.noAccount, style: const TextStyle(color: FdColors.mist)),
                  TextButton(key: const Key('login.toRegister'), onPressed: () => context.go('/register'), child: Text(l.createAccount)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
