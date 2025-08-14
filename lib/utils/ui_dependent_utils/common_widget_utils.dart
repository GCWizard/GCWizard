import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

String className(Widget widget) {
  return widget.runtimeType.toString();
}

String printErrorMessage(BuildContext context, String message) {
  return i18n(context, 'common_error') + ': ' + i18n(context, message);
}

Future<bool> launchUrl(Uri url) async {
  return urlLauncher.launchUrl(url, mode: urlLauncher.LaunchMode.externalApplication);
}

String? languageISOCodeToI18nLanguageName(BuildContext context, String code) {
  switch (code) {
    case 'de': return i18n(context, 'common_language_german');
    case 'en': return i18n(context, 'common_language_english');
    case 'fr': return i18n(context, 'common_language_french');
    case 'it': return i18n(context, 'common_language_italian');
    case 'eo': return i18n(context, 'common_language_esperanto');
    case 'sv': return i18n(context, 'common_language_swedish');
    case 'pl': return i18n(context, 'common_language_polish');
    case 'es': return i18n(context, 'common_language_spanish');
    case 'pt': return i18n(context, 'common_language_portuguese');
    case 'tr': return i18n(context, 'common_language_turkish');
    case 'nl': return i18n(context, 'common_language_dutch');
    case 'dk': return i18n(context, 'common_language_danish');
    case 'is': return i18n(context, 'common_language_icelandic');
    case 'fi': return i18n(context, 'common_language_finnish');
    case 'cz': return i18n(context, 'common_language_czech');
    case 'hu': return i18n(context, 'common_language_hungarian');
    case 'cy': return i18n(context, 'common_language_welsh');
    default: return null;
  }
}

String getAlphabetName(BuildContext context, Alphabet alphabet) {
  return alphabet.type == AlphabetType.STANDARD ? i18n(context, alphabet.key) : alphabet.name ?? '';
}
