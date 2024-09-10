// Tools with search strings
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

Map<String, String> _COMMON_SEARCHSTRINGS = {};
Map<String, String> _EN_SEARCHSTRINGS = {};
Map<String, String> _LOCALE_SEARCHSTRINGS = {};

final NOT_ALLOWED_SEARCH_CHARACTERS = RegExp(r'[^a-z0-9α-ω¥, ]');

Future<void> loadSearchStrings(String languageCode) async {
  if (_COMMON_SEARCHSTRINGS.isEmpty) {
    _COMMON_SEARCHSTRINGS = await _getSearchStringsForLocale('common');
    _EN_SEARCHSTRINGS = await _getSearchStringsForLocale('en');
  }
  await _loadLocaleSearchStrings(languageCode);
}

Future<void> _loadLocaleSearchStrings(String languageCode) async {
  if (languageCode != 'en') {
    _LOCALE_SEARCHSTRINGS = await _getSearchStringsForLocale(languageCode);
  } else {
    _LOCALE_SEARCHSTRINGS = {};
  }
}

Future<Map<String, String>> _getSearchStringsForLocale(String locale) async {
  String file;
  try {
    file = await rootBundle.loadString('lib/application/searchstrings/assets/$locale.json');
  } catch (e) {
    file = '{}';
  }

  var decoded = json.decode(file);
  Map<String, Object?> _rawStrings = asJsonMap(decoded);
  Map<String, String> _strings = _rawStrings.map((key, value) {
    return MapEntry(key, value.toString());
  });

  return _strings;
}

// Build indexed strings for each tool : concatenated lower case no accent
void createIndexedSearchStrings() {
  if (registeredTools.isEmpty) return;

  for (GCWTool tool in registeredTools) {
    List<String> searchStrings = [];
    if (tool.searchKeys.where((element) => element.isNotEmpty).isEmpty) {
      continue;
    }

    for (String searchKey in tool.searchKeys) {
      var commonStrings = _COMMON_SEARCHSTRINGS[searchKey];
      var enStrings = _EN_SEARCHSTRINGS[searchKey];
      var localeStrings = _LOCALE_SEARCHSTRINGS[searchKey];

      if (commonStrings != null && commonStrings.isNotEmpty) searchStrings.add(commonStrings);
      if (enStrings != null && enStrings.isNotEmpty) searchStrings.add(enStrings);
      if (localeStrings != null && localeStrings.isNotEmpty) searchStrings.add(localeStrings);
    }

    String? _toolName;
    if (tool.toolName != null) {
      _toolName = removeAccents(tool.toolName!).toLowerCase().replaceAll(RegExp(r'\s+'), '');
    }
    var _indexedSearchStrings =
        removeAccents(searchStrings.join(' ').toLowerCase()).replaceAll(NOT_ALLOWED_SEARCH_CHARACTERS, '');
    if (_indexedSearchStrings.isEmpty) {
      if (_toolName != null) tool.indexedSearchStrings = _toolName;
      continue;
    }

    tool.indexedSearchStrings = _removeDuplicates(_indexedSearchStrings + ' ' + (_toolName ?? ''));
  }
}

String _removeDuplicates(String strings) {
  return strings.split(REGEXP_SPLIT_STRINGLIST).toSet().join(' ');
}
