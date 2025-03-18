
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeStorageKeys{
  static const String abThemeKey = "ab_theme_key";
  static const String abThemeSysValue = "ab_theme_sys_value";
  static const String abThemeDarkValue = "ab_theme_dark_value";
  static const String abThemeLightValue = "ab_theme_light_value";
}

class ThemeNotifier extends StateNotifier<ThemeMode>{
  ThemeNotifier():super(ThemeMode.system);


  void setTheme(ThemeMode themeMode){
    state = themeMode;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier,ThemeMode>((ref){
  return ThemeNotifier();
});