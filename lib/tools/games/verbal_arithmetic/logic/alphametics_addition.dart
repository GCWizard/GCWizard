part of 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametic.dart';

class EquationData {
  late List<String> leftSide;
  late List<String> rightSide;

  late Set<String> leadingLetters;
}

VerbalArithmeticOutput? _solveAlphameticAdd(Equation equation) {
  var equationData = EquationData();
  var sides = equation.formatedEquation.split('=');
  equationData.leftSide = sides[0].split('+').map((s) => s.trim()).toList();
  equationData.rightSide = sides[1].split('+').map((s) => s.trim()).toList();
  equationData.leadingLetters = equation.leadingLetters;

  Map<String, int> frequencyMap = _letterFrequency([...equationData.leftSide, ...equationData.rightSide]);
  List<String> letters = equation.usedMembers.toList()
    ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

  List<int> digits = List.generate(10, (i) => i);
  var mapping = HashMap<String, int>();
  Set<int> usedDigits = {};

  _solutions.clear();

  __solveAlphametics(equationData, letters, digits, mapping, usedDigits);
  // for (var solution in solutions) {
      var out = equation.getOutput(_solutions.first);
      var _equation = equation.formatedEquation;
      print('Lösung gefunden: $_equation. $out'); //$mapping
  // }
  print('Lösung gefunden: ' + _solutions.length.toString());
  if (_solutions.isEmpty) {
    var _equation = equation.formatedEquation;
    print("Keine Lösung gefunden. $_equation");
  }
  return VerbalArithmeticOutput(equations: [equation], solutions: _solutions, error: '');
}

List<HashMap<String, int>> _solutions = [];

bool __solveAlphametics(EquationData equationData, List<String> letters, List<int> digits,
    Map<String, int> letterToDigit, Set<int> usedDigits) {
  if (letters.isEmpty) {
    return _isValid(letterToDigit, equationData);
  }

  String currentLetter = letters.first;
  letters.removeAt(0);

  for (var digit in digits) {
    if (usedDigits.contains(digit)) continue;

    // Avoid leading zeros.
    if (digit == 0 && !_allowLeadingZeros) {
      if (equationData.leadingLetters.contains(currentLetter)) {
        continue;
      }
    }
    _currentCombination++;
    _sendProgress();

    letterToDigit[currentLetter] = digit;
    usedDigits.add(digit);

    if (__solveAlphametics(equationData, letters, digits, letterToDigit, usedDigits)) {
      _solutions.add(HashMap<String, int>.from(letterToDigit));
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }

    letterToDigit.remove(currentLetter);
    usedDigits.remove(digit);
  }

  letters.insert(0, currentLetter);
  return false;
}

/// calculate the frequency of each letter in the equation.
Map<String, int> _letterFrequency(List<String> words) {
  Map<String, int> frequency = {};
  for (var word in words) {
    for (var letter in word.split('')) {
      frequency[letter] = (frequency[letter] ?? 0) + 1;
    }
  }
  return frequency;
}

/// check whether a digit assignment is correct.
bool _isValid(Map<String, int> letterToDigit, EquationData equationData) {
  int sum = 0;

  for (var word in equationData.leftSide) {
    int wordValue = 0;
    for (var letter in word.split('')) {
      wordValue = wordValue * 10 + (letterToDigit[letter] ?? 0);
    }
    sum += wordValue;
  }

  int resultValue = 0;
  for (var word in equationData.rightSide) {
    int wordValue = 0;
    for (var letter in word.split('')) {
      wordValue = wordValue * 10 + (letterToDigit[letter] ?? 0);
    }
    resultValue += wordValue;
  }

  return sum == resultValue;
}

