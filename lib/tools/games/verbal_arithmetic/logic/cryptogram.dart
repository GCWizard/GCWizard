import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:math_expressions/math_expressions.dart';

import 'helper.dart';

Future<SymbolArithmeticOutput?> solveCryptogramAsync(GCWAsyncExecuterParameters jobData) async {
  if (jobData.parameters is! SymbolArithmeticJobData) {
    return null;
  }

  var data = jobData.parameters as SymbolArithmeticJobData;

  var output = solveCryptogram(data.formulas, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort!.send(output);

  return output;
}

SymbolArithmeticOutput? solveCryptogram(List<String> formulas, {SendPort? sendAsyncPort}) {
  var _formulas = formulas.map((formula) => Formula(formula)).toList();
  return _solveCryptogram(_formulas, sendAsyncPort);
}


/// Funktion, die versucht, die Gleichungen zu lösen.
SymbolArithmeticOutput? _solveCryptogram(List<Formula> equations, SendPort? sendAsyncPort) {
  // Alle Variablen extrahieren
  final Set<String> variables = {};
  for (var equation in equations) {
    variables.addAll(equation.usedMembers);
  }

  // Variablen sortieren für eine konsistente Verarbeitung
  final variableList = variables.toList()..sort();

  // Automatischen Wertebereich ermitteln
  final maxValue = _findMaxValueInEquations(equations);
  final range = List.generate(maxValue + 1, (index) => index);

  // Calculating the number of possible permutations
  int totalPermutations = pow((range.length + 1), variableList.length).toInt();
  int progress = 0;
  int stepSize  = max(totalPermutations ~/ 100, 1);

  // Sortiere die Gleichungen nach dem Heuristikmaß
  equations = _sortEquationsByVariableCombinations(equations, variables, maxValue);

  // Funktion zur Evaluierung einer Gleichung mit gegebenen Variablenwerten
  bool evaluateEquations(Map<String, int> variableValues, List<Formula> equations) {
    for (var equation in equations) {
      // var exp = parser.parse(equation);
      final context = ContextModel();

      // Nur gebundene Variablen in den Kontext einfügen
      variableValues.forEach((varName, value) {
        context.bindVariable(Variable(varName), Number(value));
      });

      // Überprüfen, ob alle Variablen in der Gleichung definiert sind
      if (!variableValues.keys.toSet().containsAll(equation.usedMembers)) {
        continue;  // Überspringe diese Gleichung, bis alle Variablen belegt sind
      }

      // progress bar
      progress++;
      if (sendAsyncPort != null && progress % stepSize == 0) {
        // var progress = (count / totalPermutations * 100).toStringAsFixed(2);
        // print("Fortschritt: $progress%");
        sendAsyncPort.send(DoubleText(PROGRESS, progress / totalPermutations));
      }

      // Wenn die Gleichung unter den aktuellen Werten nicht 0 ist, breche ab
      if (equation.exp.evaluate(EvaluationType.REAL, context) != 0) {
        return false;
      }
    }
    return true;
  }

  // Rekursive Funktion zur Suche nach Lösungen (Branch-and-Bound)
  bool solve(HashMap<String, int> assignedValues, List<String> remainingVariables, List<int> availableValues) {
    // Wenn alle Variablen belegt sind, überprüfe die Gleichungen
    if (remainingVariables.isEmpty) {
      if (evaluateEquations(assignedValues, equations)) {
        var equation = equations.first.formula;
        print('Lösung gefunden: $equation $assignedValues');
        return true;
      }
      return false;
    }

    // Nächste Variable auswählen
    String variable = remainingVariables.removeAt(0);

    // Werte ausprobieren (Branch-and-Bound)
    for (var value in availableValues) {
      assignedValues[variable] = value;

      progress++;

      // progress bar
      if (sendAsyncPort != null && progress % stepSize == 0) {
        // var progress = (count / totalPermutations * 100).toStringAsFixed(2);
        // print("Fortschritt: $progress%");
        sendAsyncPort.send(DoubleText(PROGRESS, progress / totalPermutations));
      }

      // Frühzeitige Prüfung der Gültigkeit der Zuweisungen
      if (!evaluateEquations(assignedValues, equations)) {
        assignedValues.remove(variable);
        continue;
      }

      // Rekursion für den nächsten Schritt
      if (solve(assignedValues, remainingVariables, availableValues.where((v) => v != value).toList())) {
        return true;
      }

      // Rückgängigmachen der Zuweisung, falls kein Erfolg
      assignedValues.remove(variable);
    }

    // Keine Lösung gefunden in diesem Pfad
    remainingVariables.insert(0, variable);
    return false;
  }

  var mapping = HashMap<String, int>();
  // Initiale Aufruf der Lösungssuche
  var result = solve(mapping, variableList, range);
  var formulas = equations.map((formula) => formula.formula).toList();
  return SymbolArithmeticOutput(formulas: formulas, solutions: mapping, error: '');
}

/// Funktion, die den maximalen Wert in den Gleichungen findet
int _findMaxValueInEquations(List<Formula> equations) {
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

/// Sortiert die Gleichungen so, dass die Gleichung mit den wenigsten Variablenkombinationen zuerst gelöst wird
List<Formula> _sortEquationsByVariableCombinations(List<Formula> equations, Set<String> variables, int maxValue) {
  final parser = Parser();
  final variableDomainSize = maxValue + 1;  // Die Anzahl möglicher Werte pro Variable (0 bis maxValue)

  // Berechne das Heuristikmaß für jede Gleichung (Summe aus Variablenanzahl * Wertebereich)
  List<MapEntry<Formula, int>> equationScores = equations.map((equation) {
    // var exp = parser.parse(equation);
    // var equationVariables = <String>{};
    // equationVariables = equation.usedMembers;

    // Extrahiere Variablen aus der Gleichung
    // exp.traverse((node) {
    //   if (node is Variable) {
    //     equationVariables.add(node.name);
    //   }
    // });
    // var regExp = RegExp(r'\w+');
    // regExp.allMatches(equation).forEach((match) {
    //   equationVariables.add(match.group(0)!);
    // });

    // Heuristik: Anzahl Variablen * mögliche Wertebereiche pro Variable
    int score = equation.usedMembers.length * variableDomainSize;
    return MapEntry(equation, score);
  }).toList();

  // Sortiere die Gleichungen nach der berechneten Heuristik (aufsteigend)
  equationScores.sort((a, b) => a.value.compareTo(b.value));

  // Gib die sortierten Gleichungen zurück
  return equationScores.map((entry) => entry.key).toList();
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
  // List<String> variables = ['A', 'B', 'C', 'D', 'E', 'F'];
  var startTime = DateTime.now();
  // Lösen
  solveCryptogram(equations);
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
  // List<String> variables = ['A', 'B', 'C', 'D', 'E', 'F'];

  startTime = DateTime.now();
  // Lösen
  solveCryptogram(equations);
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

   equations = [
  'A*B-1428',
  'C-D-12',
  'A*C-840',
  'B-D-33',
  ];
  // // Manuelle Übergabe der Variablenliste
  // List<String> variables = ['A', 'B', 'C', 'D'];

  startTime = DateTime.now();
  // Lösen
  solveCryptogram(equations);
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

