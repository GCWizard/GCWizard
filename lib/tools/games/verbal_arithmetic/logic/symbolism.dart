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

  var output = solveSymbolism(data.equations, data.allSolutions, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort!.send(output);

  return output;
}

bool _allSolutions = false;

VerbalArithmeticOutput? solveSymbolism(List<String> equations, bool allSolutions, {SendPort? sendAsyncPort}) {
  var _equations = equations.map((equation) => Equation(equation, singleLetter: true, rearrange: true)).toList();
  var notValid = _equations.any((equation) => !equation.validFormula);
  if (notValid || _equations.isEmpty) {
    return VerbalArithmeticOutput(equations: _equations, solutions: [], error: 'InvalidEquation');
  }

  _allSolutions = allSolutions;
  return _solveSymbolism(_equations, sendAsyncPort);
}

int _totalPermutations = 0;
int _currentCombination = 0;
int _stepSize = 1;
int _nextSendStep = 1;
SendPort? _sendAsyncPort;
List<HashMap<String, int>> _solutions = [];

VerbalArithmeticOutput? _solveSymbolism(List<Equation> equations, SendPort? sendAsyncPort) {
  final Set<String> variables = {};
  for (var equation in equations) {
    variables.addAll(equation.usedMembers);
  }

  final variableList = variables.toList()..sort();

  final digits = List.generate(10, (i) => i);

  // equations = _sortEquationsByVariableCombinations(equations, variables, maxValue);

  _totalPermutations = _calculatePossibilities(digits.length, variableList.length);
  _currentCombination = 0;
  _stepSize  = max(_totalPermutations ~/ 100, 1);
  _nextSendStep = _stepSize;

  __solveCryptogram(equations, HashMap<String, int>(), variableList, digits);

  return VerbalArithmeticOutput(equations: equations, solutions: _solutions, error: '');
}

