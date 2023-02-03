import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gade/logic/gade.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class Gade extends StatefulWidget {
  @override
  GadeState createState() => GadeState();
}

class GadeState extends State<Gade> {
  var _GadeInputController;
  String _currentGadeInput = '';

  bool _currentParseLetters = true;

  @override
  void initState() {
    super.initState();
    _GadeInputController = TextEditingController(text: _currentGadeInput);
  }

  @override
  void dispose() {
    _GadeInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _GadeInputController,
          onChanged: (text) {
            setState(() {
              _currentGadeInput = text;
            });
          },
        ),
        GCWOnOffSwitch(
          value: _currentParseLetters,
          title: i18n(context, 'gade_parselettervalues'),
          onChanged: (mode) {
            setState(() {
              _currentParseLetters = mode;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    String _input;
    if (_currentParseLetters) {
      _input = AlphabetValues(alphabet: alphabetAZ.alphabet)
          .textToValues(_currentGadeInput, keepNumbers: true)
          .where((e) => e != null)
          .join(' ');
    } else {
      _input = _currentGadeInput.replaceAll(RegExp(r'[^0-9]'), '');
    }

    var sorted = _input.replaceAll(RegExp(r'[^0-9]'), '').split('').toList();
    sorted.sort();
    var sortedStr = sorted.join();

    return Column(
      children: [
        GCWOutput(
            title: i18n(context, 'common_input'),
            child: GCWColumnedMultilineOutput(
            data: [
                    [i18n(context, 'gade_parsed'), _input],
                    [i18n(context, 'gade_sorted'), sortedStr]
                  ]
            )
        ),
        GCWDefaultOutput(
          child: GCWColumnedMultilineOutput(
              data: buildGade(_input).entries.map((entry) {
                            return [entry.key, entry.value];
                          }).toList()
          ),
        )
      ],
    );
  }
}
