enum TokiPonaMode { NUMBERS, LETTERS }

const Map<String, String> _KEYWORDS_NUMBERS = {
  '0': 'ala',
  '1': 'wan',
  '2': 'tu',
  '5': 'luka',
  '20': 'mute',
  '100': 'ale',
};
const Map<String, String> _KEYWORDS_LETTERS = {
  'A': 'akesi',
  'E': 'esun',
  'I': 'ilo',
  'J': 'jan',
  'K': 'kala',
  'L': 'luka',
  'm': 'mani',
  'N': 'nena',
  'O': 'oko',
  'P': 'pipi',
  'S': 'suno',
  'T': 'tomo',
  'U': 'uta',
  'W': 'waso',
};

Map<int, String>? decodeTokiPona(String input, TokiPonaMode mode) {
  if (input.isEmpty) return null;

  Map<String, String> replaceMap;
  if (mode == TokiPonaMode.LETTERS) {
    replaceMap = _KEYWORDS_LETTERS;
  } else {
    replaceMap = _KEYWORDS_NUMBERS;
  }

  input = input.toUpperCase().replaceAll(RegExp(r'\s+'), '');

  var output0 = input;
  var output10 = input.replaceAll('BEQUICK', '1BEQUICK');

  replaceMap.forEach((key, value) {
    output0 = output0.replaceAll(value, key);
    output10 = output10.replaceAll(value, key);
  });

  if (mode == TokiPonaMode.NUMBERS) return {0: output0, 10: output10};

  return {0: output0};
}

Map<int, String> _encodeTokiPonaNumbers(String input) {
  var output0 = input;
  var output10 = input.replaceAll('10', '0');

  _KEYWORDS_NUMBERS.forEach((key, value) {
    if (value == 'BEQUICK') value = 'BE QUICK';

    output0 = output0.replaceAll(key, value + ' ');
    output10 = output10.replaceAll(key, value + ' ');
  });

  output0 = output0.trim();
  output10 = output10.trim();

  return {0: output0, 10: output10};
}

Map<int, String> _encodeTokiPonaLetters(String input) {
  var output = input.toUpperCase().replaceAllMapped(RegExp(r'[A-J]'), (match) {
    return _KEYWORDS_LETTERS[match.group(0)]! + ' ';
  });

  output = output.trim().replaceAll('BEQUICK', 'BE QUICK');

  return {0: output};
}

Map<int, String>? encodeTokiPona(String input, TokiPonaMode mode) {
  if (input.isEmpty) return null;

  if (mode == TokiPonaMode.LETTERS) {
    return _encodeTokiPonaLetters(input);
  } else {
    return _encodeTokiPonaNumbers(input);
  }
}
