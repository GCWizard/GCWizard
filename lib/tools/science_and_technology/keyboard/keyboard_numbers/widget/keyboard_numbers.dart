import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/keyboard/_common/logic/keyboard.dart';

class KeyboardNumbers extends StatefulWidget {
  const KeyboardNumbers({Key? key}) : super(key: key);

  @override
  KeyboardNumbersState createState() => KeyboardNumbersState();
}

class KeyboardNumbersState extends State<KeyboardNumbers> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
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
            ? GCWTextField(
                controller: _encodeController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]'))],
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
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
        const GCWDefaultOutput(),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    List<List<String>> outputData;
    List<List<String>> output = <List<String>>[];

    if (_currentMode == GCWSwitchPosition.left) {
      outputData = encodeKeyboardNumbers(_currentEncodeInput);
    } else {
      outputData = decodeKeyboardNumbers(_currentDecodeInput);
    }

    for (int i = 0; i < outputData.length; i++) {
      output.add([i18n(context, outputData[i][0]), outputData[i][1]]);
    }

    return GCWColumnedMultilineOutput(data: output);
  }
}
