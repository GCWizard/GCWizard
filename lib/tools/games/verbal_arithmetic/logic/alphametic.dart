import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/helper.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:math_expressions/math_expressions.dart';

part 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametics_addition.dart';

Future<VerbalArithmeticOutput?> solveAlphameticsAsync(GCWAsyncExecuterParameters jobData) async {
  if (jobData.parameters is! VerbalArithmeticJobData) {
    return null;
  }
  var data = jobData.parameters as VerbalArithmeticJobData;
  var output = solveAlphametic(data.equations.first, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort!.send(output);

  return output;
}

VerbalArithmeticOutput? solveAlphametic(String equation, {SendPort? sendAsyncPort}) {
  var _equation = Equation(equation, singleLetter: true);
  if (!_equation.validFormula) {
    return VerbalArithmeticOutput(equations: [_equation], solutions: null, error: 'InvalidFormula');
  }

  // Check if there are too many letters (maximum 10)
  if (_equation.usedMembers.length > 10) {
    return VerbalArithmeticOutput(equations: [], solutions: null, error: 'TooManyLetters');
  }

  if (_equation.onlyAddition) {
    return _solveAlphameticAdd(_equation, sendAsyncPort: sendAsyncPort);
  } else {
    return _solveAlphametic(_equation, sendAsyncPort: sendAsyncPort);
  }
}

// Funktion, die Alphametic-Rätsel löst
VerbalArithmeticOutput? _solveAlphametic(Equation equation, {SendPort? sendAsyncPort}) {

  var letterList = equation.usedMembers.toList();

  // Generate permutations and evaluate each combination
  var result = _permuteAndEvaluate(letterList, equation.equation, equation.leadingLetters, sendAsyncPort);

  return VerbalArithmeticOutput(equations: [equation], solutions: result, error: '');
}


// Funktion zum Generieren von Permutationen und gleichzeitiger Auswertung
HashMap<String, int>? _permuteAndEvaluate(List<String> letters, String formula, Set<String> leadingLetters,
     SendPort? sendAsyncPort) {
  var availableDigits = List.generate(10, (i) => i);
  var allPermutations = _generatePermutations(letters.length, availableDigits);

  // Calculating the number of possible permutations
  int totalPermutations = factorial(10) ~/ factorial(10 - letters.length);
  int count = 0;
  int stepSize  = max(totalPermutations ~/ 100, 1);

  for (var perm in allPermutations) {
    // progress bar
    count++;
    if (sendAsyncPort != null && count % stepSize == 0) {
      sendAsyncPort.send(DoubleText(PROGRESS, count / totalPermutations));
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
    if (_evaluateFormula(formula, mapping)) {
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

// Funktion zur Auswertung der Formel
bool _evaluateFormula(String equation, Map<String, int> mapping) {

  // Split expression into left and right side
  // var sides = modifiedFormula.split('=');
  var sides = Equation.replaceValues(equation, mapping).split('=');
  if (sides.length != 2) return false;

  try {
    // Auswerten beider Seiten des Ausdrucks
    var leftValue = _eval(sides[0]);
    var rightValue = _eval(sides[1]);

    // Check if the left and right sides are equal
    return leftValue == rightValue;
  } catch (e) {
    return false;
  }
}

ContextModel _cm = ContextModel();

// function for evaluating the mathematical expression
num _eval(String expression) {
  Expression exp = parser.parse(expression);

  var result = exp.evaluate(EvaluationType.REAL, _cm);
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

  startTime = DateTime.now();
  // Beispiel: "BASE + BALL = GAMES
  solveAlphametic("BASE + BALL = GAMES");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

  startTime = DateTime.now();
  // Beispiel: THIS + A + FIRE... (langes Beispiel)
  solveAlphametic(
      "THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES");
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
  // Lösung gefunden: THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES {S: 4, A: 1, F: 5, O: 6, T: 9, E: 0, H: 8, I: 7, R: 3, L: 2}
  // 95336ms

  // mit Spezial Methode für Addition
  // Lösung gefunden: SEND+MORE=MONEY. {S: 9, O: 0, N: 6, Y: 2, E: 5, M: 1, D: 7, R: 8}
  // 352ms
  // Lösung gefunden: ELEVEN+NINE+FIVE+FIVE=THIRTY. {F: 4, T: 8, N: 5, Y: 6, E: 7, V: 2, H: 1, R: 3, I: 0, L: 9}
  // 1180ms
  // Lösung gefunden: ENIGMA/M=TIMES {S: 3, A: 6, T: 9, N: 8, E: 1, M: 2, I: 0, G: 4}
  // 838ms
  // Lösung gefunden: BASE + BALL = GAMES. {S: 8, A: 4, E: 3, B: 7, M: 9, G: 1, L: 5}
  // 85ms
  // Lösung gefunden: THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES. {F: 5, A: 1, S: 4, O: 6, T: 9, E: 0, H: 8, I: 7, R: 3, L: 2}
  // 4031ms
}
