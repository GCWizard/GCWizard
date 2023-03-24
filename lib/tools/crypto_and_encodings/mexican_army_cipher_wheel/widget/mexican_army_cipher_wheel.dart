import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/gcw_letter_value_relation.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_abc_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/mexican_army_cipher_wheel/logic/mexican_army_cipher_wheel.dart';

class MexicanArmyCipherWheel extends StatefulWidget {
  const MexicanArmyCipherWheel({Key? key}) : super(key: key);

  @override
  MexicanArmyCipherWheelState createState() => MexicanArmyCipherWheelState();
}

class MexicanArmyCipherWheelState extends State<MexicanArmyCipherWheel> {
  late TextEditingController _controller;
  late TextEditingController _key4Controller;

  String _currentInput = '';
  int _currentKey1 = 1;
  int _currentKey2 = 27;
  int _currentKey3 = 53;
  int _currentKey4 = 79;
  int _currentLetterValue4 = 1;
  final String _currentKey4Text = '79';
  String _output = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);
    _key4Controller = TextEditingController(text: _currentKey4Text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _key4Controller.dispose();
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
              _currentKey1 = value;
              _calculateOutput();
            });
          },
        ),
        GCWLetterValueRelation(
          minValue: 27,
          startValue: 27,
          onChanged: (value) {
            setState(() {
              _currentKey2 = value;
              _calculateOutput();
            });
          },
        ),
        GCWLetterValueRelation(
          minValue: 53,
          startValue: 53,
          onChanged: (value) {
            setState(() {
              _currentKey3 = value;
              _calculateOutput();
            });
          },
        ),
        Row(
          children: [
            Expanded(
                child: GCWABCSpinner(
              value: _currentLetterValue4,
              suppressLetterValues: true,
              onChanged: (value) {
                setState(() {
                  _currentLetterValue4 = value;
                  _calculateOutput();
                });
              },
            )),
            Container(
              padding: const EdgeInsets.only(left: 2 * DEFAULT_MARGIN, right: 2 * DEFAULT_MARGIN),
              child: const GCWText(
                text: '=',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GCWIntegerSpinner(
                controller: _key4Controller,
                value: _currentKey4,
                min: 79,
                max: 104,
                onChanged: (value) {
                  setState(() {
                    _currentKey4 = value;

                    if (_currentKey4 == 100) {
                      _key4Controller.text = '00';
                    }
                    if (_currentKey4 >= 101) {
                      _key4Controller.text = '--- (${_currentKey4 - 100})';
                    }

                    _calculateOutput();
                  });
                },
              ),
            )
          ],
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

  void _calculateOutput() {
    var keys = [_currentKey1, _currentKey2, _currentKey3, _currentKey4 - _currentLetterValue4 + 1];

    if (_currentMode == GCWSwitchPosition.right) {
      _output = decryptMexicanArmyCipherWheel(_currentInput, keys);
    } else {
      _output = encryptMexicanArmyCipherWheel(_currentInput, keys);
    }
  }
}
