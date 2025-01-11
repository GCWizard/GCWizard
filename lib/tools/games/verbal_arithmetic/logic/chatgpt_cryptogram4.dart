// import 'dart:math';
// import 'package:math_expressions/math_expressions.dart';
//
// /// Funktion, die versucht, die Gleichungen zu lösen.
// void solveCryptogram(List<String> equations) {
//   // Parser initialisieren
//   final parser = Parser();
//
//   // Funktion, um Variablen aus einem Ausdruck zu extrahieren
//   Set<String> extractVariables(Expression exp) {
//     return <String>{'A', 'B', 'C', 'D', 'E', 'F'};
//     // final variables = <String>{};
//     // exp.traverse((node) {
//     //   if (node is Variable) {
//     //     variables.add(node.name);
//     //   }
//     // });
//     // return variables;
//   }
//
//   // Alle Variablen extrahieren
//   final Set<String> variables = {};
//   for (var equation in equations) {
//     var exp = parser.parse(equation);
//     variables.addAll(extractVariables(exp));
//   }
//
//   // Variablen sortieren für eine konsistente Verarbeitung
//   final variableList = variables.toList()..sort();
//
//   // Automatischen Wertebereich ermitteln (1 bis 9 für diese Beispielaufgabe)
//   final range = List.generate(9, (index) => index + 1);
//
//   // Funktion zur Evaluierung einer Gleichung mit gegebenen Variablenwerten
//   bool evaluateEquations(Map<String, int> variableValues, List<String> equations) {
//     for (var equation in equations) {
//       var exp = parser.parse(equation);
//       final context = ContextModel();
//       variableValues.forEach((varName, value) {
//         context.bindVariable(Variable(varName), Number(value));
//       });
//
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
//   solve({}, variableList, range);
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
//   // Lösen
//   solveCryptogram(equations);
// }
