import 'package:flutter/cupertino.dart';
import 'package:force_wallet/utils/app_set_utils.dart';
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
    await ABStorageInitializer.setup(securityKey: 'ab_storage_key');

    /// Other1...

    /// Other2...

    /// Other3...
  }

  /// These settings after initialize() success
  static void setUp({required BuildContext context}) {
    AppSetUtils.appSetting(context: context);


    // LibUikit.setup(language, isDark, hzldMode);

    /// Other2...

    /// Other3...
  }

  /// These settings after initialize() fail
  static void setDefaultUp({required BuildContext context}) {
    AppSetUtils.setDefaultSetting(context: context);

    // LibUikit.setup(language, isDark, hzldMode);

    /// Other1...

    /// Other2...

    /// Other3...
  }
}
