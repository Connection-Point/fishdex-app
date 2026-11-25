import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/presentation/ai_consent_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/catalogue/presentation/species_detail_screen.dart';
import '../features/catalogue/presentation/species_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/home_shell.dart';
import '../features/shell/placeholder_screens.dart';

/// Routes + auth redirect. The router re-evaluates whenever the session changes.
final routerProvider = Provider<GoRouter>((ref) {
  // Only sign-in *status* changes re-run redirects. Profile updates (consent, language)
  // must not rebuild the navigation stack, or in-flight pushes/pops get lost.
  final session = ValueNotifier<AuthStatus>(ref.read(authControllerProvider).status);
  ref.listen(authControllerProvider, (_, next) => session.value = next.status);
  ref.onDispose(session.dispose);

  const publicPaths = {'/login', '/register'};

  return GoRouter(
    initialLocation: '/dex',
    refreshListenable: session,
    redirect: (context, state) {
      final status = session.value;
      final path = state.matchedLocation;

      if (status == AuthStatus.unknown) return path == '/splash' ? null : '/splash';
      if (status == AuthStatus.signedOut) return publicPaths.contains(path) ? null : '/login';
      if (publicPaths.contains(path) || path == '/splash') return '/dex';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const _Splash()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/consent', builder: (_, _) => const AiConsentScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/dex', builder: (_, _) => const DexPlaceholderScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/scan', builder: (_, _) => const ScanPlaceholderScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/journal', builder: (_, _) => const JournalPlaceholderScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/catalogue',
                builder: (_, _) => const SpeciesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => SpeciesDetailScreen(speciesId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
});

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}
