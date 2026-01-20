part of 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametics.dart';

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

  var availableDigits = _availableDigits(equation.equation);
  var mapping = HashMap<String, int>();
  Set<int> usedDigits = {};

  _solutions.clear();

  __solveAlphametics(equationData, letters, availableDigits, mapping, usedDigits);
  return VerbalArithmeticOutput(equations: [equation], solutions: _solutions, error: '');
}

List<HashMap<String, int>> _solutions = [];

bool __solveAlphametics(EquationData equationData, List<String> letters, List<int> availableDigits,
    Map<String, int> mapping, Set<int> usedDigits) {
  if (letters.isEmpty) {
    if (__evaluateEquation(mapping, equationData)) {
      _solutions.add(HashMap<String, int>.from(mapping));
      return true;
    }
    return false;
  }

  String currentLetter = letters.first;
  letters.removeAt(0);

  for (var digit in availableDigits) {
    if (usedDigits.contains(digit)) continue;

    // Avoid leading zeros.
    if (digit == 0 && !_allowLeadingZeros) {
      if (equationData.leadingLetters.contains(currentLetter)) {
        continue;
      }
    }
    _currentCombination++;
    _sendProgress();

    mapping[currentLetter] = digit;
    usedDigits.add(digit);

    if (__solveAlphametics(equationData, letters, availableDigits, mapping, usedDigits)) {
      if (!_allSolutions || _solutions.length >= MAX_SOLUTIONS) return true;
    }

    mapping.remove(currentLetter);
    usedDigits.remove(digit);
  }

  letters.insert(0, currentLetter);
  return false;
}

Map<String, int> _letterFrequency(List<String> words) {
  Map<String, int> frequency = {};
  for (var word in words) {
    for (var letter in word.split('')) {
      frequency[letter] = (frequency[letter] ?? 0) + 1;
    }
  }
  return frequency;
}

bool __evaluateEquation(Map<String, int> letterToDigit, EquationData equationData) {
  int sum = 0;

  for (var word in equationData.leftSide) {
    int wordValue = 0;
    for (var letter in word.split('')) {
      wordValue = wordValue * 10 +
          (letterToDigit[letter] ?? (RegExp(r'^[0-9]+$').hasMatch(letter) ? int.parse(letter) : 0));
    }
    sum += wordValue;
  }

  int resultValue = 0;
  for (var word in equationData.rightSide) {
    int wordValue = 0;
    for (var letter in word.split('')) {
      wordValue = wordValue * 10 +
          (letterToDigit[letter] ?? (RegExp(r'^[0-9]+$').hasMatch(letter) ? int.parse(letter) : 0));
    }
    resultValue += wordValue;
  }

  return sum == resultValue;
}
