import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../config.dart';
import '../storage/token_store.dart';
import 'api_exception.dart';

/// Thin wrapper over Dio for the FishDex REST API (doc 07).
///
/// - adds bearer token, Accept-Language, X-App-Version and X-Device-Id
/// - adds an Idempotency-Key to POSTs that need one
/// - converts every failure into [ApiException]
/// - calls [onUnauthenticated] on 401 so the app can sign out
class ApiClient {
  ApiClient({required this.tokens, String? baseUrl, Dio? dio, this.localeCode = 'en', this.onUnauthenticated}) : dio = dio ?? Dio() {
    this.dio.options
      ..baseUrl = baseUrl ?? AppConfig.apiBaseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 30)
      ..responseType = ResponseType.json
      ..headers['Accept'] = 'application/json';

    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokens.readToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          options.headers['Accept-Language'] = localeCode;
          options.headers['X-App-Version'] = AppConfig.appVersion;
          options.headers['X-Device-Id'] = await tokens.deviceId();
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
  final TokenStore tokens;
  String localeCode;
  void Function()? onUnauthenticated;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => dio.get<dynamic>(path, queryParameters: _clean(query)));

  Future<Map<String, dynamic>> post(String path, {Object? data, bool idempotent = false}) => _send(
    () => dio.post<dynamic>(
      path,
      data: data,
      options: Options(headers: {if (idempotent) 'Idempotency-Key': const Uuid().v4()}),
    ),
  );

  Future<Map<String, dynamic>> patch(String path, {Object? data}) => _send(() => dio.patch<dynamic>(path, data: data));

  Future<Map<String, dynamic>> delete(String path, {Object? data}) => _send(() => dio.delete<dynamic>(path, data: data));

  Future<Map<String, dynamic>> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      final body = response.data;
      return body is Map<String, dynamic> ? body : <String, dynamic>{};
    } on DioException catch (e) {
      final error = ApiException.fromDio(e);
      if (error.isUnauthenticated) onUnauthenticated?.call();
      throw error;
    }
  }

  Map<String, dynamic>? _clean(Map<String, dynamic>? query) {
    if (query == null) return null;
    return {
      for (final e in query.entries)
        if (e.value != null && '${e.value}'.isNotEmpty) e.key: e.value,
    };
  }
}
