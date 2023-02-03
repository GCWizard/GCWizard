import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';

class Substitution extends StatefulWidget {
  final String input;
  final Map<String, String> substitutions;

  const Substitution({Key key, this.input, this.substitutions}) : super(key: key);

  @override
  SubstitutionState createState() => SubstitutionState();
}

class SubstitutionState extends State<Substitution> {
  var _inputController;

  var _currentInput = '';
  var _currentFromInput = '';
  var _currentToInput = '';
  var _currentCaseSensitive = false;

  var _currentIdCount = 0;
  var _currentSubstitutions = <int, Map<String, String>>{};

  String _output = '';

  @override
  void initState() {
    super.initState();

    if (widget.substitutions != null) {
      widget.substitutions.entries.forEach((element) {
        _currentSubstitutions.putIfAbsent(++_currentIdCount, () => {element.key: element.value});
      });
    }

    if (widget.input != null) {
      _currentInput = widget.input;
      _calculateOutput();
    }

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  _addEntry(String currentFromInput, String currentToInput, BuildContext context) {
    if (currentFromInput.length > 0)
      _currentSubstitutions.putIfAbsent(++_currentIdCount, () => {currentFromInput: currentToInput});
    _calculateOutput();
  }

  _updateNewEntry(String currentFromInput, String currentToInput, BuildContext context) {
    _currentFromInput = currentFromInput;
    _currentToInput = currentToInput;
    _calculateOutput();
  }

  _updateEntry(dynamic id, String key, String value) {
    _currentSubstitutions[id] = {key: value};
    _calculateOutput();
  }

  _removeEntry(dynamic id, BuildContext context) {
    _currentSubstitutions.remove(id);
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
        onNewEntryChanged: _updateNewEntry,
        onAddEntry: _addEntry,
        middleWidget: Column(children: <Widget>[
          GCWOnOffSwitch(
            title: i18n(context, 'common_case_sensitive'),
            value: _currentCaseSensitive,
            onChanged: (value) {
              _currentCaseSensitive = value;
              _calculateOutput();
            },
          ),
        ]),
        dividerText: i18n(context, 'substitution_current_substitutions'),
        keyKeyValueMap: _currentSubstitutions,
        onUpdateEntry: _updateEntry,
        onRemoveEntry: _removeEntry);
  }

  _calculateOutput() {
    var _substitutions = <String, String>{};
    _currentSubstitutions.entries.forEach((entry) {
      _substitutions.putIfAbsent(entry.value.keys.first, () => entry.value.values.first);
    });

    if (_currentFromInput != null && _currentFromInput.length > 0 && _currentToInput != null) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    _output = substitution(_currentInput, _substitutions, caseSensitive: _currentCaseSensitive);
    setState(() {});
  }
}
