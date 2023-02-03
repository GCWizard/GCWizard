import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/logic/bacon.dart';

class Bacon extends StatefulWidget {
  @override
  BaconState createState() => BaconState();
}

class BaconState extends State<Bacon> {
  var _controller;

  var _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _binaryMode = GCWSwitchPosition.left;
  bool _inversMode = false;

  String _output = '';

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
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'bacon_coding'),
          leftValue: 'AB',
          rightValue: '01',
          value: _binaryMode,
          onChanged: (value) {
            setState(() {
              _binaryMode = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: _binaryMode == GCWSwitchPosition.left ? 'AAAAB → BBBBA' : '00001 → 11110',
          value: _inversMode,
          onChanged: (value) {
            setState(() {
              _inversMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      _output = encodeBacon(_currentInput, _inversMode, _binaryMode == GCWSwitchPosition.right);
    } else {
      _output = decodeBacon(_currentInput, _inversMode, _binaryMode == GCWSwitchPosition.right);
    }

    return GCWDefaultOutput(child: _output);
  }
}
