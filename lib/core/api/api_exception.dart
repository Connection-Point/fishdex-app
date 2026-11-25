import 'package:dio/dio.dart';

/// Typed error from the FishDex API (RFC 9457 problem+json with a stable `code`).
class ApiException implements Exception {
  ApiException({required this.status, required this.code, required this.message, this.fieldErrors = const {}, this.extra = const {}});

  /// HTTP status, or 0 when the server could not be reached.
  final int status;

  /// Machine-readable code, e.g. `invalid_credentials`, `scan_quota_exceeded`.
  final String code;

  /// Human-readable detail from the server (or a client-side fallback).
  final String message;

  /// Validation errors keyed by field name.
  final Map<String, List<String>> fieldErrors;

  /// Any extra problem members (e.g. `quota`, `min_supported_version`).
  final Map<String, dynamic> extra;

  bool get isNetwork => status == 0;
  bool get isUnauthenticated => status == 401;

  String? fieldError(String field) => fieldErrors[field]?.firstOrNull;

  factory ApiException.fromProblem(int status, Object? body) {
    if (body is Map<String, dynamic>) {
      final errors = <String, List<String>>{};
      final raw = body['errors'];
      if (raw is Map) {
        raw.forEach((k, v) {
          if (v is List) errors['$k'] = v.map((e) => '$e').toList();
        });
      }
      final known = {'type', 'title', 'status', 'detail', 'code', 'errors'};
      return ApiException(
        status: status,
        code: (body['code'] as String?) ?? 'http_$status',
        message: (body['detail'] as String?) ?? (body['message'] as String?) ?? 'Something went wrong.',
        fieldErrors: errors,
        extra: {
          for (final e in body.entries)
            if (!known.contains(e.key)) e.key: e.value,
        },
      );
    }
    return ApiException(status: status, code: 'http_$status', message: 'Something went wrong (HTTP $status).');
  }

  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    if (response != null) {
      return ApiException.fromProblem(response.statusCode ?? 0, response.data);
    }
    return ApiException(status: 0, code: 'network_error', message: 'Can\'t reach FishDex. Check your connection and try again.');
  }

  @override
  String toString() => 'ApiException($status, $code): $message';
}
