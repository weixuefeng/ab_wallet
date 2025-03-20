import 'package:flutter/material.dart';
import 'package:ab_wallet/common/app_initializer.dart';
import 'package:ab_wallet/generated/l10n.dart';
import 'package:ab_wallet/module/home/home_page.dart';
import 'package:ab_wallet/providers/initialize_provider.dart';
import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_uikit/providers/theme_provider.dart';
import 'package:lib_uikit/generated/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/provider/ab_navigator_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        ABWalletS.delegate,
        LibUIKitS.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
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
        data: (result) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if(result.mmkvSuccess){
              AppBeforeHomePageInitializer.setUp(ref:ref);
            }else{
              AppBeforeHomePageInitializer.setDefaultUp();
            }
          });
          // if(result.haveLocalWalletInfo){
          return HomePage(title: ABWalletS.current.ab_home_home_page);
          // }else{
          //   return WalletCreateTypePage();
          // }
        },
        error: (error, stack) {
          //TODO: 暂时不会走到错误，视情况处理
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppBeforeHomePageInitializer.setDefaultUp();
          });
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

