import 'package:flutter/material.dart';

final Map<Locale, Map<String, Object>> SUPPORTED_LOCALES = {
  const Locale('cs'): {'name_native': '🇨🇿 Čeština', 'percent_translated': 10},
  const Locale('da'): {'name_native': '🇩🇰 Dansk', 'percent_translated': 1},
  const Locale('de'): {'name_native': '🇩🇪 Deutsch', 'percent_translated': 100},
  const Locale('el'): {'name_native': '🇬🇷 Ελληνικά', 'percent_translated': 4},
  const Locale('en'): {'name_native': '🇬🇧🇺🇸 English', 'percent_translated': 100},
  const Locale('es'): {'name_native': '🇪🇸 Español', 'percent_translated': 99},
  const Locale('fi'): {'name_native': '🇫🇮 Suomi', 'percent_translated': 40},
  const Locale('fr'): {'name_native': '🇫🇷 Français', 'percent_translated': 76},
  const Locale('it'): {'name_native': '🇮🇹 Italiano', 'percent_translated': 6},
  const Locale('ko'): {'name_native': '🇰🇷 한국어', 'percent_translated': 88},
  const Locale('nl'): {'name_native': '🇳🇱 Nederlands', 'percent_translated': 100},
  const Locale('pl'): {'name_native': '🇵🇱 Polski', 'percent_translated': 73},
  const Locale('pt'): {'name_native': '🇵🇹 Português', 'percent_translated': 14},
  const Locale('ru'): {'name_native': '🇷🇺 Ру́сский', 'percent_translated': 7},
  const Locale('sk'): {'name_native': '🇸🇰 Slovenský', 'percent_translated': 100},
  const Locale('sv'): {'name_native': '🇸🇪 Svenska', 'percent_translated': 98},
  const Locale('tr'): {'name_native': '🇹🇷 Türkçe', 'percent_translated': 8},
};

const Locale DEFAULT_LOCALE = Locale('en');

final SUPPORTED_HELPLOCALES = ['en', 'de', 'nl'];

///
///  Control if locale is supported
///
bool isLocaleSupported(Locale locale) {
  // Include all of your supported language codes here
  return SUPPORTED_LOCALES.containsKey(locale);
}
