import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/hohoho/logic/hohoho.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class Hohoho extends StatefulWidget {
  const Hohoho({Key? key}) : super(key: key);

  @override
  HohohoState createState() => HohohoState();
}

class HohohoState extends State<Hohoho> {
  late TextEditingController _textEncodeController;
  late TextEditingController _textDecodeController;
  late TextEditingController _inputController;

  var _currentEncodeText = '';
  var _currentDecodeText = '';
  var _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _textEncodeController = TextEditingController(text: _currentEncodeText);
    _textDecodeController = TextEditingController(text: _currentDecodeText);
    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _textEncodeController.dispose();
    _textDecodeController.dispose();
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
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _textDecodeController,
                hintText: i18n(context, 'common_programming_hint_sourcecode'),
                onChanged: (text) {
                  setState(() {
                    _currentDecodeText = text;
                  });
                },
              )
            : GCWTextField(
                controller: _textEncodeController,
                hintText: i18n(context, 'common_programming_hint_output'),
                onChanged: (text) {
                  setState(() {
                    _currentEncodeText = text;
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
        HohohoOutput output = interpretHohoho(_currentDecodeText, STDIN: _currentInput);
        if (output.error.isEmpty) {
          return output.output;
        } else {
          return output.output + '\n' + i18n(context, output.error);
        }
      } on FormatException catch (e) {
        return printErrorMessage(context, e.message);
      }
    } else {
      return generateHohoho(_currentEncodeText);
    }
  }
}
