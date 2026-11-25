import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Persists the API token (Android Keystore-backed) and a stable device id.
abstract class TokenStore {
  Future<String?> readToken();
  Future<void> writeToken(String token);
  Future<void> clearToken();
  Future<String> deviceId();
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'fishdex.api_token';
  static const _deviceKey = 'fishdex.device_id';
  String? _cachedDeviceId;

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> writeToken(String token) => _storage.write(key: _tokenKey, value: token);

  @override
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  @override
  Future<String> deviceId() async {
    if (_cachedDeviceId != null) return _cachedDeviceId!;
    var id = await _storage.read(key: _deviceKey);
    if (id == null) {
      id = const Uuid().v4();
      await _storage.write(key: _deviceKey, value: id);
    }
    return _cachedDeviceId = id;
  }
}

/// In-memory store for tests and the contract test.
class MemoryTokenStore implements TokenStore {
  MemoryTokenStore({this.token});

  String? token;
  final String _device = const Uuid().v4();

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> writeToken(String value) async => token = value;

  @override
  Future<void> clearToken() async => token = null;

  @override
  Future<String> deviceId() async => _device;
}
