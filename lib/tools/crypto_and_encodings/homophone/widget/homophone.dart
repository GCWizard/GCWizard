import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/homophone/logic/homophone.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';

enum _KeyType { CUSTOM_KEY_LIST, CUSTOM_KEY_MAP, GENERATED }

class Homophone extends StatefulWidget {
  const Homophone({Key? key}) : super(key: key);

  @override
  _HomophoneState createState() => _HomophoneState();
}

class _HomophoneState extends State<Homophone> {
  var _currentMode = GCWSwitchPosition.right;

  late TextEditingController _currentRotationController;
  late TextEditingController _newKeyController;
  late GCWMaskTextInputFormatter _keyMaskInputFormatter;
  String _currentInput = '';
  Alphabet _currentAlphabet = alphabetGerman1;
  _KeyType _currentKeyType = _KeyType.GENERATED;
  int _currentRotation = 1;
  int _currentMultiplierIndex = 0;
  String _currentCustomKeyList = '';
  final List<KeyValueBase> _currentSubstitutions = [];

  final _mask = '#';
  final _filter = {"#": RegExp(r'\D')};
  final aKeys = [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 25];

  @override
  void initState() {
    super.initState();

    _currentRotationController = TextEditingController(text: _currentRotation.toString());
    _newKeyController = TextEditingController(text: _maxLetter());
    _keyMaskInputFormatter = GCWMaskTextInputFormatter(mask: _mask, filter: _filter);
  }

  @override
  void dispose() {
    _currentRotationController.dispose();
    _newKeyController.dispose();

    super.dispose();
  }

  String _maxLetter() {
    int maxLetterIndex = 0;
    var alphabetTable = getLetterFrequenciesFromAlphabet(_currentAlphabet);
    for (var entry in _currentSubstitutions) {
      if (entry.key.length != 1) continue;

      if (alphabetTable.containsKey(entry.key.toUpperCase())) {
        maxLetterIndex = max(maxLetterIndex, alphabetTable.keys.toList().indexOf(entry.key.toUpperCase()) + 1);
      }
    }

    if (maxLetterIndex < alphabetTable.length) {
      return alphabetTable.keys.elementAt(maxLetterIndex);
    }

    return '';
  }

  void _addEntry(KeyValueBase entry) {
    if (entry.key.isEmpty) return;
    entry.key = entry.key.toUpperCase();
    if (_currentSubstitutions.firstWhereOrNull((_entry) => _entry.key == entry.key) == null) {
      _currentSubstitutions.add(entry);
      _newKeyController.text = _maxLetter();
    }
  }

