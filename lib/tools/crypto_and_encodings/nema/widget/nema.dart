import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NEMA extends StatefulWidget {
  const NEMA({Key? key}) : super(key: key);

  @override
  _NEMAState createState() => _NEMAState();
}

class _NEMAState extends State<NEMA> {
  late TextEditingController _inputController;
  late TextEditingController _innerKeyController;
  late TextEditingController _outerKeyController;

  late TextEditingController _spaceController;
  late TextEditingController _letterController;
  late TextEditingController _digitController;

  String _currentInput = '';
  String _currentInnerKey = '';
  String _currentOuterKey = '';

  String _currentSpace = 'XY';
  String _currentShiftToLetter = 'Y';
  String _currentShiftToDigit = 'X';

  final MaskTextInputFormatter _MASKINPUTFORMATTER_innerKey =
      MaskTextInputFormatter(
          mask: "@@-# @@-# @@-# @@-#",
          filter: {"@": RegExp(r'[0-9]'), "#": RegExp(r'[A-Za-z]')});
  final MaskTextInputFormatter _MASKINPUTFORMATTER_outerKey =
      MaskTextInputFormatter(
          mask: "##########", filter: {"#": RegExp(r'[A-Za-z]')});

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  NEMA_TYPE _currentType = NEMA_TYPE.EXER;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _innerKeyController = TextEditingController(text: _currentInnerKey);
    _outerKeyController = TextEditingController(text: _currentOuterKey);

    _spaceController = TextEditingController(text: _currentSpace);
    _letterController = TextEditingController(text: _currentShiftToLetter);
    _digitController = TextEditingController(text: _currentShiftToDigit);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _innerKeyController.dispose();
    _outerKeyController.dispose();

    _spaceController.dispose();
    _letterController.dispose();
    _digitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
            rightValue: i18n(context, 'nema_type_exer'),
            leftValue: i18n(context, 'nema_type_oper'),
            value: _currentMode,
            onChanged: (value) {
              setState(() {
                _currentMode = value;
                _currentType = _currentMode == GCWSwitchPosition.right
                    ? NEMA_TYPE.EXER
                    : NEMA_TYPE.OPER;
              });
            }),
        GCWTextDivider(
          text: i18n(context, 'common_input'),
          suppressTopSpace: true,
        ),
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWExpandableTextDivider(
          suppressTopSpace: false,
          text: i18n(context, 'nema_keys'),
          child: Column(
            children: [
              GCWTextDivider(
                text: i18n(context, 'nema_inner_key'),
                suppressTopSpace: true,
              ),
              GCWTextField(
                controller: _innerKeyController,
                hintText: _currentType == NEMA_TYPE.EXER ? '16-A 19-B 20-C 21-D' : '12-A 13-B 14-C 15-D',
                inputFormatters: [_MASKINPUTFORMATTER_innerKey],
                onChanged: (text) {
                  setState(() {
                    _currentInnerKey = text;
                  });
                },
              ),
              GCWTextDivider(
                text: i18n(context, 'nema_outer_key') +' / ' + i18n(context, 'nema_rotor'),
                suppressTopSpace: false,
              ),
              GCWTextField(
                hintText: 'DISTELFINK',
                controller: _outerKeyController,
                inputFormatters: [_MASKINPUTFORMATTER_outerKey],
                onChanged: (text) {
                  setState(() {
                    _currentOuterKey = text;
                    nema_init(_currentType);
                  });
                },
              ),
            ],
          ),
        ),
        GCWExpandableTextDivider(
            expanded: false,
            suppressTopSpace: false,
            text: i18n(context, 'nema_agreements'),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child:
                        GCWText(text: i18n(context, 'nema_agreements_space')),
                  ),
                  Expanded(
                      child: GCWTextField(
                          controller: _spaceController,
                          onChanged: (text) {
                            setState(() {
                              _currentSpace = text.toUpperCase();
                            });
                          })),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GCWText(
                        text: i18n(context, 'nema_agreements_shift_to_digit')),
                  ),
                  Expanded(
                      child: GCWTextField(
                          controller: _digitController,
                          onChanged: (text) {
                            setState(() {
                              _currentShiftToDigit = text.toUpperCase();
                            });
                          })),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GCWText(
                        text: i18n(context, 'nema_agreements_shift_to_letter')),
                  ),
                  Expanded(
                      child: GCWTextField(
                          controller: _letterController,
                          onChanged: (text) {
                            setState(() {
                              _currentShiftToLetter = text.toUpperCase();
                            });
                          })),
                ],
              ),
            ])),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    if (nema_valid_key(_currentInnerKey, _currentType) &&
        _currentOuterKey.length == 10) {
      NEMAOutput output =
          nema(_currentInput, _currentType, _currentInnerKey, _currentOuterKey);
      return Column(
        children: [
          GCWDefaultOutput(
            child: output.output,
          ),
          GCWTextDivider(text: i18n(context, 'nema_outer_key') +' / ' + i18n(context, 'nema_rotor')),
          GCWOutput(child: output.rotor),
          GCWExpandableTextDivider(
            expanded: false,
            text: i18n(context, 'nema_interpreted_text'),
            child: GCWText(
              text: _interpretedOutput(output.output),
            ),
          ),
        ],
      );
    } else {
      return GCWDefaultOutput(child: i18n(context, 'nema_error_invalid_key'));
    }
  }

  String _interpretedOutput(String output) {
    const Map<String, String> NEMA_LETTER_TO_DIGIT = {
      'Q': '1',
      'W': '2',
      'E': '3',
      'R': '4',
      'T': '5',
      'Z': '6',
      'U': '7',
      'I': '8',
      'O': '9',
      'P': '0',
    };
    List<String> interpretedOutput = [];
    bool isDigitMode = false;
    output.replaceAll(' ', '').replaceAll(_currentSpace, ' ').split('').forEach((char) {
      if (isDigitMode) {
        if (char == _currentShiftToLetter) {
          isDigitMode = false;
        } else if (NEMA_LETTER_TO_DIGIT[char] != null) {
          interpretedOutput.add(NEMA_LETTER_TO_DIGIT[char]!);
        } else {
          interpretedOutput.add(char);
        }
      } else {
        if (char == _currentShiftToDigit) {
          isDigitMode = true;
        } else {
          interpretedOutput.add(char);
        }
      }
    });

    return interpretedOutput.join('');
  }
}
