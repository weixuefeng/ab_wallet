import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_uikit/providers/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_uikit/src/utils/theme/colors_value.dart';

class DemoSettingPage extends HookConsumerWidget {
  const DemoSettingPage({super.key});

  static const String TAG = 'DemoSettingPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale systemLocale = Localizations.localeOf(context);

    final themeNotifier = ref.watch(themeProvider.notifier);
    final localeNotifier = ref.read(localeProvider.notifier);

    final themeMode = ref.watch(themeProvider);

    void setLanguageEn() async {
      localeNotifier.changeLocale(Locale.fromSubtags(languageCode: 'en'));
      toSaveLocal(locale: Locale.fromSubtags(languageCode: 'en'));
    }

    void setLanguageZh() async {
      localeNotifier.changeLocale(Locale.fromSubtags(languageCode: 'zh'));
      toSaveLocal(locale: Locale.fromSubtags(languageCode: 'zh'));
    }

    void setDisplayMode() async {
      themeNotifier.toggleTheme();
    }

    setLanguageFollowSystem(Locale systemLocale) {
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

    setThemeFollowSystem() {}

    setRedUp() {}

    setGreenUp() {}

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Setting测试 Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ABWalletS.current.ab_public_app_name,style: TextStyle(color: ABColors.text2.color),),
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
              onPressed: () => {setDisplayMode()},
              child: Text(themeMode == ThemeMode.light ? "切换夜间" : "切换白天"),
            ),
            ElevatedButton(
              onPressed: () => {setLanguageFollowSystem(systemLocale)},
              child: Text("语言跟随系统"),
            ),
            ElevatedButton(
              onPressed: () => {setThemeFollowSystem()},
              child: Text("主题跟随系统"),
            ),
            ElevatedButton(onPressed: () => {setRedUp()}, child: Text("红涨绿跌")),
            ElevatedButton(
              onPressed: () => {setGreenUp()},
              child: Text("红跌绿涨"),
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
  void toSaveTheme({
    required ThemeMode themeMode,
    bool isSystemTheme = false,
  }) {}
}
