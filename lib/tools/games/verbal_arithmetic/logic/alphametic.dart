import 'dart:collection';
import 'dart:math';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/helper.dart';
import 'package:math_expressions/math_expressions.dart';

class SymbolArithmeticJobData {
  final List<String> formulas;
  final Map<String, String> substitutions;

  SymbolArithmeticJobData({
    required this.formulas,
    required this.substitutions,
  });
}

class SymbolArithmeticOutput {
  final List<String> formulas;
  final List<Map<String, String>> solutions;
  final bool error;

  SymbolArithmeticOutput({
    required this.formulas,
    required this.solutions,
    required this.error,
  });
}

// Funktion, die Alphametic-Rätsel löst
HashMap<String, int>? solveAlphametic(Formula formula) {
  var letters = <String>{};
  var leadingLetters = <String>{};

  // Extrahiere alle Buchstaben und bestimme die führenden Buchstaben
  for (var token in formula.formula.split(RegExp(r'[^A-Z]'))) {
    if (token.isNotEmpty) {
      // letters.addAll(token.split(''));
      // if (leadingLetters.isEmpty || leadingLetters.length == token.length) {
      //   leadingLetters.add(token[0]);
      // }
      letters.addAll(token.split(''));
      leadingLetters.add(token[0]); // Alle führenden Buchstaben speichern

    }
  }

  // Prüfen, ob zu viele Buchstaben vorhanden sind (maximal 10)
  if (letters.length > 10) {
    print("Zu viele verschiedene Buchstaben, um eine Lösung zu finden.");
    return null;
  }

  // Liste der Buchstaben
  var letterList = letters.toList();

  // Berechnung der Anzahl der möglichen Permutationen
  var totalPermutations = _factorial(10) ~/ _factorial(10 - letterList.length);
  print("Gesamtanzahl der Permutationen: $totalPermutations");

  // Generiere Permutationen und evaluiere jede Kombination
  return _permuteAndEvaluate(letterList, formula.formula, leadingLetters, totalPermutations);
}

// Funktion zum Berechnen der Fakultät
int _factorial(int n) {
  if (n <= 1) return 1;
  return n * _factorial(n - 1);
}

// Funktion zum Generieren von Permutationen und gleichzeitiger Auswertung
HashMap<String, int>? _permuteAndEvaluate(List<String> letters, String formula, Set<String> leadingLetters, int totalPermutations) {
  var availableDigits = List.generate(10, (i) => i);
  var allPermutations = _generatePermutations(letters.length, availableDigits);
  int count = 0;
  int stepSize  = max(totalPermutations ~/ 100, 1);

  for (var perm in allPermutations) {
    count++;

    // progress bar
    if (count % stepSize == 0) {
      var progress = (count / totalPermutations * 100).toStringAsFixed(2);
      // print("Fortschritt: $progress%");
    }

    var mapping = HashMap<String, int>();
    for (var i = 0; i < letters.length; i++) {
      mapping[letters[i]] = perm[i];
    }

    // Ausschließen von Permutationen mit führenden Nullen
    if (leadingLetters.any((letter) => mapping[letter] == 0)) {
      continue;
    }

    // Check if this permutation solves the formula
    if (evaluateFormula(formula, mapping)) {
      print("Lösung gefunden: $formula $mapping");
      return mapping;
    }
  }

  // Falls keine Lösung gefunden wird
  print("Keine Lösung gefunden. $formula");
  return null;
}

// Funktion zur Generierung aller Permutationen
Iterable<List<int>> _generatePermutations(int length, List<int> availableDigits) sync* {
  if (length == 0) {
    yield [];
  } else {
    for (var i = 0; i < availableDigits.length; i++) {
      var digit = availableDigits[i];
      var remainingDigits = List.of(availableDigits)..removeAt(i);

      for (var perm in _generatePermutations(length - 1, remainingDigits)) {
        yield [digit, ...perm];
      }
    }
  }
}

String modifiedFormula(String formula, Map<String, int> mapping) {
  for (var entry in mapping.entries) {
    formula = formula.replaceAll(entry.key, entry.value.toString());
  }

  return formula;
}

