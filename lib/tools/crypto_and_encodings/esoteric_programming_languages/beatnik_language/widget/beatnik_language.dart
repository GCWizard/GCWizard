import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/logic/beatnik_language.dart';
import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';

class Beatnik extends StatefulWidget {
  @override
  BeatnikState createState() => BeatnikState();
}

class BeatnikState extends State<Beatnik> {
  var _programmController;
  var _inputController;
  var _outputController;

  var _currentProgram = '';
  var _currentInput = '';
  var _currentOutput = '';

  var _currentScrabbleVersion = scrabbleID_EN;
  bool _currentShowScrabble = true;
  bool _currentShowDebug = false;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left; // interpret

  @override
  void initState() {
    super.initState();
    _programmController = TextEditingController(text: _currentProgram);
    _inputController = TextEditingController(text: _currentInput);
    _outputController = TextEditingController(text: _currentOutput);
  }

  @override
  void dispose() {
    _programmController.dispose();
    _inputController.dispose();
    _outputController.dispose();
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
        _currentMode == GCWSwitchPosition.right // generate Beatnik-programm
            ? Column(
                children: <Widget>[
                  GCWTextField(
                    controller: _outputController,
                    hintText: i18n(context, 'common_programming_hint_output'),
                    onChanged: (text) {
                      setState(() {
                        _currentOutput = text;
                      });
                    },
                  ),
                ],
              )
            : Column(
                // interpret Beatnik-programm
                children: <Widget>[
                  GCWTextDivider(
                    text: i18n(context, 'beatnik_hint_scrabble'),
                  ),
                  GCWDropDown(
                    value: _currentScrabbleVersion,
                    onChanged: (value) {
                      setState(() {
                        _currentScrabbleVersion = value;
                      });
                    },
                    items: scrabbleSets.entries.map((set) {
                      return GCWDropDownMenuItem(
                        value: set.key,
                        child: i18n(context, set.value.i18nNameId),
                      );
                    }).toList(),
                  ),
                  GCWTextField(
                    controller: _programmController,
                    hintText: i18n(context, 'common_programming_hint_sourcecode'),
                    onChanged: (text) {
                      setState(() {
                        _currentProgram = text;
                      });
                    },
                  ),
                  GCWTextField(
                    controller: _inputController,
                    hintText: i18n(context, 'common_programming_hint_input'),
                    onChanged: (text) {
                      setState(() {
                        _currentInput = text;
                      });
                    },
                  ),
                ],
              ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    BeatnikOutput _output = BeatnikOutput([''], [''], [''], [''], []);
    String _outputData = '';
    List<List<String>> _columnData = <List<String>>[];

    if (_currentMode == GCWSwitchPosition.right) {
      // generate beatnik
      _output = generateBeatnik(_currentScrabbleVersion, _currentOutput);
    } else {
      // interpret beatnik
      _output = interpretBeatnik(_currentScrabbleVersion, _currentProgram, _currentInput);

      for (int i = 0; i < _output.debug.length; i++) {
        _columnData
            .add([_output.debug[i].pc, _output.debug[i].command, _output.debug[i].stack, _output.debug[i].output]);
      }
    }

    _outputData = buildOutputText(_output.output);

    return Column(
      children: <Widget>[
        GCWDefaultOutput(
          child: GCWOutputText(
            text: _outputData,
          ),
        ),
        _currentMode == GCWSwitchPosition.left // interpret Beatnik
            ? Column(
                children: [
                  GCWOnOffSwitch(
                    title: i18n(context, 'common_programming_debug'),
                    value: _currentShowDebug,
                    onChanged: (value) {
                      setState(() {
                        _currentShowDebug = value;
                      });
                    },
                  ),
                  _currentShowDebug == true
                      ? Column(children: <Widget>[
                          GCWOnOffSwitch(
                            title: i18n(context, 'beatnik_show_scrabble'),
                            value: _currentShowScrabble,
                            onChanged: (value) {
                              setState(() {
                                _currentShowScrabble = value;
                              });
                            },
                          ),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            _currentShowScrabble == true
                                ? Expanded(
                                    flex: 2,
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          child: Column(children: <Widget>[
                                            GCWTextDivider(text: i18n(context, 'beatnik_hint_code_scrabble')),
                                            GCWOutputText(
                                              text: _output.scrabble.join('\n'),
                                              isMonotype: true,
                                            ),
                                          ]),
                                          padding: EdgeInsets.only(right: DEFAULT_MARGIN),
                                        )))
                                : Container(),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        GCWTextDivider(text: i18n(context, 'common_programming_code_assembler')),
                                        GCWOutputText(
                                          text: _output.assembler.join('\n'),
                                          isMonotype: true,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(right: DEFAULT_MARGIN),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        GCWTextDivider(text: i18n(context, 'common_programming_code_mnemonic')),
                                        GCWOutputText(
                                          text: _output.mnemonic.join('\n'),
                                          isMonotype: true,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: DEFAULT_MARGIN),
                                  ),
                                )),
                          ]),
                          GCWOutput(
                            title: i18n(context, 'common_programming_debug'),
                            child: GCWColumnedMultilineOutput(
                                data: _columnData,
                                flexValues: [1, 2, 3, 3]
                            ),
                          ),
                        ])
                      : Container(),
                ],
              )
            : Column(// generete beatnik
                children: <Widget>[
                GCWOutputText(
                  text: i18n(context, 'beatnik_hint_generated'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                GCWTextDivider(text: i18n(context, 'common_programming_code_assembler')),
                                GCWOutputText(
                                  text: _output.assembler.join('\n'),
                                  isMonotype: true,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.only(right: DEFAULT_MARGIN),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                GCWTextDivider(text: i18n(context, 'common_programming_code_mnemonic')),
                                GCWOutputText(
                                  text: _output.mnemonic.join('\n'),
                                  isMonotype: true,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.only(left: DEFAULT_MARGIN),
                          ),
                        )),
                  ],
                ),
              ]),
      ],
    );
  }

  String buildOutputText(List<String> outputList) {
    String output = '';
    outputList.forEach((element) {
      if (element.startsWith('beatnik_') || element.startsWith('common_programming_')) {
        output = output + i18n(context, element) + '\n';
      } else
        output = output + element + '\n';
    });
    return output.trim();
  }
}
