/// Tiny, null-safe JSON readers so models stay readable without code generation.
typedef Json = Map<String, dynamic>;

extension JsonRead on Json {
  String str(String key, [String fallback = '']) => (this[key] as String?) ?? fallback;
  String? strOrNull(String key) => this[key] as String?;
  int integer(String key, [int fallback = 0]) => (this[key] as num?)?.toInt() ?? fallback;
  double? dbl(String key) => (this[key] as num?)?.toDouble();
  bool boolean(String key, [bool fallback = false]) => (this[key] as bool?) ?? fallback;
  Json? obj(String key) => this[key] is Map ? Map<String, dynamic>.from(this[key] as Map) : null;
  List<Json> objList(String key) => (this[key] as List?)?.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() ?? const [];
  List<String> strList(String key) => (this[key] as List?)?.map((e) => '$e').toList() ?? const [];
  DateTime? date(String key) => this[key] == null ? null : DateTime.tryParse('${this[key]}');
}
