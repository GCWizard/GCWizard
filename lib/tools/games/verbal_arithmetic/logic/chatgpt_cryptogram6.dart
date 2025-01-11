// import 'dart:math';
// import 'package:math_expressions/math_expressions.dart';
//
// /// Funktion, die den maximalen Wert in den Gleichungen findet
// int findMaxValueInEquations(List<String> equations) {
//   final parser = Parser();
//   int maxValue = 0;
//
//   // Suche nach numerischen Werten in den Gleichungen
//   for (var equation in equations) {
//     var exp = parser.parse(equation);
//     final constants = <int>[];
//     exp.traverse((node) {
//       if (node is Number) {
//         constants.add(node.value.toInt());
//       }
//     });
//     if (constants.isNotEmpty) {
//       maxValue = max(maxValue, constants.reduce(max));
//     }
//   }
//
//   return maxValue;
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
//       // Überprüfen, ob alle Variablen in der Gleichung definiert sind
//       var expVariables = exp.traverse((node) => node is Variable ? node.name : null)
//           .where((v) => v != null)
//           .toSet();
//       if (!variableValues.keys.toSet().containsAll(expVariables)) {
//         continue;  // Überspringe diese Gleichung, bis alle Variablen belegt sind
//       }
//
//       // Wenn die Gleichung unter den aktuellen Werten nicht 0 ist, breche ab
//       if (exp.evaluate(EvaluationType.REAL, context) != 0) {
//         return false;
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
//   List<String> equations = [
//     "B+A*C+C*A-D-65",  // Gleichung angepasst für math_expressions (gleichsetzen mit 0)
//     "E-D+C*A+A-C-27",
//     "A*E+C*B-E*B-53",
//     "A*B+C-D*A-E-41",
//     "B*C+C-F+E*A-77",
//     "E*F+C-D+C*A-37",
//     "B+F*E*A-D+C-24",
//     "D*B+E+C*A+F-31"
//   ];
//
//   // Manuelle Übergabe der Variablenliste
//   List<String> variables = ['A', 'B', 'C', 'D', 'E', 'F'];
//
//   // Lösen
//   solveCryptogram(equations, variables);
// }
