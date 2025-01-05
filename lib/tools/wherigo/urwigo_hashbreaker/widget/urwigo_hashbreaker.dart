import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/wherigo/krevo/logic/ucommons.dart';
import 'package:gc_wizard/tools/wherigo/logic/urwigo_tools.dart';

class UrwigoHashBreaker extends StatefulWidget {
  const UrwigoHashBreaker({Key? key}) : super(key: key);

  @override
  _UrwigoHashBreakerState createState() => _UrwigoHashBreakerState();
}

class _UrwigoHashBreakerState extends State<UrwigoHashBreaker> {
  var _currentInput = 0;
  String _currentOutputNumeric = '29735'; // Value for initial Hash == 0;
  String _currentOutputAlphabetical = 'bgqv'; // Value for initial Hash == 0;

  late TextEditingController _inputController;

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
                        _currentOutputAlphabetical = breakUrwigoHash(_currentInput, HASH.ALPHABETICAL) ?? '';
                        _currentOutputNumeric = breakUrwigoHash(_currentInput, HASH.NUMERIC) ?? '';
                      });
                    },
                  ),
                ],
              )
            : GCWTextField(
                controller: _inputController,
                onChanged: (text) {
                  setState(() {
                    _currentTextInput = text.toLowerCase();
                  });
                },
              ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.right) {
      return GCWDefaultOutput(
          child: GCWColumnedMultilineOutput(data: [
        [i18n(context, 'common_letters'), _currentOutputAlphabetical],
        [i18n(context, 'common_numbers'), _currentOutputNumeric]
      ]));
    } else {
      return GCWDefaultOutput(child: RSHash(_currentTextInput).toString());
    }
  }
}
