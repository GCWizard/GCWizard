import 'dart:collection';
import 'dart:isolate';
import 'dart:math';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';

final RegExp VARIABLESTRING =
    RegExp(r'^((\s*\d+(\s*-\s*(\d*|\d+\s*#\s*\d*))?)\s*,)*(\s*\d*|(\s*\d+\s*-\s*(\d*|\d+\s*#\s*\d*)))\s*$');

enum VariableStringExpanderBreakCondition { RUN_ALL, BREAK_ON_FIRST_FOUND }

class VariableStringExpanderValue {
  final String? text;
  final Map<String, String>? variables;
  final int? count;

  VariableStringExpanderValue({this.text, this.variables, this.count});
}

/*
  - Takes a string which contains an arbitrary number of variables, e.g. "A B C"
  - Requires for every variable one or many possible values like {'A': '1-3', 'B': '5,6', 'C': '4-6#2'}
  - Creates strings with all possible variable combinations:
    '1 5 4', '1 5 6', '1 6 4', '1 6 6',
    '2 5 4', '2 5 6', '2 6 4', '2 6 6',
    '3 5 4', '3 5 6', '3 6 4', '3 6 6'

  - for every string, an operation can be executed (given by isResult callback).
    This callback return can return true if the function should add the current
    string to a result set which will be returned in the end
    e.g.: - Create all possible string combinations, calculate a hash and check if it matches
            a given one. If so, add to result set (-> Hash Breaker)
          - Create all possible coordinate strings, evaluate and expand formulata terms,
            add every formula expanded string to the result set (-> Variable Coordinate)

   - Performance note:
     - Three final status were considered
       1. Don't use formula groups (brackets): No need of finding some groups that
          must be considered different to the outside parts. Spares a loop with separate
          (expensive) replace operation: "N 52 23.ABC E 10 45.DEF; {A: 0-9, B: 0-9, ...}"
          -> drawback (visible in this example): The east E will be treated as variable.
          -> could be done with creating a warning when adding a variable which is found as text in the input
          -> fastest. In tested real-world use case with ca. 30 Mio. combinations: 1:24min runtime
       2. Use formula groups to be able to make difference between variables and text,
          but don't use mathematical engine to expand real formulas: "N 52 23.[ABC] E 10 45.[DEF]; {A: 0-9, B: 0-9, ...}"
          -> More flexible in handling
          -> same example: Runtime 1:39min
       3. Apply the whole formula magic incl. mathematical engine: "N 52 [A/10000] E 10 [B/10000]; {A: 23000-23999, B: 45000-45999}"
          -> Extremely flexible
          -> VarCoords could profit from it: The formula calculating part would be moved from there
          -> Expensive, even on basic examples
          -> Runtime: 2:51
     - Decision for 2. Best Cost/Price-Balance
 */
class VariableStringExpander {
  final String _input;
  final Map<String, String>? _substitutions;
  String? Function(String)? onAfterExpandedText;
  SendPort? sendAsyncPort;

  VariableStringExpanderBreakCondition breakCondition;
  bool orderAndUnique;

  VariableStringExpander(this._input, this._substitutions,
      {this.onAfterExpandedText,
      this.breakCondition = VariableStringExpanderBreakCondition.RUN_ALL,
      this.orderAndUnique = true,
      this.sendAsyncPort}) {
    onAfterExpandedText ??= (e) => e;
  }

  final List<List<String>> _expandedVariableGroups = [];
  final List<String> _substitutionKeys = [];

  List<String> _variableGroups = [];
  int _countVariableGroups = -1;
  String _variableGroup = '';

  final List<VariableStringExpanderValue> _results = [];
  final List<String> _uniqueResults = [];

  final List<int> _variableValueIndexes = [];
  final List<int> _countVariableValues = [];
  int _currentVariableIndex = -1;

  int _countCombinations = -1;

  // Expands a "compressed" variable group like "5-10" to "5,6,7,8,9,10"
  List<String> _expandVariableGroup(String group) {
    dynamic output; // Explicit dynamic type is intended here!

    if (orderAndUnique) {
      output = SplayTreeSet<String>();
    } else {
      output = <String>[];
    }

    group = group.replaceAll(RegExp(r'[^\d,\-#]'), '');

    if (group.isEmpty) return [];

    var ranges = group.split(',');
    for (var range in ranges) {
      var rangeParts = range.split('#');
      var rangeBounds = rangeParts[0].split('-');
      if (rangeBounds.length == 1) {
        output.add(int.tryParse(rangeBounds[0]).toString());
        continue;
      }

      var start = int.parse(rangeBounds[0]);
      var end = int.parse(rangeBounds[1]);

      if (start == end) {
        output.add(start.toString());
        continue;
      }

      var increment = 1;
      if (rangeParts.length > 1) increment = int.parse(rangeParts[1]);

      if (start < end) {
        for (int i = start; i <= end; i += increment) {
          output.add(i.toString());
        }
      } else {
        for (int i = start; i >= end; i -= increment) {
          output.add(i.toString());
        }
      }
    }

    return output.toList() as List<String>;
  }

