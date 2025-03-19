import 'package:flutter/material.dart';
import 'package:lib_router/lib_router_exports.dart';
import 'package:lib_uikit/lib_uikit.dart';

class ABConstants {
  // ABWallet App's default language is English.
  static const abDefaultLanguage = "en";
  // ABWallet App's default preference setting is RedUp.
  static const abDefaultPre = 0;
}

class Routes {
  static const root = '/';
  static const homeNamedPage = '/';
  static const homeDetailsNamedPage = 'details';
  static const profileNamedPage = '/profile';
  static const profileDetailsNamedPage = 'details';
  static const settingsNamedPage = '/settings';
  //static profileNamedPage([String? name]) => '/${name ?? ':profile'}';
  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundScreen();
}
