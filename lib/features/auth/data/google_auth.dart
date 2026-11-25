import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config.dart';

/// Wraps google_sign_in 7.x so screens and tests don't depend on the plugin.
abstract class GoogleAuth {
  bool get isAvailable;

  /// Returns a Google ID token for the backend, or null if the user cancelled.
  Future<String?> signIn();

  Future<void> signOut();
}

class PluginGoogleAuth implements GoogleAuth {
  bool _initialized = false;

  @override
  bool get isAvailable => AppConfig.googleSignInEnabled;

  Future<void> _init() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(serverClientId: AppConfig.googleServerClientId);
    _initialized = true;
  }

  @override
  Future<String?> signIn() async {
    await _init();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.signOut();
  }
}
