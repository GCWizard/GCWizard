import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';

class RomanNumbers extends StatefulWidget {
  @override
  RomanNumbersState createState() => RomanNumbersState();
}

class RomanNumbersState extends State<RomanNumbers> {
  var _decodeController;

  var _currentEncodeInput = 1;
  var _currentDecodeInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWIntegerSpinner(
                min: 1,
                max: 100000,
                value: _currentEncodeInput,
                onChanged: (value) {
                  setState(() {
                    _currentEncodeInput = value;
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'romannumbers_numberstoroman'),
          rightValue: i18n(context, 'romannumbers_romantonumbers'),
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
    List<dynamic> output;

    if (_currentMode == GCWSwitchPosition.left) {
      if (_currentEncodeInput == null) return GCWDefaultOutput();

      output = [
        encodeRomanNumbers(_currentEncodeInput, type: RomanNumberType.USE_SUBTRACTION_RULE) ?? '',
        encodeRomanNumbers(_currentEncodeInput, type: RomanNumberType.ONLY_ADDITION) ?? ''
      ];
    } else {
      if (_currentDecodeInput == null || _currentDecodeInput.isEmpty) return GCWDefaultOutput();

      output = [
        _currentDecodeInput
            .split(RegExp(r'\s+'))
            .map((number) => decodeRomanNumbers(number, type: RomanNumberType.USE_SUBTRACTION_RULE))
            .where((number) => number != null)
            .join(' '),
        _currentDecodeInput
            .split(RegExp(r'\s+'))
            .map((number) => decodeRomanNumbers(number, type: RomanNumberType.ONLY_ADDITION))
            .where((number) => number != null)
            .join(' ')
      ];
    }

    return GCWMultipleOutput(children: [
      output[0],
      GCWOutput(
        child: output[1],
        title: i18n(context, 'romannumbers_withoutsubtractionrule'),
      )
    ]);
  }
}
