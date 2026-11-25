import '../../../core/api/api_client.dart';
import 'species.dart';

class SpeciesQuery {
  const SpeciesQuery({this.q, this.waterType, this.origin, this.rarity, this.habitat});

  final String? q;
  final String? waterType;
  final String? origin;
  final String? rarity;
  final String? habitat;

  bool get isFiltered => [waterType, origin, rarity, habitat].any((v) => v != null);

  SpeciesQuery copyWith({String? q, Object? waterType = _keep, Object? origin = _keep, Object? rarity = _keep, Object? habitat = _keep}) =>
      SpeciesQuery(
        q: q ?? this.q,
        waterType: waterType == _keep ? this.waterType : waterType as String?,
        origin: origin == _keep ? this.origin : origin as String?,
        rarity: rarity == _keep ? this.rarity : rarity as String?,
        habitat: habitat == _keep ? this.habitat : habitat as String?,
      );

  Map<String, dynamic> toQuery() => {'q': q, 'water_type': waterType, 'origin': origin, 'rarity': rarity, 'habitat': habitat};

  @override
  bool operator ==(Object other) =>
      other is SpeciesQuery &&
      other.q == q &&
      other.waterType == waterType &&
      other.origin == origin &&
      other.rarity == rarity &&
      other.habitat == habitat;

  @override
  int get hashCode => Object.hash(q, waterType, origin, rarity, habitat);
}

const _keep = Object();

abstract class CatalogueRepository {
  Future<Page<SpeciesSummary>> search(SpeciesQuery query, {String? cursor, int limit = 20});
  Future<SpeciesDetail> detail(String id);
  Future<List<Family>> families();
}

class ApiCatalogueRepository implements CatalogueRepository {
  ApiCatalogueRepository(this._api);

  final ApiClient _api;

  @override
  Future<Page<SpeciesSummary>> search(SpeciesQuery query, {String? cursor, int limit = 20}) async {
    final body = await _api.get('/species', query: {...query.toQuery(), 'cursor': cursor, 'limit': limit});
    final items = (body['data'] as List).cast<Map<String, dynamic>>().map(SpeciesSummary.fromJson).toList();
    return Page(items, (body['meta'] as Map?)?['next_cursor'] as String?);
  }

  @override
  Future<SpeciesDetail> detail(String id) async => SpeciesDetail.fromJson((await _api.get('/species/$id'))['data'] as Map<String, dynamic>);

  @override
  Future<List<Family>> families() async =>
      ((await _api.get('/families'))['data'] as List).cast<Map<String, dynamic>>().map(Family.fromJson).toList();
}
