import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ab_wallet/common/constants.dart';
import 'package:ab_wallet/repositry/initializer_result.dart';
import 'package:ab_wallet/utils/app_set_utils.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/lib_chain_manager.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_realm_storage.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

class AppInitializer {
  /// These libraries need to be loaded in front of the app start.
  static Future<void> initialize() async {
    // The libraries that need to be loaded before the runApp() function execution require adding await.

    // Other1...

    // Other2...

    // Other3...
  }

  /// Destroy resources together after exit app.
  static void disposeAll() {
    // dispose for lib_uikit.
    LibUikit.instance.destroy();
    // dispose  for lib_chain_manager.
    LibChainManager.instance.destroy();
    // dispose  global provider of lib_base.
    abGlobalProviderContainer.dispose();
  }
}

class AppBeforeHomePageInitializer {
  /// These libraries need to be loaded in front of the home page.
  Future<InitializerResult> initialize() async {
    // Init MMKV
    bool initStorageSuccess = true;
    try {
      await ABStorageInitializer.setup();
    } catch (error) {
      initStorageSuccess = false;
    }

    // Read Local WalletInfo
    bool readWalletInfoSuccess = true;
    List<ABWalletInfo> walletInfos = [];
    try {
      walletInfos = await ABWalletRealmStorage.instance.getAllWalletList();
    } catch (error) {
      readWalletInfoSuccess = false;
    }

    // Other2...

    // Other3...

    return InitializerResult(
      mmkvSuccess: initStorageSuccess,
      walletInfoSuccess: readWalletInfoSuccess,
      haveLocalWalletInfo: walletInfos.isNotEmpty,
    );
  }

  /// These settings after initialize() success
  static void setUp({required WidgetRef ref}) {
    // local setting include preferences language theme.
    Locale locale = AppSetUtils.getLoadLocalSetting();
    bool isDark = AppSetUtils.getLoadThemeSetting();
    int preType = AppSetUtils.getLoadPreferencesSetting();

    AppSetUtils.appSetting(
      ref: ref,
      locale: locale,
      isDark: isDark,
      preType: preType,
    );

    LibUikit.setup(
      locale.toString(),
      isDark,
      preType != ABConstants.abDefaultPre,
    );

    // Other2...

    // Other3...
  }

  /// These settings after initialize() fail
  static void setDefaultUp() {
    AppSetUtils.setDefaultSetting();

    LibUikit.setup(ABConstants.abDefaultLanguage, true, false);

    // Other2...

    // Other3...
  }
}
