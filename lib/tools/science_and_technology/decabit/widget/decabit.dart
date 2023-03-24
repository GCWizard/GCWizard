import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/decabit/logic/decabit.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class Decabit extends StatefulWidget {
  const Decabit({Key? key}) : super(key: key);

  @override
  DecabitState createState() => DecabitState();
}

class DecabitState extends State<Decabit> {
  late TextEditingController _inputController;
  late TextEditingController _aController;
  late TextEditingController _bController;

  var _currentInput = '';
  var _currentA = '+';
  var _currentB = '-';

  var _currentMode = GCWSwitchPosition.right;
  bool _numericMode = false;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _aController = TextEditingController(text: _currentA);
    _bController = TextEditingController(text: _currentB);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _aController.dispose();
    _bController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        _buildInputButtons(context),
        GCWTextDivider(text: i18n(context, 'common_key')),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: GCWTextField(
                    controller: _aController,
                    onChanged: (text) {
                      setState(() {
                        _currentA = text;
                      });
                    },
                  )),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: GCWTextField(
                    controller: _bController,
                    onChanged: (text) {
                      setState(() {
                        _currentB = text;
                      });
                    },
                  )),
            ),
          ],
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWOnOffSwitch(
          value: _numericMode,
          title: i18n(context, 'decabit_numeric_mode'),
          onChanged: (value) {
            setState(() {
              _numericMode = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Widget _buildInputButtons(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.left) return Container();

    return GCWToolBar(children: [
      GCWButton(
        text: _currentA,
        onPressed: () {
          setState(() {
            _addCharacter(_currentA);
          });
        },
      ),
      GCWButton(
        text: _currentB,
        onPressed: () {
          setState(() {
            _addCharacter(_currentB);
          });
        },
      ),
      GCWIconButton(
        icon: Icons.backspace,
        onPressed: () {
          setState(() {
            _currentInput = textControllerDoBackSpace(_currentInput, _inputController);
          });
        },
      ),
    ]);
  }

  void _addCharacter(String input) {
    _currentInput = textControllerInsertText(input, _currentInput, _inputController);
  }

  String _buildOutput() {
    if (_currentInput.isEmpty || _currentA.isEmpty || _currentB.isEmpty) return '';

    var key = {'+': _currentA, '-': _currentB};
    return _currentMode == GCWSwitchPosition.left
        ? encryptDecabit(_currentInput, key, _numericMode)
        : decryptDecabit(_currentInput, key, _numericMode);
  }
}
