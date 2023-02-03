import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/houdini/logic/houdini.dart';

class Houdini extends StatefulWidget {
  @override
  HoudiniState createState() => HoudiniState();
}

class HoudiniState extends State<Houdini> {
  String _currentInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentCryptMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (mode) {
            setState(() {
              _currentMode = mode;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentCryptMode,
          title: i18n(context, 'houdini_cryptmode'),
          leftValue: i18n(context, 'houdini_cryptmode_numbers'),
          rightValue: i18n(context, 'houdini_cryptmode_letters'),
          onChanged: (mode) {
            setState(() {
              _currentCryptMode = mode;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  _houdiniMode() {
    return _currentCryptMode == GCWSwitchPosition.left ? HoudiniMode.NUMBERS : HoudiniMode.LETTERS;
  }

  _buildOutput() {
    var outputs;
    if (_currentMode == GCWSwitchPosition.left) {
      outputs = encodeHoudini(_currentInput, _houdiniMode());
    } else {
      outputs = decodeHoudini(_currentInput, _houdiniMode());
    }

    if (outputs == null) return GCWDefaultOutput();

    if (outputs[10] == null || outputs[0] == outputs[10]) {
      return GCWDefaultOutput(child: outputs[0]);
    } else {
      return Column(
        children: [
          GCWOutput(
            title: i18n(context, 'common_output') + ': "BE QUICK" = 0',
            child: outputs[0],
          ),
          GCWOutput(
            title: i18n(context, 'common_output') + ': "BE QUICK" = 10',
            child: outputs[10],
          ),
        ],
      );
    }
  }
}
