
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/providers/global_provider.dart';
import 'package:lib_uikit/providers/theme_provider.dart';

class ThemeUtils{

  /// Obtain the current topic through the global provider
  static ThemeMode getCurrentTheme(){
    return globalProviderContainer.read(themeProvider);
  }

  /// Check whether the current theme is dart
  /// return true:is dart mode
  static bool isDarkTheme(){
    return globalProviderContainer.read(themeProvider) == ThemeMode.dark;
  }

  /// Get current theme mode in Widget Build.
  /// [context] the context in Widget Build.
  /// [ref] the ref in Widget Build.
  ///
  /// return current mode of this Widget.
  static ThemeMode getCurrentThemeByContext({required BuildContext context,required WidgetRef ref}) {
    return ref.read(themeProvider);
  }

  /// Get current theme mode is dart mode.
  /// [context] the context in Widget Build.
  /// [ref] the ref in Widget Build.
  ///
  /// return is dart mode.
  static bool isDartThemeByContext({required BuildContext context,required WidgetRef ref}) {
    return ref.read(themeProvider) == ThemeMode.dark;
  }

}