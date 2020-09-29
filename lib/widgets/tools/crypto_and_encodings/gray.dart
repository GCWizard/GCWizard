import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/gray.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/wrapper_for_masktextinputformatter.dart';

class Gray extends StatefulWidget {
  @override
  GrayState createState() => GrayState();
}

class GrayState extends State<Gray> {
  var _inputDecimalController;
  var _inputBinaryController;

  String _currentDecimalInput = '';
  String _currentBinaryInput = '';
  var _currentOutput = GrayOutput([], []);

  GCWSwitchPosition _currentInputMode = GCWSwitchPosition.left;
  GCWSwitchPosition _currentCodingMode = GCWSwitchPosition.left;

  var _decimalMaskFormatter = WrapperForMaskTextInputFormatter(
    mask: '#' * 10000,
    filter: {"#": RegExp(r'[0-9\s]')}
  );

  var _binaryDigitsMaskFormatter = WrapperForMaskTextInputFormatter(
    mask: '#' * 10000,
    filter: {"#": RegExp(r'[01\s]')}
  );


  @override
  void initState() {
    super.initState();
    _inputDecimalController = TextEditingController(text: _currentDecimalInput);
    _inputBinaryController = TextEditingController(text: _currentBinaryInput);
  }

  @override
  void dispose() {
    _inputBinaryController.dispose();
    _inputDecimalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[

        _currentInputMode == GCWSwitchPosition.left
          ? GCWTextField(
            controller: _inputDecimalController,
            inputFormatters: [_decimalMaskFormatter],
            onChanged: (text){
              setState(() {
                _currentDecimalInput = text;
              });
            }
          )
          : GCWTextField (
            controller: _inputBinaryController,
            inputFormatters: [_binaryDigitsMaskFormatter],
            onChanged: (text){
              setState(() {
                _currentBinaryInput = text;
              });
            }
          ),

        GCWTwoOptionsSwitch(
          title: i18n(context, 'gray_mode'),
          leftValue: i18n(context, 'gray_mode_decimal'),
          rightValue: i18n(context, 'gray_mode_binary'),
          onChanged: (value) {
            setState(() {
              _currentInputMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          onChanged: (value) {
            setState(() {
              _currentCodingMode = value;
            });
          },
        ),

        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentCodingMode == GCWSwitchPosition.left) {
      if (_currentInputMode == GCWSwitchPosition.left) {
         _currentOutput = encodeGray(_currentDecimalInput, mode: GrayMode.DECIMAL);
      } else {// input is binary
         _currentOutput = encodeGray(_currentBinaryInput, mode: GrayMode.BINARY);
      }
    } else {
      if (_currentInputMode == GCWSwitchPosition.left) {
         _currentOutput = decodeGray(_currentDecimalInput, mode: GrayMode.DECIMAL);
      } else {
         _currentOutput = decodeGray(_currentBinaryInput, mode: GrayMode.BINARY);
      }
    }

    if (_currentOutput == null )
      return GCWDefaultOutput();

    var outputChildren = <Widget>[];

    if (_currentOutput.decimalOutput != null && _currentOutput.decimalOutput.length > 0)
      outputChildren.add(
        GCWOutput(
          title: i18n(context, 'gray_mode_decimal'),
          child: _currentOutput.decimalOutput.join(' '),
        ),
      );

    if (_currentOutput.binaryOutput != null && _currentOutput.binaryOutput.length > 0)
      outputChildren.add(
        GCWOutput(
          title: i18n(context, 'gray_mode_binary'),
          child: _currentOutput.binaryOutput.join(' '),
        ),
      );

    return GCWDefaultOutput(
      child: Column(
        children: outputChildren,
      ),
    );
  }
}