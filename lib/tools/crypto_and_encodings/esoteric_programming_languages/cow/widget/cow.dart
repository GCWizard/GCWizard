import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/cow/logic/cow.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class Cow extends StatefulWidget {
  const Cow({Key? key}) : super(key: key);

  @override
  CowState createState() => CowState();
}

class CowState extends State<Cow> {
  late TextEditingController _textController;
  late TextEditingController _inputController;

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

  String _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      try {
        CowOutput output = interpretCow(_currentText, STDIN: _currentInput);
        if (output.error.isEmpty) {
          return output.output;
        } else {
          return output.output + '\n' + i18n(context, output.error);
        }
      } on FormatException catch (e) {
        return printErrorMessage(context, e.message);
      }
    } else {
      return generateCow(_currentText);
    }
  }
}
