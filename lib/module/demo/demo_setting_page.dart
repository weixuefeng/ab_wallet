import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:force_wallet/common/constants.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_uikit/providers/preferences_provider.dart';
import 'package:lib_uikit/providers/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_uikit/src/utils/theme/colors_utils.dart';
import 'package:lib_uikit/src/components/ab_empty_view.dart';

class DemoSettingPage extends HookConsumerWidget {
  const DemoSettingPage({super.key});

  static const String TAG = 'DemoSettingPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Locale systemLocale = Localizations.localeOf(context);

    final themeNotifier = ref.read(themeProvider.notifier);
    final themeMode = ref.watch(themeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    final preNotifier = ref.read(preferencesProvider.notifier);

    final preWatchNotifier = ref.watch(preferencesProvider);

    ///（Test Finish）
    void setLanguageEn() async {
      localeNotifier.changeLocale(Locale.fromSubtags(languageCode: 'en'));
      toSaveLocal(locale: Locale.fromSubtags(languageCode: 'en'));
    }

    ///（Test Finish）
    void setLanguageZh() async {
      localeNotifier.changeLocale(Locale.fromSubtags(languageCode: 'zh'));
      toSaveLocal(locale: Locale.fromSubtags(languageCode: 'zh'));
    }

    ///设置语言跟随系统（Test Finish）
    setLanguageFollowSystem() {
      Locale systemLocale = ui.window.locale;
      ABLogger.d("当前系统语言systemLocale：${systemLocale.toString()}");

      ///统一英文
      if (systemLocale.toString().startsWith(ABConstants.abDefaultLanguage)) {
        systemLocale = Locale.fromSubtags(
          languageCode: ABConstants.abDefaultLanguage,
        );
      }
      if (ABWalletS.delegate.supportedLocales.contains(systemLocale)) {
        localeNotifier.changeLocale(systemLocale);
        toSaveLocal(locale: systemLocale, isSystemLocale: true);
      } else {
        ABToast().showToast(
          context,
          ToastLevel.error,
          "暂不支持${systemLocale.toString()}",
        );
      }
    }

    ///设置白夜间模式（Test Finished）
    void setDisplayMode(bool currentIsDark) async {
      ///当前是夜间，优先修改本地保存值为白天
      toSaveTheme(!currentIsDark);

      ///当前是夜间则切到白天
      themeNotifier.setTheme(currentIsDark ? ThemeMode.light : ThemeMode.dark);
    }

    ///设置跟随系统主题（Test finished）
    setThemeFollowSystem() {
      ///获取当前系统主题
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;

      ///保存系统主题作为App主题
      bool isDark = brightness == Brightness.dark;
      ABLogger.d("当前系统主题：isDark：$isDark");
      toSaveTheme(isDark, isSystemTheme: true);

      ///当前App主题和系统不一致需要切换到系统的主题
      bool currentAppModelIsDark = themeMode == ThemeMode.dark;
      if (currentAppModelIsDark != isDark) {
        themeNotifier.setTheme(isDark ? ThemeMode.dark : ThemeMode.light);
      }
    }

    ///红涨绿跌
    setGreenOrRedUp() {
      ABLogger.d("当前个人设置：preWatchNotifier：$preWatchNotifier");

      if (preWatchNotifier == 0) {
        preNotifier.setPre(PreStorageKeys.abPreRedUpValue);
        toSavePre(PreStorageKeys.abPreRedUpValue);
      } else {
        preNotifier.setPre(PreStorageKeys.abPreGreenUpValue);
        toSavePre(PreStorageKeys.abPreGreenUpValue);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Setting测试 Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ABEmptyView(iconType: ABEmptyIconType.data),
            Text(
              ABWalletS.current.ab_public_app_name,
              style: TextStyle(color: ABColors.text2.color),
            ),
            SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => {setLanguageEn()},
              child: Text("国际化测试-英文"),
            ),
            ElevatedButton(
              onPressed: () => {setLanguageZh()},
              child: Text("国际化测试-中文"),
            ),
            ElevatedButton(
              onPressed: () => {setDisplayMode(themeMode == ThemeMode.dark)},
              child: Text(themeMode == ThemeMode.dark ? "切换到白天" : "切换到夜间"),
            ),
            ElevatedButton(
              onPressed: () => {setLanguageFollowSystem()},
              child: Text("语言跟随系统"),
            ),
            ElevatedButton(
              onPressed: () => {setThemeFollowSystem()},
              child: Text("主题跟随系统"),
            ),
            Text(
              preWatchNotifier == 0 ? "当前是绿涨红跌" : "当前是红涨绿跌",
              style: TextStyle(color: ABColors.redPreColor.color),
            ),
            ElevatedButton(
              onPressed: () => {setGreenOrRedUp()},
              child: Text("红绿涨跌设置"),
            ),
          ],
        ),
      ),
    );
  }

  //存储当前语言到本地
  void toSaveLocal({required Locale locale, bool isSystemLocale = false}) {
    ABStorageKV.saveString(
      LocaleStorageKeys.abLocaleKey,
      isSystemLocale ? LocaleStorageKeys.abLocaleSysValue : locale.toString(),
    );
  }

  //存储当前主题到本地
  void toSaveTheme(bool isDark, {bool isSystemTheme = false}) {
    ABStorageKV.saveString(
      ThemeStorageKeys.abThemeKey,
      isSystemTheme
          ? ThemeStorageKeys.abThemeSysValue
          : (isDark
              ? ThemeStorageKeys.abThemeDarkValue
              : ThemeStorageKeys.abThemeLightValue),
    );
  }

  void toSavePre(int type) {
    ABStorageKV.saveInt(PreStorageKeys.abPreKey, type);
  }
}
