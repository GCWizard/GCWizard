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
      var equation = equations.first.equation;
      // var solution = assignedValues.entries.toList();
      // solution.sort(((a, b) => a.key.compareTo(b.key)));
      print('Lösung gefunden: $equation $mapping $_currentCombination% $_totalPermutations');

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
      // _currentCombination += _calculatePossibilities(availableValues.length, remainingVariables.length);
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
      var result = parser.parse(expression).evaluate(EvaluationType.REAL, _cm);
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

// void main() {
//   // Beispielgleichungen
//   List<String> equations = [
//     "ABCB+DEAF=GFFB",
//     "AEEF+AHG=AGIG",
//     "EBB*AH=HGCF",
//     "ABCB-AEEF=EBB",
//     "DEAF/AHG=AH",
//     "GFFB+AGIG=HGCF"
//   ];
//
//   var startTime = DateTime.now();
//   // Lösen
//   solveSymbolism(equations, false, false);
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
//   equations = [
//   "GJ*DJ=LBAC",
//   "BJKD+BCCK=DJKB",
//   "BJLH-GF=BHJL",
//   "BJKD-GJ=BJLH",
//   "BCCK/DJ=GF",
//   "DJKB-LBAC=BHJL"
//   ];
//
//   startTime = DateTime.now();
//   // Lösen
//   solveSymbolism(equations, false, false);
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
// }

// Solution for Example 1: {A: 1, B: 6, C: 9, D: 2, E: 3, F: 0, G: 4, H: 5, I: 8}
// 2532ms
// Solution for Example 2: {G: 5, J: 7, D: 3, K: 8, B: 1, C: 9, F: 4, L: 2, H: 6, A: 0}
// 8365ms

// Lösung gefunden: ABCB-AEEF=EBB {F: 0, A: 1, E: 3, B: 6, H: 5, D: 2, C: 9, I: 8, G: 4} 656608% 100000000
// 233ms
// Lösung gefunden: BJKD+BCCK=DJKB {F: 4, A: 0, J: 7, K: 8, B: 1, H: 6, D: 3, C: 9, G: 5, L: 2} 98282% 1000000000
// 233ms

