import 'package:flutter/material.dart';

class RouteObserver extends NavigatorObserver {
  // Implements route change listening

  final void Function(String path) onRouteChange;

  RouteObserver({required this.onRouteChange});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChange(route.settings.name ?? '');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChange(previousRoute?.settings.name ?? '');
  }
}
