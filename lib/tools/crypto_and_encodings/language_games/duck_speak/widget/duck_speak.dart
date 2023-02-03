import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/duck_speak/logic/duck_speak.dart';

class DuckSpeak extends StatefulWidget {
  @override
  DuckSpeakState createState() => DuckSpeakState();
}

class DuckSpeakState extends State<DuckSpeak> {
  var _currentInput = '';
  var _currentMode = GCWSwitchPosition.right;
  var _currentDuckSpeakMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(onChanged: (text) {
          setState(() {
            _currentInput = text;
          });
        }),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentDuckSpeakMode,
          title: i18n(context, 'duckspeak_version'),
          leftValue: i18n(context, 'duckspeak_version_normal'),
          rightValue: i18n(context, 'duckspeak_version_onlydigits'),
          onChanged: (value) {
            setState(() {
              _currentDuckSpeakMode = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  _buildOutput() {
    if (_currentInput == null) return '';

    if (_currentDuckSpeakMode == GCWSwitchPosition.left) {
      return _currentMode == GCWSwitchPosition.left ? encodeDuckSpeak(_currentInput) : decodeDuckSpeak(_currentInput);
    } else {
      if (_currentMode == GCWSwitchPosition.left) {
        var numbers = _currentInput
            .replaceAll(RegExp(r'[^0-9]'), '')
            .split('')
            .map((number) => int.tryParse(number))
            .where((number) => number != null)
            .toList();
        return encodeDuckSpeakNumbers(numbers);
      } else {
        return decodeDuckSpeakNumbers(_currentInput).join();
      }
    }
  }
}
