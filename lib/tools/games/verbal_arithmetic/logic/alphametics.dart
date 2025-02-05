import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/helper.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:math_expressions/math_expressions.dart';

part 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametics_addition.dart';
part 'package:gc_wizard/tools/games/verbal_arithmetic/logic/symbolism.dart';

Future<VerbalArithmeticOutput?> solveAlphameticsAsync(GCWAsyncExecuterParameters jobData) async {
  if (jobData.parameters is! VerbalArithmeticJobData) {
    return null;
  }
  var data = jobData.parameters as VerbalArithmeticJobData;

  var output = solveAlphametic(data.equations, data.allSolutions, data.allowLeadingZeros,
      sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort!.send(output);

  return output;
}

bool _allSolutions = false;
bool _allowLeadingZeros = false;
int _totalPermutations = 0;
int _currentCombination = 0;
int _stepSize = 1;
int _nextSendStep = 1;
SendPort? _sendAsyncPort;
ContextModel _cm = ContextModel();

VerbalArithmeticOutput? solveAlphametic(List<String> equations, bool allSolutions, bool allowLeadingZeros,
    {SendPort? sendAsyncPort}) {
  SymbolMatrixString.deleteEmptyLines(equations);
  var _equations = equations.map((equation) => Equation(equation, singleLetter: true,
      rearrange: equations.length > 1)).toList();

  if (_equations.length <= 1 && equations.length > 1) {
    _equations = equations.map((equation) => Equation(equation, singleLetter: true,
        rearrange: _equations.length > 1)).toList();
  }
  var notValid = _equations.any((equation) => !equation.validFormula);
  if (notValid || _equations.isEmpty) {
    return VerbalArithmeticOutput(equations: _equations, solutions: [], error: 'InvalidEquation');
  }

  final Set<String> variables = {};
  final Set<String> leadingVariables = {};
  for (var equation in _equations) {
    variables.addAll(equation.usedMembers);
    leadingVariables.addAll(equation.leadingLetters);
  }
  if (variables.length > 10) {
    return VerbalArithmeticOutput(equations: [], solutions: [], error: 'TooManyLetters');
  }

  _allSolutions = allSolutions;
  _allowLeadingZeros = allowLeadingZeros;

  _totalPermutations = _calculatePossibilities(variables.length);
  _currentCombination = 0;
  _stepSize  = max(_totalPermutations ~/ 100, 1);
  _nextSendStep = _stepSize;
  _sendAsyncPort = sendAsyncPort;

  if (_equations.length > 1) {
    return _solveSymbolism(_equations, variables);
  } else if (_equations.first.onlyAddition) {
    return _solveAlphameticAdd(_equations.first);
  } else {
    return _solveAlphametic(_equations.first);
  }
}

VerbalArithmeticOutput? _solveAlphametic(Equation equation) {
  var letterList = equation.usedMembers.toList();

  // Generate permutations and evaluate each combination
  var mappings = _permuteAndEvaluate(letterList, equation.formatedEquation, equation.leadingLetters);
  var solutions = <HashMap<String, int>>[];
  for (var mapping in mappings) {
    if (mapping != null) {
      solutions.add(mapping);
      if (!_allSolutions || solutions.length >= MAX_SOLUTIONS) {
        break;
      }
    }
  }
  return VerbalArithmeticOutput(equations: [equation], solutions: solutions, error: '');
}

Iterable<HashMap<String, int>?> _permuteAndEvaluate(List<String> letters, String formula,
    Set<String> leadingLetters) sync* {
  var availableDigits = List.generate(10, (i) => i);
  var allPermutations = _generatePermutations(letters.length, availableDigits);

  for (var perm in allPermutations) {
    _currentCombination++;
    _sendProgress();

    var mapping = HashMap<String, int>();
    for (var i = 0; i < letters.length; i++) {
      mapping[letters[i]] = perm[i];
    }

    if (!_allowLeadingZeros && leadingLetters.any((letter) => mapping[letter] == 0)) {
      continue;
    }

    if (_evaluateEquation(formula, mapping)) {
      yield mapping;
    }
  }
  yield null;
}

void _sendProgress() {
  if (_sendAsyncPort != null && _currentCombination >= _nextSendStep) {
    _nextSendStep += _stepSize;
    _sendAsyncPort?.send(DoubleText(PROGRESS, _currentCombination / _totalPermutations));
  }
}

/// generating all permutations
Iterable<List<int>> _generatePermutations(int length, List<int> availableDigits) sync* {
  if (length == 0) {
    yield [];
  } else {
    for (var i = 0; i < availableDigits.length; i++) {
      var digit = availableDigits[i];
      var remainingDigits = List.of(availableDigits)..removeAt(i);

      for (var perm in _generatePermutations(length - 1, remainingDigits)) {
        yield [digit, ...perm];
      }
    }
  }
}

bool _evaluateEquation(String equation, Map<String, int> mapping) {
  var sides = Equation.replaceValues(equation, mapping).split('=');
  if (sides.length != 2) return false;

  try {
    var leftValue = _eval(sides[0]);
    var rightValue = _eval(sides[1]);

    return leftValue == rightValue;
  } catch (e) {
    return false;
  }
}

num _eval(String expression) {
  var result = parser.parse(expression).evaluate(EvaluationType.REAL, _cm);
  return result != null && result is num ? result : double.negativeInfinity;
}

int _calculatePossibilities(int lettersCount) {
  return factorial(10) ~/ factorial(10 - lettersCount);
}

int factorialRange(int start, int end) {
  int result = 1;
  for (int i = start; i > end; i--) {
    result *= i;
  }
  return result;
}