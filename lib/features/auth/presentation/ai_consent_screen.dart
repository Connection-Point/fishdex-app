import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/tokens.dart';
import '../../../design_system/widgets/feedback.dart';
import '../../../l10n/app_localizations.dart';
import '../auth_controller.dart';

/// Closed-beta notice (D-16): images go to Gemini's free tier. Required before the first scan.
class AiConsentScreen extends ConsumerStatefulWidget {
  const AiConsentScreen({super.key});

  @override
  ConsumerState<AiConsentScreen> createState() => _AiConsentScreenState();
}

class _AiConsentScreenState extends ConsumerState<AiConsentScreen> {
  bool _busy = false;

  Future<void> _accept() async {
    setState(() => _busy = true);
    try {
      await ref.read(authControllerProvider.notifier).acceptAiConsent();
      if (mounted) context.pop(true);
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    Widget point(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: FdSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: FdColors.lagoon, size: 22),
          const SizedBox(width: FdSpace.md),
          Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(FdSpace.xl),
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 48, color: FdColors.glow),
            const SizedBox(height: FdSpace.lg),
            Text(l.consentTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: FdSpace.md),
            Text(l.consentBody, style: const TextStyle(color: FdColors.mist, height: 1.45, fontSize: 15)),
            const SizedBox(height: FdSpace.xl),
            point(Icons.photo_camera_outlined, l.consentPoint1),
            point(Icons.privacy_tip_outlined, l.consentPoint2),
            point(Icons.delete_outline_rounded, l.consentPoint3),
            const SizedBox(height: FdSpace.xl),
            FilledButton(
              key: const Key('consent.accept'),
              onPressed: _busy ? null : _accept,
              child: _busy
                  ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
                  : Text(l.consentAccept),
            ),
            const SizedBox(height: FdSpace.sm),
            TextButton(onPressed: () => context.pop(false), child: Text(l.consentLater)),
          ],
        ),
      ),
    );
  }
}
