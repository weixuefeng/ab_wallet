import 'package:flutter/material.dart';

class ABNavigatorProvider {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ABNavigator');

  static final ABNavigatorProvider _instance = ABNavigatorProvider._();

  ABNavigatorProvider._();

  /// navigatorKey.currentState.pushName('url') can use for push page
  static GlobalKey<NavigatorState> get navigatorKey => _instance._navigatorKey;

  static BuildContext? get navigatorContext => _instance._navigatorKey.currentState?.context;

  static BuildContext? get currentContext => _instance._navigatorKey.currentState?.context;

  static NavigatorState? get currentState => _instance._navigatorKey.currentState;

  static OverlayState? get overlayState => _instance._navigatorKey.currentState?.overlay;

}
