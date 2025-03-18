import 'package:flutter/material.dart';
import 'package:force_wallet/common/app_initializer.dart';
// import 'package:force_wallet/generated/l10n.dart';
// import 'package:force_wallet/module/home/home_page.dart';
// import 'package:force_wallet/module/root/root.dart';
// import 'package:force_wallet/providers/initialize_provider.dart';
import 'package:lib_uikit/providers/global_provider.dart';
// import 'package:lib_uikit/providers/locale_provider.dart';
// import 'package:lib_uikit/providers/theme_provider.dart';
// import 'package:force_wallet/utils/app_set_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:lib_base/provider/ab_navigator_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:force_wallet/app.dart';

Future<void> main() async {
  /// Centralized management of initialization logic
  await AppInitializer.initialize();

  /// Start Application
  runApp(
    ProviderScope(
      parent: globalProviderContainer,
      //wait riverpod update to stable version 3.0
      child: const MyApp(),
    ),
  );

  /// Destroy resources together
  WidgetsBinding.instance.addObserver(
    _AppLifecycleObserver(globalProviderContainer),
  );
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final ProviderContainer container;

  _AppLifecycleObserver(this.container);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      container.dispose();
      AppInitializer.disposeAll();
    }
  }
}
