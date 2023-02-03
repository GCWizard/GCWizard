import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_onlydigitsandcomma_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_list_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart' as logic;
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:prefs/prefs.dart';

class AlphabetValues extends StatefulWidget {
  @override
  AlphabetValuesState createState() => AlphabetValuesState();
}

class AlphabetValuesState extends State<AlphabetValues> {
  List<Alphabet> _alphabets;

  var _encodeController;
  var _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = defaultIntegerListText;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  var _currentAlphabetKey;
  Map<String, String> _currentAlphabet;
  Map<String, String> _currentCustomizedAlphabet;
  var _currentIsEditingAlphabet = false;
  var _currentReverseAlphabet = GCWSwitchPosition.left;
  var _reverseSwitchTitleLeft;
  var _reverseSwitchTitleRight;
  var _currentOffset = 0;
  var _currentCustomizeAlphabet = GCWSwitchPosition.left;
  var _currentCustomAlphabetName = '';

  List<String> _storedAlphabets;

  @override
  void initState() {
    super.initState();

    _encodeController = TextEditingController(text: _currentEncodeInput);
    _decodeController = TextEditingController(text: _currentDecodeInput['text']);

    _storedAlphabets = Prefs.getStringList(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS);
    _alphabets = List<Alphabet>.from(ALL_ALPHABETS);
    _alphabets.addAll(_storedAlphabets.map<Alphabet>((storedAlphabet) {
      var alphabet = Map<String, dynamic>.from(jsonDecode(storedAlphabet));
      return Alphabet(
          key: alphabet['key'],
          name: alphabet['name'],
          type: AlphabetType.CUSTOM,
          alphabet: Map<String, String>.from(alphabet['alphabet']));
    }).toList());

    _currentAlphabetKey = Prefs.get(PREFERENCE_ALPHABET_DEFAULT_ALPHABET);
    _setAlphabet();
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();

    super.dispose();
  }

  Alphabet _getAlphabetByKey(String key) {
    return _alphabets.firstWhere((alphabet) => alphabet.key == key);
  }

  _setAlphabet() {
    _currentAlphabet = _getAlphabetByKey(_currentAlphabetKey).alphabet;
    _currentIsEditingAlphabet = false;
    _currentOffset = 0;
    _currentReverseAlphabet = GCWSwitchPosition.left;
    _currentCustomizeAlphabet = GCWSwitchPosition.left;

    Prefs.setString(PREFERENCE_ALPHABET_DEFAULT_ALPHABET, _currentAlphabetKey);

    _setReverseLabels();
  }

  _setReverseLabels() {
    var firstEntry = _currentAlphabet.entries.first;
    var lastEntry = _currentAlphabet.entries.last;

    var firstValue = _setValueOffset(firstEntry.value);
    var lastValue = _setValueOffset(lastEntry.value);

    _reverseSwitchTitleLeft =
        firstEntry.key + '-' + lastEntry.key + ' ' + String.fromCharCode(8594) + ' ' + firstValue + '-' + lastValue;
    _reverseSwitchTitleRight =
        lastEntry.key + '-' + firstEntry.key + ' ' + String.fromCharCode(8594) + ' ' + firstValue + '-' + lastValue;
  }

  _setValueOffset(String value) {
    return value.split(',').map((value) => int.tryParse(value) + _currentOffset).join(',');
  }

  Map<String, String> _setOffset(Map<String, String> alphabet) {
    return alphabet.map((key, value) => MapEntry(key, _setValueOffset(value)));
  }

  Map<String, String> _setReverse(Map<String, String> alphabet) {
    if (_currentReverseAlphabet == GCWSwitchPosition.left) return alphabet;

    var reversedMap = <String, String>{};
    var entries = alphabet.entries.toList();
    var length = entries.length;

    for (int i = 0; i < length; i++) {
      reversedMap.putIfAbsent(entries[length - i - 1].key, () => entries[i].value);
    }

    return Map<String, String>.fromEntries(reversedMap.entries);
  }

