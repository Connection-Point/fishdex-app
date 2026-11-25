import 'package:material_ui/material_ui.dart';

import '../../features/catalogue/data/species.dart';
import '../tokens.dart';

/// Colour + icon + label, so rarity is readable without colour vision.
class RarityBadge extends StatelessWidget {
  const RarityBadge({super.key, required this.rarity, this.compact = false});

  final Rarity? rarity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final r = rarity;
    if (r == null) return const SizedBox.shrink();
    final color = FdColors.fromHex(r.colorHex, fallback: FdColors.rarity[r.code] ?? FdColors.mist);

    return Semantics(
      label: 'Rarity: ${r.name}',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: compact ? 2 : 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(rarityIcon(r.code), size: compact ? 12 : 14, color: color),
            if (!compact) ...[
              const SizedBox(width: 4),
              Text(
                r.name.toUpperCase(),
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
