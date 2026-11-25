@Tags(['contract'])
library;

import 'dart:io';

import 'package:fishdex/app/providers.dart';
import 'package:fishdex/core/api/api_client.dart';
import 'package:fishdex/core/api/api_exception.dart';
import 'package:fishdex/core/storage/token_store.dart';
import 'package:fishdex/features/auth/data/auth_repository.dart';
import 'package:fishdex/features/catalogue/data/catalogue_repository.dart';
import 'package:fishdex/features/config/remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs the real repositories against a live FishDex backend.
///
///   php artisan serve            (in fishdex-api, seeded)
///   flutter test test/contract --dart-define=... is not needed; use:
///   $env:FISHDEX_API="http://127.0.0.1:8000/api/v1"; flutter test test/contract
///
/// Skipped when FISHDEX_API isn't set.
void main() {
  final base = Platform.environment['FISHDEX_API'];
  final skip = base == null ? 'Set FISHDEX_API to run contract tests' : null;

  test('register → me → consent → catalogue → detail → logout', () async {
    final tokens = MemoryTokenStore();
    final api = ApiClient(tokens: tokens, baseUrl: base);
    final auth = ApiAuthRepository(api, tokens);
    final catalogue = ApiCatalogueRepository(api);
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(5);

    final config = RemoteConfig.fromJson((await api.get('/app/config'))['data'] as Map<String, dynamic>);
    expect(config.rarityTiers, isNotEmpty);

    final user = await auth.register(
      email: 'contract$suffix@fishdex.test',
      password: 'Contract-toman-$suffix!',
      displayName: 'Contract',
      handle: 'contract_$suffix',
      locale: 'ms',
    );
    expect(user.handle, 'contract_$suffix');
    expect(user.scanQuota, isNotNull);
    expect(await tokens.readToken(), isNotNull);

    expect((await auth.acceptAiConsent()).betaAiConsent, isTrue);

    final page = await catalogue.search(const SpeciesQuery(q: 'toman'));
    expect(page.items.first.scientificName, 'Channa micropeltes');

    final detail = await catalogue.detail(page.items.first.id);
    expect(detail.summary.rarity, isNotNull);
    expect(detail.habitats, isNotEmpty);

    final filtered = await catalogue.search(const SpeciesQuery(waterType: 'marine'));
    expect(filtered.items.every((s) => s.waterTypes.contains('marine')), isTrue);

    expect(await catalogue.families(), isNotEmpty);

    await auth.logout();
    expect(await tokens.readToken(), isNull);
    await expectLater(auth.me(), throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)));
  }, skip: skip);

  test('providers wire up against the live API', () async {
    final container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
        apiClientProvider.overrideWith((ref) => ApiClient(tokens: ref.watch(tokenStoreProvider), baseUrl: base)),
      ],
    );
    addTearDown(container.dispose);

    final config = await container.read(remoteConfigProvider.future);
    expect(config.country, 'MY');
  }, skip: skip);
}
