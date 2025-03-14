

import 'package:flutter/cupertino.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:lib_uikit/generated/l10n.dart';
import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_storage/ab_storage_kv.dart';

class AppSetUtils{

  static void appSetting({required BuildContext context}){
    loadLocalSetting(context:context);
    loadThemeSetting(context:context);
  }

  static void loadLocalSetting({required BuildContext context}){
    /// default language is en
    Locale currentLocal = Locale.fromSubtags(languageCode: 'en');

    String? localeLanguage = ABStorageKV.queryString(
      LocaleStorageKeys.abLocaleKey,
    );
    if (localeLanguage == LocaleStorageKeys.abLocaleSysValue) {
      Locale sysLocal = Localizations.localeOf(context);
      if (ABWalletS.delegate.supportedLocales.contains(sysLocal)) {
        currentLocal = sysLocal;
      }
    } else {
      currentLocal = Locale.fromSubtags(languageCode: localeLanguage ?? 'en');
    }
    ABWalletS.load(currentLocal);
  }

  static void loadThemeSetting({required BuildContext context}){

  }

  /// after local and theme init error,we used system setting.
  static void setDefaultSetting({required BuildContext context}){
    Locale sysLocal = Localizations.localeOf(context);
    ABWalletS.load(sysLocal);
    /// lib_uikit also need to set locale
    LibUIKitS.load(sysLocal);
  }
}