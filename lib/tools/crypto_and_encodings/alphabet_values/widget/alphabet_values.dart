import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_onlydigitsandcomma_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart' as logic;
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:prefs/prefs.dart';
import 'package:uuid/uuid.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values_key_value_input.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values_key_value_item.dart';

const String _apiSpecification = '''
{
  "/alphabetvalues" : {
    "alternative_paths": ["alphabet_values", "av", "buchstabenwerte", "bww"],
    "get": {
      "summary": "Alphabet Values Tool",
      "responses": {
        "204": {
          "description": "Tool loaded. No response data."
        }
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data for encoding or decoding text",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "mode",
          "description": "Defines encoding or decoding mode; 'encode' is for letters to values, 'decode' is for values to letters",
          "schema": {
            "type": "string",
            "enum": [
              "encode",
              "decode"
            ],
            "default": "encode"
          }
        }
      ] 
    }
  }
}
''';

class AlphabetValues extends GCWWebStatefulWidget {
  AlphabetValues({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _AlphabetValuesState createState() => _AlphabetValuesState();
}

class _AlphabetValuesState extends State<AlphabetValues> {
  late List<Alphabet> _alphabets;

  late TextEditingController _controller;

  var _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  late String _currentAlphabetKey;
  late Map<String, String> _currentAlphabet;
  List<KeyValueBase>? _currentCustomizedAlphabet;
  var _currentIsEditingAlphabet = false;
  var _currentReverseAlphabet = GCWSwitchPosition.left;
  String _reverseSwitchTitleLeft = '';
  String _reverseSwitchTitleRight = '';
  var _currentOffset = 0;
  var _currentCustomizeAlphabet = GCWSwitchPosition.left;
  var _currentCustomAlphabetName = '';

  late List<String> _storedAlphabets;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'decode') {
        _currentMode = GCWSwitchPosition.right;
      }
      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      widget.webParameter = null;
    }

    _controller = TextEditingController(text: _currentInput);

    _storedAlphabets = Prefs.getStringList(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS);
    _alphabets = List<Alphabet>.from(ALL_ALPHABETS);
    _alphabets.addAll(_storedAlphabets.map<Alphabet>((storedAlphabet) {
      var alphabet = asJsonMap(jsonDecode(storedAlphabet));
      return Alphabet(
          key: toStringOrDefault(alphabet['key'], ''),
          name: toStringOrNull(alphabet['name']),
          type: AlphabetType.CUSTOM,
          alphabet: toStringMapOrNull(asJsonMapOrNull(alphabet['alphabet'])) ?? {});
    }).toList());

    _currentAlphabetKey = Prefs.getString(PREFERENCE_ALPHABET_DEFAULT_ALPHABET);
    _setAlphabet();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Alphabet _getAlphabetByKey(String key) {
    return _alphabets.firstWhere((alphabet) => alphabet.key == key);
  }

  void _setAlphabet() {
    _currentAlphabet = _getAlphabetByKey(_currentAlphabetKey).alphabet;
    _currentIsEditingAlphabet = false;
    _currentOffset = 0;
    _currentReverseAlphabet = GCWSwitchPosition.left;
    _currentCustomizeAlphabet = GCWSwitchPosition.left;

    Prefs.setString(PREFERENCE_ALPHABET_DEFAULT_ALPHABET, _currentAlphabetKey);

    _setReverseLabels();
  }

  void _setReverseLabels() {
    if (_currentAlphabet.isEmpty) return;
    var firstEntry = _currentAlphabet.entries.first;
    var lastEntry = _currentAlphabet.entries.last;

    var firstValue = _setValueOffset(firstEntry.value);
    var lastValue = _setValueOffset(lastEntry.value);

    _reverseSwitchTitleLeft = firstEntry.key + '-' + lastEntry.key + ' \u2192 ' + firstValue + '-' + lastValue;
    _reverseSwitchTitleRight = lastEntry.key + '-' + firstEntry.key + ' \u2192 ' + firstValue + '-' + lastValue;
  }

  String _setValueOffset(String value) {
    return value.split(',').map((value) => (int.tryParse(value) ?? 0) + _currentOffset).join(',');
  }

  Map<String, String> _setOffset(Map<String, String> alphabet) {
    return alphabet.map((key, value) => MapEntry(key, _setValueOffset(value)));
  }

