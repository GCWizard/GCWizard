import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
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
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

enum _KeyType { CUSTOM_KEY_LIST, CUSTOM_KEY_MAP, GENERATED }

class Homophone extends StatefulWidget {
  const Homophone({Key? key}) : super(key: key);

  @override
  HomophoneState createState() => HomophoneState();
}

class HomophoneState extends State<Homophone> {
  var _currentMode = GCWSwitchPosition.right;

  late TextEditingController _currentRotationController;
  late TextEditingController _newKeyController;
  late WrapperForMaskTextInputFormatter _keyMaskInputFormatter;
  String _currentInput = '';
  Alphabet _currentAlphabet = alphabetGerman1;
  _KeyType _currentKeyType = _KeyType.GENERATED;
  int _currentRotation = 1;
  int _currentMultiplierIndex = 0;
  String _currentCustomKeyList = '';
  final _currentSubstitutions = <String, String>{};

  final _mask = '#';
  final _filter = {"#": RegExp(r'\D')};
  final aKeys = [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 25];

  @override
  void initState() {
    super.initState();

    _currentRotationController = TextEditingController(text: _currentRotation.toString());
    _newKeyController = TextEditingController(text: _maxLetter());
    _keyMaskInputFormatter = WrapperForMaskTextInputFormatter(mask: _mask, filter: _filter);
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
    _currentSubstitutions.forEach((key, value) {
      if (key.length != 1) return;

      if (alphabetTable.containsKey(key.toUpperCase())) {
        maxLetterIndex = max(maxLetterIndex, alphabetTable.keys.toList().indexOf(key.toUpperCase()) + 1);
      }
    });

    if (maxLetterIndex < alphabetTable.length) {
      return alphabetTable.keys.elementAt(maxLetterIndex);
    }

    return '';
  }

  void _addEntry(String currentFromInput, String currentToInput, FormulaValueType type, BuildContext context) {
    if (currentFromInput.isNotEmpty) {
      _currentSubstitutions.putIfAbsent(currentFromInput.toUpperCase(), () => currentToInput);
    }

    _newKeyController.text = _maxLetter();

    setState(() {});
  }

  void _updateEntry(Object id, String key, String value, FormulaValueType type) {
    _currentSubstitutions[id as String] = value;
    setState(() {});
  }

  void _removeEntry(Object id, BuildContext context) {
    _currentSubstitutions.remove(id);
    setState(() {});
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
          _currentOutput = encryptHomophoneWithKeyMap(
              _currentInput, _currentSubstitutions.map((key, value) => MapEntry(key, textToIntList(value))));
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
          _currentOutput = decryptHomophoneWithKeyMap(
              _currentInput, _currentSubstitutions.map((key, value) => MapEntry(key, textToIntList(value))));
          break;
      }
    }

    if (_currentOutput.errorCode != HomophoneErrorCode.OK) {
      switch (_currentOutput.errorCode) {
        case HomophoneErrorCode.CUSTOM_KEY_COUNT:
          showToast(i18n(context, "homophone_error_own_key"));
          return const GCWDefaultOutput(child: '');
        case HomophoneErrorCode.CUSTOM_KEY_DUPLICATE:
          showToast(i18n(context, "homophone_error_own_double_keys"));
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
        keyValueMap: _currentSubstitutions,
        //onNewEntryChanged: _updateNewEntry,
        onAddEntry: _addEntry,
        onUpdateEntry: _updateEntry,
        onRemoveEntry: _removeEntry);
  }
}
