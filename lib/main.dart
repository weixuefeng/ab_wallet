import 'package:flutter/material.dart';
import 'package:force_wallet/common/app_initializer.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/module/home/home_page.dart';
import 'package:force_wallet/providers/initialize_provider.dart';
import 'package:lib_uikit/providers/global_provider.dart';
import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_uikit/providers/theme_provider.dart';
import 'package:force_wallet/utils/app_set_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/provider/ab_navigator_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Global language state management
    final locale = ref.watch(localeProvider);

    /// Global theme state management
    final themeMode = ref.watch(themeProvider);

    /// Libraries states management that needs to be loaded before going to the home page
    final initialization = ref.watch(initializationProvider);

    return MaterialApp(
      navigatorKey: ABNavigatorProvider.navigatorKey,
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      supportedLocales: ABWalletS.delegate.supportedLocales,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ABWalletS.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: initialization.when(
        data: (_) {
          AppBeforeHomePageInitializer.setUp(context: context);
          return HomePage(title: ABWalletS.current.ab_home_home_page);
        },
        error: (error, stack) {
          AppBeforeHomePageInitializer.setDefaultUp(context: context);
          return Scaffold(
            body: HomePage(title: ABWalletS.current.ab_home_home_page),
          );
        },
        loading: () {
          return Scaffold(
            body: Center(child: Text('loading page，developing...')),
          );
        },
      ),
    );
  }
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
