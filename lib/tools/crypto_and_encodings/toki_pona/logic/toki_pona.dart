import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

enum TokiPonaMode { NUMBERS, LETTERS, DIGITS }

const Map<String, String> _KEYWORDS_NUMBERS = {
  '0': 'ala',
  '1': 'wan',
  '2': 'tu',
  '5': 'luka',
  '20': 'mute',
  '100': 'ale',
};
const Map<String, String> _KEYWORDS_DIGITS = {
  '0': 'ala',
  '1': 'wan',
  '2': 'tu',
  '3': 'tu wan',
  '4': 'tu tu',
  '5': 'luka',
  '6': 'luka wan',
  '7': 'luka tu',
  '8': 'luka tu wan',
  '9': 'luka tu tu',
};
const Map<String, String> _KEYWORDS_LETTERS = {
  'a': 'akesi',
  'e': 'esun',
  'i': 'ilo',
  'j': 'jan',
  'k': 'kala',
  'l': 'luka',
  'm': 'mani',
  'n': 'nena',
  'o': 'oko',
  'p': 'pipi',
  's': 'suno',
  't': 'tomo',
  'u': 'uta',
  'w': 'waso',
};

String decodeTokiPona(String input, TokiPonaMode mode) {
  if (input.isEmpty) return '';

  Map<String, String> replaceMap = switchMapKeyValue(_KEYWORDS_LETTERS)
    ..addAll(switchMapKeyValue(_KEYWORDS_NUMBERS));

  return substitution(input, replaceMap);
}

String _NumberToTokiPona(String number){
  if (number == '0') return 'ala';

  List<String> result = [];

  int intNumber = int.parse(number);
  while (intNumber >= 100) {
    result.add('ale');
    intNumber = intNumber - 100;
  }
  while (intNumber >= 20) {
    result.add('mute');
    intNumber = intNumber - 20;
  }
  while (intNumber >= 5) {
    result.add('luka');
    intNumber = intNumber - 5;
  }
  while (intNumber >= 2) {
    result.add('tu');
    intNumber = intNumber - 2;
  }
  while (intNumber >= 1) {
    result.add('wan');
    intNumber = intNumber - 1;
  }
  return result.join(' ');
}

String _encodeTokiPonaNumbers(String input) {
  List<String> output = [];

  input.split(' ').forEach((number) {
    if (int.tryParse(number) == null) {
      output.add(number);
    } else {
      output.add(_NumberToTokiPona(number));
    }
  });

  return output.join(' ');
}

String _encodeTokiPonaLetters(String input) {
  var output = input.toLowerCase().replaceAllMapped(RegExp(r'[aeijklmnopstuw]'),
      (match) {
    return _KEYWORDS_LETTERS[match.group(0)]! + ' ';
  });

  output = output.trim();

  return output;
}

String _encodeTokiPonaDigits(String input) {
  var output = input.toLowerCase().replaceAllMapped(RegExp(r'[0-9]'), (match) {
    return _KEYWORDS_DIGITS[match.group(0)]! + ' ';
  });

  output = output.trim();

  return output;
}

String encodeTokiPona(String input, TokiPonaMode mode) {
  if (input.isEmpty) return '';

  switch (mode) {
    case TokiPonaMode.LETTERS:
      return _encodeTokiPonaLetters(input);
    case TokiPonaMode.NUMBERS:
      return _encodeTokiPonaNumbers(input);
    case TokiPonaMode.DIGITS:
      return _encodeTokiPonaDigits(input);
  }
}
