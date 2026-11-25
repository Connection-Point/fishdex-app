import 'dart:convert';
import 'dart:io';

import 'package:fishdex/app/app.dart';
import 'package:fishdex/app/providers.dart';
import 'package:fishdex/core/api/api_exception.dart';
import 'package:fishdex/core/storage/token_store.dart';
import 'package:fishdex/features/auth/data/app_user.dart';
import 'package:fishdex/features/auth/data/auth_repository.dart';
import 'package:fishdex/features/auth/data/google_auth.dart';
import 'package:fishdex/features/catalogue/data/catalogue_repository.dart';
import 'package:fishdex/features/catalogue/data/species.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Size;

/// JSON captured from the real FishDex backend (see test/fixtures/README.md).
Map<String, dynamic> fixture(String name) => jsonDecode(File('test/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

AppUser fixtureUser({bool consented = false}) {
  final json = Map<String, dynamic>.from(fixture('me')['data'] as Map);
  json['beta_ai_consent'] = consented;
  return AppUser.fromJson(json);
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.restored, this.loginError});

  AppUser? restored;
  ApiException? loginError;
  AppUser? current;
  int consentCalls = 0;
  final calls = <String>[];

  @override
  Future<AppUser?> restoreSession() async => current = restored;

  @override
  Future<AppUser> login(String email, String password) async {
    calls.add('login:$email');
    if (loginError != null) throw loginError!;
    return current = fixtureUser();
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String displayName,
    required String handle,
    required String locale,
  }) async {
    calls.add('register:$handle');
    if (loginError != null) throw loginError!;
    return current = fixtureUser();
  }

  @override
  Future<AppUser> loginWithGoogle(String idToken) async => current = fixtureUser();

  @override
  Future<AppUser> me() async => current ?? fixtureUser();

  @override
  Future<AppUser> acceptAiConsent() async {
    consentCalls++;
    return current = fixtureUser(consented: true);
  }

  @override
  Future<AppUser> updateProfile(Map<String, dynamic> changes) async {
    final json = Map<String, dynamic>.from(fixture('me')['data'] as Map)..addAll(changes);
    return current = AppUser.fromJson(json);
  }

  @override
  Future<void> requestPasswordReset(String email) async => calls.add('reset:$email');

  @override
  Future<void> deleteAccount({String? password}) async => calls.add('delete');

  @override
  Future<void> logout() async => calls.add('logout');
}

class FakeGoogleAuth implements GoogleAuth {
  @override
  bool get isAvailable => false;
  @override
  Future<String?> signIn() async => null;
  @override
  Future<void> signOut() async {}
}

/// Serves the captured species list/detail fixtures, with simple client-side search.
class FixtureCatalogueRepository implements CatalogueRepository {
  final queries = <SpeciesQuery>[];

  @override
  Future<Page<SpeciesSummary>> search(SpeciesQuery query, {String? cursor, int limit = 20}) async {
    queries.add(query);
    final all = (fixture('species_list')['data'] as List).cast<Map<String, dynamic>>().map(SpeciesSummary.fromJson).toList()
      ..add(SpeciesDetail.fromJson(fixture('species_detail')['data'] as Map<String, dynamic>).summary);
    final q = query.q?.toLowerCase() ?? '';
    final items = all
        .where((s) => q.isEmpty || '${s.names.en} ${s.names.ms} ${s.scientificName}'.toLowerCase().contains(q))
        .where((s) => query.waterType == null || s.waterTypes.contains(query.waterType))
        .toList();
    return Page(items, null);
  }

  @override
  Future<SpeciesDetail> detail(String id) async => SpeciesDetail.fromJson(fixture('species_detail')['data'] as Map<String, dynamic>);

  @override
  Future<List<Family>> families() async => (fixture('families')['data'] as List).cast<Map<String, dynamic>>().map(Family.fromJson).toList();
}

Future<void> pumpApp(WidgetTester tester, {required FakeAuthRepository auth, CatalogueRepository? catalogue}) async {
  // Stops the looping foil animation so pumpAndSettle can settle.
  tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
        authRepositoryProvider.overrideWithValue(auth),
        googleAuthProvider.overrideWithValue(FakeGoogleAuth()),
        catalogueRepositoryProvider.overrideWithValue(catalogue ?? FixtureCatalogueRepository()),
      ],
      child: const FishDexApp(),
    ),
  );
  await tester.pumpAndSettle();
}
