import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/straddling_checkerboard/logic/straddling_checkerboard.dart';

class StraddlingCheckerboard extends StatefulWidget {
  const StraddlingCheckerboard({Key? key}) : super(key: key);

  @override
  StraddlingCheckerboardState createState() => StraddlingCheckerboardState();
}

class StraddlingCheckerboardState extends State<StraddlingCheckerboard> {
  late TextEditingController _plainTextController;
  late TextEditingController _chiffreTextController;
  late TextEditingController _KeyController;
  late TextEditingController _AlphabetWordController;
  late TextEditingController _AlphabetController;
  late TextEditingController _ColumnOrderController;

  PolybiosMode _currentAlphabetMode = PolybiosMode.AZ09;
  var _currentMode = GCWSwitchPosition.right;
  var _currentDigitMode = GCWSwitchPosition.right;

  String _currentPlainText = '';
  String _currentChiffreText = '';
  String _currentKey = '';
  String _currentKeyHint = '';
  String _currentAlphabet = '';
  String _currentAlphabetWord = '';
  String _currentColumnOrder = '0123456789';
  String _output = '';

  @override
  void initState() {
    super.initState();
    _plainTextController = TextEditingController(text: _currentPlainText);
    _chiffreTextController = TextEditingController(text: _currentChiffreText);
    _KeyController = TextEditingController(text: _currentKey);
    _AlphabetWordController = TextEditingController(text: _currentAlphabetWord);
    _AlphabetController = TextEditingController(text: _currentAlphabet);
    _ColumnOrderController = TextEditingController(text: _currentColumnOrder);
  }

  @override
  void dispose() {
    _plainTextController.dispose();
    _chiffreTextController.dispose();
    _KeyController.dispose();
    _AlphabetWordController.dispose();
    _AlphabetController.dispose();
    _ColumnOrderController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var AlphabetModeItems = {
      PolybiosMode.AZ09: i18n(context, 'bifid_mode_az09'),
      PolybiosMode.ZA90: i18n(context, 'bifid_mode_za90'),
      PolybiosMode.CUSTOM: i18n(context, 'bifid_mode_custom'),
    };

    if (_currentDigitMode == GCWSwitchPosition.right) {
      _currentKeyHint = i18n(context, 'straddlingcheckerboard_hint_key');
    } else {
      _currentKeyHint = i18n(context, 'straddlingcheckerboard_hint_key_4x10');
    }

    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _plainTextController,
                hintText: i18n(context, 'straddlingcheckerboard_hint_plaintext'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ./]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentPlainText = text;
                  });
                },
              )
            : GCWTextField(
                controller: _chiffreTextController,
                hintText: i18n(context, 'straddlingcheckerboard_hint_chiffretext'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentChiffreText = text;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentDigitMode,
          title: i18n(context, 'straddlingcheckerboard_digitmode'),
          leftValue: i18n(context, 'straddlingcheckerboard_digitmode_4x10'),
          rightValue: i18n(context, 'straddlingcheckerboard_digitmode_escape'),
          onChanged: (value) {
            if (value == GCWSwitchPosition.right) {
              _currentKeyHint = i18n(context, 'straddlingcheckerboard_hint_key');
            } else {
              _currentKeyHint = i18n(context, 'straddlingcheckerboard_hint_key_4x10');
            }
            setState(() {
              _currentDigitMode = value;
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'straddlingcheckerboard_hint_matrix'),
        ),
        GCWTextField(
          controller: _KeyController,
          hintText: _currentKeyHint,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z./ ]')),
          ],
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: Column(children: [
                  GCWTextField(
                    controller: _AlphabetWordController,
                    hintText: i18n(context, 'straddlingcheckerboard_hint_alphabetword'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z./]')),
                    ],
                    onChanged: (text) {
                      setState(() {
                        _currentAlphabetWord = text;
                      });
                    },
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                  child: Column(
                    children: [
                      GCWDropDown<PolybiosMode>(
                        value: _currentAlphabetMode,
                        onChanged: (value) {
                          setState(() {
                            _currentAlphabetMode = value;
                          });
                        },
                        items: AlphabetModeItems.entries.map((mode) {
                          return GCWDropDownMenuItem(
                            value: mode.key,
                            child: mode.value,
                          );
                        }).toList(),
                      ),
                      _currentAlphabetMode == PolybiosMode.CUSTOM
                          ? GCWTextField(
                              hintText: i18n(context, 'common_alphabet'),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9./]')),
                              ],
                              controller: _AlphabetController,
                              onChanged: (text) {
                                setState(() {
                                  _currentAlphabet = text;
                                });
                              },
                            )
                          : Container(),
                    ],
                  )),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: Column(children: [
                  GCWOutputText(
                    text: i18n(context, 'straddlingcheckerboard_hint_column'),
                    suppressCopyButton: true,
                  )
                ]),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: Column(
                  children: [
                    GCWTextField(
                      controller: _ColumnOrderController,
                      hintText: i18n(context, 'straddlingcheckerboard_hint_column'),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'\d')),
                      ],
                      onChanged: (text) {
                        setState(() {
                          _currentColumnOrder = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    StraddlingCheckerboardOutput _currentOutput = StraddlingCheckerboardOutput('', '');

    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptStraddlingCheckerboard(
        _currentPlainText,
        _currentKey,
        _currentAlphabetWord,
        _currentColumnOrder,
        _currentDigitMode == GCWSwitchPosition.left,
        mode: _currentAlphabetMode,
        alphabet: _currentAlphabet,
      );
    } else {
      _currentOutput = decryptStraddlingCheckerboard(
        _currentChiffreText,
        _currentKey,
        _currentAlphabetWord,
        _currentColumnOrder,
        _currentDigitMode == GCWSwitchPosition.left,
        mode: _currentAlphabetMode,
        alphabet: _currentAlphabet,
      );
    }

    if (_currentOutput.output.contains('error')) {
      if (_currentOutput.output.contains('runtime')) {
        _output = i18n(context, _currentOutput.output.split('#')[0]) + '\n' + _currentOutput.output.split('#')[1];
      } else {
        _output = i18n(context, _currentOutput.output);
      }
    } else {
      _output = _currentOutput.output;
    }

    return GCWMultipleOutput(
      children: [
        _output,
        GCWOutput(
            title: i18n(context, 'straddlingcheckerboard_usedgrid'),
            child: GCWOutputText(
              text: _currentOutput.grid,
              isMonotype: true,
            ))
      ],
    );
  }
}
