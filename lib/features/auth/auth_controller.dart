import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import 'data/app_user.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthState {
  const AuthState(this.status, [this.user]);

  final AuthStatus status;
  final AppUser? user;

  static const unknown = AuthState(AuthStatus.unknown);
  static const signedOut = AuthState(AuthStatus.signedOut);
}

/// Single source of truth for the session. The router listens to this.
final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Any 401 from the API signs the user out.
    ref.read(apiClientProvider).onUnauthenticated = () {
      if (state.status == AuthStatus.signedIn) _setSignedOut();
    };
    return AuthState.unknown;
  }

  Future<void> restore() async {
    final user = await ref.read(authRepositoryProvider).restoreSession();
    user == null ? _setSignedOut() : _setUser(user);
  }

  Future<void> login(String email, String password) async => _setUser(await ref.read(authRepositoryProvider).login(email, password));

  Future<void> register({required String email, required String password, required String displayName, required String handle}) async =>
      _setUser(
        await ref
            .read(authRepositoryProvider)
            .register(email: email, password: password, displayName: displayName, handle: handle, locale: ref.read(localeCodeProvider)),
      );

  /// Returns false if the user cancelled the Google sheet.
  Future<bool> loginWithGoogle() async {
    final idToken = await ref.read(googleAuthProvider).signIn();
    if (idToken == null) return false;
    _setUser(await ref.read(authRepositoryProvider).loginWithGoogle(idToken));
    return true;
  }

  Future<void> refreshUser() async => _setUser(await ref.read(authRepositoryProvider).me());

  Future<void> acceptAiConsent() async => _setUser(await ref.read(authRepositoryProvider).acceptAiConsent());

  Future<void> setLanguage(String code) async {
    ref.read(localeCodeProvider.notifier).set(code);
    if (state.status == AuthStatus.signedIn) {
      _setUser(await ref.read(authRepositoryProvider).updateProfile({'locale': code}));
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    await ref.read(googleAuthProvider).signOut();
    _setSignedOut();
  }

  Future<void> deleteAccount({String? password}) async {
    await ref.read(authRepositoryProvider).deleteAccount(password: password);
    await ref.read(googleAuthProvider).signOut();
    _setSignedOut();
  }

  void _setUser(AppUser user) {
    ref.read(localeCodeProvider.notifier).set(user.locale);
    state = AuthState(AuthStatus.signedIn, user);
  }

  void _setSignedOut() => state = AuthState.signedOut;
}
