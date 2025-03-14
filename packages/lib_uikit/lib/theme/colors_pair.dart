import 'dart:ui';

import 'package:lib_uikit/theme/theme_utils.dart';

class ColorsPair {
  final Color lightColor;
  final Color dartColor;

  const ColorsPair({required this.lightColor, required this.dartColor});

  Color get color => ThemeUtils.isDartTheme() ? dartColor : lightColor;

  Color get(bool isDart) {
    return isDart ? dartColor : lightColor;
  }
}
