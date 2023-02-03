import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_abc_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enigma/logic/enigma.dart';
import 'package:gc_wizard/utils/alphabets.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/enigma/widget/enigma_rotor_dropdown.dart';

class Enigma extends StatefulWidget {
  @override
  EnigmaState createState() => EnigmaState();
}

class EnigmaState extends State<Enigma> {
  var _inputController;
  var _plugboardController;

  String _currentInput = '';
  String _currentPlugboard = '';

  var _currentEntryRotorMode = true;
  var _currentReflectorMode = true;
  var _currentEntryRotor =
      EnigmaRotorConfiguration(getEnigmaRotorByName(defaultRotorEntryRotor));
  var _currentReflector =
      EnigmaRotorConfiguration(getEnigmaRotorByName(defaultRotorReflector));

  var _isTextChange = false;

  var _currentNumberRotors = 3;
  List<EnigmaRotorDropDown> _currentRotors = [];
  List<EnigmaRotorConfiguration> _currentRotorsConfigurations = [];

  var _currentRotorInformation = 0;

  var _plugboardMaskFormatter = WrapperForMaskTextInputFormatter(
      mask: '## ' * 25 + '##', filter: {"#": RegExp(r'[A-Za-z]')});

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _plugboardController = TextEditingController(text: _currentPlugboard);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _plugboardController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, 'enigma_input'),
          suppressTopSpace: true,
        ),
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _isTextChange = true;
              _currentInput = text;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'enigma_reflector')),
        Row(
          children: <Widget>[
            Expanded(
                child: GCWOnOffSwitch(
                  notitle: true,
                  value: _currentReflectorMode,
                  onChanged: (value) {
                    setState(() {
                      _currentReflectorMode = value;
                    });
                  },
                ),
                flex: 1),
            Expanded(
                child: _currentReflectorMode
                    ? EnigmaRotorDropDown(
                        type: EnigmaRotorType.REFLECTOR,
                        onChanged: (value) {
                          setState(() {
                            _currentReflector = value['rotorConfiguration'];
                          });
                        },
                      )
                    : Container(),
                flex: 4)
          ],
        ),
        GCWTextDivider(text: i18n(context, 'enigma_rotors')),
        GCWIntegerSpinner(
          title: i18n(context, 'enigma_numberrotors'),
          min: 1,
          max: 10,
          value: _currentNumberRotors,
          onChanged: (value) {
            setState(() {
              _currentNumberRotors = value;
            });
          },
        ),
        _buildRotors(),
        GCWTextDivider(text: i18n(context, 'enigma_entryrotor')),
        Row(
          children: <Widget>[
            Expanded(
                child: GCWOnOffSwitch(
                  notitle: true,
                  value: _currentEntryRotorMode,
                  onChanged: (value) {
                    setState(() {
                      _currentEntryRotorMode = value;
                    });
                  },
                ),
                flex: 1),
            Expanded(
                child: _currentEntryRotorMode
                    ? EnigmaRotorDropDown(
                        type: EnigmaRotorType.ENTRY_ROTOR,
                        onChanged: (value) {
                          setState(() {
                            _currentEntryRotor = value['rotorConfiguration'];
                          });
                        },
                      )
                    : Container(),
                flex: 4)
          ],
        ),
        GCWTextDivider(text: i18n(context, 'enigma_plugboard')),
        GCWTextField(
          controller: _plugboardController,
          hintText: 'AB CD EF...',
          inputFormatters: [_plugboardMaskFormatter],
          onChanged: (text) {
            setState(() {
              _isTextChange = true;
              _currentPlugboard = _plugboardMaskFormatter.getMaskedText();
            });
          },
        ),
        _buildOutput(),
        _buildRotorInformation()
      ],
    );
  }

  _rotorType(EnigmaRotorType type) {
    switch (type) {
      case EnigmaRotorType.ENTRY_ROTOR:
        return i18n(context, 'enigma_rotortype_entryrotor');
      case EnigmaRotorType.REFLECTOR:
        return i18n(context, 'enigma_rotortype_reflector');
      case EnigmaRotorType.STANDARD:
        return i18n(context, 'enigma_rotortype_standard');
    }
  }

  Widget _buildRotorInformation() {
    List<EnigmaRotorConfiguration> _allRotors = [];
    if (_currentReflectorMode) _allRotors.add(_currentReflector);

    _allRotors.addAll(_currentRotorsConfigurations);

    if (_currentEntryRotorMode) _allRotors.add(_currentEntryRotor);

    if (_allRotors.length == 0) return Container();

    if (_currentRotorInformation >= _allRotors.length)
      _currentRotorInformation = 0;

    var currentRotor = _allRotors[_currentRotorInformation].rotor;

    return Column(
      children: [
        GCWTextDivider(text: i18n(context, 'enigma_rotorinfo')),
        GCWDropDownSpinner(
          index: _currentRotorInformation,
          items: _allRotors
              .map((EnigmaRotorConfiguration e) => e.rotor.name)
              .toList(),
          onChanged: (value) {
            setState(() {
              _currentRotorInformation = value;
            });
          },
        ),
        GCWOutputText(
          style: gcwMonotypeTextStyle(),
          text: alphabet_AZ.keys.join() + '\n' + currentRotor.alphabet,
          copyText: currentRotor.alphabet,
        ),
        GCWColumnedMultilineOutput(data: [
          [i18n(context, 'common_type'), _rotorType(currentRotor.type)],
          [
            i18n(context, 'enigma_turnovers'),
            (currentRotor.turnovers ?? '').isEmpty
                ? i18n(context, 'common_none')
                : currentRotor.turnovers
          ]
        ]),
      ],
    );
  }

  Widget _buildRotors() {
    while (_currentRotors.length < _currentNumberRotors) {
      _currentRotors.add(EnigmaRotorDropDown(
        position: _currentRotors.length,
        onChanged: (value) {
          setState(() {
            _currentRotorsConfigurations[value['position']] =
                value['rotorConfiguration'];
          });
        },
      ));
      _currentRotorsConfigurations.add(EnigmaRotorConfiguration(
          getEnigmaRotorByName(defaultRotorStandard),
          offset: 1,
          setting: 1));
    }

    while (_currentRotors.length > _currentNumberRotors) {
      _currentRotors.removeLast();
      _currentRotorsConfigurations.removeLast();
    }

    return Padding(
      child: Column(
        children: _currentRotors,
      ),
      padding: EdgeInsets.only(top: 10),
    );
  }

  Widget _buildOutput() {
    if (!_isTextChange) {
      FocusScope.of(context).requestFocus(new FocusNode());
    } else {
      _isTextChange = false;
    }

    List<EnigmaRotorConfiguration> rotorConfigurations = [];
    if (_currentEntryRotorMode) rotorConfigurations.add(_currentEntryRotor);

    rotorConfigurations
        .addAll((_currentRotorsConfigurations.reversed).map((configuration) {
      return configuration.clone();
    }).toList());

    if (_currentReflectorMode) rotorConfigurations.add(_currentReflector);

    var key = EnigmaKey(rotorConfigurations,
        plugboard: Map.fromIterable(
            _currentPlugboard
                .split(' ')
                .where((digraph) => digraph.length == 2),
            key: (digraph) => digraph[0],
            value: (digraph) => digraph[1]));

    var results = calculateEnigmaWithMessageKey(_currentInput, key);

    var output = [];

    results.forEach((result) {
      output.add(result['text']);

      var rotorSettings = result['rotorSettingAfter'] as List<int>;

      var stripHead = _currentEntryRotorMode ? 1 : 0;
      var stripTail = _currentReflectorMode ? 1 : 0;

      var rotorSetting = rotorSettings
          .sublist(stripHead, rotorSettings.length - stripTail)
          .reversed
          .map((setting) => alphabet_AZIndexes[setting + 1]);

      output.add(GCWOutputText(
        text: i18n(context, 'enigma_output_rotorsettingafter') +
            ': ' +
            rotorSetting.join(' - '),
        copyText: rotorSetting.join(),
      ));
    });

    if (results.length == 2)
      output.insert(
          2, GCWTextDivider(text: i18n(context, 'enigma_usedmessagekey')));

    return GCWMultipleOutput(children: output);
  }
}
