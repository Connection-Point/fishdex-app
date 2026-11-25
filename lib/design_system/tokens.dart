import 'package:material_ui/material_ui.dart';

/// FishDex dark-ocean palette (doc 06 §4). Original branding — no third-party TCG assets.
abstract final class FdColors {
  static const abyss = Color(0xFF040B16); // app background
  static const deep = Color(0xFF0A1A2E); // surfaces
  static const reef = Color(0xFF11263F); // raised surfaces
  static const current = Color(0xFF1B3A5C); // outlines
  static const lagoon = Color(0xFF2EC4B6); // primary
  static const glow = Color(0xFF7CF6FF); // bioluminescent accent
  static const sand = Color(0xFFE9DFC7); // warm text accent
  static const foam = Color(0xFFE6F1FF); // primary text
  static const mist = Color(0xFF8FA6C1); // secondary text
  static const coral = Color(0xFFFF6B6B); // errors / protected
  static const gold = Color(0xFFF5B700);

  /// Fallback rarity colours if the API hasn't loaded yet (server is the source of truth).
  static const rarity = {
    'common': Color(0xFF9AA5B1),
    'uncommon': Color(0xFF2FBF71),
    'rare': Color(0xFF2D7FF9),
    'epic': Color(0xFF9B5DE5),
    'legendary': Color(0xFFF5B700),
  };

  static Color fromHex(String? hex, {Color fallback = mist}) {
    if (hex == null) return fallback;
    final clean = hex.replaceFirst('#', '');
    final value = int.tryParse(clean.length == 6 ? 'FF$clean' : clean, radix: 16);
    return value == null ? fallback : Color(value);
  }
}

abstract final class FdSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class FdRadius {
  static const card = 18.0;
  static const chip = 10.0;
  static const field = 14.0;
}

/// Rarity icon so rarity is never conveyed by colour alone (accessibility, PRD §8).
IconData rarityIcon(String code) => switch (code) {
  'uncommon' => Icons.change_history_rounded,
  'rare' => Icons.diamond_outlined,
  'epic' => Icons.auto_awesome_outlined,
  'legendary' => Icons.workspace_premium_outlined,
  _ => Icons.circle_outlined,
};
