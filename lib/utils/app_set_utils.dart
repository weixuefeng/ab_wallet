import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_wallet/common/constants.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_uikit/generated/l10n.dart';
import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_uikit/providers/preferences_provider.dart';
import 'package:lib_uikit/providers/theme_provider.dart';

class AppSetUtils {
  static void appSetting({
    required WidgetRef ref,
    required Locale locale,
    required bool isDark,
    required int preType,
  }) {
    loadLocalSetting(locale: locale);
    loadThemeSetting(ref:ref,isDark: isDark);
    loadPreferencesSetting(ref: ref,preType:preType);
  }

  static Locale getLoadLocalSetting() {
    /// default language is en
    Locale currentLocal = Locale.fromSubtags(languageCode: 'en');

    String? localeLanguage = ABStorageKV.queryString(
      LocaleStorageKeys.abLocaleKey,
    );
    if (localeLanguage == LocaleStorageKeys.abLocaleSysValue) {
      // Locale sysLocal = Localizations.localeOf(context);
      Locale sysLocal = ui.window.locale;
      if (ABWalletS.delegate.supportedLocales.contains(sysLocal)) {
        currentLocal = sysLocal;
      }
    } else {
      currentLocal = Locale.fromSubtags(
        languageCode: localeLanguage ?? ABConstants.abDefaultLanguage,
      );
    }
    return currentLocal;
  }

  static void loadLocalSetting({required Locale locale}) {
    ABWalletS.load(locale);
  }

  static bool getLoadThemeSetting() {
    bool isDark = false;
    String? localeTheme = ABStorageKV.queryString(ThemeStorageKeys.abThemeKey);
    if (localeTheme == null) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDark = brightness == Brightness.dark;
    } else {
      switch (localeTheme) {
        case ThemeStorageKeys.abThemeLightValue:
          isDark = false;
          break;
        case ThemeStorageKeys.abThemeDarkValue:
          isDark = true;
          break;
        case ThemeStorageKeys.abThemeSysValue:
          isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
          break;
      }
    }
    return isDark;
  }

  static void loadThemeSetting({required WidgetRef ref,required bool isDark}) {
    ref.read(themeProvider.notifier).setTheme(isDark? ThemeMode.dark:ThemeMode.light);
  }

  static int getLoadPreferencesSetting({required BuildContext context}) {
    return ABStorageKV.queryInt(
      PreStorageKeys.abPreKey,
      defaultValue:ABConstants.abDefaultPre,
    );
  }

  static void loadPreferencesSetting({required WidgetRef ref,required int preType}) {
    ABLogger.d("设置全局模式为：preType：$preType");
    ref.read(preferencesProvider.notifier).setPre(preType);
  }

  /// after local and theme init error,we used system setting.
  static void setDefaultSetting({required BuildContext context}) {
    Locale sysLocal = Localizations.localeOf(context);
    ABWalletS.load(sysLocal);

    /// lib_uikit also need to set locale
    LibUIKitS.load(sysLocal);
  }
}
