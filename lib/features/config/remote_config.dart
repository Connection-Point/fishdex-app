import '../../core/api/json.dart';
import '../catalogue/data/species.dart';

/// GET /app/config — reference data and AI availability.
class RemoteConfig {
  const RemoteConfig({
    required this.minSupportedVersion,
    required this.country,
    required this.aiTier,
    required this.scanningAvailable,
    required this.consentRequired,
    required this.rarityTiers,
    required this.habitats,
    required this.regions,
    this.nextCapacityReset,
  });

  final String minSupportedVersion;
  final String country;
  final String aiTier;
  final bool scanningAvailable;
  final bool consentRequired;
  final DateTime? nextCapacityReset;
  final List<Rarity> rarityTiers;
  final List<NamedCode> habitats;
  final List<NamedCode> regions;

  factory RemoteConfig.fromJson(Json j) {
    final ai = j.obj('ai') ?? const {};
    return RemoteConfig(
      minSupportedVersion: j.str('min_supported_version', '0.0.0'),
      country: j.str('country', 'MY'),
      aiTier: ai.str('tier', 'free'),
      scanningAvailable: ai.boolean('scanning_available', true),
      consentRequired: ai.boolean('consent_required'),
      nextCapacityReset: ai.date('next_capacity_reset'),
      rarityTiers: j.objList('rarity_tiers').map((t) => Rarity.fromJson(t)!).toList(),
      habitats: j.objList('habitats').map(NamedCode.fromJson).toList(),
      regions: j.objList('regions').map(NamedCode.fromJson).toList(),
    );
  }
}
