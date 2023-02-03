import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/variablestring_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hash_breaker/logic/hash_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

final _ALERT_COMBINATIONS = 100000;

class HashBreaker extends StatefulWidget {
  final Function hashFunction;

  const HashBreaker({Key key, this.hashFunction}) : super(key: key);

  @override
  _HashBreakerState createState() => _HashBreakerState();
}

class _HashBreakerState extends State<HashBreaker> {
  var _inputController;
  var _maskController;

  var _currentInput = '';
  var _currentMask = '';
  var _currentFromInput = '';
  var _currentToInput = '';

  var _currentIdCount = 0;

  var _currentOutput = '';
  var _currentHashFunction = md5Digest;
  var _currentSubstitutions = <int, Map<String, String>>{};

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _maskController = TextEditingController(text: _currentMask);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _maskController.dispose();

    super.dispose();
  }

  _addEntry(String currentFromInput, String currentToInput, BuildContext context) {
    if (currentFromInput.length > 0)
      _currentSubstitutions.putIfAbsent(++_currentIdCount, () => {currentFromInput: currentToInput});
  }

  _updateEntry(dynamic id, String key, String value) {
    _currentSubstitutions[id] = {key: value};
  }

  _updateNewEntry(String currentFromInput, String currentToInput, BuildContext context) {
    _currentFromInput = currentFromInput;
    _currentToInput = currentToInput;
  }

  _removeEntry(dynamic id, BuildContext context) {
    _currentSubstitutions.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          hintText: i18n(context, 'hashes_hashbreaker_hashtobreak'),
          controller: _inputController,
          onChanged: (value) {
            _currentInput = value;
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'hashes_hashbreaker_searchconfiguration'),
        ),
        GCWDropDown(
          value: _currentHashFunction,
          onChanged: (newValue) {
            setState(() {
              _currentHashFunction = newValue;
            });
          },
          items: HASH_FUNCTIONS.entries.map((hashFunction) {
            return GCWDropDownMenuItem(
              value: hashFunction.value,
              child: i18n(context, hashFunction.key + '_title'),
            );
          }).toList(),
        ),
        GCWTextField(
          hintText: i18n(context, 'hashes_hashbreaker_searchconfiguration_searchmask'),
          controller: _maskController,
          onChanged: (value) {
            _currentMask = value;
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_variablecoordinate_variables'),
        ),
        _buildVariablesEditor(),
        _buildSubmitButton(),
        GCWDefaultOutput(child: _currentOutput)
      ],
    );
  }

  Widget _buildVariablesEditor() {
    return GCWKeyValueEditor(
        keyHintText: i18n(context, 'coords_variablecoordinate_variable'),
        valueHintText: i18n(context, 'coords_variablecoordinate_possiblevalues'),
        valueInputFormatters: [VariableStringTextInputFormatter()],
        valueFlex: 4,
        onNewEntryChanged: _updateNewEntry,
        onAddEntry: _addEntry,
        keyKeyValueMap: _currentSubstitutions,
        onUpdateEntry: _updateEntry,
        onRemoveEntry: _removeEntry);
  }

  _onDoCalculation() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            child: GCWAsyncExecuter(
              isolatedFunction: breakHashAsync,
              parameter: _buildJobData(),
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
            height: 220,
            width: 150,
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return GCWSubmitButton(
      onPressed: () async {
        var countCombinations = preCheckCombinations(_getSubstitutions());

        if (countCombinations >= _ALERT_COMBINATIONS) {
          showGCWAlertDialog(
            context,
            i18n(context, 'hashes_hashbreaker_manycombinations_title'),
            i18n(context, 'hashes_hashbreaker_manycombinations_text', parameters: [countCombinations]),
            () async {
              _onDoCalculation();
            },
          );
        } else {
          _onDoCalculation();
        }
      },
    );
  }

  Map<String, String> _getSubstitutions() {
    var _substitutions = <String, String>{};
    _currentSubstitutions.entries.forEach((entry) {
      _substitutions.putIfAbsent(entry.value.keys.first, () => entry.value.values.first);
    });

    if (_currentFromInput != null &&
        _currentFromInput.length > 0 &&
        _currentToInput != null &&
        _currentToInput.length > 0) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    return _substitutions;
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    _currentOutput = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    var _substitutions = _getSubstitutions();

    return GCWAsyncExecuterParameters(HashBreakerJobData(
        input: _currentInput,
        searchMask: _currentMask,
        substitutions: _substitutions,
        hashFunction: _currentHashFunction));
  }

  _showOutput(Map<String, dynamic> output) {
    if (output == null || output['state'] == null || output['state'] == 'not_found') {
      _currentOutput = i18n(context, 'hashes_hashbreaker_solutionnotfound');
    } else
      _currentOutput = output['text'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
