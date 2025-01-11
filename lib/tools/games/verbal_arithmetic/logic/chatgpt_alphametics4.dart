import 'dart:collection';
import 'package:math_expressions/math_expressions.dart';

import 'helper.dart';

// Funktion, die Alphametic-Rätsel löst
void solveAlphametic(String formula) {
  // Extrahieren aller Buchstaben
  var letters = <String>{};
  var leadingLetters = <String>{};

  // Extrahiere alle Buchstaben und bestimme die führenden Buchstaben
  for (var token in formula.split(RegExp(r'[^A-Z]'))) {
    if (token.isNotEmpty) {
      letters.addAll(token.split(''));
      if (leadingLetters.isEmpty || leadingLetters.length == token.length) {
        leadingLetters.add(token[0]);
      }
    }
  }

  // Prüfen, ob zu viele Buchstaben vorhanden sind (maximal 10)
  if (letters.length > 10) {
    print("Zu viele verschiedene Buchstaben, um eine Lösung zu finden.");
    return;
  }

  // Liste der Buchstaben und Berechnung aller möglichen Permutationen von Ziffern
  var letterList = letters.toList();
  var permutations = generatePermutations(List.generate(10, (i) => i), letterList.length);

  // Prüfen jeder Permutation auf Gültigkeit
  for (var permutation in permutations) {
    var mapping = HashMap<String, int>();
    for (var i = 0; i < letterList.length; i++) {
      mapping[letterList[i]] = permutation[i];
    }

    // Ausschließen von Kombinationen, bei denen führende Buchstaben die Zahl 0 sind
    if (leadingLetters.any((letter) => mapping[letter] == 0)) {
      continue;
    }

    // Prüfen, ob die Permutation die gegebene Formel erfüllt
    if (evaluateFormula(formula, mapping)) {
      print("Lösung gefunden: $formula $mapping");
      return;
    }
  }

  // Falls keine Lösung gefunden wird
  print("Keine Lösung gefunden. $formula");
}

// Funktion zur Auswertung der Formel
bool evaluateFormula(String formula, Map<String, int> mapping) {
  // Ersetzen der Buchstaben durch ihre zugeordneten Ziffern in der Formel
  var modifiedFormula = formula.split('').map((char) {
    if (RegExp(r'[A-Z]').hasMatch(char)) {
      return mapping[char].toString();
    }
    return char;
  }).join('');

  // Ausdruck in linke und rechte Seite trennen
  var sides = modifiedFormula.split('=');
  if (sides.length != 2) return false;

  try {
    // Auswerten beider Seiten des Ausdrucks
    var leftValue = eval(sides[0]);
    var rightValue = eval(sides[1]);

    // Prüfen, ob die linke und rechte Seite gleich sind
    return leftValue == rightValue;
  } catch (e) {
    return false;
  }
}

ContextModel cm = ContextModel();

// Funktion zur Evaluierung eines mathematischen Ausdrucks (mit math_expressions)
num eval(String expression) {
  // Parser parser = Parser();
  Expression exp = parser.parse(expression);

  // return exp.evaluate(EvaluationType.REAL, cm);
  var result = exp.evaluate(EvaluationType.REAL, cm);
  return result != null && result is num ? result : double.negativeInfinity;
}

// Funktion, die alle Permutationen generiert
List<List<int>> generatePermutations(List<int> elements, int length) {
  if (length == 0) return [[]];
  var perms = <List<int>>[];
  for (var i = 0; i < elements.length; i++) {
    var rest = [...elements]..removeAt(i);
    for (var perm in generatePermutations(rest, length - 1)) {
      perms.add([elements[i], ...perm]);
    }
  }
  return perms;
}

void main() {
  var startTime = DateTime.now();
  // Beispiel: SEND + MORE = MONEY
  solveAlphametic("SEND+MORE=MONEY");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: ELEVEN + NINE + FIVE + FIVE = THIRTY
  solveAlphametic("ELEVEN+NINE+FIVE+FIVE=THIRTY");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: ENIGMA / M = TIMES
  solveAlphametic("ENIGMA/M=TIMES");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  // startTime = DateTime.now();
  // // Beispiel: THIS + A + FIRE... (langes Beispiel)
  // solveAlphametic(
  //     "THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES");
  // print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: "BASE + BALL = GAMES
  solveAlphametic("BASE + BALL = GAMES");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: THIS + A + FIRE... (langes Beispiel)
  solveAlphametic("THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE = FORTRESSES");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  // Lösung gefunden: {S: 2, O: 3, N: 1, Y: 5, E: 8, M: 0, D: 7, R: 6}
  // 4667ms
  // Lösung gefunden: {F: 4, T: 8, N: 5, Y: 6, E: 7, V: 2, H: 1, R: 3, I: 0, L: 9}
  // 41975ms
  // Lösung gefunden: {S: 3, A: 6, T: 9, N: 8, E: 1, M: 2, I: 0, G: 4}
  // 2978ms

  // Lösung gefunden: {S: 2, O: 3, N: 1, Y: 5, E: 8, M: 0, D: 7, R: 6}
  // 3786ms
  // Lösung gefunden: {F: 4, T: 8, N: 5, Y: 6, E: 7, V: 2, H: 1, R: 3, I: 0, L: 9}
  // 28915ms
  // Lösung gefunden: {S: 3, A: 6, T: 9, N: 8, E: 1, M: 2, I: 0, G: 4}
  // 2334ms
}
