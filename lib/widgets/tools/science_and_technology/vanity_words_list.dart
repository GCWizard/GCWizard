import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/numeral_words.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/vanity/vanity_words.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';

class VanityWordsList extends StatefulWidget {
  @override
  VanityWordsListState createState() => VanityWordsListState();
}

class VanityWordsListState extends State<VanityWordsList> {
  TextEditingController _decodeController;

  var _currentDecodeInput = '';
  var _currentLanguage = NumeralWordsLanguage.DEU;

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
    return Column(
      children: <Widget>[
        GCWDropDownButton(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: VANITYWORDS_LANGUAGES.entries.map((mode) {
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
    Map<String, String> vanityWordsOverview = new Map<String, String>();
    vanityWordsOverview = VanWords[_currentLanguage];
    if (_currentLanguage == NumeralWordsLanguage.DEU) NUMERAL_WORDS[_currentLanguage]['fünf'] = '5';

    return GCWDefaultOutput(
        child: GCWColumnedMultilineOutput(
            data: vanityWordsOverview.entries.map((entry) {
                    return [
                      entry.key,
                      entry.value,
                      NUMERAL_WORDS[_currentLanguage][(entry.value).toLowerCase()].toString().startsWith('numeralwords_')
                          ? i18n(context, NUMERAL_WORDS[_currentLanguage][(entry.value).toLowerCase()]) + ' '
                          : NUMERAL_WORDS[_currentLanguage][entry.value.toLowerCase()]
                    ];
                  }).toList(),
          flexValues: [2, 2, 1]
        ),
    );
  }
}
