//
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
//     // Sucht nach einer gültigen mathematischen Ausdrucksauswertung
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
// // Hauptlogik zur Lösung der Symbol-Arithmetik
// void solveSymbolArithmetic(List<String> formulas) {
//   var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
//   var usedDigits = <int>{}; // Die bereits verwendeten Ziffern (0-9)
//
//   // Bereitet die Liste von gültigen Ziffern für jeden Buchstaben vor
//   var digitCandidates = prepareDigitCandidates(formulas);
//
//   // Funktion zur Rekursiven Suche nach Lösungen
//   bool backtrack(Map<String, int> values, int idx) {
//     if (idx == alphabet.length) {
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
//     // Versucht für jeden Buchstaben im Alphabet
//     String letter = alphabet[idx];
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
//         // Wenn es eine Lösung für den aktuellen Zustand gibt
//         if (backtrack(values, idx + 1)) {
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
//   backtrack({}, 0);
// }
//
// void main() {
//   // Beispiel-Formeln
//   List<String> formulas = [
//     'ELEVEN + NINE + FIVE + FIVE = THIRTY',
//     'ENIGMA / M = TIMES',
//     'ENIGMA = TIMES * M'
//   ];
//
//   solveSymbolArithmetic(formulas);
// }
