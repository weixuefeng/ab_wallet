import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:force_wallet/common/app_initializer.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/module/demo/demo_page.dart';
import 'package:force_wallet/module/home/home_page.dart';
import 'package:force_wallet/providers/initialize_provider.dart';
import 'package:force_wallet/providers/theme_provider.dart';
import 'package:force_wallet/utils/app_set_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/provider/ab_navigator_provider.dart';
import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'providers/locale_provider.dart';

Future<void> main() async {
  ///Centralized management of initialization logic
  await AppInitializer.initialize();

  ///Start Application
  runApp(ProviderScope(child: const MyApp()));
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
          AppSetUtils.appSetting(context: context);
          return HomePage(title: ABWalletS.current.ab_home_home_page);
        },
        error: (error, stack) {
          return Scaffold(
            body: Center(child: Text('error page，developing...')),
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
