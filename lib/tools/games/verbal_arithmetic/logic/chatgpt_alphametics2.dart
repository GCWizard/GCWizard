// import 'dart:collection';
// import 'dart:math';
//
// import 'helper.dart';
//
// // Funktion, die Alphametic-Rätsel löst
// void solveAlphametic(String formula) {
//   var letters = <String>{};
//   var leadingLetters = <String>{};
//   var operations = ['+', '-', '*', '/'];
//
//   // Extrahieren der Buchstaben aus der Formel
//   for (var token in formula.split(RegExp(r'[^A-Z]'))) {
//     if (token.isNotEmpty) {
//       letters.addAll(token.split(''));
//       if (leadingLetters.isEmpty || leadingLetters.length == token.length) {
//         leadingLetters.add(token[0]);
//       }
//     }
//   }
//
//   if (letters.length > 10) {
//     print("Zu viele verschiedene Buchstaben, um eine Lösung zu finden.");
//     return;
//   }
//
//   var letterList = letters.toList();
//   var permutations = generatePermutations(List.generate(10, (i) => i), letterList.length);
//
//   // Prüfen jeder Permutation auf Gültigkeit
//   for (var permutation in permutations) {
//     var mapping = HashMap<String, int>();
//     for (var i = 0; i < letterList.length; i++) {
//       mapping[letterList[i]] = permutation[i];
//     }
//
//     if (leadingLetters.any((letter) => mapping[letter] == 0)) {
//       // Der erste Buchstabe darf keine Null sein
//       continue;
//     }
//
//     if (evaluateFormula(formula, mapping, operations)) {
//       print("Lösung gefunden: $mapping");
//       return;
//     }
//   }
//
//   print("Keine Lösung gefunden.");
// }
//
// // Funktion zur Auswertung der Formel
// bool evaluateFormula(String formula, Map<String, int> mapping, List<String> operations) {
//   var modifiedFormula = formula.split('').map((char) {
//     if (RegExp(r'[A-Z]').hasMatch(char)) {
//       return mapping[char].toString();
//     }
//     return char;
//   }).join('');
//
//   try {
//     return eval(modifiedFormula);
//   } catch (e) {
//     return false;
//   }
// }
//
// // Funktion zur Evaluierung eines mathematischen Ausdrucks
// bool eval(String expression) {
//   try {
//     exp = parser.parse(expression);
//     var result = ExpressionEvaluator().eval(expression);
//     return result != null && result is num;
//   } catch (e) {
//     return false;
//   }
// }
//
// // Funktion, die alle Permutationen generiert
// List<List<int>> generatePermutations(List<int> elements, int length) {
//   if (length == 0) return [[]];
//   var perms = <List<int>>[];
//   for (var i = 0; i < elements.length; i++) {
//     var rest = [...elements]..removeAt(i);
//     for (var perm in generatePermutations(rest, length - 1)) {
//       perms.add([elements[i], ...perm]);
//     }
//   }
//   return perms;
// }
//
// void main() {
//   solveAlphametic("SEND+MORE=MONEY");
//   solveAlphametic("ELEVEN+NINE+FIVE+FIVE=THIRTY");
//   solveAlphametic("ENIGMA/M=TIMES");
// }
