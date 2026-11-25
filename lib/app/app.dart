import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../design_system/theme.dart';
import '../features/auth/auth_controller.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router.dart';

class FishDexApp extends ConsumerStatefulWidget {
  const FishDexApp({super.key});

  @override
  ConsumerState<FishDexApp> createState() => _FishDexAppState();
}

class _FishDexAppState extends ConsumerState<FishDexApp> {
  @override
  void initState() {
    super.initState();
    // Start in the device language (Malay devices get BM), then restore the session.
    final device = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    Future.microtask(() {
      ref.read(localeCodeProvider.notifier).set(device);
      ref.read(authControllerProvider.notifier).restore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeCodeProvider);

    return MaterialApp.router(
      title: 'FishDex',
      debugShowCheckedModeBanner: false,
      theme: buildFishDexTheme(),
      themeMode: ThemeMode.dark,
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      // Material's plural `delegates` also registers Cupertino + Widgets localizations
      // (text-selection menus use Cupertino strings even on Android).
      localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
      routerConfig: router,
    );
  }
}
