import 'dart:collection';
import 'package:math_expressions/math_expressions.dart';

// Funktion, die Alphametic-Rätsel löst
void solveAlphametic(String formula) {
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

  // Liste der Buchstaben
  var letterList = letters.toList();

  // Erstellen der Permutationen und Auswertung
  _permuteAndEvaluate(letterList, formula, leadingLetters);
}

// Funktion, die rekursiv Permutationen erstellt und jede direkt auswertet
void _permuteAndEvaluate(List<String> letters, String formula, Set<String> leadingLetters, [List<int>? prefix, List<int>? availableDigits]) {
  prefix ??= [];
  availableDigits ??= List.generate(10, (i) => i); // Liste von 0-9

  // Wenn wir eine vollständige Permutation haben, evaluieren wir sie
  if (prefix.length == letters.length) {
    var mapping = HashMap<String, int>();
    for (var i = 0; i < letters.length; i++) {
      mapping[letters[i]] = prefix[i];
    }

    // Prüfen, ob diese Permutation die Formel löst
    if (evaluateFormula(formula, mapping)) {
      print("Lösung gefunden: $mapping");
      return;
    }
  } else {
    // Rekursives Erstellen der Permutationen
    for (var i = 0; i < availableDigits.length; i++) {
      var newPrefix = [...prefix, availableDigits[i]];
      var newAvailableDigits = List.of(availableDigits)..removeAt(i);
      _permuteAndEvaluate(letters, formula, leadingLetters, newPrefix, newAvailableDigits);
    }
  }
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

// Funktion zur Evaluierung eines mathematischen Ausdrucks (mit math_expressions)
num eval(String expression) {
  Parser parser = Parser();
  Expression exp = parser.parse(expression);
  ContextModel cm = ContextModel();

  // Angepasster Ausdruck für die Evaluierung, wie von dir vorgeschlagen
  var result = exp.evaluate(EvaluationType.REAL, cm);
  return result != null && result is num ? result : double.negativeInfinity;
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
}
