import 'dart:collection';
import 'dart:isolate';
import 'dart:math';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/helper.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:math_expressions/math_expressions.dart';

Future<VerbalArithmeticOutput?> solveCryptogramAsync(GCWAsyncExecuterParameters jobData) async {
  if (jobData.parameters is! VerbalArithmeticJobData) {
    return null;
  }
  var data = jobData.parameters as VerbalArithmeticJobData;

  var output = solveCryptogram(data.equations, data.allSolutions, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort!.send(output);

  return output;
}

bool _allSolutions = false;
int _totalPermutations = 0;
int _currentCombination = 0;
int _stepSize = 1;
int _nextSendStep = 1;
SendPort? _sendAsyncPort;
List<HashMap<String, int>> _solutions = [];

VerbalArithmeticOutput? solveCryptogram(List<String> equations, bool allSolutions, {SendPort? sendAsyncPort}) {
  SymbolMatrixString.deleteEmptyLines(equations);
  var _equations = equations.map((equation) => Equation(equation, rearrange: true)).toList();

  var notValid = _equations.any((equation) => !equation.validFormula);
  if (notValid || _equations.isEmpty) {
    return VerbalArithmeticOutput(equations: _equations, solutions: [], error: 'InvalidEquation');
  }
  _allSolutions = allSolutions;
  return _solveCryptogram(_equations, sendAsyncPort);
}

VerbalArithmeticOutput? _solveCryptogram(List<Equation> equations, SendPort? sendAsyncPort) {
  final Set<String> variables = {};
  for (var equation in equations) {
    variables.addAll(equation.usedMembers);
  }

  final variableList = variables.toList();

  // Automatically determine value range
  final maxValue = _findMaxValueInEquations(equations);
  final range = List.generate(maxValue + 1, (index) => index);

  _solutions.clear();
  var _equations = _sortEquations(equations);

  _totalPermutations = _calculatePossibilities(range.length, variableList.length);
  _currentCombination = 0;
  _stepSize  = max(_totalPermutations ~/ 100, 1);
  _nextSendStep = _stepSize;
  _sendAsyncPort = sendAsyncPort;

  __solveCryptogram(_equations, HashMap<String, int>(), variableList, range);

  return VerbalArithmeticOutput(equations: equations, solutions: _solutions, error: '');
}

bool __solveCryptogram(List<Equation> equations, HashMap<String, int> mapping, List<String> remainingVariables,
    List<int> availableValues) {

  if (remainingVariables.isEmpty) {
    if (_evaluateEquation(mapping, equations)) {
      _solutions.add(HashMap<String, int>.from(mapping));
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }
    return false;
  }

  String variable = remainingVariables.removeAt(0);

  for (var value in availableValues) {
    mapping[variable] = value;

    _currentCombination++;
    _sendProgress();

    if (!_evaluateEquation(mapping, equations)) {
      mapping.remove(variable);
      _currentCombination += _calculatePossibilities(availableValues.length, remainingVariables.length);
      _sendProgress();
      continue;
    }

    if (__solveCryptogram(equations, mapping, remainingVariables,
        availableValues.where((v) => v != value).toList())) {
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }

    mapping.remove(variable);
  }

  remainingVariables.insert(0, variable);
  return false;
}

void _sendProgress() {
  if (_sendAsyncPort != null && _currentCombination >= _nextSendStep) {
    _nextSendStep += _stepSize;
    _sendAsyncPort?.send(DoubleText(PROGRESS, _currentCombination / _totalPermutations));
  }
}

/// Calculating the number of possible permutations
int _calculatePossibilities(int totalNumbers, int variableCount) {
  return pow(totalNumbers, variableCount-1).toInt();
}

int _findMaxValueInEquations(List<Equation> equations) {
  int maxValue = 0;
  final constants = <int>[];

  for (var equation in equations) {
    for (var value in equation.Values) {
      constants.add(value);
    }
  }
  if (constants.isNotEmpty) {
    maxValue = max(maxValue, constants.reduce(max));
  }
  if (maxValue == 0) maxValue = 100;

  return maxValue;
}

List<Equation> _sortEquations(List<Equation> equations) {

  List<MapEntry<Equation, int>> equationScores = equations.map((equation) {
    int score = equation.usedMembers.length;
    if (equation.formatedEquation.contains('*')) score *= 2;
    if (equation.formatedEquation.contains('/')) score *= 2;

    return MapEntry(equation, score);
  }).toList();

  equationScores.sort((a, b) => a.value.compareTo(b.value));

  return equationScores.map((entry) => entry.key).toList();
}

bool _evaluateEquation(Map<String, int> variableValues, List<Equation> equations) {
  for (var equation in equations) {

    // all variables definied ?
    if (!variableValues.keys.toSet().containsAll(equation.usedMembers)) {
      continue;
    }

    final context = ContextModel();

    variableValues.forEach((varName, value) {
      context.bindVariable(Variable(varName), Number(value));
    });

    if (equation.exp.evaluate(EvaluationType.REAL, context) != 0) {
      return false;
    }
  }
  return true;
}