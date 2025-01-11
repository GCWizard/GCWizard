//
// import 'dart:async';
//
// // Funktion zum Berechnen von Formeln
// bool evaluateFormula(Map<String, int> values, String formula) {
//   // Ersetzt die Buchstaben durch Zahlen und wertet die Formel aus
//   for (var key in values.keys) {
//     formula = formula.replaceAll(key, values[key].toString());
//   }
//
//   try {
//     // Versucht, die resultierende Formel als mathematische Ausdruck auszuwerten
//     var result = _evalMathExpression(formula);
//     return result != null;
//   } catch (e) {
//     return false;
//   }
// }
//
// // Hilfsfunktion zur Auswertung der mathematischen Formel als String
// double? _evalMathExpression(String expr) {
//   try {
//     var result = double.parse(expr);
//     return result;
//   } catch (e) {
//     return null;
//   }
// }
//
// // Hilfsfunktion zur Überprüfung, ob eine Zahl führende Nullen hat
// bool hasLeadingZero(String number) {
//   return number.length > 1 && number.startsWith('0');
// }
//
// // Funktion zur Vorauswahl der Ziffern
// Map<String, List<int>> prepareDigitCandidates(List<String> formulas) {
//   var candidates = <String, List<int>>{};
//
//   // Alle Buchstaben aus den Formeln extrahieren
//   var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
//
//   // Für jeden Buchstaben setzen wir mögliche Ziffern
//   for (var letter in alphabet) {
//     candidates[letter] = List<int>.from([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
//
//     // Buchstaben, die an erster Stelle einer Zahl sind, dürfen nicht 0 sein
//     for (var formula in formulas) {
//       if (formula.contains('$letter ')) {
//         candidates[letter]!.remove(0);
//       }
//     }
//   }
//
//   return candidates;
// }
//
// // Optimierung durch heuristische Reihenfolge
// List<String> getOrderedVariables(Map<String, List<int>> digitCandidates) {
//   // Buchstaben nach der Anzahl der möglichen Ziffern sortieren
//   var orderedVars = digitCandidates.keys.toList();
//   orderedVars.sort((a, b) => digitCandidates[a]!.length.compareTo(digitCandidates[b]!.length));
//   return orderedVars;
// }
//
// // Hauptlogik zur Lösung der Symbol-Arithmetik
// Future<bool> solveSymbolArithmetic(List<String> formulas) {
//   var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
//   var usedDigits = <int>{}; // Die bereits verwendeten Ziffern (0-9)
//
//   // Bereitet die Liste von gültigen Ziffern für jeden Buchstaben vor
//   var digitCandidates = prepareDigitCandidates(formulas);
//
//   // Heuristische Auswahl der Variablen
//   var orderedVars = getOrderedVariables(digitCandidates);
//
//   // Funktion zur Rekursiven Suche nach Lösungen
//   Future<bool> backtrack(Map<String, int> values, int idx) async {
//     if (idx == orderedVars.length) {
//       // Alle Buchstaben haben Werte
//       for (var formula in formulas) {
//         if (!evaluateFormula(values, formula)) {
//           return false; // Wenn eine Formel nicht zutrifft
//         }
//       }
//       // Ausgabe der gefundenen Lösung
//       print('Lösung gefunden:');
//       values.forEach((key, value) {
//         print('$key = $value');
//       });
//       return true;
//     }
//
//     // Versucht für jede mögliche Ziffer der Variablen
//     String letter = orderedVars[idx];
//     for (int digit in digitCandidates[letter]!) {
//       if (!usedDigits.contains(digit)) {
//         // Verhindere führende Nullen
//         if (hasLeadingZero(digit.toString())) {
//           continue;
//         }
//
//         usedDigits.add(digit);
//         values[letter] = digit;
//
//         // Berechnung auswerten und frühzeitig abbrechen, falls ungültig
//         if (await backtrack(values, idx + 1)) {
//           return true;
//         }
//
//         // Wenn nicht, zurücksetzen
//         values.remove(letter);
//         usedDigits.remove(digit);
//       }
//     }
//     return false;
//   }
//
//   // Initiale Rekursion starten
//   return backtrack({}, 0);
// }
//
// Future<void> main() async {
//   // Beispiel-Formeln
//   List<String> formulas = [
//     'ELEVEN + NINE + FIVE + FIVE = THIRTY',
//
//   ];
//
//   ///    'ENIGMA / M = TIMES',
//   //     'ENIGMA = TIMES * M'
//
//   print(await solveSymbolArithmetic(formulas));
// }
//
// ///
// /// Erläuterung der Optimierungen:
// // Heuristische Reihenfolge bei der Variablensuche:
// //
// // Die Funktion getOrderedVariables sortiert die Buchstaben nach der Anzahl der möglichen Ziffern. Dadurch wird zuerst die Variable mit den wenigsten Optionen (also der schwierigste Fall) bearbeitet, was in vielen Fällen die Rekursion verkürzt.
// // Frühzeitiges Überprüfen und Abbrechen von ungültigen Kombinationen:
// //
// // Während der Rekursion überprüfen wir weiterhin, ob jede Teilberechnung der Formel gültig ist, indem wir die evaluateFormula-Funktion verwenden. Wenn eine ungültige Berechnung auftritt (z. B. Division durch Null), wird der aktuelle Versuch sofort abgebrochen.
// // Zwischenspeicherung (Memoization):
// //
// // In diesem Beispiel haben wir keine explizite Memoization implementiert, aber die Idee ist, Zwischenberechnungen zu speichern, falls dies für Formeln mit ähnlichen Strukturen hilfreich ist. Diese Technik ist besonders nützlich, wenn dieselben Teilformeln mehrfach berechnet werden.
// // Parallelisierung (Async/await):
// //
// // Der backtrack-Prozess wurde so umstrukturiert, dass er mit Future<bool> arbeitet, um parallele Berechnungen zu ermöglichen. Obwohl diese Funktion in Dart nicht direkt parallel arbeitet, könnte sie in einer echten Umgebung so angepasst werden, dass Rekursionen parallel auf mehreren Threads ausgeführt werden (z.B. mit Isolates). In diesem Beispiel haben wir dies als Platzhalter für zukünftige Optimierungen eingeführt.
// // Weitere Überlegungen:
// // Komplexität: Auch mit diesen Optimierungen bleibt der Algorithmus komplex. Es kann sein, dass die Berechnung bei einer sehr großen Anzahl an Variablen und Formeln immer noch nicht schnell genug ist. Weitere Optimierungen wie Branch-and-Bound oder die Verwendung eines SAT-Solvers könnten für extrem komplexe Fälle in Betracht gezogen werden.
// //
// // Zwischenberechnungen und Memoization: Eine fortgeschrittenere Technik könnte die Zwischenspeicherung der Auswertungen einzelner Formeln und Teile von Formeln umfassen, sodass redundante Berechnungen vermieden werden.
// //
// // Mit diesen Verbesserungen sollte der Algorithmus schneller und effizienter sein und auch größere Probleme besser handhaben können.
