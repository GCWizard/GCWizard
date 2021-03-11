import 'package:flutter/material.dart';

final supportedLocales = [
  Locale('en'), //, 'US'),
  Locale('de'), //, 'DE'),
  Locale('fr'), //, 'FR'),
];
const String defaultLanguage = 'en';

/**
 *  Control if locale is supported
 */
bool isLocaleSupported(Locale locale) {
  // Include all of your supported language codes here
  return supportedLocales
      .map((locale) => locale.languageCode)
      .toList()
      .contains(locale.languageCode);
}