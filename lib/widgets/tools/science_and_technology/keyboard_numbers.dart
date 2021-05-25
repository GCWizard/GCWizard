import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/keyboard.dart';
import 'package:gc_wizard/widgets/common/base/gcw_divider.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class KeyboardNumbers extends StatefulWidget {
  @override
  KeyboardNumbersState createState() => KeyboardNumbersState();
}

class KeyboardNumbersState extends State<KeyboardNumbers> {
  TextEditingController _encodeController;
  TextEditingController _decodeController;

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
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9 .]*$'))],
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[!"§$%&/()={[]}²³{[]}@^]*$'))],
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        GCWDefaultOutput(),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var outputData;
    List<List<String>> output = new List<List<String>>();

    if (_currentMode == GCWSwitchPosition.left) {
      outputData = encodeKeyboardNumbers(_currentEncodeInput);
    } else
      outputData = decodeKeyboardNumbers(_currentDecodeInput);

    for (int i = 0; i < outputData.length; i++) {
      output.add([i18n(context, outputData[i][0]), outputData[i][1]]);
    }

    outputData = columnedMultiLineOutput(context, output);

    return Column(children: outputData);
  }
}
