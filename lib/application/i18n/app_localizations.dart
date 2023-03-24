import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/supported_locales.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/search_strings.dart';
import 'package:gc_wizard/application/category_views/all_tools_view.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/json_utils.dart';

class AppLocalizations {
  final Locale _locale;

  Map<String, String> _localizedStrings = {};
  Map<String, String> _defaultLocalizedStrings = {};

  AppLocalizations(this._locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? _of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    _defaultLocalizedStrings = await loadLang(DEFAULT_LOCALE.languageCode);
    Map<String, String> _localStrings = await loadLang(_locale.languageCode);

    // Remove new added keys with empty values (urls for manual)
    _localStrings.removeWhere((k, v) => v.isEmpty);

    _localizedStrings = {
      ..._defaultLocalizedStrings,
      ..._localStrings,
    };

    // refresh toolNames needs a refreshed registry
    refreshRegistry();
    refreshToolLists();

    await loadSearchStrings(_locale.languageCode);

    return Future.value(true);
  }

  Future<Map<String, String>> loadLang(String langCode) async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString('assets/i18n/$langCode.json');
    var decoded = json.decode(jsonString);
    if (!(isJsonMap(decoded))) return <String, String>{};

    Map<String, Object?> jsonMap = decoded as Map<String, Object?>;

    Map<String, String> _strings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return _strings;
  }

  // This method will be called from every widget which needs a localized text
  String? _translate(String key) {
    return _localizedStrings[key];
  }

  String? _translateDefault(String key) {
    return _defaultLocalizedStrings[key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return isLocaleSupported(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/*
 * Supports variables: Give parameter list. Converts:
 * %s1 -> parameter 1 (list index 0)
 * %s2 -> parameter 2 (list index 1),
 * ...
 */
String i18n(BuildContext context, String key, {List<dynamic> parameters = const [], bool useDefaultLanguage = false, String ifTranslationNotExists = ''}) {
  Map<String, String> parametersMap = {};
  for (int i = parameters.length; i >= 1; i--) {
    parametersMap.putIfAbsent('%s' + i.toString(), () => parameters[i - 1].toString());
  }

  var appLocalization = AppLocalizations._of(context);
  if (appLocalization == null) {
    return ifTranslationNotExists;
  }

  var text = useDefaultLanguage ? appLocalization._translateDefault(key) : appLocalization._translate(key);
  if (text == null) {
    return ifTranslationNotExists;
  }

  return parametersMap.isEmpty ? text : substitution(text, parametersMap);
}
