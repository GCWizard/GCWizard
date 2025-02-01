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
      var equation = equations.first.equation;

      print('Lösung gefunden: $equation $mapping $_currentCombination% $_totalPermutations');

      _solutions.add(mapping);
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

void main() {
  // Beispielgleichungen
  List<String> equations = [
    "B+A*C+C*A-D-65",  // Gleichung angepasst für math_expressions (gleichsetzen mit 0)
    "E-D+C*A+A-C-27",
    "A*E+C*B-E*B-53",
    "A*B+C-D*A-E-41",
    "B*C+C-F+E*A-77",
    "E*F+C-D+C*A-37",
    "B+F*E*A-D+C-24",
    "D*B+E+C*A+F-31"
  ];

  var startTime = DateTime.now();
  // Lösen
  solveCryptogram(equations, false);
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  equations = [
  'A+A+B+B+C+D-49',
  'E+C+E+F+D+D-67',
  'D+F+C+E+D+D-56',
  'A+A+A+A+F+D-36',
  'D+F+F+D+F+D-60',
  'A+A+A+A+C+D-25',
  'A+E+D+A+D+A-47',
  'A+C+F+A+F+A-37',
  'B+E+C+A+F+A-56',
  'B+F+E+A+D+A-63',
  'C+D+D+F+F+C-42',
  'D+D+D+D+D+D-48',
  ];

  startTime = DateTime.now();
  // Lösen
  solveCryptogram(equations, false);
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

   equations = [
  'A*B-1428',
  'C-D-12',
  'A*C-840',
  'B-D-33',
  ];

  startTime = DateTime.now();
  // Lösen
  solveCryptogram(equations, false);
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
}

// Lösung gefunden: B+A*C+C*A-D-65 {F: 1, A: 4, D: 0, C: 7, E: 2, B: 9}
// 2274ms
// Lösung gefunden: D+D+D+D+D+D-48 {F: 12, A: 4, D: 8, C: 1, E: 19, B: 16}
// 853ms
// Lösung gefunden: A*B-1428 {A: 28, D: 18, C: 30, B: 51}
// 48ms

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

