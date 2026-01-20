part of 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametics.dart';


VerbalArithmeticOutput? _solveSymbolism(List<Equation> equations, Set<String> variables) {
  final variableList = variables.toList();
  final digits = List.generate(10, (i) => i);

  _solutions.clear();
  var _equations = _sortEquations(equations);

  __solveSymbolism(_equations, HashMap<String, int>(), variableList, digits);

  return VerbalArithmeticOutput(equations: equations, solutions: _solutions, error: '');
}

bool __solveSymbolism(List<Equation> equations, HashMap<String, int> mapping, List<String> remainingVariables,
    List<int> availableValues) {

  if (remainingVariables.isEmpty) {
    if (_evaluateEquationSymbolism(mapping, equations)) {
      if (!_allowLeadingZeros && _hasLeadingZeros(mapping, equations)) {
        return false;
      }
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

    if (!_evaluateEquationSymbolism(mapping, equations)) {
      mapping.remove(variable);
      _sendProgress();
      continue;
    }

    if (__solveSymbolism(equations, mapping, remainingVariables,
        availableValues.where((v) => v != value).toList())) {
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }

    mapping.remove(variable);
  }

  remainingVariables.insert(0, variable);
  return false;
}

List<Equation> _sortEquations(List<Equation> equations) {

  List<MapEntry<Equation, int>> equationScores = equations.map((equation) {
    int score = equation.usedMembers.length;
    if (equation.formatedEquation.contains('*')) score *= 2;
    if (equation.formatedEquation.contains('/')) score *= 2;

    return MapEntry(equation, score);
  }).toList();

  equationScores.sort((a, b) => b.value.compareTo(a.value));

  return equationScores.map((entry) => entry.key).toList();
}

bool _evaluateEquationSymbolism(Map<String, int> mapping, List<Equation> equations) {
  for (var equation in equations) {

    if (!mapping.keys.toSet().containsAll(equation.usedMembers)) {
      continue;
    }
    var expression = Equation.replaceValues(equation.formatedEquation, mapping);

    try {
      var result = RealEvaluator(_cm).evaluate(parser.parse(expression));
      if (result != 0) return false;
    } catch (e) {
      return false;
    }
  }
  return true;
}

bool _hasLeadingZeros(Map<String, int> mapping, List<Equation> equations) {
  var zeroLetter = mapping.entries.where((entry) => entry.value == 0);
  if (zeroLetter.isEmpty) return false;
  for (var equation in equations) {
    if (zeroLetter.any((entry) => equation.leadingLetters.contains(entry.key))) {
      return true;
    }
  }
  return false;
}

