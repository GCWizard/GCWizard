import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

import 'helper.dart';

VerbalArithmeticOutput? solveCryptogram(List<String> formulas, {SendPort? sendAsyncPort}) {
  var _formulas = formulas.map((formula) => Equation(formula)).toList();
  return _solveCryptogram(_formulas, sendAsyncPort);
}

/// Funktion, die versucht, die Gleichungen zu lösen.
VerbalArithmeticOutput? _solveCryptogram(List<Equation> equations, SendPort? sendAsyncPort) {
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

  // Sortiere die Gleichungen nach dem Heuristikmaß
  equations = _sortEquationsByVariableCombinations(equations, variables, maxValue);

  // Berechne die Gesamtzahl der Möglichkeiten für die Fortschrittsanzeige
  final totalPermutations = calculatePossibilities(range.length, variableList.length);
  int currentCombination = 0; // Fortschrittszähler

  // Funktion zur Evaluierung einer Gleichung mit gegebenen Variablenwerten
  bool evaluateEquations(Map<String, int> variableValues, List<Equation> equations) {
    for (var equation in equations) {
      final context = ContextModel();

      // Nur gebundene Variablen in den Kontext einfügen
      variableValues.forEach((varName, value) {
        context.bindVariable(Variable(varName), Number(value));
      });

      // Überprüfen, ob alle Variablen in der Gleichung definiert sind
      if (!variableValues.keys.toSet().containsAll(equation.usedMembers)) {
        continue; // Überspringe diese Gleichung, bis alle Variablen belegt sind
      }

      // Wenn die Gleichung unter den aktuellen Werten nicht 0 ist, breche ab
      if (equation.exp.evaluate(EvaluationType.REAL, context) != 0) {
        return false;
      }
    }
    return true;
  }

  // Funktion zur Anzeige des Fortschritts
  void showProgress(int current, int total) {
    double progress = (current / total) * 100;
    print('Fortschritt: ${progress.toStringAsFixed(2)}%');
  }

  // Rekursive Funktion zur Suche nach Lösungen (Branch-and-Bound)
  bool solve(HashMap<String, int> assignedValues, List<String> remainingVariables, List<int> availableValues) {
    // Wenn alle Variablen belegt sind, überprüfe die Gleichungen
    if (remainingVariables.isEmpty) {
      currentCombination++; // Erhöhe den Fortschrittszähler
      if (currentCombination % 1000 == 0) {
        showProgress(currentCombination, totalPermutations);
      }

      if (evaluateEquations(assignedValues, equations)) {
        print('Lösung gefunden: $assignedValues');
        return true;
      }
      return false;
    }

    // Nächste Variable auswählen
    String variable = remainingVariables.removeAt(0);

    // Werte ausprobieren (Branch-and-Bound)
    for (var value in availableValues) {
      assignedValues[variable] = value;

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

  if (!result) {
    print('Keine Lösung gefunden.');
  }

  return VerbalArithmeticOutput(equations: equations, solutions: mapping, error: '');
}

/// Funktion zur Berechnung der möglichen Kombinationen
int calculatePossibilities(int totalNumbers, int variableCount) {
  return pow(totalNumbers, variableCount).toInt();
}

/// Funktion, die den maximalen Wert in den Gleichungen findet
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

/// Sortiert die Gleichungen so, dass die Gleichung mit den wenigsten Variablenkombinationen zuerst gelöst wird
List<Equation> _sortEquationsByVariableCombinations(List<Equation> equations, Set<String> variables, int maxValue) {
  final variableDomainSize = maxValue + 1;  // Die Anzahl möglicher Werte pro Variable (0 bis maxValue)

  // Berechne das Heuristikmaß für jede Gleichung (Summe aus Variablenanzahl * Wertebereich)
  List<MapEntry<Equation, int>> equationScores = equations.map((equation) {
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