  _addNewLetter2(String letter, String value, BuildContext context) {
    _addNewLetter(letter, value, context, adjust: true);
  }

  _addNewLetter(String letter, String value, BuildContext context, {adjust: false}) {
    if (letter == null || letter.length == 0 || value == null) return;

    value = value
        .split(',')
        .where((character) => character != null && character.length > 0)
        .map((character) => character.toUpperCase())
        .join(',');

    if (value.length == 0) return;

    letter = letter.toUpperCase();
    if (_currentCustomizedAlphabet.containsKey(letter)) {
      showGCWDialog(context, i18n(context, 'alphabetvalues_edit_mode_customize_addletter_replace_title'),
          Text(i18n(context, 'alphabetvalues_edit_mode_customize_addletter_replace_text', parameters: [letter])), [
        GCWDialogButton(
            text: i18n(context, 'alphabetvalues_edit_mode_customize_addletter_replace'),
            onPressed: () {
              setState(() {
                _currentCustomizedAlphabet.addAll({letter: value});
              });
            })
      ]);
    } else {
      setState(() {
        if (adjust) {
          var insertedValue = int.tryParse(value);
          _currentCustomizedAlphabet = _currentCustomizedAlphabet.map((currentKey, currentValue) {
            var newValue = currentValue.split(',').map((value) {
              var intValue = int.tryParse(value);
              if (intValue >= insertedValue) intValue++;

              return intValue.toString();
            }).join(',');

            return MapEntry(currentKey, newValue);
          });
        }

        _currentCustomizedAlphabet.putIfAbsent(letter, () => value);
      });
    }
  }

