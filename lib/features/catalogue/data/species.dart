import '../../../core/api/json.dart';

/// Backend-assigned game rarity (never from AI).
class Rarity {
  const Rarity({required this.code, required this.name, required this.sortOrder, required this.colorHex, required this.foil});

  final String code;
  final String name;
  final int sortOrder;
  final String colorHex;
  final String foil;

  bool get hasFoil => foil != 'none';

  static Rarity? fromJson(Json? j) => j == null
      ? null
      : Rarity(
          code: j.str('code'),
          name: j.str('name'),
          sortOrder: j.integer('sort_order'),
          colorHex: j.str('color', '#9AA5B1'),
          foil: j.str('foil', 'none'),
        );
}

class CardInfo {
  const CardInfo({required this.id, required this.set, required this.number, required this.variant, this.artUrl});

  final String id;
  final String set;
  final String number;
  final String variant;
  final String? artUrl;

  static CardInfo? fromJson(Json? j) => j == null
      ? null
      : CardInfo(id: j.str('id'), set: j.str('set'), number: j.str('number'), variant: j.str('variant'), artUrl: j.strOrNull('art_url'));
}

/// unseen → silhouette, seen → released/confirmed only, collected → card owned.
enum UserSpeciesState {
  unseen,
  seen,
  collected;

  static UserSpeciesState parse(String? v) => UserSpeciesState.values.firstWhere((s) => s.name == v, orElse: () => UserSpeciesState.unseen);
}

class SpeciesNames {
  const SpeciesNames({this.en, this.ms});

  final String? en;
  final String? ms;

  /// Malay first for a Malaysian audience when the UI is in Malay.
  String primary(String locale) => (locale == 'ms' ? (ms ?? en) : (en ?? ms)) ?? '';
  String? secondary(String locale) {
    final other = locale == 'ms' ? en : ms;
    return other == primary(locale) ? null : other;
  }

  factory SpeciesNames.fromJson(Json? j) => SpeciesNames(en: j?.strOrNull('en'), ms: j?.strOrNull('ms'));
}

class SpeciesSummary {
  const SpeciesSummary({
    required this.id,
    required this.scientificName,
    required this.names,
    required this.waterTypes,
    required this.userState,
    this.family,
    this.rarity,
    this.thumbnailUrl,
    this.card,
  });

  final String id;
  final String scientificName;
  final SpeciesNames names;
  final String? family;
  final List<String> waterTypes;
  final Rarity? rarity;
  final String? thumbnailUrl;
  final CardInfo? card;
  final UserSpeciesState userState;

  factory SpeciesSummary.fromJson(Json j) => SpeciesSummary(
    id: j.str('id'),
    scientificName: j.str('scientific_name'),
    names: SpeciesNames.fromJson(j.obj('names')),
    family: j.strOrNull('family'),
    waterTypes: j.strList('water_types'),
    rarity: Rarity.fromJson(j.obj('rarity')),
    thumbnailUrl: j.strOrNull('thumbnail_url'),
    card: CardInfo.fromJson(j.obj('card')),
    userState: UserSpeciesState.parse(j.strOrNull('user_state')),
  );
}

class NamedCode {
  const NamedCode(this.code, this.name);
  final String code;
  final String name;
  factory NamedCode.fromJson(Json j) => NamedCode(j.str('code'), j.str('name'));
}

class Alias {
  const Alias(this.name, this.locale, this.type);
  final String name;
  final String locale;
  final String type;
  factory Alias.fromJson(Json j) => Alias(j.str('name'), j.str('locale'), j.str('type'));
}

class Conservation {
  const Conservation(this.authority, this.status, this.year, this.sourceUrl);
  final String authority;
  final String status;
  final int? year;
  final String? sourceUrl;
  factory Conservation.fromJson(Json j) =>
      Conservation(j.str('authority'), j.str('status'), j['year'] == null ? null : j.integer('year'), j.strOrNull('source_url'));
}

class ReferenceImage {
  const ReferenceImage({required this.url, required this.license, this.attribution});
  final String url;
  final String license;
  final String? attribution;
  factory ReferenceImage.fromJson(Json j) =>
      ReferenceImage(url: j.str('url'), license: j.str('license'), attribution: j.strOrNull('attribution'));
}

class Lookalike {
  const Lookalike(this.id, this.scientificName, this.names);
  final String id;
  final String scientificName;
  final SpeciesNames names;
  factory Lookalike.fromJson(Json j) => Lookalike(j.str('id'), j.str('scientific_name'), SpeciesNames.fromJson(j.obj('names')));
}

class LegalNotice {
  const LegalNotice(this.protection, this.notes);
  final String protection;
  final String? notes;
}

class SpeciesDetail {
  const SpeciesDetail({
    required this.summary,
    required this.aliases,
    required this.genus,
    required this.habitats,
    required this.regions,
    required this.conservation,
    required this.images,
    required this.lookalikes,
    this.familyCommonName,
    this.description,
    this.identificationNotes,
    this.funFact,
    this.maxLengthCm,
    this.maxWeightKg,
    this.origin,
    this.legalNotice,
  });

  final SpeciesSummary summary;
  final List<Alias> aliases;
  final String genus;
  final String? familyCommonName;
  final String? description;
  final String? identificationNotes;
  final String? funFact;
  final double? maxLengthCm;
  final double? maxWeightKg;
  final List<NamedCode> habitats;
  final String? origin;
  final List<NamedCode> regions;
  final List<Conservation> conservation;
  final LegalNotice? legalNotice;
  final List<ReferenceImage> images;
  final List<Lookalike> lookalikes;

  factory SpeciesDetail.fromJson(Json j) {
    final taxonomy = j.obj('taxonomy') ?? const {};
    final distribution = j.obj('distribution') ?? const {};
    final legal = j.obj('legal_notice');
    return SpeciesDetail(
      summary: SpeciesSummary.fromJson(j),
      aliases: j.objList('aliases').map(Alias.fromJson).toList(),
      genus: taxonomy.str('genus'),
      familyCommonName: taxonomy.strOrNull('family_common_name'),
      description: j.strOrNull('description'),
      identificationNotes: j.strOrNull('identification_notes'),
      funFact: j.strOrNull('fun_fact'),
      maxLengthCm: j.dbl('max_length_cm'),
      maxWeightKg: j.dbl('max_weight_kg'),
      habitats: j.objList('habitats').map(NamedCode.fromJson).toList(),
      origin: distribution.strOrNull('origin'),
      regions: distribution.objList('regions').map(NamedCode.fromJson).toList(),
      conservation: j.objList('conservation').map(Conservation.fromJson).toList(),
      legalNotice: legal == null ? null : LegalNotice(legal.str('protection'), legal.strOrNull('notes')),
      images: j.objList('images').map(ReferenceImage.fromJson).toList(),
      lookalikes: j.objList('lookalikes').map(Lookalike.fromJson).toList(),
    );
  }
}

class Family {
  const Family(this.scientificName, this.commonName, this.speciesCount);
  final String scientificName;
  final String? commonName;
  final int speciesCount;
  factory Family.fromJson(Json j) => Family(j.str('scientific_name'), j.strOrNull('common_name'), j.integer('species_count'));
}

/// One page of a cursor-paginated list.
class Page<T> {
  const Page(this.items, this.nextCursor);
  final List<T> items;
  final String? nextCursor;
  bool get hasMore => nextCursor != null;
}
