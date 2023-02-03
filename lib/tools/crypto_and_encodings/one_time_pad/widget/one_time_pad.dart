import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/logic/one_time_pad.dart';

class OneTimePad extends StatefulWidget {
  @override
  OneTimePadState createState() => OneTimePadState();
}

class OneTimePadState extends State<OneTimePad> {
  TextEditingController _inputController;
  TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';

  var _currentOffset = 0;

  var _currentMode = GCWSwitchPosition.right;

  // two same maskTextInputFormatters are necessary because using the same formatter creates conflicts
  // (entered value in one input will be used for the other one)
  var _mask = '#' * 10000;
  var _filter = {"#": RegExp(r'[A-Za-z]')};
  var _inputMaskInputFormatter;
  var _keyMaskInputFormatter;

  @override
  void initState() {
    super.initState();

    _inputMaskInputFormatter = WrapperForMaskTextInputFormatter(mask: _mask, filter: _filter);
    _keyMaskInputFormatter = WrapperForMaskTextInputFormatter(mask: _mask, filter: _filter);

    _inputController = TextEditingController(text: _currentInput);
    _keyController = TextEditingController(text: _currentKey);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          hintText: i18n(context, 'onetimepad_input'),
          inputFormatters: [_inputMaskInputFormatter],
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextField(
          hintText: i18n(context, 'onetimepad_key'),
          inputFormatters: [_keyMaskInputFormatter],
          controller: _keyController,
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'onetimepad_keyoffset'),
          value: _currentOffset + 1,
          onChanged: (value) {
            setState(() {
              _currentOffset = value - 1;
            });
          },
        ),
        GCWTwoOptionsSwitch(
            value: _currentMode,
            onChanged: (value) {
              setState(() {
                _currentMode = value;
              });
            }),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  _calculateOutput() {
    return _currentMode == GCWSwitchPosition.left
        ? encryptOneTimePad(_currentInput, _currentKey, keyOffset: _currentOffset)
        : decryptOneTimePad(_currentInput, _currentKey, keyOffset: _currentOffset);
  }
}
