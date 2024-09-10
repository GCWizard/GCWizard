import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';

enum _GenerateAlphabet {
  CAPLETTERS,
  SMALLLETTERS,
  ALLLETTERS,
  NUMERALS,
  CHARS,
  CAPLETTERS_NUMERALS,
  SMALLLETTERS_NUMERALS,
  ALLLETTERS_NUMERALS,
  CAPLETTERS_CHARS,
  SMALLLETTERS_CHARS,
  ALLLETTERS_CHARS,
  NUMERALS_CHARS,
  CAPLETTERS_NUMERALS_CHARS,
  SMALLLETTERS_NUMERALS_CHARS,
  ALLLETTERS_NUMERALS_CHARS
}

class Substitution extends StatefulWidget {
  final String? input;
  final Map<String, String>? substitutions;

  const Substitution({Key? key, this.input, this.substitutions}) : super(key: key);

  @override
  _SubstitutionState createState() => _SubstitutionState();
}

class _SubstitutionState extends State<Substitution> {
  late TextEditingController _inputController;

  var _currentInput = '';
  var _currentFromInput = '';
  var _currentToInput = '';
  var _currentCaseSensitive = false;

  var _currentGenerate = false;
  var _currentUniqueResults = true;
  var _currentFromLetters = _GenerateAlphabet.CAPLETTERS;
  var _currentToLetters = _GenerateAlphabet.CAPLETTERS;
  var _currentToNumerals = _GenerateAlphabet.NUMERALS;
  var _currentToCharacters = _GenerateAlphabet.CHARS;
  final _currentCharacters = '!"§\$%&/()=?\\}][{°^+*~#\'-.,;:_<>|';

  var _currentIdCount = 0;
  final List<KeyValueBase> _currentSubstitutions = [];

  String _output = '';