  List<KeyValueBase> _setOffsetList(List<KeyValueBase> alphabet) {
    return alphabet.map((entry) => KeyValueBase(null, entry.key, _setValueOffset(entry.value))).toList();
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

  List<KeyValueBase> _setReverseList(List<KeyValueBase> alphabet) {
    if (_currentReverseAlphabet == GCWSwitchPosition.left) return alphabet;

    var reversedMap = <String, String>{};
    var entries = alphabet;
    var length = entries.length;

    for (int i = 0; i < length; i++) {
      reversedMap.putIfAbsent(entries[length - i - 1].key, () => entries[i].value);
    }

    return _convertToEditingAlphabet(reversedMap);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GCWDropDown<String>(
                    value: _currentAlphabetKey,
                    items: _alphabets.map((Alphabet alphabet) {
                      return GCWDropDownMenuItem(
                          value: alphabet.key,
                          child:
                              (alphabet.type == AlphabetType.STANDARD ? i18n(context, alphabet.key) : alphabet.name) ??
                                  '',
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

  String _generateItemDescription(Alphabet alphabet) {
    var description = i18n(context, alphabet.key + '_description');
    if (description.isNotEmpty) return description;

    var entries = alphabet.alphabet.entries.toList();

    description = '';
    if (alphabet.type == AlphabetType.CUSTOM) description = '[' + i18n(context, 'alphabetvalues_custom') + '] ';

    description += '${entries.length} ${i18n(context, 'alphabetvalues_letters')}';
    if (entries.isEmpty) return description;

    description += ': ';
    description += entries.first.key + ' \u2192 ' + entries.first.value;
    description += ' ... ';
    description += entries.last.key + ' \u2192 ' + entries.last.value;

    return description;
  }

  Widget _buildEditingAlphabet() {
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
                _currentCustomizedAlphabet = _convertToEditingAlphabet(_currentAlphabet);
                _currentCustomizedAlphabet = _setOffsetList(_currentCustomizedAlphabet!);
                _currentCustomizedAlphabet = _setReverseList(_currentCustomizedAlphabet!);
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

  List<KeyValueBase> _convertToEditingAlphabet(Map<String, String> alphabet) {
    return _currentAlphabet.entries.map((entry) => KeyValueBase(null, entry.key, entry.value)).toList();
  }

  Map<String, String> _convertFromEditingAlphabet(List<KeyValueBase> alphabet) {
    return {for (var entry in alphabet) entry.key: entry.value};
  }

  Widget _buildEditingAlphabetCustomizing() {
    var isCustomAlphabet = _getAlphabetByKey(_currentAlphabetKey).type == AlphabetType.CUSTOM;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: isCustomAlphabet ? 2 : 1,
              child: isCustomAlphabet
                  ? Container(
                      padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                      child: GCWButton(
                          text: i18n(context, 'alphabetvalues_edit_mode_customize_deletealphabet'),
                          onPressed: () {
                            _removeAlphabet();
                          }),
                    )
                  : Container(),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: isCustomAlphabet ? DEFAULT_MARGIN : 0),
                  child: GCWButton(
                    text: i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet'),
                    onPressed: () {
                      setState(() {
                        _saveAlphabet();
                      });
                    },
                  ),
                )),
            isCustomAlphabet ? Container() : Expanded(flex: 1, child: Container())
          ],
        ),
        const SizedBox(height: 10),
        GCWKeyValueEditor(
          keyHintText: i18n(context, 'alphabetvalues_edit_mode_customize_letter'),
          valueHintText: i18n(context, 'alphabetvalues_edit_mode_customize_value'),
          addValueInputFormatters: [GCWOnlyDigitsAndCommaInputFormatter()],
          entries: _currentCustomizedAlphabet ?? [],
          editAllowed: false,
          addOnDispose: false,
          onCreateInput: (Key? key) => _AlphabetValuesKeyValueInput(key: key),
          onCreateNewItem: (entry, odd) => _createNewItem(entry, odd),
        ),
        const GCWDivider()
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
        const GCWDivider()
      ],
    );
  }

  void _removeAlphabet() {
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

  void _saveAlphabet() {
    showGCWDialog(
        context,
        i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet'),
        SizedBox(
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
              if (name.isEmpty) {
                name = i18n(context, 'alphabetvalues_edit_mode_customize_savealphabet_customname');
              }

              if (_currentCustomizedAlphabet == null) return;
              var entries = _currentCustomizedAlphabet!;
              entries.sort((a, b) {
                var intA = int.tryParse(a.value.split(',')[0]);
                var intB = int.tryParse(b.value.split(',')[0]);

                if (intA == null || intB == null) return 0;
                return intA.compareTo(intB);
              });
              var orderedAlphabet = _convertFromEditingAlphabet(entries);

              var newAlphabet = Alphabet(
                  key: const Uuid().v4().toString(), name: name, type: AlphabetType.CUSTOM, alphabet: orderedAlphabet);

              _storedAlphabets.add(
                  jsonEncode({'key': newAlphabet.key, 'name': newAlphabet.name, 'alphabet': newAlphabet.alphabet}));
              Prefs.setStringList(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS, _storedAlphabets);

              setState(() {
                _alphabets.add(newAlphabet);
                _currentAlphabetKey = newAlphabet.key;
                _setAlphabet();
              });
            },
          )
        ]);
  }

  Map<String, String> _getFinalAlphabet() {
    var alphabet = _currentAlphabet;
    if (_currentCustomizeAlphabet == GCWSwitchPosition.right) {
      alphabet = _currentCustomizedAlphabet != null ? _convertFromEditingAlphabet(_currentCustomizedAlphabet!) : {};
    } else {
      alphabet = _setOffset(alphabet);
      alphabet = _setReverse(alphabet);
    }

    return alphabet;
  }

  Widget _buildCrossTotals() {
    var alphabet = _getFinalAlphabet();

    if (_currentMode == GCWSwitchPosition.left) {
      var alphabetValues = logic.AlphabetValues(alphabet: alphabet).textToValues(_currentInput, keepNumbers: true);

      return CrosstotalOutput(
          text: _currentInput, values: List<int>.from(alphabetValues.where((value) => value != null)));
    } else {
      var _currentDecodeInput = textToIntList(_currentInput);

      var text = logic.AlphabetValues(alphabet: alphabet).valuesToText(_currentDecodeInput);
      return CrosstotalOutput(text: text, values: _currentDecodeInput);
    }
  }

  String _calculateOutput() {
    var alphabet = _getFinalAlphabet();

    if (_currentMode == GCWSwitchPosition.left) {
      return intListToString(logic.AlphabetValues(alphabet: alphabet).textToValues(_currentInput, keepNumbers: true),
          delimiter: ' ');
    } else {
      var _currentDecodeInput = textToIntList(_currentInput);
      return logic.AlphabetValues(alphabet: alphabet).valuesToText(_currentDecodeInput);
    }
  }

  GCWKeyValueItem _createNewItem(KeyValueBase entry, bool odd) {
    return _AlphabetValuesKeyValueItem(
      keyValueEntry: entry,
      odd: odd,
    );
  }
}
