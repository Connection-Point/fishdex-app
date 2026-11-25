import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Material 3 dark theme tuned for the FishDex ocean look.
ThemeData buildFishDexTheme() {
  const scheme = ColorScheme.dark(
    primary: FdColors.lagoon,
    onPrimary: FdColors.abyss,
    secondary: FdColors.glow,
    onSecondary: FdColors.abyss,
    surface: FdColors.deep,
    onSurface: FdColors.foam,
    surfaceContainerHighest: FdColors.reef,
    surfaceContainerHigh: FdColors.reef,
    surfaceContainer: FdColors.deep,
    outline: FdColors.current,
    outlineVariant: FdColors.current,
    error: FdColors.coral,
    onSurfaceVariant: FdColors.mist,
  );

  final base = ThemeData(colorScheme: scheme, useMaterial3: true, brightness: Brightness.dark);
  final text = base.textTheme.apply(bodyColor: FdColors.foam, displayColor: FdColors.foam);

  return base.copyWith(
    scaffoldBackgroundColor: FdColors.abyss,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: FdColors.abyss,
      foregroundColor: FdColors.foam,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: FdColors.deep,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FdRadius.card),
        side: const BorderSide(color: FdColors.current),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FdColors.deep,
      contentPadding: const EdgeInsets.symmetric(horizontal: FdSpace.lg, vertical: FdSpace.md + 2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FdRadius.field),
        borderSide: const BorderSide(color: FdColors.current),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FdRadius.field),
        borderSide: const BorderSide(color: FdColors.current),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FdRadius.field),
        borderSide: const BorderSide(color: FdColors.lagoon, width: 1.6),
      ),
      labelStyle: const TextStyle(color: FdColors.mist),
      helperStyle: const TextStyle(color: FdColors.mist),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FdRadius.field)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: FdColors.foam,
        side: const BorderSide(color: FdColors.current),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FdRadius.field)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: FdColors.deep,
      selectedColor: FdColors.lagoon.withValues(alpha: 0.22),
      side: const BorderSide(color: FdColors.current),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FdRadius.chip)),
      labelStyle: const TextStyle(color: FdColors.foam, fontWeight: FontWeight.w600),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: FdColors.deep,
      indicatorColor: FdColors.lagoon.withValues(alpha: 0.22),
      labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ),
    dividerTheme: const DividerThemeData(color: FdColors.current, thickness: 1),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: FdColors.reef,
      contentTextStyle: TextStyle(color: FdColors.foam),
    ),
  );
}
