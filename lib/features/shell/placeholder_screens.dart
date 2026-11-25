import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../design_system/tokens.dart';
import '../../design_system/widgets/feedback.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';

/// FishDex grid — built in the next milestone (M5).
class DexPlaceholderScreen extends StatelessWidget {
  const DexPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navDex)),
      body: EmptyState(icon: Icons.style_outlined, message: l.comingSoon),
    );
  }
}

/// Journal — built in M5.
class JournalPlaceholderScreen extends StatelessWidget {
  const JournalPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navJournal)),
      body: EmptyState(icon: Icons.menu_book_outlined, message: l.comingSoon),
    );
  }
}

/// Scanner — camera flow comes in M4. For now: the AI-consent gate.
class ScanPlaceholderScreen extends ConsumerWidget {
  const ScanPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final consented = ref.watch(authControllerProvider).user?.betaAiConsent ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l.navScan)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(FdSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.center_focus_strong_rounded, size: 72, color: FdColors.lagoon),
              const SizedBox(height: FdSpace.lg),
              Text(l.scanIntro, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.4)),
              const SizedBox(height: FdSpace.xl),
              if (consented)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: FdColors.lagoon),
                    const SizedBox(width: FdSpace.sm),
                    Flexible(child: Text(l.scanningEnabled, key: const Key('scan.enabled'))),
                  ],
                )
              else
                FilledButton(key: const Key('scan.enable'), onPressed: () => context.push('/consent'), child: Text(l.enableScanning)),
              const SizedBox(height: FdSpace.lg),
              Text(l.comingSoon, style: const TextStyle(color: FdColors.mist)),
            ],
          ),
        ),
      ),
    );
  }
}
