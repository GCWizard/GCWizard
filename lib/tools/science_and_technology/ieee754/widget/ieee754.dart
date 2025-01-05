import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';
import 'package:gc_wizard/tools/science_and_technology/ieee754/logic/ieee754.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class IEEE754 extends StatefulWidget {
  const IEEE754({Key? key}) : super(key: key);

  @override
  _IEEE754State createState() => _IEEE754State();
}

class _IEEE754State extends State<IEEE754> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  DoubleText _currentEncodeInput = defaultDoubleText;
  String _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentBitMode = GCWSwitchPosition.left;
  GCWSwitchPosition _currentEndian = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput.text);
    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTwoOptionsSwitch(
                leftValue: '32',
                rightValue: '64',
                value: _currentBitMode,
                onChanged: (value) {
                  setState(() {
                    _currentBitMode = value;
                  });
                },
              )
            : Container(),
        _currentMode == GCWSwitchPosition.left
            ? GCWDoubleTextField(
                controller: _encodeController,
                onChanged: (value) {
                  setState(() {
                    _currentEncodeInput = value;
                  });
                })
            : GCWTextField(
                controller: _decodeController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[01]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
            title: 'Endian',
            leftValue: 'Little (LE)',
            rightValue: 'Big (BE)',
            value: _currentEndian,
            onChanged: (value) {
              setState(() {
                _currentEndian = value;
              });
            }),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';

    if (_currentMode == GCWSwitchPosition.left) {
      var out = encodeIEEE754(_currentEncodeInput.value, _currentBitMode == GCWSwitchPosition.left);
      if (_currentEndian == GCWSwitchPosition.left) {
        out = insertEveryNthCharacter(out, 8, ' ');
        out = reverseBlocks(out).replaceAll(' ', '');
      }
      output = out;
    } else {
      output = _currentDecodeInput;
      if (_currentEndian == GCWSwitchPosition.left) {
        output = insertEveryNthCharacter(output, 8, ' ');
        output = reverseBlocks(output).replaceAll(' ', '');
      }
      output = decodeIEEE754(output).toString();
    }

    return GCWDefaultOutput(
      child: output,
    );
  }
}
