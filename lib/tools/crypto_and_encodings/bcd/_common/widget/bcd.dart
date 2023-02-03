import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';

abstract class AbstractBCD extends StatefulWidget {
  final BCDType type;

  AbstractBCD({Key key, this.type}) : super(key: key);

  @override
  AbstractBCDState createState() => AbstractBCDState();
}

class AbstractBCDState extends State<AbstractBCD> {
  var _encodeController;
  var _decodeController;

  var _encodeMaskFormatter = WrapperForMaskTextInputFormatter(mask: '#' * 10000, // allow 10000 characters input
      filter: {"#": RegExp(r'[0-9]')});

  var _decode4DigitsMaskFormatter = WrapperForMaskTextInputFormatter(
      mask: '#### ' * 5000, // allow 5000 4-digit binary blocks, spaces will be set automatically after each block
      filter: {"#": RegExp(r'[01]')});

  var _decode5DigitsMaskFormatter = WrapperForMaskTextInputFormatter(
      mask: '##### ' * 5000, // allow 5000 5-digit binary blocks, spaces will be set automatically after each block
      filter: {"#": RegExp(r'[01]')});

  var _decode7DigitsMaskFormatter = WrapperForMaskTextInputFormatter(
      mask: '####### ' * 5000, // allow 5000 5-digit binary blocks, spaces will be set automatically after each block
      filter: {"#": RegExp(r'[01]')});

  var _decode10DigitsMaskFormatter = WrapperForMaskTextInputFormatter(
      mask: '########## ' * 5000, // allow 5000 5-digit binary blocks, spaces will be set automatically after each block
      filter: {"#": RegExp(r'[01]')});

  String _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentInput);
    _decodeController = TextEditingController(text: _currentInput);
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
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encodeController,
                inputFormatters: [_encodeMaskFormatter],
                onChanged: (text) {
                  setState(() {
                    _currentInput = text;
                  });
                })
            : _buildDecode(context),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildDecode(BuildContext context) {
    switch (widget.type) {
      case BCDType.ONEOFTEN:
        return GCWTextField(
            controller: _decodeController,
            inputFormatters: [_decode10DigitsMaskFormatter],
            onChanged: (text) {
              setState(() {
                _currentInput = text;
              });
            });
        break;
      case BCDType.HAMMING:
      case BCDType.BIQUINARY:
        return GCWTextField(
            controller: _decodeController,
            inputFormatters: [_decode7DigitsMaskFormatter],
            onChanged: (text) {
              setState(() {
                _currentInput = text;
              });
            });
        break;
      case BCDType.LIBAWCRAIG:
      case BCDType.TWOOFFIVE:
      case BCDType.PLANET:
      case BCDType.POSTNET:
        return GCWTextField(
            controller: _decodeController,
            inputFormatters: [_decode5DigitsMaskFormatter],
            onChanged: (text) {
              setState(() {
                _currentInput = text;
              });
            });
        break;
      default:
        return GCWTextField(
            controller: _decodeController,
            inputFormatters: [_decode4DigitsMaskFormatter],
            onChanged: (text) {
              setState(() {
                _currentInput = text;
              });
            });
    }
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';

    if (_currentMode == GCWSwitchPosition.left) {
      output = encodeBCD(_currentInput, widget.type);
    } else {
      output = decodeBCD(_currentInput, widget.type);
    }

    return GCWDefaultOutput(child: output);
  }
}
