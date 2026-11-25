import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../core/storage/token_store.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/google_auth.dart';
import '../features/catalogue/data/catalogue_repository.dart';
import '../features/config/remote_config.dart';

/// Composition root. Tests override these with fakes.
final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

/// UI language: 'en' or 'ms'. Initialised from the device, then from the user profile.
final localeCodeProvider = NotifierProvider<LocaleCode, String>(LocaleCode.new);

class LocaleCode extends Notifier<String> {
  @override
  String build() => 'en';

  void set(String code) => state = (code == 'ms') ? 'ms' : 'en';
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(tokens: ref.watch(tokenStoreProvider));
  ref.listen(localeCodeProvider, (_, next) => client.localeCode = next, fireImmediately: true);
  return client;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(ref.watch(apiClientProvider), ref.watch(tokenStoreProvider)),
);

final googleAuthProvider = Provider<GoogleAuth>((ref) => PluginGoogleAuth());

final catalogueRepositoryProvider = Provider<CatalogueRepository>((ref) => ApiCatalogueRepository(ref.watch(apiClientProvider)));

final remoteConfigProvider = FutureProvider<RemoteConfig>((ref) async {
  final body = await ref.watch(apiClientProvider).get('/app/config');
  return RemoteConfig.fromJson(body['data'] as Map<String, dynamic>);
});
