// import 'dart:math';
// import 'package:math_expressions/math_expressions.dart';
//
// import 'helper.dart';
//
// /// Funktion, die den maximalen Wert in den Gleichungen findet
// int findMaxValueInEquations(List<String> equations) {
//   final parser = Parser();
//   int maxValue = 0;
//   var regExp = RegExp(r'\d+');
//   final constants = <int>[];
//
//   for (var equation in equations) {
//     regExp.allMatches(equation).forEach((match) {
//       constants.add(int.parse(match.group(0)!));
//     });
//   }
//   if (constants.isNotEmpty) {
//     maxValue = max(maxValue, constants.reduce(max));
//   }
//   if (maxValue == 0) maxValue = 100;
//
//   // Suche nach numerischen Werten in den Gleichungen
//   // for (var equation in equations) {
//   //   var exp = parser.parse(equation);
//   //   final constants = <int>[];
//   //   exp.traverse((node) {
//   //     if (node is Number) {
//   //       constants.add(node.value.toInt());
//   //     }
//   //   });
//   //   if (constants.isNotEmpty) {
//   //     maxValue = max(maxValue, constants.reduce(max));
//   //   }
//   // }
//
//   return maxValue;
// }
//
// /// Sortiert die Gleichungen so, dass die Gleichung mit den wenigsten Variablenkombinationen zuerst gelöst wird
// List<String> sortEquationsByVariableCombinations(List<String> equations, List<String> variables, int maxValue) {
//   final parser = Parser();
//   final variableDomainSize = maxValue + 1;  // Die Anzahl möglicher Werte pro Variable (0 bis maxValue)
//
//   // Berechne das Heuristikmaß für jede Gleichung (Summe aus Variablenanzahl * Wertebereich)
//   List<MapEntry<String, int>> equationScores = equations.map((equation) {
//     var exp = parser.parse(equation);
//     var equationVariables = <String>{};
//
//     // Extrahiere Variablen aus der Gleichung
//     // exp.traverse((node) {
//     //   if (node is Variable) {
//     //     equationVariables.add(node.name);
//     //   }
//     // });
//     var regExp = RegExp(r'\w+');
//     regExp.allMatches(equation).forEach((match) {
//       equationVariables.add(match.group(0)!);
//     });
//
//     // Heuristik: Anzahl Variablen * mögliche Wertebereiche pro Variable
//     int score = equationVariables.length * variableDomainSize;
//     return MapEntry(equation, score);
//   }).toList();
//
//   // Sortiere die Gleichungen nach der berechneten Heuristik (aufsteigend)
//   equationScores.sort((a, b) => a.value.compareTo(b.value));
//
//   // Gib die sortierten Gleichungen zurück
//   return equationScores.map((entry) => entry.key).toList();
// }
//
// /// Funktion, die versucht, die Gleichungen zu lösen.
// void solveCryptogram(List<String> equations, List<String> variables) {
//   // Parser initialisieren
//   final parser = Parser();
//
//   // Automatischen Wertebereich ermitteln
//   final maxValue = findMaxValueInEquations(equations);
//   final range = List.generate(maxValue + 1, (index) => index);
//
//   // Sortiere die Gleichungen nach dem Heuristikmaß
//   equations = sortEquationsByVariableCombinations(equations, variables, maxValue);
//
//   // Funktion zur Evaluierung einer Gleichung mit gegebenen Variablenwerten
//   bool evaluateEquations(Map<String, int> variableValues, List<String> equations) {
//     for (var equation in equations) {
//       var exp = parser.parse(equation);
//       final context = ContextModel();
//
//       // Nur gebundene Variablen in den Kontext einfügen
//       variableValues.forEach((varName, value) {
//         context.bindVariable(Variable(varName), Number(value));
//       });
//
//       try {
//         // Wenn die Gleichung unter den aktuellen Werten nicht 0 ist, breche ab
//         if (exp.evaluate(EvaluationType.REAL, context) != 0) {
//           return false;
//         }
//       } catch (e) {
//         // Wenn eine Exception auftritt, bedeutet das, dass noch nicht alle Variablen definiert sind
//         continue;
//       }
//     }
//     return true;
//   }
//
//   // Rekursive Funktion zur Suche nach Lösungen (Branch-and-Bound)
//   bool solve(Map<String, int> assignedValues, List<String> remainingVariables, List<int> availableValues) {
//     // Wenn alle Variablen belegt sind, überprüfe die Gleichungen
//     if (remainingVariables.isEmpty) {
//       if (evaluateEquations(assignedValues, equations)) {
//         print('Lösung gefunden: $assignedValues');
//         return true;
//       }
//       return false;
//     }
//
//     // Nächste Variable auswählen
//     String variable = remainingVariables.removeAt(0);
//
//     // Werte ausprobieren (Branch-and-Bound)
//     for (var value in availableValues) {
//       assignedValues[variable] = value;
//
//       // Frühzeitige Prüfung der Gültigkeit der Zuweisungen
//       if (!evaluateEquations(assignedValues, equations)) {
//         assignedValues.remove(variable);
//         continue;
//       }
//
//       // Rekursion für den nächsten Schritt
//       if (solve(assignedValues, remainingVariables, availableValues.where((v) => v != value).toList())) {
//         return true;
//       }
//
//       // Rückgängigmachen der Zuweisung, falls kein Erfolg
//       assignedValues.remove(variable);
//     }
//
//     // Keine Lösung gefunden in diesem Pfad
//     remainingVariables.insert(0, variable);
//     return false;
//   }
//
//   // Initiale Aufruf der Lösungssuche
//   solve({}, variables, range);
// }
//
// void main() {
//   // Beispielgleichungen
//   // List<String> equations = [
//   //   "B+A*C+C*A-D-65",  // Gleichung angepasst für math_expressions (gleichsetzen mit 0)
//   //   "E-D+C*A+A-C-27",
//   //   "A*E+C*B-E*B-53",
//   //   "A*B+C-D*A-E-41",
//   //   "B*C+C-F+E*A-77",
//   //   "E*F+C-D+C*A-37",
//   //   "B+F*E*A-D+C-24",
//   //   "D*B+E+C*A+F-31"
//   // ];
//   // List<String> variables = ['A', 'B', 'C', 'D', 'E', 'F'];
//
//   List<String> equations = [
//   'A+A+B+B+C+D-49',
//   'E+C+E+F+D+D-67',
//   'D+F+C+E+D+D-56',
//   'A+A+A+A+F+D-36',
//   'D+F+F+D+F+D-60',
//   'A+A+A+A+C+D-25',
//   'A+E+D+A+D+A-47',
//   'A+C+F+A+F+A-37',
//   'B+E+C+A+F+A-56',
//   'B+F+E+A+D+A-63',
//   'C+D+D+F+F+C-42',
//   'D+D+D+D+D+D-48',
//   ];
//   List<String> variables = ['A', 'B', 'C', 'D', 'E', 'F'];
//
//   // List<String> equations = [
//   // 'A*B-1428',
//   // 'C-D-12',
//   // 'A*C-840',
//   // 'B-D-33',
//   // ];
//   //
//   // // Manuelle Übergabe der Variablenliste
//   // List<String> variables = ['A', 'B', 'C', 'D'];
//
//   equations.forEach((f) => print(Formula(f).toString()));
//
//   var startTime = DateTime.now();
//   // Lösen
//   solveCryptogram(equations, variables);
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
// }
