// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class LibUIKitS {
  LibUIKitS();

  static LibUIKitS? _current;

  static LibUIKitS get current {
    assert(
      _current != null,
      'No instance of LibUIKitS was loaded. Try to initialize the LibUIKitS delegate before accessing LibUIKitS.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<LibUIKitS> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = LibUIKitS();
      LibUIKitS._current = instance;

      return instance;
    });
  }

  static LibUIKitS of(BuildContext context) {
    final instance = LibUIKitS.maybeOf(context);
    assert(
      instance != null,
      'No instance of LibUIKitS present in the widget tree. Did you add LibUIKitS.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static LibUIKitS? maybeOf(BuildContext context) {
    return Localizations.of<LibUIKitS>(context, LibUIKitS);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<LibUIKitS> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<LibUIKitS> load(Locale locale) => LibUIKitS.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
