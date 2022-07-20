import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/cow/logic/cow.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

class Cow extends StatefulWidget {
  @override
  CowState createState() => CowState();
}

class CowState extends State<Cow> {
  var _textController;
  var _inputController;

  var _currentText = '';
  var _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentText);
    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _textController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_programming_mode_interpret'),
          rightValue: i18n(context, 'common_programming_mode_generate'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextField(
          controller: _textController,
          hintText: _currentMode == GCWSwitchPosition.left
              ? i18n(context, 'common_programming_hint_sourcecode')
              : i18n(context, 'common_programming_hint_output'),
          onChanged: (text) {
            setState(() {
              _currentText = text;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _inputController,
                hintText: i18n(context, 'common_programming_hint_input'),
                onChanged: (text) {
                  setState(() {
                    _currentInput = text;
                  });
                },
              )
            : Container(),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      try {
        CowOutput output = interpretCow(_currentText, STDIN: _currentInput);
        if (output.error == '')
          return output.output;
        else
          return output.output + '\n' + i18n(context, output.error);
      } on FormatException catch (e) {
        return printErrorMessage(context, e.message);
      }
    } else {
      return generateCow(_currentText);
    }
  }
}
