import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gray/logic/gray.dart';

class Gray extends StatefulWidget {
  const Gray({Key? key}) : super(key: key);

  @override
  _GrayState createState() => _GrayState();
}

class _GrayState extends State<Gray> {
  late TextEditingController _inputDecimalController;
  late TextEditingController _inputBinaryController;

  String _currentDecimalInput = '';
  String _currentBinaryInput = '';
  var _currentOutput = GrayOutput([], []);

  GCWSwitchPosition _currentInputMode = GCWSwitchPosition.left;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  final _decimalMaskFormatter = GCWMaskTextInputFormatter(mask: '#' * 10000, filter: {"#": RegExp(r'[0-9\s]')});

  final _binaryDigitsMaskFormatter = GCWMaskTextInputFormatter(mask: '#' * 10000, filter: {"#": RegExp(r'[01\s]')});

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
                onChanged: (text) {
                  setState(() {
                    _currentDecimalInput = text;
                  });
                })
            : GCWTextField(
                controller: _inputBinaryController,
                inputFormatters: [_binaryDigitsMaskFormatter],
                onChanged: (text) {
                  setState(() {
                    _currentBinaryInput = text;
                  });
                }),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'gray_mode_decimal'),
          rightValue: i18n(context, 'gray_mode_binary'),
          value: _currentInputMode,
          onChanged: (value) {
            setState(() {
              _currentInputMode = value;
            });
          },
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.left) {
      if (_currentInputMode == GCWSwitchPosition.left) {
        _currentOutput = encodeGray(_currentDecimalInput, mode: GrayMode.DECIMAL);
      } else {
        // input is binary
        _currentOutput = encodeGray(_currentBinaryInput, mode: GrayMode.BINARY);
      }
    } else {
      if (_currentInputMode == GCWSwitchPosition.left) {
        _currentOutput = decodeGray(_currentDecimalInput, mode: GrayMode.DECIMAL);
      } else {
        _currentOutput = decodeGray(_currentBinaryInput, mode: GrayMode.BINARY);
      }
    }

    var outputChildren = <Widget>[];

    if (_currentOutput.decimalOutput.isNotEmpty) {
      outputChildren.add(
        GCWOutput(
          title: i18n(context, 'gray_mode_decimal'),
          child: _currentOutput.decimalOutput.join(' '),
        ),
      );
    }

    if (_currentOutput.binaryOutput.isNotEmpty) {
      outputChildren.add(
        GCWOutput(
          title: i18n(context, 'gray_mode_binary'),
          child: _currentOutput.binaryOutput.join(' '),
        ),
      );
    }

    return GCWDefaultOutput(
      child: Column(
        children: outputChildren,
      ),
    );
  }
}
