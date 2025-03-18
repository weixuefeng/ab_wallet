import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/providers/preferences_provider.dart';
import 'package:lib_uikit/src/res/colors.dart';
import 'package:lib_uikit/src/utils/theme/colors_pair.dart';
import 'package:lib_uikit/src/utils/theme/preferences_utils.dart';

class ABColors {
  ///文本颜色1
  static const text1 = ColorsPair(
    lightColor: Color(0xFF262933),
    dartColor: Color(0xFFFAFAFA),
  );

  ///文本颜色2
  static const text2 = ColorsPair(
    lightColor: Colors.red,
    dartColor: Colors.green,
  );

  ///红涨绿跌的红
  static ColorsPair get redPreColor =>
  // static ColorsPair redPreColor({required BuildContext context}) {
    // final redPreColor = ProviderScope.containerOf(
    //   context,
    // ).read(preferencesProvider);

   // int redPreColor =  PreferencesUtils.getCurrentPreType();
  PreferencesUtils.getCurrentPreType() == 0
        ? ColorsPair(
          lightColor: ABAppColors.green,
          dartColor: ABAppColors.green,
        )
        : ColorsPair(lightColor: ABAppColors.red, dartColor: ABAppColors.red);

}
