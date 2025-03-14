import 'package:flutter/cupertino.dart';

import 'generated/l10n.dart';

class LibUikit {
  static final _instance = LibUikit._internal();

  static LibUikit get instance => _instance;

  LibUikit._internal();

  static void setup(String language, bool isDark, bool hzldMode) {
    Locale languageLocale = Locale.fromSubtags(languageCode: language);
    if (LibUIKitS.delegate.supportedLocales.contains(languageLocale)) {
      LibUIKitS.load(languageLocale);
    } else {
      LibUIKitS.load(Locale.fromSubtags(languageCode: 'en'));
    }
  }

  LocalizationsDelegate<dynamic> localizationsDelegate() => LibUIKitS.delegate;

  List<Locale> supportedLocales() => LibUIKitS.delegate.supportedLocales;
}
