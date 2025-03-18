import 'package:go_router/go_router.dart';

class LibRouterConfig {
  // Defines the RouterConfig class for managing routing configuration and initializing GoRouter

  final List<GoRoute> routes;
  final String initialRoute;

  LibRouterConfig({required this.routes, this.initialRoute = '/'});

  GoRouter buildRouter() {
    return GoRouter(initialLocation: initialRoute, routes: routes);
  }
}