bool __solveCryptogram(List<Equation> equations, HashMap<String, int> assignedValues, List<String> remainingVariables,
    List<int> availableValues) {

  if (remainingVariables.isEmpty) {
    if (_evaluateEquation(assignedValues, equations)) {
      var equation = equations.first.equation;
      // var solution = assignedValues.entries.toList();
      // solution.sort(((a, b) => a.key.compareTo(b.key)));
      print('Lösung gefunden: $equation $assignedValues $_currentCombination% $_totalPermutations');

      _solutions.add(assignedValues);
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }
    return false;
  }

  String variable = remainingVariables.removeAt(0);

  for (var value in availableValues) {
    assignedValues[variable] = value;

    _currentCombination++;
    _sendProgress();

    if (!_evaluateEquation(assignedValues, equations)) {
      assignedValues.remove(variable);
      _currentCombination += _calculatePossibilities(availableValues.length, remainingVariables.length);
      _sendProgress();
      continue;
    }

    if (__solveCryptogram(equations, assignedValues, remainingVariables,
        availableValues.where((v) => v != value).toList())) {
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }

    assignedValues.remove(variable);
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

/// Sorts the equations so that the equation with the fewest combinations of variables is solved first
List<Equation> _sortEquationsByVariableCombinations(List<Equation> equations, Set<String> variables, int maxValue) {
  final variableDomainSize = maxValue + 1;

  List<MapEntry<Equation, int>> equationScores = equations.map((equation) {
    // Heuristic: number of variables * possible value ranges per variable
    int score = equation.usedMembers.length * variableDomainSize;
    return MapEntry(equation, score);
  }).toList();

  equationScores.sort((a, b) => a.value.compareTo(b.value));

  return equationScores.map((entry) => entry.key).toList();
}

bool _evaluateEquation(Map<String, int> mapping, List<Equation> equations) {
  for (var equation in equations) {

    // all variables definied ?
    if (!mapping.keys.toSet().containsAll(equation.usedMembers)) {
      continue;
    }

    final context = ContextModel();

    var expression = Equation.replaceValues(equation.formatedEquation, mapping);
    Expression exp = parser.parse(expression);

    var result = exp.evaluate(EvaluationType.REAL, context);
    if (result != 0) return false;
  }
  return true;
}

void main() {
  // Beispielgleichungen
  List<String> equations = [
    "ABCB+DEAF=GFFB",
    "AEEF+AHG=AGIG",
    "EBB*AH=HGCF",
    "ABCB-AEEF=EBB",
    "DEAF/AHG=AH",
    "GFFB+AGIG=HGCF"
  ];

  var startTime = DateTime.now();
  // Lösen
  solveSymbolism(equations, false);
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  equations = [
  "GJ*DJ=LBAC",
  "BJKD+BCCK=DJKB",
  "BJLH-GF=BHJL",
  "BJKD-GJ=BJLH",
  "BCCK/DJ=GF",
  "DJKB-LBAC=BHJL"
  ];

  startTime = DateTime.now();
  // Lösen
  solveSymbolism(equations, false);
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

}

// Solution for Example 1: {A: 1, B: 6, C: 9, D: 2, E: 3, F: 0, G: 4, H: 5, I: 8}
// 2532ms
// Solution for Example 2: {G: 5, J: 7, D: 3, K: 8, B: 1, C: 9, F: 4, L: 2, H: 6, A: 0}
// 8365ms

// Lösung gefunden: ABCB+DEAF=GFFB {F: 0, A: 1, E: 3, B: 6, H: 5, D: 2, C: 9, I: 8, G: 4} 656608% 100000000
// 253ms
// Lösung gefunden: GJ*DJ=LBAC {F: 4, A: 0, J: 7, K: 8, B: 1, H: 6, D: 3, C: 9, G: 5, L: 2} 98282% 1000000000
// 248ms

// import 'package:math_expressions/math_expressions.dart';
//
// void main() {
//   // Beispiel: Lösen des Systems:
//   // A * B = 1428
//   // C - D = 12
//   // A * C = 840
//   // B - D = 33
//
//   // Wir versuchen, das System numerisch zu lösen:
//   double A = 0, B = 0, C = 0, D = 0;
//   double tolerance = 0.0001; // Toleranz für die Lösung
//   double learningRate = 0.01; // Lernrate für die numerische Lösung
//
//   // Startwerte für die Variablen
//   A = 10;
//   B = 10;
//   C = 10;
//   D = 10;
//
//   // Hilfsfunktion zur Berechnung des Fehlers
//   double error() {
//     double eq1 = A * B - 1428;
//     double eq2 = C - D - 12;
//     double eq3 = A * C - 840;
//     double eq4 = B - D - 33;
//
//     // Fehler ist die Summe der Quadrate der Abweichungen
//     return eq1 * eq1 + eq2 * eq2 + eq3 * eq3 + eq4 * eq4;
//   }
//
//   // Iterativer Ansatz (Gradientenabstieg)
//   while (error() > tolerance) {
//     // Berechne die Ableitungen (Gradienten) für jede Gleichung
//     double eq1 = A * B - 1428;
//     double eq2 = C - D - 12;
//     double eq3 = A * C - 840;
//     double eq4 = B - D - 33;
//
//     // Berechne die partiellen Ableitungen (Zahlenbeispiel)
//     double dA = B * eq1 + C * eq3;
//     double dB = A * eq1 + eq4;
//     double dC = A * eq3 - eq2;
//     double dD = eq2 + eq4;
//
//     // Update der Werte durch Subtraktion der Lernrate * Ableitung
//     A -= learningRate * dA;
//     B -= learningRate * dB;
//     C -= learningRate * dC;
//     D -= learningRate * dD;
//
//     // Debug-Ausgabe
//     print("A: $A, B: $B, C: $C, D: $D, Fehler: ${error()}");
//   }
//
//   // Endergebnis
//   print("Lösung: A = $A, B = $B, C = $C, D = $D");
// }

