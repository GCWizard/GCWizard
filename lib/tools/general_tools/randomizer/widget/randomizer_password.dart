import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class RandomizerPassword extends StatefulWidget {
  const RandomizerPassword({Key? key}) : super(key: key);

  @override
  _RandomizerPasswordState createState() => _RandomizerPasswordState();
}

class _RandomizerPasswordState extends State<RandomizerPassword> {
  var _currentCount = 1;
  var _currentLength = 8;

  var _currentCapitalLetters = true;
  var _currentSmallLetters = true;
  var _currentNumbers = true;
  var _currentSpecialChars = true;
  var _currentSpace = false;

  var _specifiedSpecialChars = '°!"§\$%&/()=?,.;:_-+#\'*^{[]}\\<>|';

  Widget _currentOutput = const GCWDefaultOutput();

  late TextEditingController _specialCharsController;

  @override
  void initState() {
    super.initState();

    _specialCharsController = TextEditingController(text: _specifiedSpecialChars);
  }

  @override
  void dispose() {
    _specialCharsController.dispose();

    super.dispose();
  }

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
        GCWIntegerSpinner(
          title: i18n(context, 'common_length'),
          min: 1,
          max: 1000,
          value: _currentLength,
          onChanged: (int value) {
            setState(() {
              _currentLength = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: 'A-Z',
          value: _currentCapitalLetters,
          onChanged: (bool value) {
            setState(() {
              _currentCapitalLetters = value;
            });
          }
        ),
        GCWOnOffSwitch(
          title: 'a-z',
          value: _currentSmallLetters,
          onChanged: (bool value) {
            setState(() {
              _currentSmallLetters = value;
            });
          }
        ),
        GCWOnOffSwitch(
          title: '0-9',
          value: _currentNumbers,
          onChanged: (bool value) {
            setState(() {
              _currentNumbers = value;
            });
          }
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'randomizer_password_space'),
          value: _currentSpace,
          onChanged: (bool value) {
            setState(() {
              _currentSpace = value;
            });
          }
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'randomizer_password_specialchars'),
          value: _currentSpecialChars,
          onChanged: (bool value) {
            setState(() {
              _currentSpecialChars = value;
            });
          }
        ),
        _currentSpecialChars
          ? GCWTextField(
              controller: _specialCharsController,
              onChanged: (text) {
                setState(() {
                  _specifiedSpecialChars = text;
                });
              }
            )
          : Container(),
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
    var alphabet = '';
    if (_currentCapitalLetters) {
      alphabet += alphabet_AZString.toUpperCase();
    }
    if (_currentSmallLetters) {
      alphabet += alphabet_AZString.toLowerCase();
    }
    if (_currentNumbers) {
      alphabet += '0123456789';
    }
    if (_currentSpace) {
      alphabet += ' ';
    }
    if (_currentSpecialChars) {
      alphabet += _specifiedSpecialChars;
    }

    var out = <String>[];
    for (int i = 0; i < _currentCount; i++) {
      out.add(passwordGenerator(alphabet, _currentLength));
    }

    out = out.where((String pswd) => pswd.isNotEmpty).toList();
    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: [
          GCWColumnedMultilineOutput(data: out.map((String pswd) => [pswd]).toList())
        ],
      ),
    );
  }
}
