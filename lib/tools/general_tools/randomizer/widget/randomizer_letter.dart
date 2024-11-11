import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer_lists.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class RandomizerLetter extends StatefulWidget {
  const RandomizerLetter({Key? key}) : super(key: key);

  @override
  _RandomizerLetterState createState() => _RandomizerLetterState();
}

enum _LetterCase {SMALL, CAPITAL, BOTH}

class _RandomizerLetterState extends State<RandomizerLetter> {
  var _currentCount = 1;
  var _currentRepeat = true;

  var _currentAlphabet = alphabetAZ;

  var _currentCase = _LetterCase.CAPITAL;

  Widget _currentOutput = const GCWDefaultOutput();

  final _alphabets = [
    alphabetAZ,
    alphabetGerman1,
    alphabetDanish,
    alphabetFrench2,
    alphabetSpanish1,
    alphabetPolish1,
    alphabetGreek1,
    alphabetRussian1
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: 1000,
          value: _currentCount,
          onChanged: (int value) {
            setState(() {
              _currentCount = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'randomizer_repeat'),
          value: _currentRepeat,
          onChanged: (bool value) {
            setState(() {
              _currentRepeat = value;
            });
          }
        ),
        GCWDropDown<Alphabet>(
          title: i18n(context, 'common_alphabet'),
          value: _currentAlphabet,
          items: _alphabets.map((Alphabet value) {
            return GCWDropDownMenuItem(
              value: value,
              child: i18n(context, value.key).split(RegExp(r'[^A-Za-z]'))[0]
            );
          }).toList(),
          onChanged: (Alphabet value) {
            setState(() {
              _currentAlphabet = value;
            });
          }
        ),
        GCWDropDown<_LetterCase>(
            title: i18n(context, 'common_case_sensitive'),
            value: _currentCase,
            items: _LetterCase.values.map((_LetterCase value) {
              String text = '';
              switch (value) {
                case _LetterCase.SMALL: text = i18n(context, 'randomizer_letter_smallcase'); break;
                case _LetterCase.CAPITAL: text = i18n(context, 'randomizer_letter_capitalcase'); break;
                case _LetterCase.BOTH: text = i18n(context, 'randomizer_letter_bothcases'); break;
                default: break;
              }

              return GCWDropDownMenuItem(
                  value: value,
                  child: text
              );
            }).toList(),
            onChanged: (_LetterCase value) {
              setState(() {
                _currentCase = value;
              });
            }
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        _currentOutput
      ],
    );
  }

  void _calculateOutput() {
    var out = <String>[];

    if (_currentRepeat == false) {
      var list = List<String>.generate(_currentAlphabet.alphabet.length, (index) => _currentAlphabet.alphabet.keys.toList()[index].toUpperCase());
      if (_currentCase == _LetterCase.BOTH) {
        list.addAll(
          List<String>.generate(_currentAlphabet.alphabet.length, (index) => _currentAlphabet.alphabet.keys.toList()[index].toLowerCase())
        );
      }
      out = shuffleList(list).sublist(0, min(_currentCount, list.length));
    } else {
      for (int i = 0; i < _currentCount; i++) {
        out.add(randomLetter(_currentAlphabet, _currentCase != _LetterCase.BOTH));
      }
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    switch (_currentCase) {
      case _LetterCase.SMALL: out = out.map((String char) => char.toLowerCase()).toList(); break;
      case _LetterCase.CAPITAL: out = out.map((String char) => char.toUpperCase()).toList(); break;
      default: break;
    }

    var av = AlphabetValues(alphabet: _currentAlphabet.alphabet);

    var outText = out.join();
    var outValues = List<int>.from(av.textToValues(outText).where((int? value) => value != null));

    var output = <Widget>[];
    if (_currentRepeat == false && out.length < _currentCount) {
      output.add(GCWOutput(child: i18n(context, 'randomizer_letter_notenoughdistinct'), suppressCopyButton: true));
      output.add(Container(height: DOUBLE_DEFAULT_MARGIN));
    }
    output.add(GCWOutput(child: outText));
    output.add(CrosstotalOutput(text: outText, values: outValues));

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: output,
      ),
    );
  }
}
