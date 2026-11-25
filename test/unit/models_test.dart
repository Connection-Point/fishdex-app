import 'package:dio/dio.dart';
import 'package:fishdex/core/api/api_exception.dart';
import 'package:fishdex/features/auth/data/app_user.dart';
import 'package:fishdex/features/catalogue/data/species.dart';
import 'package:fishdex/features/config/remote_config.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Parses real backend responses, so model drift from the API shows up here.
void main() {
  test('user from /me includes quota and consent', () {
    final user = AppUser.fromJson(fixture('me')['data'] as Map<String, dynamic>);
    expect(user.handle, 'fixture_user');
    expect(user.country, 'MY');
    expect(user.betaAiConsent, isTrue);
    expect(user.scanQuota!.limit, greaterThan(0));
    expect(user.scanQuota!.resetsAt, isNotNull);
  });

  test('species list items parse with rarity, card and bilingual names', () {
    final items = (fixture('species_list')['data'] as List).cast<Map<String, dynamic>>().map(SpeciesSummary.fromJson).toList();
    expect(items, hasLength(3));
    for (final s in items) {
      expect(s.id, hasLength(26), reason: 'public ULIDs only');
      expect(s.names.en, isNotEmpty);
      expect(s.names.ms, isNotEmpty);
      expect(s.rarity, isNotNull);
      expect(s.card, isNotNull);
      expect(s.userState, UserSpeciesState.unseen);
    }
    expect(fixture('species_list')['meta']['next_cursor'], isNotNull);
  });

  test('species detail parses every section', () {
    final d = SpeciesDetail.fromJson(fixture('species_detail')['data'] as Map<String, dynamic>);
    expect(d.summary.scientificName, 'Channa micropeltes');
    expect(d.summary.names.primary('ms'), 'Toman');
    expect(d.summary.names.secondary('ms'), 'Giant snakehead');
    expect(d.summary.rarity!.code, 'rare');
    expect(d.summary.rarity!.hasFoil, isTrue);
    expect(d.summary.card!.set, 'MY-S1');
    expect(d.origin, 'native');
    expect(d.habitats.map((h) => h.code), contains('river'));
    expect(d.aliases.map((a) => a.name), contains('Toman bunga'));
    expect(d.lookalikes.single.scientificName, 'Channa striata');
    expect(d.identificationNotes, contains('snakehead'));
  });

  test('app config parses AI tier and reference data', () {
    final c = RemoteConfig.fromJson(fixture('app_config')['data'] as Map<String, dynamic>);
    expect(c.aiTier, 'free');
    expect(c.consentRequired, isTrue);
    expect(c.rarityTiers.map((r) => r.code), containsAllInOrder(['common', 'uncommon', 'rare', 'epic', 'legendary']));
    expect(c.regions, hasLength(16));
    expect(c.habitats, isNotEmpty);
  });

  test('families parse', () {
    final f = (fixture('families')['data'] as List).cast<Map<String, dynamic>>().map(Family.fromJson).toList();
    expect(f.map((e) => e.scientificName), contains('Channidae'));
  });

  group('ApiException', () {
    test('reads problem+json code and message', () {
      final e = ApiException.fromProblem(401, fixture('error_invalid_credentials'));
      expect(e.code, 'invalid_credentials');
      expect(e.isUnauthenticated, isTrue);
      expect(e.message, isNotEmpty);
    });

    test('reads validation field errors', () {
      final e = ApiException.fromProblem(422, fixture('error_validation'));
      expect(e.code, 'validation_failed');
      expect(e.fieldError('email'), isNotNull);
      expect(e.fieldError('handle'), isNotNull);
    });

    test('keeps extra problem members (e.g. quota)', () {
      final e = ApiException.fromProblem(429, {
        'code': 'scan_quota_exceeded',
        'detail': 'x',
        'quota': {'remaining': 0},
      });
      expect(e.extra['quota'], {'remaining': 0});
    });

    test('no response means a network error', () {
      final e = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.connectionError,
        ),
      );
      expect(e.isNetwork, isTrue);
      expect(e.code, 'network_error');
    });
  });
}
