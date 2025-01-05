import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/variablestring_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hash_breaker/logic/hash_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

const _ALERT_COMBINATIONS = 100000;

class HashBreaker extends StatefulWidget {
  final Function? hashFunction;

  const HashBreaker({Key? key, this.hashFunction}) : super(key: key);

  @override
  _HashBreakerState createState() => _HashBreakerState();
}

class _HashBreakerState extends State<HashBreaker> {
  late TextEditingController _inputController;
  late TextEditingController _maskController;

  var _currentInput = '';
  var _currentMask = '';
  var _currentFromInput = '';
  var _currentToInput = '';

  var _currentIdCount = 0;

  var _currentOutput = '';
  Function _currentHashFunction = md5Digest;
  final List<KeyValueBase> _currentSubstitutions = [];

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

  void _onAddEntry(KeyValueBase entry) {
    if (entry.key.isEmpty) return;
    _currentIdCount++;
    if (_currentSubstitutions.firstWhereOrNull((_entry) => _entry.id == _currentIdCount) == null) {
      entry.id = _currentIdCount;
      return _currentSubstitutions.add(entry);
    }
  }

  void _updateNewEntry(KeyValueBase entry) {
    _currentFromInput = entry.key;
    _currentToInput = entry.value;
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
        GCWDropDown<Function>(
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
      addValueInputFormatters: [VariableStringTextInputFormatter()],
      valueFlex: 4,
      entries: _currentSubstitutions,
      onNewEntryChanged: (entry) => _updateNewEntry(entry),
      onAddEntry: (entry) => _onAddEntry(entry),
      validateEditedValue: (String input) {
        return VARIABLESTRING.hasMatch(input);
      },
      invalidEditedValueMessage: i18n(context, 'formulasolver_values_novalidinterpolated'),
    );
  }

  void _onDoCalculation() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<BoolText?>(
              isolatedFunction: breakHashAsync,
              parameter: _buildJobData,
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
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
    for (var entry in _currentSubstitutions) {
      _substitutions.putIfAbsent(entry.key, () => entry.value);
    }

    if (_currentFromInput.isNotEmpty && _currentToInput.isNotEmpty) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    return _substitutions;
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
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

  void _showOutput(BoolText? output) {
    if (output == null || !output.value) {
      _currentOutput = i18n(context, 'hashes_hashbreaker_solutionnotfound');
    } else {
      _currentOutput = output.text;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