  // counting indexes like a normal numeral system:
  // First count the last index until all values are checked, reset index to 0
  // Second increase last but one index, run last index again, and so on.
  // Example:
  //   [0, 0, 0], [0, 0, 1], [0, 0, 2]
  //   [0, 1, 0], [0, 1, 1], [0, 1, 2]
  //   [0, 2, 0], [0, 2, 1], [0, 2, 2]
  //   [0, 3, 0], [0, 3, 1], [0, 3, 2]
  //   [0, 4, 0], [0, 4, 1], [0, 4, 2]
  //
  //   [1, 0, 0], [1, 0, 1], [1, 0, 2]
  //   [1, 1, 0], [1, 1, 1], [1, 1, 2]
  //   [1, 2, 0], [1, 2, 1], [1, 2, 2]
  //   [1, 3, 0], [1, 3, 1], [1, 3, 2]
  //   [1, 4, 0], [1, 4, 1], [1, 4, 2]
  bool _setIndexes() {
    while (_variableValueIndexes[_currentVariableIndex] == _countVariableValues[_currentVariableIndex] - 1) {
      if (_currentVariableIndex == 0) return true;

      _variableValueIndexes[_currentVariableIndex] = 0;
      _currentVariableIndex--;
    }

    _variableValueIndexes[_currentVariableIndex] = _variableValueIndexes[_currentVariableIndex] + 1;
    _currentVariableIndex = _variableValueIndexes.length - 1;

    return false;
  }

  int _variableGroupIndex = -1;
  int _variableValueIndex = -1;
  String? _result = '';

  Map<String, String> _getCurrentVariables() {
    Map<String, String> variables = {};

    for (int i = 0; i < _variableValueIndexes.length; i++) {
      variables.putIfAbsent(_substitutionKeys[i], () => _expandedVariableGroups[i][_variableValueIndexes[i]]);
    }

    return variables;
  }

  void _generateCartesianVariables() {
    var progress = 0;
    int progressStep = max(_countCombinations ~/ 100, 1); // 100 steps

    if (sendAsyncPort != null && (progress % progressStep == 0)) {
      sendAsyncPort!.send(DoubleText(PROGRESS, progress / _countCombinations));
    }

    do {
      _substitute();

      if (_result == null) continue;
      if (onAfterExpandedText != null) {
        _result = onAfterExpandedText!(_result!);
      }

      progress++;
      if (sendAsyncPort != null && (progress % progressStep == 0)) {
        sendAsyncPort!.send(DoubleText(PROGRESS, progress / _countCombinations));
      }

      if (_result == null || _uniqueResults.contains(_result)) continue;

      _results.add(VariableStringExpanderValue(text: _result, variables: _getCurrentVariables()));

      if (breakCondition == VariableStringExpanderBreakCondition.BREAK_ON_FIRST_FOUND) break;
    } while (_setIndexes() == false);
  }

  // do the substitution of the variables set with their specific values given by their counted indexes
  void _substitute() {
    _result = _input;
    for (_variableGroupIndex = 0; _variableGroupIndex < _countVariableGroups; _variableGroupIndex++) {
      _variableGroup = _variableGroups[_variableGroupIndex];

      for (_variableValueIndex = 0; _variableValueIndex < _variableValueIndexes.length; _variableValueIndex++) {
        _variableGroup = _variableGroup.toUpperCase().replaceAll(
              _substitutionKeys[_variableValueIndex],
              _expandedVariableGroups[_variableValueIndex][_variableValueIndexes[_variableValueIndex]],
            );
      }

      _result = _result!.replaceFirst(_variableGroups[_variableGroupIndex], _variableGroup);
    }
  }

  List<VariableStringExpanderValue> run({bool onlyPrecheck = false}) {
    if (_input.isEmpty) return [];

    if (_substitutions == null || _substitutions!.isEmpty) {
      return [VariableStringExpanderValue(text: _input)];
    }

    // expand all groups, initialize lists
    for (MapEntry<String, String> substitution in _substitutions!.entries) {
      if (!VARIABLESTRING.hasMatch(substitution.value)) {
        return [VariableStringExpanderValue(text: _input)];
      }

      _substitutionKeys.add(substitution.key.toUpperCase());
      var group = _expandVariableGroup(substitution.value);

      if (group.isNotEmpty) {
        _expandedVariableGroups.add(group);

        _countVariableValues.add(group.length);
        _variableValueIndexes.add(0);
        _currentVariableIndex++;
      }
    }

    // check number of combinations
    _countCombinations = _countVariableValues.fold(1, (previousValue, element) => previousValue * element);
    if (onlyPrecheck) {
      return [VariableStringExpanderValue(count: _countCombinations)];
    }

    // Find matching formula groups
    RegExp regExp = RegExp(r'\[.+?\]');
    if (regExp.hasMatch(_input)) {
      _variableGroups = regExp.allMatches(_input.trim()).map((elem) => elem.group(0)!).toList();
    } else {
      _variableGroups = [_input];
    }
    _countVariableGroups = _variableGroups.length;

    // gogogo!
    _generateCartesianVariables();

    return _results;
  }
}

int preCheckCombinations(Map<String, String> substitutions) {
  if (substitutions.isEmpty) return 0;

  var expander = VariableStringExpander('DUMMY', substitutions, onAfterExpandedText: (e) => null);
  var result = expander.run(onlyPrecheck: true);
  if (result.isEmpty || result.first.count == null) return 0;

  return result.first.count!;
}
