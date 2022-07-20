import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cipher_wheel/logic/cipher_wheel.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_letter_value_relation/widget/gcw_letter_value_relation.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class CipherWheel extends StatefulWidget {
  const CipherWheel();

  @override
  CipherWheelState createState() => CipherWheelState();
}

class CipherWheelState extends State<CipherWheel> {
  var _controller;

  String _currentInput = '';
  int _currentKey = 1;
  String _output = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

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
              _calculateOutput();
            });
          },
        ),
        GCWLetterValueRelation(
          onChanged: (value) {
            setState(() {
              _currentKey = value;
              _calculateOutput();
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _calculateOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _output)
      ],
    );
  }

  _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.right) {
      var input = _currentInput
          .split(RegExp('[^0-9]+'))
          .where((number) => number != null && number.length > 0)
          .map((number) => int.tryParse(number))
          .toList();
      _output = decryptCipherWheel(input, _currentKey);
    } else {
      _output = encryptCipherWheel(_currentInput, _currentKey).join(' ');
    }
  }
}
