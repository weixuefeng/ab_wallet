import 'package:flutter/material.dart';
import 'package:force_wallet/common/app_initializer.dart';
import 'package:lib_uikit/providers/global_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