// void main() {
//   var startTime = DateTime.now();
//   // Beispiel: SEND + MORE = MONEY
//   solveAlphameticAdd("SEND+MORE=MONEY");
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
//   startTime = DateTime.now();
//   // Beispiel: ELEVEN + NINE + FIVE + FIVE = THIRTY
//   solveAlphameticAdd("ELEVEN+NINE+FIVE+FIVE=THIRTY");
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
//   startTime = DateTime.now();
//   // Beispiel: ENIGMA / M = TIMES
//   solveAlphameticAdd("ENIGMA/M=TIMES");
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
//   startTime = DateTime.now();
//   // Beispiel: "BASE + BALL = GAMES
//   solveAlphameticAdd("BASE + BALL = GAMES");
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
//   startTime = DateTime.now();
//   // Beispiel: THIS + A + FIRE... (langes Beispiel)
//   solveAlphameticAdd(
//       "THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES");
//   print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
//
//   // Lösung gefunden: SEND+MORE=MONEY {E: 5, O: 0, N: 6, M: 1, S: 9, Y: 2, D: 7, R: 8}
//   // 427ms
//   // Lösung gefunden: ELEVEN+NINE+FIVE+FIVE=THIRTY {E: 7, I: 0, N: 5, V: 2, F: 4, T: 8, Y: 6, H: 1, R: 3, L: 9}
//   // 1240ms
//   // Keine Lösung gefunden.
//   // 1339ms
//   // Lösung gefunden: BASE + BALL = GAMES {A: 4, S: 8, B: 7, E: 3, L: 5, M: 9, G: 1}
//   // 93ms
//   // Lösung gefunden: THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES {E: 0, T: 9, S: 4, R: 3, H: 8, A: 1, F: 5, O: 6, L: 2, I: 7}
//   // 4407ms
//
//   // Lösung gefunden: SEND+MORE=MONEY {E: 5, O: 0, N: 6, M: 1, S: 9, Y: 2, D: 7, R: 8}
//   // 418ms
//   // Lösung gefunden: ELEVEN+NINE+FIVE+FIVE=THIRTY {E: 7, I: 0, N: 5, V: 2, F: 4, T: 8, Y: 6, H: 1, R: 3, L: 9}
//   // 1284ms
//   // Keine Lösung gefunden. ENIGMA/M=TIMES
//   // 1345ms
//   // Lösung gefunden: BASE + BALL = GAMES {A: 4, S: 8, B: 7, E: 3, L: 5, M: 9, G: 1}
//   // 112ms
//   // Lösung gefunden: THIS+A+FIRE+THEREFORE+FOR+ALL+HISTORIES+I+TELL+A+TALE+THAT+FALSIFIES+ITS+TITLE+TIS+A+LIE+THE+TALE+OF+THE+LAST+FIRE+HORSES+LATE+AFTER+THE+FIRST+FATHERS+FORESEE+THE+HORRORS+THE+LAST+FREE+TROLL+TERRIFIES+THE+HORSES+OF+FIRE+THE+TROLL+RESTS+AT+THE+HOLE+OF+LOSSES+IT+IS+THERE+THAT+SHE+STORES+ROLES+OF+LEATHERS+AFTER+SHE+SATISFIES+HER+HATE+OFF+THOSE+FEARS+A+TASTE+RISES+AS+SHE+HEARS+THE+LEAST+FAR+HORSE+THOSE+FAST+HORSES+THAT+FIRST+HEAR+THE+TROLL+FLEE+OFF+TO+THE+FOREST+THE+HORSES+THAT+ALERTS+RAISE+THE+STARES+OF+THE+OTHERS+AS+THE+TROLL+ASSAILS+AT+THE+TOTAL+SHIFT+HER+TEETH+TEAR+HOOF+OFF+TORSO+AS+THE+LAST+HORSE+FORFEITS+ITS+LIFE+THE+FIRST+FATHERS+HEAR+OF+THE+HORRORS+THEIR+FEARS+THAT+THE+FIRES+FOR+THEIR+FEASTS+ARREST+AS+THE+FIRST+FATHERS+RESETTLE+THE+LAST+OF+THE+FIRE+HORSES+THE+LAST+TROLL+HARASSES+THE+FOREST+HEART+FREE+AT+LAST+OF+THE+LAST+TROLL+ALL+OFFER+THEIR+FIRE+HEAT+TO+THE+ASSISTERS+FAR+OFF+THE+TROLL+FASTS+ITS+LIFE+SHORTER+AS+STARS+RISE+THE+HORSES+REST+SAFE+AFTER+ALL+SHARE+HOT+FISH+AS+THEIR+AFFILIATES+TAILOR+A+ROOFS+FOR+THEIR+SAFE=FORTRESSES {E: 0, T: 9, S: 4, R: 3, H: 8, A: 1, F: 5, O: 6, L: 2, I: 7}
//   // 4589ms
// }
