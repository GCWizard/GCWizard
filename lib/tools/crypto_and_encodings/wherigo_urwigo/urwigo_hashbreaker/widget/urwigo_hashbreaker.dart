import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wherigo_urwigo/krevo/logic/ucommons.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wherigo_urwigo/logic/urwigo_tools.dart';
import 'package:gc_wizard/tools/common/base/gcw_button/widget/gcw_button.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_integer_spinner/widget/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class UrwigoHashBreaker extends StatefulWidget {
  @override
  UrwigoHashBreakerState createState() => UrwigoHashBreakerState();
}

class UrwigoHashBreakerState extends State<UrwigoHashBreaker> {
  var _currentInput = 0;
  var _currentOutput = '';

  var _inputController;

  String _currentTextInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentTextInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'urwigo_hashbreaker_mode_hash'),
          rightValue: i18n(context, 'urwigo_hashbreaker_mode_break_hash'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.right
            ? Column(
                children: <Widget>[
                  GCWIntegerSpinner(
                    title: i18n(context, 'urwigo_hashbreaker_input'),
                    value: _currentInput,
                    min: 0,
                    max: 65534,
                    onChanged: (value) {
                      setState(() {
                        _currentInput = value;
                      });
                    },
                  ),
                  GCWButton(
                    text: i18n(context, 'common_submit_button_text'),
                    onPressed: () {
                      setState(() {
                        _currentOutput = breakUrwigoHash(_currentInput);
                      });
                    },
                  ),
                ],
              )
            : GCWTextField(
                controller: _inputController,
                onChanged: (text) {
                  setState(() {
                    _currentTextInput = text;
                  });
                },
              ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.right) {
      return GCWDefaultOutput(child: _currentOutput);
    } else {
      return GCWDefaultOutput(child: RSHash(_currentTextInput).toString());
    }
  }
}
