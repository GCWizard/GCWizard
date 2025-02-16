import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/i18n/logic/supported_locales.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';

class SpellingAlphabetsList extends StatefulWidget {
  const SpellingAlphabetsList({Key? key}) : super(key: key);

  @override
  SpellingAlphabetsListState createState() => SpellingAlphabetsListState();
}

class SpellingAlphabetsListState extends State<SpellingAlphabetsList> {
  SPELLING _currentLanguage = SPELLING.DEU2022;
  bool _setDefaultLanguage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_setDefaultLanguage) {
      _currentLanguage = _defaultLanguage(context);
      _setDefaultLanguage = true;
    }

    return Column(
      children: <Widget>[
        GCWDropDown<SPELLING>(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: SplayTreeMap<SPELLING, String>.from(
                  SPELLING_LIST,
                  (keys1, keys2) =>
                      i18n(context, SPELLING_LIST[keys1]!).compareTo(i18n(context, SPELLING_LIST[keys2]!)))
              .entries
              .map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var spellingOverview = <MapEntry<String, String>>[];
    spellingOverview = SPELLING_ALPHABETS[_currentLanguage]!;
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        data: spellingOverview.map((entry) {
          return [entry.key, entry.value];
        }).toList(),
        flexValues: const [1, 3],
      ),
    );
  }

  SPELLING _defaultLanguage(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    if (isLocaleSupported(appLocale)) {
      return SUPPORTED_SPELLING_LOCALES[appLocale]!;
    } else {
      return SUPPORTED_SPELLING_LOCALES[DEFAULT_LOCALE]!;
    }
  }
}