  @override
  void initState() {
    super.initState();

    if (widget.substitutions != null) {
      for (var element in widget.substitutions!.entries) {
        _currentIdCount++;
        if (_currentSubstitutions.firstWhereOrNull((entry) => entry.id == _currentIdCount) == null) {
          _currentSubstitutions.add(KeyValueBase(_currentIdCount, element.key, element.value));
        }
      }
    }

    if (widget.input != null) {
      _currentInput = widget.input!;
      _calculateOutput();
    }

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  void _addEntry(KeyValueBase entry) {
    if (entry.key.isEmpty) return;
    _currentIdCount++;
    if (_currentSubstitutions.firstWhereOrNull((_entry) => _entry.id == _currentIdCount) == null) {
      entry.id = _currentIdCount;
      _currentSubstitutions.add(entry);
      _calculateOutput();
    }
  }

  void _updateNewEntry(KeyValueBase entry) {
    _currentFromInput = entry.key;
    _currentToInput = entry.value;
    _calculateOutput();
  }

  void _updateEntry(KeyValueBase entry) {
    _calculateOutput();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            _currentInput = text;
            _calculateOutput();
          },
        ),
        _buildVariablesEditor(),
        GCWDefaultOutput(child: _output)
      ],
    );
  }

  Widget _buildVariablesEditor() {
    return GCWKeyValueEditor(
      keyHintText: i18n(context, 'substitution_from'),
      valueHintText: i18n(context, 'substitution_to'),
      middleWidget: Column(children: <Widget>[
        GCWOnOffSwitch(
            value: _currentGenerate,
            title: i18n(context, 'substitution_generate'),
            onChanged: (mode) {
              setState(() {
                _currentGenerate = mode;
              });
            }
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'common_case_sensitive'),
          value: _currentCaseSensitive,
          onChanged: (value) {
            _currentCaseSensitive = value;
            _calculateOutput();
          },
        ),
        _currentGenerate
            ? _buildGenerationSection()
            : Container()
      ]),
      dividerText: i18n(context, 'substitution_current_substitutions'),
      entries: _currentSubstitutions,
      onNewEntryChanged: (entry) => _updateNewEntry(entry),
      onAddEntry: (entry) => _addEntry(entry),
      onUpdateEntry: (entry) => _updateEntry(entry),
    );
  }

  void _calculateOutput() {
    var _substitutions = <String, String>{};

    for (var entry in _currentSubstitutions) {
      _substitutions.putIfAbsent(entry.key, () => entry.value);
    }

    if (_currentFromInput.isNotEmpty) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    _output = substitution(_currentInput, _substitutions, caseSensitive: _currentCaseSensitive);
    setState(() {});
  }

  void _generate(String fromAlphabet, _GenerateAlphabet toAlphabet) {
    var _to = '';

    var az = alphabet_AZString;
    var _09 = alphabet_09.keys.join();
    var chars = _currentCharacters;

    switch (toAlphabet) {
      case _GenerateAlphabet.CAPLETTERS: _to = az.toUpperCase(); break;
      case _GenerateAlphabet.SMALLLETTERS: _to = az.toLowerCase(); break;
      case _GenerateAlphabet.ALLLETTERS: _to = az.toUpperCase() + az.toLowerCase(); break;
      case _GenerateAlphabet.NUMERALS: _to = _09; break;
      case _GenerateAlphabet.CHARS: _to = chars; break;
      case _GenerateAlphabet.CAPLETTERS_NUMERALS: _to = az.toUpperCase() + _09; break;
      case _GenerateAlphabet.SMALLLETTERS_NUMERALS: _to = az.toLowerCase() + _09; break;
      case _GenerateAlphabet.ALLLETTERS_NUMERALS: _to = az.toUpperCase() + az.toLowerCase() + _09; break;
      case _GenerateAlphabet.CAPLETTERS_CHARS: _to = az.toUpperCase() + chars; break;
      case _GenerateAlphabet.SMALLLETTERS_CHARS: _to = az.toLowerCase() + chars; break;
      case _GenerateAlphabet.ALLLETTERS_CHARS: _to = az.toUpperCase() + az.toLowerCase() + chars; break;
      case _GenerateAlphabet.NUMERALS_CHARS: _to = _09 + chars; break;
      case _GenerateAlphabet.CAPLETTERS_NUMERALS_CHARS: _to = az.toUpperCase() + _09 + chars; break;
      case _GenerateAlphabet.SMALLLETTERS_NUMERALS_CHARS: _to = az.toLowerCase() + _09 + chars; break;
      case _GenerateAlphabet.ALLLETTERS_NUMERALS_CHARS: _to = az.toUpperCase() + az.toLowerCase() + _09 + chars; break;
    }

    var _toList = _to.split('').toList();
    _toList.shuffle();

    var rand = Random();
    var _min = min<int>(fromAlphabet.length, _toList.length);
    for (int i = 0; i < _min; i++) {
      _addEntry(KeyValueBase(null, fromAlphabet[i], _toList[_currentUniqueResults ? i : rand.nextInt(_toList.length)]));
    }
  }

  String _generateAlphabetTitle(_GenerateAlphabet alphabet) {
    switch (alphabet) {
      case _GenerateAlphabet.CAPLETTERS: return 'ABC';
      case _GenerateAlphabet.SMALLLETTERS:return 'abc';
      case _GenerateAlphabet.ALLLETTERS: return 'ABC abc';
      case _GenerateAlphabet.NUMERALS: return '123';
      case _GenerateAlphabet.CHARS: return '%&?';
      case _GenerateAlphabet.CAPLETTERS_NUMERALS: return 'ABC 123';
      case _GenerateAlphabet.SMALLLETTERS_NUMERALS: return 'abc 123';
      case _GenerateAlphabet.ALLLETTERS_NUMERALS: return 'ABC abc 123';
      case _GenerateAlphabet.CAPLETTERS_CHARS: return 'ABC %&?';
      case _GenerateAlphabet.SMALLLETTERS_CHARS: return 'abc %&?';
      case _GenerateAlphabet.ALLLETTERS_CHARS: return 'ABC abc %&?';
      case _GenerateAlphabet.NUMERALS_CHARS: return '123 %&?';
      case _GenerateAlphabet.CAPLETTERS_NUMERALS_CHARS: return 'ABC 123 %&?';
      case _GenerateAlphabet.SMALLLETTERS_NUMERALS_CHARS: return 'abc 123 %&?';
      case _GenerateAlphabet.ALLLETTERS_NUMERALS_CHARS: return 'ABC abc 123 %&?';
    }
  }

  List<_GenerateAlphabet> _generateToList() {
    var _list = _GenerateAlphabet.values.toList();

    if (!_currentCaseSensitive) {
      _list.remove(_GenerateAlphabet.SMALLLETTERS);
      _list.remove(_GenerateAlphabet.SMALLLETTERS_NUMERALS);
      _list.remove(_GenerateAlphabet.SMALLLETTERS_CHARS);
      _list.remove(_GenerateAlphabet.SMALLLETTERS_NUMERALS_CHARS);
      _list.remove(_GenerateAlphabet.ALLLETTERS);
      _list.remove(_GenerateAlphabet.ALLLETTERS_NUMERALS);
      _list.remove(_GenerateAlphabet.ALLLETTERS_CHARS);
      _list.remove(_GenerateAlphabet.ALLLETTERS_NUMERALS_CHARS);
    }

    return _list;
  }

  Column _buildGenerationSection(
    ) {
    var titleLetters = i18n(context, 'common_letters');
    var titleNumerals = i18n(context, 'common_numerals');
    var titleCharacters = i18n(context, 'common_characters');

    return Column(
      children: [
        GCWOnOffSwitch(
            value: _currentUniqueResults,
            title: i18n(context, 'substitution_uniqueresults'),
            onChanged: (value) {
              setState(() {
                _currentUniqueResults = value;
              });
            }
        ),
        GCWTextDivider(text: titleLetters),
        _currentCaseSensitive
            ? GCWDropDown(
                title: i18n(context, 'common_from'),
                value: _currentFromLetters,
                items: [_GenerateAlphabet.CAPLETTERS, _GenerateAlphabet.SMALLLETTERS, _GenerateAlphabet.ALLLETTERS].map((value) {
                  return GCWDropDownMenuItem(
                    value: value,
                    child: _generateAlphabetTitle(value)
                  );
                }).toList(),
                onChanged: (value) {
                  _currentFromLetters = value;
                  _calculateOutput();
                }
              )
            : Container(),
        GCWDropDown(
          title: i18n(context, 'common_to'),
          value: _currentToLetters,
          items: _generateToList().map((value) {
            return GCWDropDownMenuItem(
              value: value,
              child: _generateAlphabetTitle(value)
            );
          }).toList(),
          onChanged: (value) {
            _currentToLetters = value;
            _calculateOutput();
          }
        ),
        GCWButton(text: i18n(context, 'substitution_generate') + ' ' + titleLetters,
          onPressed: () {
            setState(() {
              var _fromAlphabet = alphabet_AZString.toUpperCase();
              if (_currentCaseSensitive) {
                switch (_currentFromLetters) {
                  case _GenerateAlphabet.SMALLLETTERS: _fromAlphabet = alphabet_AZString.toLowerCase(); break;
                  case _GenerateAlphabet.ALLLETTERS: _fromAlphabet += alphabet_AZString.toLowerCase(); break;
                  default: break;
                }
              }
              _generate(_fromAlphabet, _currentToLetters);
            });
          }
        ),

        GCWTextDivider(text: titleNumerals),
        GCWDropDown(
          title: i18n(context, 'common_to'),
          value: _currentToNumerals,
          items: _generateToList().map((value) {
            return GCWDropDownMenuItem(
                value: value,
                child: _generateAlphabetTitle(value)
            );
          }).toList(),
          onChanged: (value) {
            _currentToNumerals = value;
            _calculateOutput();
          }
        ),
        GCWButton(text: i18n(context, 'substitution_generate') + ' ' + titleNumerals,
          onPressed:  () {
            setState(() {
              _generate('0123456789', _currentToNumerals);
            });
          }
        ),

        GCWTextDivider(text: titleCharacters),
        GCWDropDown(
          title: i18n(context, 'common_to'),
          value: _currentToCharacters,
          items: _generateToList().map((value) {
            return GCWDropDownMenuItem(
                value: value,
                child: _generateAlphabetTitle(value)
            );
          }).toList(),
          onChanged: (value) {
            _currentToCharacters = value;
            _calculateOutput();
          }
        ),
        GCWButton(text: i18n(context, 'substitution_generate') + ' ' + titleCharacters,
          onPressed:  () {
            setState(() {
              _generate(_currentCharacters, _currentToCharacters);
            });
          }
        )
      ]
    );
  }
}
