import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_abc_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';

class Caesar extends StatefulWidget {
  @override
  CaesarState createState() => CaesarState();
}

class CaesarState extends State<Caesar> {
  var _controller;

  String _currentInput = '';
  int _currentKey = 13;

  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWABCSpinner(
          title: i18n(context, 'common_key'),
          value: _currentKey,
          onChanged: (value) {
            setState(() {
              _currentKey = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  _buildOutput() {
    var _key = _currentMode == GCWSwitchPosition.right ? -_currentKey : _currentKey;
    var _output = Rotator().rotate(_currentInput, _key);

    return GCWDefaultOutput(child: _output);
  }
}
