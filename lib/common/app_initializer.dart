import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_wallet/common/constants.dart';
import 'package:force_wallet/utils/app_set_utils.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:lib_uikit/lib_uikit.dart';

class AppInitializer {
  /// These libraries need to be loaded in front of the app start.
  static Future<void> initialize() async {
    // The libraries that need to be loaded before the runApp() function execution require adding await.

    /// Other1...

    /// Other2...

    /// Other3...
  }

  /// Destroy resources together after exit app.
  static void disposeAll() {
    /// Other1...

    /// Other2...

    /// Other3...
  }

}

class AppBeforeHomePageInitializer {
  /// These libraries need to be loaded in front of the home page.
  Future<void> initialize() async {
    ///
    await ABStorageInitializer.setup();

    /// Other1...

    /// Other2...

    /// Other3...
  }

  /// These settings after initialize() success
  static void setUp({required BuildContext context,required WidgetRef ref }) {
    Locale locale =  AppSetUtils.getLoadLocalSetting();
    bool isDark =  AppSetUtils.getLoadThemeSetting();
    int preType =  AppSetUtils.getLoadPreferencesSetting(context: context);

    AppSetUtils.appSetting(ref:ref,locale: locale,isDark:isDark,preType:preType);

    LibUikit.setup(locale.toString(), isDark, preType != ABConstants.abDefaultPre);

    /// Other2...

    /// Other3...
  }

  /// These settings after initialize() fail
  static void setDefaultUp({required BuildContext context}) {
    AppSetUtils.setDefaultSetting(context: context);

    LibUikit.setup(ABConstants.abDefaultLanguage, true, false);

    /// Other2...

    /// Other3...
  }
}
