import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk_derivative.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class Brainfk extends StatefulWidget {
  final String Function(String, {String? input})? interpret;
  final String Function(String)? generate;

  const Brainfk({Key? key, this.interpret, this.generate}) : super(key: key);

  @override
  _BrainfkState createState() => _BrainfkState();
}

class _BrainfkState extends State<Brainfk> {
  late TextEditingController _textController;
  late TextEditingController _inputController;
  late TextEditingController _inputController_shiftRight;
  late TextEditingController _inputController_shiftLeft;
  late TextEditingController _inputController_increaseValue;
  late TextEditingController _inputController_decreaseValue;
  late TextEditingController _inputController_output;
  late TextEditingController _inputController_input;
  late TextEditingController _inputController_startLoop;
  late TextEditingController _inputController_endLoop;

  BrainfkDerivatives _currentDerivate = BRAINFKDERIVATIVE_OOK;

  String _currentText = '';
  String _currentInput = '';
  String _currentInput_shiftRight = '';
  String _currentInput_shiftLeft = '';
  String _currentInput_increaseValue = '';
  String _currentInput_decreaseValue = '';
  String _currentInput_output = '';
  String _currentInput_input = '';
  String _currentInput_startLoop = '';
  String _currentInput_endLoop = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;
  GCWSwitchPosition _currentOriginal = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentText);
    _inputController = TextEditingController(text: _currentInput);
    _inputController_shiftRight = TextEditingController(text: _currentInput_shiftRight);
    _inputController_shiftLeft = TextEditingController(text: _currentInput_shiftLeft);
    _inputController_increaseValue = TextEditingController(text: _currentInput_increaseValue);
    _inputController_decreaseValue = TextEditingController(text: _currentInput_decreaseValue);
    _inputController_output = TextEditingController(text: _currentInput_output);
    _inputController_input = TextEditingController(text: _currentInput_input);
    _inputController_startLoop = TextEditingController(text: _currentInput_startLoop);
    _inputController_endLoop = TextEditingController(text: _currentInput_endLoop);
  }

  @override
  void dispose() {
    _textController.dispose();
    _inputController.dispose();
    _inputController_shiftRight.dispose();
    _inputController_shiftLeft.dispose();
    _inputController_increaseValue.dispose();
    _inputController_decreaseValue.dispose();
    _inputController_output.dispose();
    _inputController_input.dispose();
    _inputController_startLoop.dispose();
    _inputController_endLoop.dispose();
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
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'brainfk_original'),
          rightValue: i18n(context, 'brainfk_substitition'),
          value: _currentOriginal,
          onChanged: (value) {
            setState(() {
              _currentOriginal = value;
            });
          },
        ),
        _currentOriginal == GCWSwitchPosition.left
            ? Container()
            : Column(children: <Widget>[
                GCWDropDown<BrainfkDerivatives>(
                  value: _currentDerivate,
                  onChanged: (value) {
                    setState(() {
                      _currentDerivate = value;
                    });
                  },
                  items: BRAINFK_DERIVATIVES.entries.map((mode) {
                    return GCWDropDownMenuItem(
                      value: mode.key,
                      child: mode.value,
                    );
                  }).toList(),
                ),
                _currentDerivate == BRAINFKDERIVATIVE_CUSTOM
                    ? Column(children: [
                        GCWTextField(
                          controller: _inputController_shiftRight,
                          hintText: i18n(context, 'brainfk_input_greater'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_shiftRight = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_shiftLeft,
                          hintText: i18n(context, 'brainfk_input_smaller'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_shiftLeft = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_increaseValue,
                          hintText: i18n(context, 'brainfk_input_plus'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_increaseValue = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_decreaseValue,
                          hintText: i18n(context, 'brainfk_input_minus'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_decreaseValue = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_output,
                          hintText: i18n(context, 'brainfk_input_dot'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_output = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_input,
                          hintText: i18n(context, 'brainfk_input_komma'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_input = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_startLoop,
                          hintText: i18n(context, 'brainfk_input_open'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_startLoop = text;
                            });
                          },
                        ),
                        GCWTextField(
                          controller: _inputController_endLoop,
                          hintText: i18n(context, 'brainfk_input_close'),
                          onChanged: (text) {
                            setState(() {
                              _currentInput_endLoop = text;
                            });
                          },
                        ),
                      ])
                    : Container(),
              ]),
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

  Object _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      if (_currentOriginal == GCWSwitchPosition.left) {
        try {
          return widget.interpret == null
              ? interpretBrainfk(_currentText, input: _currentInput)
              : widget.interpret!(_currentText, input: _currentInput);
        } on FormatException catch (e) {
          return printErrorMessage(context, e.message);
        }
      } else {
        if (_currentDerivate == BRAINFKDERIVATIVE_CUSTOM) {
          try {
            return BrainfkDerivatives(
              pointerShiftRightInstruction: _currentInput_shiftRight,
              pointerShiftLeftInstruction: _currentInput_shiftLeft,
              increaseValueInstruction: _currentInput_increaseValue,
              decreaseValueInstruction: _currentInput_decreaseValue,
              outputInstruction: _currentInput_output,
              inputInstruction: _currentInput_input,
              startLoopInstruction: _currentInput_startLoop,
              endLoopInstruction: _currentInput_endLoop,
            ).interpretBrainfkDerivatives(_currentText, input: _currentInput);
          } catch (e) {
            return printErrorMessage(context, 'brainfk_error_customundefined');
          }
        } else {
          return _currentDerivate.interpretBrainfkDerivatives(_currentText, input: _currentInput);
        }
      }
    } else {
      if (_currentOriginal == GCWSwitchPosition.left) {
        return widget.generate == null ? generateBrainfk(_currentText) : widget.generate!(_currentText);
      } else {
        if (_currentDerivate == BRAINFKDERIVATIVE_CUSTOM) {
          try {
            return BrainfkDerivatives(
              pointerShiftRightInstruction: _currentInput_shiftRight,
              pointerShiftLeftInstruction: _currentInput_shiftLeft,
              increaseValueInstruction: _currentInput_increaseValue,
              decreaseValueInstruction: _currentInput_decreaseValue,
              outputInstruction: _currentInput_output,
              inputInstruction: _currentInput_input,
              startLoopInstruction: _currentInput_startLoop,
              endLoopInstruction: _currentInput_endLoop,
            ).generateBrainfkDerivative(_currentText);
          } catch (e) {
            return printErrorMessage(context, 'brainfk_error_customundefined');
          }
        } else {
          return _currentDerivate.generateBrainfkDerivative(_currentText);
        }
      }
    }
  }
}
