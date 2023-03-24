const _NumbersMap = {'0': 1, '6': 1, '8': 2, '9': 1};

const Map<String, int> _LettersMap = {
  'A': 1, 'B': 2, 'D': 1, 'O': 1, 'P': 1, 'Q': 1, 'R': 1,
  '\u00C4': 1, //Ä
  '\u00C1': 1, //Á
  '\u00C0': 1, //À
  '\u0104': 1, //Ą
  '\u00C5': 2, //Å
  '\u00C2': 1, //Â
  '\u00C3': 1, //Ã
  '\u00C6': 1, //Æ
  '\u0102': 1, //Ă
  '\u010E': 1, //Ď
  '\u00D0': 1, //Ð
  '\u00D6': 1, //Ö
  '\u00D3': 1, //Ó
  '\u00D4': 1, //Ô
  '\u00D2': 1, //Ò
  '\u00D5': 1, //Õ
  '\u00D8': 2, //Ø
  '\u0154': 1, //Ŕ
  '\u0158': 1, //Ř
  '\u016E': 1, //Ů
  '\u00DE': 1, //Þ

  'a': 1, 'b': 1, 'd': 1, 'e': 1,
  'g': 1, // in most cases, g has only one hole, in some fonts the lower part is closed as well...
  'o': 1, 'p': 1, 'q': 1,
  '\u00E4': 1, //ä
  '\u00E1': 1, //á
  '\u0105': 1, //ą
  '\u00E2': 1, //â
  '\u00E5': 2, //å
  '\u00E0': 1, //à
  '\u00E3': 1, //ã
  '\u0103': 1, //ă
  '\u00E6': 2, //æ
  '\u00F0': 1, //ð
  '\u010F': 1, //ď
  '\u0111': 1, //đ
  '\u00EA': 1, //ê
  '\u0119': 1, //ę
  '\u00E9': 1, //é
  '\u00EB': 1, //ë
  '\u00E8': 1, //è
  '\u00F6': 1, //ö
  '\u00F3': 1, //ó
  '\u00F4': 1, //ô
  '\u00F2': 1, //ò
  '\u00F5': 1, //õ
  '\u00F8': 2, //ø
  '\u016F': 1, //ů
  '\u00FE': 1, //þ
};
const Map<String, int> _SpecialCharsMap = {
  '%': 2,
  '&': 2,
  '#': 1,
  '°': 1,
  '§': 1,
  '@': 1,
  '\u00A4': 0, //¤
  '\u00BA': 0, //º
};
const _With4 = {'4': 1};

Map<String, int> _createAlpabetMap(bool with4, bool onlyNumbers) {
  var alphabetMap = <String, int>{};

  alphabetMap.addAll(_NumbersMap);
  if (with4) alphabetMap.addAll(_With4);
  if (!onlyNumbers) alphabetMap.addAll(_LettersMap);
  if (!onlyNumbers) alphabetMap.addAll(_SpecialCharsMap);

  return alphabetMap;
}

String decodeEnclosedAreas(String input, {bool with4 = false, bool onlyNumbers = false}) {
  if (input.isEmpty) return '';

  var alphabetMap = _createAlpabetMap(with4, onlyNumbers);

  return input
      .split(RegExp(onlyNumbers ? r'\D+' : r'\s+'))
      .where((block) => block.isNotEmpty)
      .map((block) => _decodeEnclosedAreaBlock(block, alphabetMap))
      .join(' ');
}

int _decodeEnclosedAreaBlock(String input, Map<String, int> alphabetMap) {
  var output = 0;

  input.split('').forEach((character) {
    if (alphabetMap.containsKey(character)) output += alphabetMap[character]!;
  });

  return output;
}
