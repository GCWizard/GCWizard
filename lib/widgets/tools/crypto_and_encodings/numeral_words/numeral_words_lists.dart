import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/i18n/supported_locales.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/numeral_words.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class NumeralWordsLists extends StatefulWidget {
  @override
  NumeralWordsListsState createState() => NumeralWordsListsState();
}

class NumeralWordsListsState extends State<NumeralWordsLists> {
  TextEditingController _decodeController;

  var _currentDecodeInput = '';
  var _currentLanguage = NumeralWordsLanguage.DEU;
  int _valueFontsizeOffset = 0;
  bool _setDefaultLanguage = false;

  SplayTreeMap<String, NumeralWordsLanguage> _LANGUAGES;

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_setDefaultLanguage) {
      _currentLanguage = _defaultLanguage(context);
      _setDefaultLanguage = true;
    }
    if (_LANGUAGES == null) {
      _LANGUAGES = SplayTreeMap.from(
          switchMapKeyValue(NUMERALWORDS_LANGUAGES).map((key, value) => MapEntry(i18n(context, key), value)));
    }

    return Column(
      children: <Widget>[
        GCWDropDownButton(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
              _valueFontsizeOffset = 0;
            });
          },
          items: _LANGUAGES.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.value,
              child: mode.key,
            );
          }).toList(),
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    Map<String, String> numeralWordsOverview = new Map<String, String>();
    numeralWordsOverview = NUMERAL_WORDS[_currentLanguage];

    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
          data: numeralWordsOverview.entries.map((entry) {
              if (int.tryParse(entry.value) != null) {
                return [entry.value, entry.key];
              }
            }).toList(),
            flexValues: [1, 3],
            fontSize: defaultFontSize() + _valueFontsizeOffset
      ),
      trailing: ZOOMABLE_LANGUAGE.contains(_currentLanguage)
          ? Row(
              children: <Widget>[
                GCWIconButton(
                  size: IconButtonSize.SMALL,
                  icon: Icons.zoom_in,
                  onPressed: () {
                    if (_valueFontsizeOffset < 30) _valueFontsizeOffset++;

                    setState(() {});
                  },
                ),
                GCWIconButton(
                  size: IconButtonSize.SMALL,
                  icon: Icons.zoom_out,
                  onPressed: () {
                    if (_valueFontsizeOffset > 0) _valueFontsizeOffset--;

                    setState(() {});
                  },
                ),
              ],
            )
          : null,
    );
  }

  NumeralWordsLanguage _defaultLanguage(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    if (isLocaleSupported(appLocale)) {
      return SUPPORTED_LANGUAGES_LOCALES[appLocale];
    } else {
      return SUPPORTED_LANGUAGES_LOCALES[DEFAULT_LOCALE];
    }
  }
}
