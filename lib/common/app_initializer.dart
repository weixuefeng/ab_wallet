import 'package:lib_uikit/providers/locale_provider.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_storage/lib_storage.dart';

class AppInitializer {

  /// These libraries need to be loaded in front of the app start.
  static Future<void> initialize()async{
    // The libraries that need to be loaded before the runApp() function execution require adding await.

    /// Other1...

    /// Other2...

    /// Other3...
  }

  /// Destroy resources together
  static void disposeAll() {
    /// Other1...

    /// Other2...

    /// Other3...
  }
}


class AppBeforeHomePageInitializer {
  /// These libraries need to be loaded in front of the home page.
  Future<void> initialize() async {
    await ABStorageInitializer.setup(securityKey: 'ab_storage_key');

    //test
    String? localeLanguage = ABStorageKV.queryString(
      LocaleStorageKeys.abLocaleKey,
    );
    ABLogger.i("localeLanguage:$localeLanguage");

    /// Other1...

    /// Other2...

    /// Other3...
  }
}