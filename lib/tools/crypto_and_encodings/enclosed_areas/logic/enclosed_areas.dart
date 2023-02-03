final _NumbersMap = {'0': 1, '6': 1, '8': 2, '9': 1};

final _LettersMap = {
  'A': 1, 'B': 2, 'D': 1, 'O': 1, 'P': 1, 'Q': 1, 'R': 1,
  String.fromCharCode(196): 1, //Ä
  String.fromCharCode(193): 1, //Á
  String.fromCharCode(192): 1, //À
  String.fromCharCode(260): 1, //Ą
  String.fromCharCode(197): 2, //Å
  String.fromCharCode(194): 1, //Â
  String.fromCharCode(195): 1, //Ã
  String.fromCharCode(198): 1, //Æ
  String.fromCharCode(258): 1, //Ă
  String.fromCharCode(270): 1, //Ď
  String.fromCharCode(208): 1, //Ð
  String.fromCharCode(214): 1, //Ö
  String.fromCharCode(211): 1, //Ó
  String.fromCharCode(212): 1, //Ô
  String.fromCharCode(210): 1, //Ò
  String.fromCharCode(213): 1, //Õ
  String.fromCharCode(216): 2, //Ø
  String.fromCharCode(340): 1, //Ŕ
  String.fromCharCode(344): 1, //Ř
  String.fromCharCode(366): 1, //Ů
  String.fromCharCode(222): 1, //Þ

  'a': 1, 'b': 1, 'd': 1, 'e': 1,
  'g': 1, // in most cases, g has only one hole, in some fonts the lower part is closed as well...
  'o': 1, 'p': 1, 'q': 1,
  String.fromCharCode(228): 1, //ä
  String.fromCharCode(225): 1, //á
  String.fromCharCode(261): 1, //ą
  String.fromCharCode(226): 1, //â
  String.fromCharCode(229): 2, //å
  String.fromCharCode(224): 1, //à
  String.fromCharCode(227): 1, //ã
  String.fromCharCode(259): 1, //ă
  String.fromCharCode(230): 2, //æ
  String.fromCharCode(240): 1, //ð
  String.fromCharCode(271): 1, //ď
  String.fromCharCode(273): 1, //đ
  String.fromCharCode(234): 1, //ê
  String.fromCharCode(281): 1, //ę
  String.fromCharCode(233): 1, //é
  String.fromCharCode(235): 1, //ë
  String.fromCharCode(232): 1, //è
  String.fromCharCode(246): 1, //ö
  String.fromCharCode(243): 1, //ó
  String.fromCharCode(244): 1, //ô
  String.fromCharCode(242): 1, //ò
  String.fromCharCode(245): 1, //õ
  String.fromCharCode(248): 2, //ø
  String.fromCharCode(367): 1, //ů
  String.fromCharCode(254): 1, //þ
};
final _SpecialCharsMap = {
  '%': 2,
  '&': 2,
  '#': 1,
  '°': 1,
  '§': 1,
  '@': 1,
  String.fromCharCode(164): 0, //¤
  String.fromCharCode(186): 0, //º
};
final _With4 = {'4': 1};

Map<String, int> _createAlpabetMap(bool with4, bool onlyNumbers) {
  var alphabetMap = new Map<String, int>();

  alphabetMap.addAll(_NumbersMap);
  if (with4) alphabetMap.addAll(_With4);
  if (!onlyNumbers) alphabetMap.addAll(_LettersMap);
  if (!onlyNumbers) alphabetMap.addAll(_SpecialCharsMap);

  return alphabetMap;
}

String decodeEnclosedAreas(String input, {bool with4, onlyNumbers: false}) {
  if (input == null || input == '') return '';

  var alphabetMap = _createAlpabetMap(with4, onlyNumbers);

  return input
      .split(RegExp(onlyNumbers ? r'[^0-9]+' : r'\s+'))
      .where((block) => block != null && block.length > 0)
      .map((block) => _decodeEnclosedAreaBlock(block, alphabetMap))
      .join(' ');
}

int _decodeEnclosedAreaBlock(String input, Map<String, int> alphabetMap) {
  var output = 0;

  input.split('').forEach((character) {
    if (alphabetMap.containsKey(character)) output += alphabetMap[character];
  });

  return output;
}
