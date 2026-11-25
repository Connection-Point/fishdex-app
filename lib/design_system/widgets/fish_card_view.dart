import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/catalogue/data/species.dart';
import '../tokens.dart';
import 'rarity_badge.dart';

/// The FishDex collectible card (original frame design).
///
/// Portrait 5:7 card: rarity-tinted frame, art window, bilingual name band,
/// scientific name, set + number and a rarity gem. Foil tiers get an animated
/// sheen; it is skipped when the OS asks to reduce motion.
class FishCardView extends StatefulWidget {
  const FishCardView({
    super.key,
    required this.scientificName,
    required this.primaryName,
    this.secondaryName,
    this.rarity,
    this.card,
    this.imageUrl,
    this.revealed = true,
    this.width = 260,
  });

  final String scientificName;
  final String primaryName;
  final String? secondaryName;
  final Rarity? rarity;
  final CardInfo? card;
  final String? imageUrl;

  /// false → silhouette ("not yet found") state.
  final bool revealed;
  final double width;

  @override
  State<FishCardView> createState() => _FishCardViewState();
}

class _FishCardViewState extends State<FishCardView> with SingleTickerProviderStateMixin {
  late final AnimationController _sheen = AnimationController(vsync: this, duration: const Duration(seconds: 4));

  bool get _hasFoil => widget.revealed && (widget.rarity?.hasFoil ?? false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_hasFoil && !reduceMotion) {
      if (!_sheen.isAnimating) _sheen.repeat();
    } else {
      _sheen.stop();
    }
  }

  @override
  void dispose() {
    _sheen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rarity = widget.rarity;
    final tint = widget.revealed
        ? FdColors.fromHex(rarity?.colorHex, fallback: FdColors.rarity[rarity?.code] ?? FdColors.mist)
        : FdColors.current;
    final w = widget.width;

    return Semantics(
      label: widget.revealed ? '${widget.primaryName} card, ${rarity?.name ?? ''}' : 'Undiscovered card',
      child: SizedBox(
        width: w,
        child: AspectRatio(
          aspectRatio: 5 / 7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.06),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tint, Color.lerp(tint, FdColors.abyss, 0.55)!, tint.withValues(alpha: 0.9)],
              ),
              boxShadow: [BoxShadow(color: tint.withValues(alpha: widget.revealed ? 0.35 : 0.1), blurRadius: 24, spreadRadius: 1)],
            ),
            padding: EdgeInsets.all(w * 0.03),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.045),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: FdColors.deep),
                  Column(
                    children: [
                      _header(w, tint),
                      Expanded(child: _artWindow(w, tint)),
                      _nameBand(w),
                    ],
                  ),
                  if (_hasFoil) _foil(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(double w, Color tint) => Padding(
    padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.04, w * 0.05, w * 0.02),
    child: Row(
      children: [
        Expanded(
          child: Text(
            widget.card == null ? 'FISHDEX' : '${widget.card!.set} · ${widget.card!.number}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: FdColors.mist, fontSize: w * 0.042, fontWeight: FontWeight.w700, letterSpacing: 1.2),
          ),
        ),
        if (widget.revealed) RarityBadge(rarity: widget.rarity, compact: w < 220),
      ],
    ),
  );

  Widget _artWindow(double w, Color tint) {
    final art = widget.imageUrl;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * 0.035),
        border: Border.all(color: tint.withValues(alpha: 0.6), width: 1.2),
        gradient: const RadialGradient(colors: [FdColors.reef, FdColors.abyss], radius: 0.9),
      ),
      clipBehavior: Clip.antiAlias,
      child: !widget.revealed
          ? Icon(Icons.set_meal_rounded, size: w * 0.38, color: FdColors.current)
          : art == null
          ? Icon(Icons.set_meal_rounded, size: w * 0.42, color: tint.withValues(alpha: 0.85))
          : CachedNetworkImage(
              imageUrl: art,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Icon(Icons.set_meal_rounded, size: w * 0.42, color: tint),
            ),
    );
  }

  Widget _nameBand(double w) => Padding(
    padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.035, w * 0.05, w * 0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.revealed ? widget.primaryName : '???',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: FdColors.foam, fontSize: w * 0.085, fontWeight: FontWeight.w900, height: 1.1),
        ),
        if (widget.revealed && widget.secondaryName != null)
          Text(
            widget.secondaryName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: FdColors.sand, fontSize: w * 0.05),
          ),
        SizedBox(height: w * 0.01),
        Text(
          widget.revealed ? widget.scientificName : '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: FdColors.mist, fontSize: w * 0.045, fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );

  Widget _foil() => IgnorePointer(
    child: AnimatedBuilder(
      animation: _sheen,
      builder: (context, _) {
        final t = _sheen.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.5 + 3 * t, -1),
              end: Alignment(-0.5 + 3 * t, 1),
              transform: GradientRotation(math.pi / 10),
              colors: [
                Colors.transparent,
                FdColors.glow.withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.22),
                const Color(0xFFFF9DE2).withValues(alpha: 0.10),
                Colors.transparent,
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ),
          ),
        );
      },
    ),
  );
}
