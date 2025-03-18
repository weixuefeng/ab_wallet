import 'package:lib_uikit/src/utils/theme/theme_utils.dart';

class ABImageRes {
  static String get noDataImg =>
      ThemeUtils.isDarkTheme()
          ? "packages/lib_uikit/assets/images_dark/ic_empty_data_dark.png"
          : "packages/lib_uikit/assets/images/ic_empty_data.png";

  static String get noDataSearchImg =>
      ThemeUtils.isDarkTheme()
          ? "packages/lib_uikit/assets/images_dark/ic_empty_data_dark.png"
          : "packages/lib_uikit/assets/images/ic_empty_data.png";

  static String get noDataWalletImg =>
      ThemeUtils.isDarkTheme()
          ? "packages/lib_uikit/assets/images_dark/ic_empty_data_dark.png"
          : "packages/lib_uikit/assets/images/ic_empty_data.png";

  static String get noDataConnectImg =>
      ThemeUtils.isDarkTheme()
          ? "packages/lib_uikit/assets/images_dark/ic_empty_data_dark.png"
          : "packages/lib_uikit/assets/images/ic_empty_data.png";

  static String get errorImg =>
      ThemeUtils.isDarkTheme()
          ? "packages/lib_uikit/assets/images_dark/ic_empty_data_dark.png"
          : "packages/lib_uikit/assets/images/ic_empty_data.png";
}
