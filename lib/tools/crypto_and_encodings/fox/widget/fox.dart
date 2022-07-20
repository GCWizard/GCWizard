import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/fox/logic/fox.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/houdini/logic/houdini.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_output/widget/gcw_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class Fox extends StatefulWidget {
  @override
  FoxState createState() => FoxState();
}

class FoxState extends State<Fox> {
  String _currentInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

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
        GCWDefaultOutput(
          child: _buildOutput(),
        )
      ],
    );
  }

  _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return encodeFox(_currentInput);
    } else {
      return decodeFox(_currentInput);
    }
  }
}
