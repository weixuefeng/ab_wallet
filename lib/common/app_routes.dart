import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_router/lib_router_exports.dart';
import 'package:ab_wallet/common/constants.dart';
import 'package:ab_wallet/module/home/home_page.dart';
import 'package:ab_wallet/module/main_screen.dart';
import 'package:ab_wallet/module/settings/settings_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.homeNamedPage,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(state: state, child: child);
        },
        routes: [
          GoRoute(
            path: Routes.homeNamedPage,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: HomePage(title: '')),
            routes: [
              // GoRoute(
              //   path: Routes.homeDetailsNamedPage,
              //   builder: (context, state) => const HomeDetailsScreen(),
              // ),
            ],
          ),
          GoRoute(
            path: Routes.settingsNamedPage,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: SettingPage(title: '')),
            routes: [
              // GoRoute(
              //   path: Routes.profileDetailsNamedPage,
              //   builder: (context, state) => const ProfileDetailsScreen(),
              // ),
            ],
          ),
          // GoRoute(
          //   path: Routes.settingsNamedPage,
          //   pageBuilder:
          //       (context, state) =>
          //           const NoTransitionPage(child: SettingScreen()),
          // ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;
}

int _calculateCurrentIndex(GoRouterState state) {
  if (state.uri.path == '/') {
    return 0;
  } else if (state.uri.path == '/settings') {
    return 1;
  }
  return 0;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go('/');
      break;
    case 1:
      context.go('/settings');
      break;
  }
}
