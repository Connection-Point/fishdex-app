import 'package:fishdex/core/api/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers.dart';

void main() {
  group('auth', () {
    testWidgets('signed-out users land on login; validation runs before any request', (tester) async {
      final auth = FakeAuthRepository();
      await pumpApp(tester, auth: auth);

      expect(find.byKey(const Key('login.submit')), findsOneWidget);
      await tester.tap(find.byKey(const Key('login.submit')));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsNWidgets(2)); // email + password
      expect(auth.calls, isEmpty);
    });

    testWidgets('successful login opens the app shell', (tester) async {
      final auth = FakeAuthRepository();
      await pumpApp(tester, auth: auth);

      await tester.enterText(find.byKey(const Key('login.email')), 'ali@example.com');
      await tester.enterText(find.byKey(const Key('login.password')), 'secret-password');
      await tester.tap(find.byKey(const Key('login.submit')));
      await tester.pumpAndSettle();

      expect(auth.calls, ['login:ali@example.com']);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('server error message is shown on failed login', (tester) async {
      final auth = FakeAuthRepository(
        loginError: ApiException(status: 401, code: 'invalid_credentials', message: 'Email or password is incorrect.'),
      );
      await pumpApp(tester, auth: auth);

      await tester.enterText(find.byKey(const Key('login.email')), 'ali@example.com');
      await tester.enterText(find.byKey(const Key('login.password')), 'wrong');
      await tester.tap(find.byKey(const Key('login.submit')));
      await tester.pumpAndSettle();

      expect(find.text('Email or password is incorrect.'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('server-side field errors appear under the right field on register', (tester) async {
      final auth = FakeAuthRepository(
        loginError: ApiException(
          status: 422,
          code: 'validation_failed',
          message: 'invalid',
          fieldErrors: {
            'handle': ['The handle has already been taken.'],
          },
        ),
      );
      await pumpApp(tester, auth: auth);
      await tester.tap(find.byKey(const Key('login.toRegister')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('register.name')), 'Ali');
      await tester.enterText(find.byKey(const Key('register.handle')), 'ali_toman');
      await tester.enterText(find.byKey(const Key('register.email')), 'ali@example.com');
      await tester.enterText(find.byKey(const Key('register.password')), 'toman-hunter-99');
      await tester.ensureVisible(find.byKey(const Key('register.submit')));
      await tester.tap(find.byKey(const Key('register.submit')));
      await tester.pumpAndSettle();

      expect(find.text('The handle has already been taken.'), findsOneWidget);
    });

    testWidgets('restored session skips login; sign out returns to login', (tester) async {
      final auth = FakeAuthRepository(restored: fixtureUser());
      await pumpApp(tester, auth: auth);
      expect(find.byType(NavigationBar), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('@fixture_user'), findsOneWidget);

      await tester.tap(find.byKey(const Key('profile.signOut')));
      await tester.pumpAndSettle();
      expect(auth.calls, contains('logout'));
      expect(find.byKey(const Key('login.submit')), findsOneWidget);
    });
  });

  group('catalogue', () {
    testWidgets('lists species, searches, and opens the card detail', (tester) async {
      await pumpApp(tester, auth: FakeAuthRepository(restored: fixtureUser()));
      await tester.tap(find.text('Catalogue'));
      await tester.pumpAndSettle();

      expect(find.text('Giant snakehead'), findsOneWidget);
      expect(find.text('Climbing perch'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('catalogue.search')), 'toman');
      await tester.pump(const Duration(milliseconds: 400)); // debounce
      await tester.pumpAndSettle();
      expect(find.text('Giant snakehead'), findsOneWidget);
      expect(find.text('Climbing perch'), findsNothing);

      await tester.tap(find.text('Giant snakehead'));
      await tester.pumpAndSettle();

      expect(find.text('Channa micropeltes'), findsWidgets);
      expect(find.text('MY-S1 · 005'), findsOneWidget);
      await tester.scrollUntilVisible(find.textContaining('Toman bunga'), 300);
      expect(find.textContaining('Toman bunga'), findsOneWidget); // alias
      await tester.scrollUntilVisible(find.text('Striped snakehead'), 300);
      expect(find.text('Striped snakehead'), findsOneWidget); // look-alike
    });

    testWidgets('water-type filter narrows the list', (tester) async {
      final repo = FixtureCatalogueRepository();
      await pumpApp(
        tester,
        auth: FakeAuthRepository(restored: fixtureUser()),
        catalogue: repo,
      );
      await tester.tap(find.text('Catalogue'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('filter.brackish')));
      await tester.pumpAndSettle();

      expect(repo.queries.last.waterType, 'brackish');
      expect(find.text('Climbing perch'), findsOneWidget); // freshwater + brackish
      expect(find.text('Giant snakehead'), findsNothing);
    });
  });

  group('beta AI consent', () {
    testWidgets('scan tab gates scanning behind the consent screen', (tester) async {
      final auth = FakeAuthRepository(restored: fixtureUser(consented: false));
      await pumpApp(tester, auth: auth);
      await tester.tap(find.text('Scan'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('scan.enable')));
      await tester.pumpAndSettle();
      expect(find.text('Before your first scan'), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('consent.accept')));
      await tester.tap(find.byKey(const Key('consent.accept')));
      await tester.pumpAndSettle();

      expect(auth.consentCalls, 1);
      expect(find.byKey(const Key('scan.enabled')), findsOneWidget);
    });
  });

  testWidgets('switching language to BM re-labels the app', (tester) async {
    await pumpApp(tester, auth: FakeAuthRepository(restored: fixtureUser()));
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('BM'));
    await tester.pumpAndSettle();

    expect(find.text('Katalog'), findsOneWidget);
    expect(find.text('Log keluar'), findsOneWidget);
  });
}
