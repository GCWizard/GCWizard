import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pollux/logic/pollux.dart';

class Pollux extends StatefulWidget {
  const Pollux({Key? key}) : super(key: key);

  @override
  _PolluxState createState() => _PolluxState();
}

class _PolluxState extends State<Pollux> {
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
          hintText: i18n(context, 'pollux_key_hint'),
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

    try {
      if (_currentMode == GCWSwitchPosition.left) {
        out = polluxEncrypt(_currentInput, _currentKey);
      } else {
        out = polluxDecrypt(_currentInput, _currentKey);
      }
    } on FormatException catch (e) {
      out = i18n(context, e.message);
    }

    return out;
  }
}
