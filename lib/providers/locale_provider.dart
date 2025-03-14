import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_wallet/generated/l10n.dart';

class LocaleStorageKeys{
  static const String abLocaleKey = "ab_locale_key";
  static const String abLocaleSysValue = "ab_locale_sys_value";
}

class LocaleProvider extends StateNotifier<Locale> {
  LocaleProvider() : super(ABWalletS.delegate.supportedLocales.first);

  void changeLocale(Locale locale) {
    if (ABWalletS.delegate.supportedLocales.contains(locale)) {
      state = locale;
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleProvider, Locale>((ref) {
  return LocaleProvider();
});

