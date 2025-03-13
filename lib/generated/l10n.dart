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

class ABWalletS {
  ABWalletS();

  static ABWalletS? _current;

  static ABWalletS get current {
    assert(_current != null,
        'No instance of ABWalletS was loaded. Try to initialize the ABWalletS delegate before accessing ABWalletS.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<ABWalletS> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = ABWalletS();
      ABWalletS._current = instance;

      return instance;
    });
  }

  static ABWalletS of(BuildContext context) {
    final instance = ABWalletS.maybeOf(context);
    assert(instance != null,
        'No instance of ABWalletS present in the widget tree. Did you add ABWalletS.delegate in localizationsDelegates?');
    return instance!;
  }

  static ABWalletS? maybeOf(BuildContext context) {
    return Localizations.of<ABWalletS>(context, ABWalletS);
  }

  /// `AB Wallet`
  String get ab_public_app_name {
    return Intl.message(
      'AB Wallet',
      name: 'ab_public_app_name',
      desc: '',
      args: [],
    );
  }

  /// `Sure`
  String get ab_public_sure {
    return Intl.message(
      'Sure',
      name: 'ab_public_sure',
      desc: '',
      args: [],
    );
  }

  /// `Home Page`
  String get ab_home_home_page {
    return Intl.message(
      'Home Page',
      name: 'ab_home_home_page',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get ab_home_send {
    return Intl.message(
      'Send',
      name: 'ab_home_send',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get ab_mine_person_center {
    return Intl.message(
      'Mine',
      name: 'ab_mine_person_center',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get ab_mine_setting {
    return Intl.message(
      'Setting',
      name: 'ab_mine_setting',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<ABWalletS> {
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
  Future<ABWalletS> load(Locale locale) => ABWalletS.load(locale);
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