// Funktion zur Auswertung der Formel
bool evaluateFormula(String formula, Map<String, int> mapping) {
  // Replacing the letters with their corresponding digits in the formula
  // var modifiedFormula = formula.split('').map((char) {
  //   if (RegExp(r'[A-Z]').hasMatch(char)) {
  //     return mapping[char].toString();
  //   }
  //   return char;
  // }).join('');
  // var modifiedFormula = RegExp(r'[A-Z]').allMatches(formula).map((char) {
  //   if (RegExp(r'[A-Z]').hasMatch(char)) {
  //     return mapping[char].toString();
  //   }
  //   return char;
  // }).join('');
  // var modifiedFormula = formula.split('').map((char) {
  //   for (var key in result.keys) {
  //     equation = equation.replaceAll(key, result[key].toString());
  //   }
  //
  //   return equation;
  // }).join('');

  // Split expression into left and right side
  // var sides = modifiedFormula.split('=');
  var sides = modifiedFormula(formula, mapping).split('=');
  if (sides.length != 2) return false;

  try {
    // Auswerten beider Seiten des Ausdrucks
    var leftValue = eval(sides[0]);
    var rightValue = eval(sides[1]);

    // Check if the left and right sides are equal
    return leftValue == rightValue;
  } catch (e) {
    return false;
  }
}
Parser parser = Parser();
ContextModel cm = ContextModel();

// function for evaluating the mathematical expression
num eval(String expression) {
  Expression exp = parser.parse(expression);

  var result = exp.evaluate(EvaluationType.REAL, cm);
  return result != null && result is num ? result : double.negativeInfinity;
}


void main() {
  var startTime = DateTime.now();
  // Beispiel: SEND + MORE = MONEY
  solveAlphametic(Formula("SEND+MORE=MONEY"));
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: ELEVEN + NINE + FIVE + FIVE = THIRTY
  solveAlphametic(Formula("ELEVEN+NINE+FIVE+FIVE=THIRTY"));
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: ENIGMA / M = TIMES
  solveAlphametic(Formula("ENIGMA/M=TIMES"));
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: "BASE + BALL = GAMES
  solveAlphametic(Formula("BASE + BALL = GAMES"));
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: THIS + A + FIRE... (langes Beispiel)
  solveAlphametic(Formula(
      "THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES"));
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  // Lösung gefunden: {S: 2, O: 3, N: 1, Y: 5, E: 8, M: 0, D: 7, R: 6}
  // 3890ms
  // Lösung gefunden: {F: 4, T: 8, N: 5, Y: 6, E: 7, V: 2, H: 1, R: 3, I: 0, L: 9}
  // 40694ms
  // Lösung gefunden: {S: 3, A: 6, T: 9, N: 8, E: 1, M: 2, I: 0, G: 4}
  // 1557ms

  // Lösung gefunden: {S: 2, O: 3, N: 1, Y: 5, E: 8, M: 0, D: 7, R: 6}
  // 2592ms
  // Lösung gefunden: {F: 4, T: 8, N: 5, Y: 6, E: 7, V: 2, H: 1, R: 3, I: 0, L: 9}
  // 29443ms
  // Lösung gefunden: {S: 3, A: 6, T: 9, N: 8, E: 1, M: 2, I: 0, G: 4}
  // 1006ms
  // Lösung gefunden: {A: 4, S: 6, B: 2, E: 1, M: 9, G: 0, L: 5}
  // 691ms

  // Gesamtanzahl der Permutationen: 1814400
  // Lösung gefunden: SEND+MORE=MONEY {S: 2, O: 3, N: 1, Y: 5, E: 8, M: 0, D: 7, R: 6}
  // 2153ms
  // Gesamtanzahl der Permutationen: 3628800
  // Lösung gefunden: ELEVEN+NINE+FIVE+FIVE=THIRTY {F: 4, T: 8, N: 5, Y: 6, E: 7, V: 2, H: 1, R: 3, I: 0, L: 9}
  // 24060ms
  // Gesamtanzahl der Permutationen: 1814400
  // Lösung gefunden: ENIGMA/M=TIMES {S: 3, A: 6, T: 9, N: 8, E: 1, M: 2, I: 0, G: 4}
  // 871ms
  // Gesamtanzahl der Permutationen: 604800
  // Lösung gefunden: BASE + BALL = GAMES {A: 4, S: 6, B: 2, E: 1, M: 9, G: 0, L: 5}
  // 553ms
}
