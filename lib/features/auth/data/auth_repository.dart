import '../../../core/api/api_client.dart';
import '../../../core/storage/token_store.dart';
import 'app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> restoreSession();
  Future<AppUser> login(String email, String password);
  Future<AppUser> register({
    required String email,
    required String password,
    required String displayName,
    required String handle,
    required String locale,
  });
  Future<AppUser> loginWithGoogle(String idToken);
  Future<AppUser> me();
  Future<AppUser> acceptAiConsent();
  Future<AppUser> updateProfile(Map<String, dynamic> changes);
  Future<void> requestPasswordReset(String email);
  Future<void> deleteAccount({String? password});
  Future<void> logout();
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._api, this._tokens);

  final ApiClient _api;
  final TokenStore _tokens;

  Future<String> _deviceName() async => 'android-${(await _tokens.deviceId()).substring(0, 8)}';

  Future<AppUser> _storeSession(Map<String, dynamic> body) async {
    final data = body['data'] as Map<String, dynamic>;
    await _tokens.writeToken(data['token'] as String);
    // /me includes the scan quota, which the auth responses don't.
    return me();
  }

  @override
  Future<AppUser?> restoreSession() async {
    if (await _tokens.readToken() == null) return null;
    try {
      return await me();
    } catch (_) {
      await _tokens.clearToken();
      return null;
    }
  }

  @override
  Future<AppUser> login(String email, String password) async => _storeSession(
    await _api.post('/auth/login', data: {'email': email.trim(), 'password': password, 'device_name': await _deviceName()}),
  );

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String displayName,
    required String handle,
    required String locale,
  }) async => _storeSession(
    await _api.post(
      '/auth/register',
      data: {
        'email': email.trim(),
        'password': password,
        'display_name': displayName.trim(),
        'handle': handle.trim(),
        'locale': locale,
        'device_name': await _deviceName(),
      },
    ),
  );

  @override
  Future<AppUser> loginWithGoogle(String idToken) async =>
      _storeSession(await _api.post('/auth/google', data: {'id_token': idToken, 'device_name': await _deviceName()}));

  @override
  Future<AppUser> me() async => AppUser.fromJson((await _api.get('/me'))['data'] as Map<String, dynamic>);

  @override
  Future<AppUser> acceptAiConsent() async {
    await _api.post('/me/ai-consent');
    return me();
  }

  @override
  Future<AppUser> updateProfile(Map<String, dynamic> changes) async {
    await _api.patch('/me', data: changes);
    return me();
  }

  @override
  Future<void> requestPasswordReset(String email) => _api.post('/auth/password/forgot', data: {'email': email.trim()});

  @override
  Future<void> deleteAccount({String? password}) async {
    await _api.delete('/me', data: {'confirmation': 'DELETE', if (password != null && password.isNotEmpty) 'password': password});
    await _tokens.clearToken();
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {
      // Token may already be invalid; signing out locally is what matters.
    }
    await _tokens.clearToken();
  }
}
