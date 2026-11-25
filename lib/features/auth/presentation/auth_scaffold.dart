import 'package:material_ui/material_ui.dart';

import '../../../design_system/tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Shared layout for sign-in / sign-up: ocean gradient, wordmark, centred form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, required this.subtitle, required this.child, this.onBack});

  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B2A44), FdColors.abyss],
            stops: [0, 0.55],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(FdSpace.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (onBack != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded)),
                      ),
                    const _Wordmark(),
                    const SizedBox(height: FdSpace.sm),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: FdColors.glow.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          l.betaBadge.toUpperCase(),
                          style: const TextStyle(color: FdColors.glow, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(height: FdSpace.xxl),
                    Text(title, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: FdSpace.xs),
                    Text(subtitle, style: const TextStyle(color: FdColors.mist, fontSize: 16)),
                    const SizedBox(height: FdSpace.xl),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(colors: [FdColors.lagoon, FdColors.glow]),
        ),
        child: const Icon(Icons.set_meal_rounded, color: FdColors.abyss),
      ),
      const SizedBox(width: FdSpace.md),
      const Text('FishDex', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.8)),
    ],
  );
}
