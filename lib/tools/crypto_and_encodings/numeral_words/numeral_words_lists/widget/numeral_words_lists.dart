import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/i18n/supported_locales.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

class NumeralWordsLists extends StatefulWidget {
  const NumeralWordsLists({Key? key}) : super(key: key);

  @override
  NumeralWordsListsState createState() => NumeralWordsListsState();
}

class NumeralWordsListsState extends State<NumeralWordsLists> {
  late TextEditingController _decodeController;

  final _currentDecodeInput = '';
  var _currentLanguage = NumeralWordsLanguage.DEU;
  int _valueFontsizeOffset = 0;
  bool _setDefaultLanguage = false;

  SplayTreeMap<String, NumeralWordsLanguage>? _LANGUAGES;

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
    _LANGUAGES ??= SplayTreeMap.from(
          switchMapKeyValue(NUMERALWORDS_LANGUAGES).map((key, value) => MapEntry(i18n(context, key), value)));

    return Column(
      children: <Widget>[
        GCWDropDown<NumeralWordsLanguage>(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
              _valueFontsizeOffset = 0;
            });
          },
          items: _LANGUAGES!.entries.map((mode) {
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
    var numeralWordsOverview = <String, String>{};
    numeralWordsOverview = NUMERAL_WORDS[_currentLanguage] ?? {};
    var wordList = numeralWordsOverview.entries.map((entry) {
      return (int.tryParse(entry.value) != null) ? [entry.value, entry.key] : <String>[];
    });
    return GCWDefaultOutput(
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
      child: GCWColumnedMultilineOutput(
          data: wordList.where((element) => element.isNotEmpty).toList(),
          flexValues: const [1, 3],
          fontSize: defaultFontSize() + _valueFontsizeOffset
      ),
    );
  }

  NumeralWordsLanguage _defaultLanguage(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    if (isLocaleSupported(appLocale)) {
      return SUPPORTED_LANGUAGES_LOCALES[appLocale]!;
    } else {
      return SUPPORTED_LANGUAGES_LOCALES[DEFAULT_LOCALE]!;
    }
  }
}
