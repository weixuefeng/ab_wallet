// lib/src/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Default TextTheme
  static TextTheme get defaultTextTheme => TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
    labelMedium: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
  );

  // Default Light Theme
  static ThemeData get lightTheme =>
      ThemeData(primarySwatch: Colors.blue, textTheme: defaultTextTheme);

  // Default Dark Theme
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    textTheme: defaultTextTheme.copyWith(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
    ),
  );

  // Custom Theme
  static ThemeData customTheme({
    required Color primaryColor,
    TextTheme? textTheme,
  }) {
    return ThemeData(
      primaryColor: primaryColor,
      textTheme: textTheme ?? defaultTextTheme,
    );
  }
}
