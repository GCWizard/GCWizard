
import 'package:math_expressions/math_expressions.dart';

class AlphameticSolver {
  // Eine Methode, um alle Buchstaben aus einem gegebenen Alphametic-Rätsel zu extrahieren.
  Set<String> extractLetters(String formula) {
    final letters = <String>{};
    for (final char in formula.runes) {
      final letter = String.fromCharCode(char);
      if (RegExp(r'[A-Z]').hasMatch(letter)) {
        letters.add(letter);
      }
    }
    return letters;
  }

  // Methode zur Berechnung eines Alphametic-Rätsels.
  bool solve(String formula) {
    // Extrahiere alle Buchstaben und erstelle eine Liste.
    final letters = extractLetters(formula).toList();
    if (letters.length > 10) {
      throw ArgumentError('Es gibt mehr als 10 verschiedene Buchstaben. Kann nicht gelöst werden.');
    }

    // Generiere alle Permutationen von Ziffern für die Buchstaben
    final digits = List<int>.generate(10, (i) => i); // Liste [0, 1, 2, ..., 9]

    return _solveRecursive(formula, letters, digits, {}, 0);
  }

  // Rekursive Methode, um alle Ziffernzuordnungen zu prüfen.
  bool _solveRecursive(String formula, List<String> letters, List<int> digits, Map<String, int> assignment, int index) {
    if (index == letters.length) {
      // Wenn alle Buchstaben zugewiesen wurden, prüfen wir die Gültigkeit der Formel.
      if (_isValidAssignment(formula, assignment)) {
        print('Lösung gefunden: $assignment');
        return true;
      }
      return false;
    }

    for (final digit in digits) {
      if (assignment.containsValue(digit)) continue;

      // Frühzeitige Eliminierung ungültiger Kombinationen
      if (index == 0 && digit == 0 && _isLeadingLetter(letters[index], formula)) {
        continue; // Der erste Buchstabe einer Gruppe kann nicht 0 sein.
      }

      // Füge die Zuordnung zum aktuellen Buchstaben hinzu.
      assignment[letters[index]] = digit;

      // Rekursion
      if (_solveRecursive(formula, letters, digits, assignment, index + 1)) {
        return true;
      }

      // Entferne die Zuordnung, um die nächste Kombination zu testen.
      assignment.remove(letters[index]);
    }
    return false;
  }

  // Prüft, ob die aktuelle Ziffernzuordnung die Formel erfüllt.
  bool _isValidAssignment(String formula, Map<String, int> assignment) {
    // Evaluieren der linken und rechten Seite der Formel
    final parts = formula.split('=');
    final leftSide = parts[0];
    final rightSide = parts[1];

    // Versuche, die linke und rechte Seite der Gleichung zu berechnen.
    final leftResult = evaluateExpression(leftSide, assignment);
    final rightResult = evaluateExpression(rightSide, assignment);

    // Überprüfen, ob die beiden Seiten gleich sind.
    return leftResult == rightResult;
  }

  // Hilfsmethode, um zu prüfen, ob ein Buchstabe der führende in einem Ausdruck ist.
  bool _isLeadingLetter(String letter, String formula) {
    final terms = formula.split(RegExp(r'[+=]'));
    for (final term in terms) {
      if (term.startsWith(letter)) {
        return true;
      }
    }
    return false;
  }

  // Methode, um einen Ausdruck mit der gegebenen Zuordnung zu evaluieren.
  String evaluateExpression(String formula, Map<String, int> assignment) {
    for (final entry in assignment.entries) {
      formula = formula.replaceAll(entry.key, entry.value.toString());
    }

    // Entferne alle Leerzeichen, da math_expressions sie nicht mag
    formula = formula.replaceAll(' ', '');

    // Verwende math_expressions Parser, um den Ausdruck zu evaluieren
    final exp = Parser().parse(formula);
    final result = exp.evaluate(EvaluationType.REAL, ContextModel());

    return result.toString();
  }
}

void main() {
  final solver = AlphameticSolver();
  var startTime = DateTime.now();

  // Testbeispiel 1: ELEVEN + NINE + FIVE + FIVE = THIRTY
  solver.solve('ELEVEN + NINE + FIVE + FIVE = THIRTY');
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();  // Testbeispiel 2: SEND + MORE = MONEY
  solver.solve('SEND + MORE = MONEY');
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();  // Komplexeres Beispiel
  solver.solve('THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE = FORTRESSES');
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  // Lösung gefunden: {E: 7, L: 9, V: 2, N: 5, I: 0, F: 4, T: 8, H: 1, R: 3, Y: 6}
  // 36049ms
  // Lösung gefunden: {S: 2, E: 8, N: 1, D: 7, M: 0, O: 3, R: 6, Y: 5}
  // 3286ms
  // 100550ms
}