  _removeEntry(dynamic id, BuildContext context) {
    var _valueToDelete = _currentCustomizedAlphabet[id];
    var _isList = _valueToDelete.contains(',');

    var buttons = [
      GCWDialogButton(
          text: i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_remove'),
          onPressed: () {
            setState(() {
              _currentCustomizedAlphabet.remove(id);
            });
          })
    ];

    if (!_isList) {
      var deleteValue = int.tryParse(_valueToDelete);

      buttons.add(GCWDialogButton(
        text: i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_removeandadjust'),
        onPressed: () {
          _currentCustomizedAlphabet = _currentCustomizedAlphabet.map((currentKey, currentValue) {
            var newValue = currentValue.split(',').map((value) {
              var intValue = int.tryParse(value);
              if (intValue > deleteValue) intValue--;

              return intValue.toString();
            }).join(',');

            return MapEntry(currentKey, newValue);
          });

          setState(() {
            _currentCustomizedAlphabet.remove(id);
          });
        },
      ));
    }

    showGCWDialog(context, i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_title'),
        Text(i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_text', parameters: [id])), buttons);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : GCWIntegerListTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GCWDropDown(
                    value: _currentAlphabetKey,
                    items: _alphabets.map((Alphabet alphabet) {
                      return GCWDropDownMenuItem(
                          value: alphabet.key,
                          child: alphabet.type == AlphabetType.STANDARD ? i18n(context, alphabet.key) : alphabet.name,
                          subtitle: _generateItemDescription(alphabet));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _currentAlphabetKey = value;
                        _setAlphabet();
                      });
                    },
                  ),
                ),
                GCWIconButton(
                  icon: _currentIsEditingAlphabet ? Icons.check : Icons.edit,
                  onPressed: () {
                    setState(() {
                      _currentIsEditingAlphabet = !_currentIsEditingAlphabet;
                    });
                  },
                )
              ],
            ),
            _currentIsEditingAlphabet ? _buildEditingAlphabet() : Container(),
          ],
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'alphabetvalues_mode_left'),
          rightValue: i18n(context, 'alphabetvalues_mode_right'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput()),
        _buildCrossTotals()
      ],
    );
  }

  _generateItemDescription(Alphabet alphabet) {
    var description = i18n(context, alphabet.key + '_description');
    if (description != null && description.length > 0) return description;

    var entries = alphabet.alphabet.entries.toList();

    description = '';
    if (alphabet.type == AlphabetType.CUSTOM) description = '[' + i18n(context, 'alphabetvalues_custom') + '] ';

    description += '${entries.length} ${i18n(context, 'alphabetvalues_letters')}';
    if (entries.length == 0) return description;

    description += ': ';
    description += entries.first.key + ' ' + String.fromCharCode(8594) + ' ' + entries.first.value;
    description += ' ... ';
    description += entries.last.key + ' ' + String.fromCharCode(8594) + ' ' + entries.last.value;

    return description;
  }

  _buildEditingAlphabet() {
    return Column(
      children: [
        GCWTwoOptionsSwitch(
          value: _currentCustomizeAlphabet,
          title: i18n(context, 'alphabetvalues_edit_mode'),
          leftValue: i18n(context, 'alphabetvalues_edit_mode_adjust'),
          rightValue: i18n(context, 'alphabetvalues_edit_mode_customize'),
          onChanged: (value) {
            setState(() {
              _currentCustomizeAlphabet = value;

              if (_currentCustomizeAlphabet == GCWSwitchPosition.right) {
                _currentCustomizedAlphabet = Map<String, String>.from(_currentAlphabet);
                _currentCustomizedAlphabet = _setOffset(_currentCustomizedAlphabet);
                _currentCustomizedAlphabet = _setReverse(_currentCustomizedAlphabet);
              } else {
                _currentCustomizedAlphabet = null;
              }
            });
          },
        ),
        _currentCustomizeAlphabet == GCWSwitchPosition.left
            ? _buildEditingAlphabetAdjusting()
            : _buildEditingAlphabetCustomizing()
      ],
    );
  }

  _buildEditingAlphabetCustomizing() {
    var isCustomAlphabet = _getAlphabetByKey(_currentAlphabetKey).type == AlphabetType.CUSTOM;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: isCustomAlphabet
                  ? Container(
                      child: GCWButton(
                          text: i18n(context, 'alphabetvalues_edit_mode_customize_deletealphabet'),
                          onPressed: () {
                            _removeAlphabet();
                          }),
                      padding: EdgeInsets.only(right: DEFAULT_MARGIN),
                    )
                  : Container(),
              flex: isCustomAlphabet ? 2 : 1,
            ),
            Expanded(
                child: Container(
                  child: GCWButton(
                    text: i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet'),
                    onPressed: () {
                      setState(() {
                        _saveAlphabet();
                      });
                    },
                  ),
                  padding: EdgeInsets.only(left: isCustomAlphabet ? DEFAULT_MARGIN : 0),
                ),
                flex: 2),
            isCustomAlphabet ? Container() : Expanded(child: Container(), flex: 1)
          ],
        ),
        SizedBox(height: 10),
        GCWKeyValueEditor(
            keyHintText: i18n(context, 'alphabetvalues_edit_mode_customize_letter'),
            valueHintText: i18n(context, 'alphabetvalues_edit_mode_customize_value'),
            valueInputFormatters: [GCWOnlyDigitsAndCommaInputFormatter()],
            alphabetInstertButtonLabel: i18n(context, 'alphabetvalues_edit_mode_customize_addletter'),
            alphabetAddAndAdjustLetterButtonLabel:
                i18n(context, 'alphabetvalues_edit_mode_customize_addandadjustletter'),
            onAddEntry: _addNewLetter,
            onAddEntry2: _addNewLetter2,
            keyValueMap: _currentCustomizedAlphabet,
            onRemoveEntry: _removeEntry,
            editAllowed: false),
        GCWDivider()
      ],
    );
  }

  Widget _buildEditingAlphabetAdjusting() {
    return Column(
      children: [
        GCWIntegerSpinner(
          title: i18n(context, 'alphabetvalues_edit_mode_adjust_offset'),
          value: _currentOffset,
          onChanged: (value) {
            setState(() {
              _currentOffset = value;
              _setReverseLabels();
            });
          },
        ),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'alphabetvalues_edit_mode_adjust_reverse'),
          leftValue: _reverseSwitchTitleLeft,
          rightValue: _reverseSwitchTitleRight,
          value: _currentReverseAlphabet,
          onChanged: (value) {
            setState(() {
              _currentReverseAlphabet = value;
            });
          },
        ),
        GCWDivider()
      ],
    );
  }

  _removeAlphabet() {
    showGCWAlertDialog(
        context,
        i18n(context, 'alphabetvalues_edit_mode_customize_deletealphabet'),
        i18n(context, 'alphabetvalues_edit_mode_customize_deletealphabet_text',
            parameters: [_getAlphabetByKey(_currentAlphabetKey).name]), () {
      setState(() {
        var removeableKey = _currentAlphabetKey;
        _currentAlphabetKey = alphabetAZ.key;
        _setAlphabet();

        _storedAlphabets.removeWhere((storedAlphabet) => jsonDecode(storedAlphabet)['key'] == removeableKey);
        Prefs.setStringList(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS, _storedAlphabets);
        _alphabets.removeWhere((alphabet) => alphabet.key == removeableKey);
      });
    });
  }

  _saveAlphabet() {
    showGCWDialog(
        context,
        i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet'),
        Container(
          width: 300,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet_name')),
              GCWTextField(
                autofocus: true,
                filled: true,
                onChanged: (text) {
                  _currentCustomAlphabetName = text;
                },
              ),
            ],
          ),
        ),
        [
          GCWDialogButton(
            text: i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet_save'),
            onPressed: () {
              var name = _currentCustomAlphabetName;
              if (name == null || name.length == 0)
                name = i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet_customname');

              var entries = _currentCustomizedAlphabet.entries.toList();
              entries.sort((a, b) {
                var intA = int.tryParse(a.value.split(',')[0]);
                var intB = int.tryParse(b.value.split(',')[0]);

                return intA.compareTo(intB);
              });
              var orderedAlphabet = LinkedHashMap.fromEntries(entries);

              var newAlphabet = Alphabet(
                  key: UniqueKey().toString(), name: name, type: AlphabetType.CUSTOM, alphabet: orderedAlphabet);

              _storedAlphabets.add(
                  jsonEncode({'key': newAlphabet.key, 'name': newAlphabet.name, 'alphabet': newAlphabet.alphabet}));
              Prefs.setStringList(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS, _storedAlphabets);

              setState(() {
                _alphabets.add(newAlphabet);
              });
            },
          )
        ]);
  }

  _getFinalAlphabet() {
    var alphabet = _currentAlphabet;
    if (_currentCustomizeAlphabet == GCWSwitchPosition.right) {
      alphabet = _currentCustomizedAlphabet;
    } else {
      alphabet = _setOffset(alphabet);
      alphabet = _setReverse(alphabet);
    }

    return alphabet;
  }

  Widget _buildCrossTotals() {
    var alphabet = _getFinalAlphabet();

    if (_currentMode == GCWSwitchPosition.left) {
      return CrosstotalOutput(
          text: _currentEncodeInput,
          values: logic.AlphabetValues(alphabet: alphabet).textToValues(_currentEncodeInput, keepNumbers: true));
    } else {
      var text = logic.AlphabetValues(alphabet: alphabet).valuesToText(List<int>.from(_currentDecodeInput['values']));
      return CrosstotalOutput(text: text, values: List<int>.from(_currentDecodeInput['values']));
    }
  }

  _calculateOutput() {
    var alphabet = _getFinalAlphabet();

    if (_currentMode == GCWSwitchPosition.left) {
      return intListToString(
          logic.AlphabetValues(alphabet: alphabet).textToValues(_currentEncodeInput, keepNumbers: true),
          delimiter: ' ');
    } else {
      return logic.AlphabetValues(alphabet: alphabet).valuesToText(List<int>.from(_currentDecodeInput['values']));
    }
  }
}
