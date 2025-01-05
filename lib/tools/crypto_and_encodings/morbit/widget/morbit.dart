import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morbit/logic/morbit.dart';

class Morbit extends StatefulWidget {
  const Morbit({Key? key}) : super(key: key);

  @override
  _MorbitState createState() => _MorbitState();
}

class _MorbitState extends State<Morbit> {
  String _currentInput = '';
  String _currentKey = '';

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
        GCWTextField(
          maxLength: 10,
          hintText: i18n(context, 'morbit_key_hint'),
          onChanged: (text) {
            setState(() {
              _currentKey = text;
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

  String _buildOutput() {
    var out = '';

    if (_currentMode == GCWSwitchPosition.left) {
      out = morbitEncrypt(_currentInput, _currentKey);
    } else {
      out = morbitDecrypt(_currentInput, _currentKey);
    }

    return out;
  }
}