  @override
  Widget build(BuildContext context) {
    var Homophone_KeyTypeItems = {
      _KeyType.GENERATED: i18n(context, 'homophone_keytype_generated'),
      _KeyType.CUSTOM_KEY_LIST: i18n(context, 'homophone_keytype_own1'),
      _KeyType.CUSTOM_KEY_MAP: i18n(context, 'homophone_keytype_own2'),
    };

    var HomophoneAlphabetItems = {
      alphabetGerman1: i18n(context, 'common_language_german'),
      alphabetEnglish: i18n(context, 'common_language_english'),
      alphabetSpanish2: i18n(context, 'common_language_spanish'),
      alphabetPolish1: i18n(context, 'common_language_polish'),
      alphabetGreek1: i18n(context, 'alphabet_name_greek1'),
      alphabetGreek2: i18n(context, 'alphabet_name_greek2'),
      alphabetRussian1: i18n(context, 'common_language_russian'),
    };

    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        Row(children: <Widget>[
          Expanded(flex: 1, child: GCWText(text: i18n(context, 'homophone_keytype') + ':')),
          Expanded(
              flex: 2,
              child: GCWDropDown<_KeyType>(
                value: _currentKeyType,
                onChanged: (value) {
                  setState(() {
                    _currentKeyType = value;
                  });
                },
                items: Homophone_KeyTypeItems.entries.map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode.key,
                    child: Text(mode.value),
                  );
                }).toList(),
              )),
        ]),
        _currentKeyType == _KeyType.GENERATED
            ? Row(children: <Widget>[
                Expanded(flex: 1, child: GCWText(text: i18n(context, 'homophone_rotation') + ':')),
                Expanded(
                    flex: 2,
                    child: GCWIntegerSpinner(
                      controller: _currentRotationController,
                      value: _currentRotation,
                      min: 0,
                      max: 999999,
                      onChanged: (value) {
                        setState(() {
                          _currentRotation = value;
                        });
                      },
                    )),
              ])
            : Container(),
        _currentKeyType == _KeyType.GENERATED
            ? Row(children: <Widget>[
                Expanded(flex: 1, child: GCWText(text: i18n(context, 'homophone_multiplier') + ':')),
                Expanded(
                    flex: 2,
                    child: GCWDropDownSpinner(
                      index: _currentMultiplierIndex,
                      items: getMultipliers().map((item) => GCWText(text: item.toString())).toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentMultiplierIndex = value;
                        });
                      },
                    )),
              ])
            : Container(),
        _currentKeyType == _KeyType.CUSTOM_KEY_LIST
            ? GCWTextField(
                hintText: i18n(context, 'common_key'),
                onChanged: (text) {
                  setState(() {
                    _currentCustomKeyList = text;
                  });
                },
              )
            : Container(),
        _currentKeyType == _KeyType.CUSTOM_KEY_MAP ? _buildVariablesEditor() : Container(),
        Row(children: <Widget>[
          Expanded(flex: 1, child: GCWText(text: i18n(context, 'common_alphabet') + ':')),
          Expanded(
              flex: 2,
              child: GCWDropDown<Alphabet>(
                value: _currentAlphabet,
                onChanged: (value) {
                  setState(() {
                    _currentAlphabet = value;
                    _newKeyController.text = _maxLetter();
                  });
                },
                items: HomophoneAlphabetItems.entries.map((alphabet) {
                  return GCWDropDownMenuItem(
                    value: alphabet.key,
                    child: alphabet.value,
                    subtitle: _generateItemDescription(alphabet.key),
                  );
                }).toList(),
              )),
        ]),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput(child: '');
    int _currentMultiplier = getMultipliers()[_currentMultiplierIndex];

    HomophoneOutput _currentOutput;
    if (_currentMode == GCWSwitchPosition.left) {
      switch (_currentKeyType) {
        case _KeyType.GENERATED:
          _currentOutput =
              encryptHomophoneWithGeneratedKey(_currentInput, _currentAlphabet, _currentRotation, _currentMultiplier);
          break;
        case _KeyType.CUSTOM_KEY_LIST:
          _currentOutput =
              encryptHomophoneWithKeyList(_currentInput, _currentAlphabet, textToIntList(_currentCustomKeyList));
          break;
        case _KeyType.CUSTOM_KEY_MAP:
          _currentOutput = encryptHomophoneWithKeyMap(_currentInput,
              Map.fromEntries(_currentSubstitutions.map((entry) => MapEntry(entry.key, textToIntList(entry.value)))));
          break;
      }
    } else {
      switch (_currentKeyType) {
        case _KeyType.GENERATED:
          _currentOutput =
              decryptHomophoneWithGeneratedKey(_currentInput, _currentAlphabet, _currentRotation, _currentMultiplier);
          break;
        case _KeyType.CUSTOM_KEY_LIST:
          _currentOutput =
              decryptHomophoneWithKeyList(_currentInput, _currentAlphabet, textToIntList(_currentCustomKeyList));
          break;
        case _KeyType.CUSTOM_KEY_MAP:
          _currentOutput = decryptHomophoneWithKeyMap(_currentInput,
              Map.fromEntries(_currentSubstitutions.map((entry) => MapEntry(entry.key, textToIntList(entry.value)))));
          break;
      }
    }

    if (_currentOutput.errorCode != HomophoneErrorCode.OK) {
      switch (_currentOutput.errorCode) {
        case HomophoneErrorCode.CUSTOM_KEY_COUNT:
          showSnackBar(i18n(context, "homophone_error_own_key"), context);
          return const GCWDefaultOutput(child: '');
        case HomophoneErrorCode.CUSTOM_KEY_DUPLICATE:
          showSnackBar(i18n(context, "homophone_error_own_double_keys"), context);
          return const GCWDefaultOutput(child: '');
        default:
      }
    }

    return GCWMultipleOutput(
      children: [
        _currentOutput.output,
        GCWOutput(
            title: i18n(context, 'homophone_used_key'),
            child: GCWOutputText(
              text: _currentOutput.grid,
              isMonotype: true,
            ))
      ],
    );
  }

  String? _generateItemDescription(Alphabet alphabet) {
    if (alphabet == alphabetGreek1) return i18n(context, 'alphabet_name_greek1_description');
    if (alphabet == alphabetGreek2) return i18n(context, 'alphabet_name_greek2_description');

    return null;
  }

  Widget _buildVariablesEditor() {
    return GCWKeyValueEditor(
      keyController: _newKeyController,
      keyInputFormatters: [_keyMaskInputFormatter],
      valueHintText: i18n(context, 'homophone_own_key_hint'),
      valueFlex: 4,
      entries: _currentSubstitutions,
      onAddEntry: (entry) => _addEntry(entry),
    );
  }
}
