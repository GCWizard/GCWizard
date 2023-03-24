enum HoudiniMode { NUMBERS, LETTERS }

const Map<String, String> _KEYWORDS_NUMBERS = {
  '1': 'PRAY',
  '2': 'ANSWER',
  '3': 'SAY',
  '4': 'NOW',
  '5': 'TELL',
  '6': 'PLEASE',
  '7': 'SPEAK',
  '8': 'QUICKLY',
  '9': 'LOOK',
  '0': 'BEQUICK'
};
const Map<String, String> _KEYWORDS_LETTERS = {
  'A': 'PRAY',
  'B': 'ANSWER',
  'C': 'SAY',
  'D': 'NOW',
  'E': 'TELL',
  'F': 'PLEASE',
  'G': 'SPEAK',
  'H': 'QUICKLY',
  'I': 'LOOK',
  'J': 'BEQUICK'
};

Map<int, String>? decodeHoudini(String input, HoudiniMode mode) {
  if (input.isEmpty) return null;

  Map<String, String> replaceMap;
  if (mode == HoudiniMode.LETTERS) {
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

  if (mode == HoudiniMode.NUMBERS) return {0: output0, 10: output10};

  return {0: output0};
}

Map<int, String> _encodeHoudiniNumbers(String input) {
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

Map<int, String> _encodeHoudiniLetters(String input) {
  var output = input.toUpperCase().replaceAllMapped(RegExp(r'[A-J]'), (match) {
    return _KEYWORDS_LETTERS[match.group(0)]! + ' ';
  });

  output = output.trim().replaceAll('BEQUICK', 'BE QUICK');

  return {0: output};
}

Map<int, String>? encodeHoudini(String input, HoudiniMode mode) {
  if (input.isEmpty) return null;

  if (mode == HoudiniMode.LETTERS) {
    return _encodeHoudiniLetters(input);
  } else {
    return _encodeHoudiniNumbers(input);
  }
}
