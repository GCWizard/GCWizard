import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/logic/deadfish.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class Deadfish extends StatefulWidget {
  @override
  DeadfishState createState() => DeadfishState();
}

class DeadfishState extends State<Deadfish> {
  var _currentInput = '';
  var _currentMode = GCWSwitchPosition.left;
  var _currentDeadfishMode = GCWSwitchPosition.left;

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
          leftValue: i18n(context, 'deadfish_mode_left'),
          rightValue: i18n(context, 'deadfish_mode_right'),
          value: _currentDeadfishMode,
          onChanged: (value) {
            setState(() {
              _currentDeadfishMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'common_programming_mode_interpret'),
          rightValue: i18n(context, 'common_programming_mode_generate'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  _buildOutput() {
    if (_currentInput == null) return '';

    if (_currentMode == GCWSwitchPosition.right) {
      var encoded = encodeDeadfish(_currentInput);
      if (_currentDeadfishMode == GCWSwitchPosition.right) //XKCD
        encoded = encoded.replaceAll('i', 'x').replaceAll('s', 'k').replaceAll('o', 'c');

      return encoded;
    } else {
      var decodeable = _currentInput;
      if (_currentDeadfishMode == GCWSwitchPosition.right) //XKCD
        decodeable = decodeable
            .toLowerCase()
            .replaceAll(RegExp(r'[iso]'), '')
            .replaceAll('x', 'i')
            .replaceAll('k', 's')
            .replaceAll('c', 'o');

      return decodeDeadfish(decodeable);
    }
  }
}
