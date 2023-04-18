import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class NumeralWordsConverter extends StatefulWidget {
  const NumeralWordsConverter({Key? key}) : super(key: key);

  @override
  NumeralWordsConverterState createState() => NumeralWordsConverterState();
}

class NumeralWordsConverterState extends State<NumeralWordsConverter> {
  late TextEditingController _decodeController;

  var _currentDecodeInput = '';

  var _currentLanguage = NumeralWordsLanguage.KLI;

  int _currentNumber = 0;

  SplayTreeMap<String, NumeralWordsLanguage>? _LANGUAGES;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

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
    _LANGUAGES ??= SplayTreeMap.from(
        switchMapKeyValue(NUMERALWORDS_LANGUAGES_CONVERTER).map((key, value) => MapEntry(i18n(context, key), value)));

    return Column(
      children: <Widget>[
        GCWDropDown<NumeralWordsLanguage>(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;

              if (_currentMode == GCWSwitchPosition.left) {
                var min = MIN_MAX_NUMBER[_currentLanguage]![0];
                var max = MIN_MAX_NUMBER[_currentLanguage]![1];
                if (_currentNumber < min) {
                  _currentNumber = min;
                } else if (_currentNumber > max) {
                  _currentNumber = max;
                }
              }
            });
          },
          items: _LANGUAGES!.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.value,
              child: mode.key,
            );
          }).toList(),
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        if (_currentMode == GCWSwitchPosition.right) // decode
          GCWTextField(
            controller: _decodeController,
            onChanged: (text) {
              setState(() {
                _currentDecodeInput = text;
              });
            },
          )
        else // encode
          GCWIntegerSpinner(
            min: MIN_MAX_NUMBER[_currentLanguage]![0],
            max: MIN_MAX_NUMBER[_currentLanguage]![1],
            value: _currentNumber,
            onChanged: (value) {
              setState(() {
                _currentNumber = value;
              });
            },
          ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutputEncode(BuildContext context) {
    OutputConvertToNumeralWord output = encodeNumberToNumeralWord(_currentLanguage, _currentNumber);

    return GCWDefaultOutput(
        child: Column(children: <Widget>[
            Column(
              children: <Widget>[
                GCWOutputText(
                  text: output.numeralWord,
                ),
                if (output.nameOfNumberSystem.isNotEmpty)
                  Column(
                    children: <Widget>[
                      GCWTextDivider(text: i18n(context, output.nameOfNumberSystem)),
                      GCWOutputText(
                        text: output.numbersystem,
                      ),
                    ]
                  )
              ],
            ),
        ]));
  }

  Widget _buildOutputDecode(BuildContext context) {
    OutputConvertToNumber output = decodeNumeralWordToNumber(_currentLanguage, removeAccents(_currentDecodeInput).toLowerCase());

    if (output.error.isNotEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, output.error),
      );
    }

    return GCWDefaultOutput(
        child: Column(children: <Widget>[
          GCWOutputText(
            text: _currentDecodeInput.isEmpty ? '' : output.number.toString(),
          ),
          if (output.nameOfNumberSystem.isNotEmpty)
            Column(
              children: <Widget>[
                GCWTextDivider(text: i18n(context, output.nameOfNumberSystem)),
                GCWOutputText(
                  text: output.numbersystem,
                ),
              ],
            ),
        ]));
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.right) {
      return _buildOutputDecode(context);
    } else {
      return _buildOutputEncode(context);
    }
  }

}