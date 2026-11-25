/// Build-time configuration, passed with --dart-define (see README).
///
/// Android emulator → host machine is 10.0.2.2. For a phone over USB run
/// `adb reverse tcp:8000 tcp:8000` and use http://127.0.0.1:8000/api/v1.
class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api/v1');

  /// Web OAuth client ID used as `serverClientId` so Google issues an ID token
  /// the backend can verify (must be listed in GOOGLE_CLIENT_IDS on the server).
  static const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

  static const appVersion = String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0+1');

  static bool get googleSignInEnabled => googleServerClientId.isNotEmpty;
}
