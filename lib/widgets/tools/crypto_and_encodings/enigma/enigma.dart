import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/enigma.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_multiple_output.dart';
import 'package:gc_wizard/widgets/common/gcw_onoff_switch.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/enigma/gcw_enigma_rotor_dropdownbutton.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/wrapper_for_masktextinputformatter.dart';

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
  var _currentEntryRotor = EnigmaRotorConfiguration(getEnigmaRotorByName(defaultRotorEntryRotor));
  var _currentReflector = EnigmaRotorConfiguration(getEnigmaRotorByName(defaultRotorReflector));

  var _isTextChange = false;

  var _currentNumberRotors = 3;
  List<GCWEnigmaRotorDropDownButton> _currentRotors = [];
  List<EnigmaRotorConfiguration> _currentRotorsConfigurations = [];

  var _plugboardMaskFormatter =
      WrapperForMaskTextInputFormatter(mask: '## ' * 25 + '##', filter: {"#": RegExp(r'[A-Za-z]')});

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
        GCWTextDivider(text: i18n(context, 'enigma_input')),
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
                    ? GCWEnigmaRotorDropDownButton(
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
                    ? GCWEnigmaRotorDropDownButton(
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
        _buildOutput()
      ],
    );
  }

  _buildRotors() {
    while (_currentRotors.length < _currentNumberRotors) {
      _currentRotors.add(GCWEnigmaRotorDropDownButton(
        position: _currentRotors.length,
        onChanged: (value) {
          setState(() {
            _currentRotorsConfigurations[value['position']] = value['rotorConfiguration'];
          });
        },
      ));
      _currentRotorsConfigurations
          .add(EnigmaRotorConfiguration(getEnigmaRotorByName(defaultRotorStandard), offset: 1, setting: 1));
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

  _buildOutput() {
    if (!_isTextChange) {
      FocusScope.of(context).requestFocus(new FocusNode());
    } else {
      _isTextChange = false;
    }

    List<EnigmaRotorConfiguration> rotorConfigurations = [];
    if (_currentEntryRotorMode) rotorConfigurations.add(_currentEntryRotor);

    rotorConfigurations.addAll((_currentRotorsConfigurations.reversed).map((configuration) {
      return configuration.clone();
    }).toList());

    if (_currentReflectorMode) rotorConfigurations.add(_currentReflector);

    var key = EnigmaKey(rotorConfigurations,
        plugboard: Map.fromIterable(_currentPlugboard.split(' ').where((digraph) => digraph.length == 2),
            key: (digraph) => digraph[0], value: (digraph) => digraph[1]));

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
        text: i18n(context, 'enigma_output_rotorsettingafter') + ': ' + rotorSetting.join(' - '),
        copyText: rotorSetting.join(),
      ));
    });

    if (results.length == 2) output.insert(2, GCWTextDivider(text: i18n(context, 'enigma_usedmessagekey')));

    return GCWMultipleOutput(children: output);
  }
}
