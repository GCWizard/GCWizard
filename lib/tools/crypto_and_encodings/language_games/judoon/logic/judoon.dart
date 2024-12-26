import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
/*
 * Doctor Who Alien language
 * Every letter gets a special
 * More information you'll find here: http://www.judoon.com
 *
 */

const Map<String, String> alphabetJudoon  = {
  'a': 'blo', 'b': 'bo', 'c': 'co', 'd': 'do', 'e': 'flo',
  'f': 'fo', 'g': 'go', 'h': 'ho', 'i': 'kro', 'j': 'jo',
  'k': 'kno', 'l': 'lo', 'm': 'mo', 'n': 'no', 'o': 'plo',
  'p': 'po', 'q': 'qwo', 'r': 'ro', 's': 'so', 't': 'to',
  'u': 'tro', 'v': 'vo', 'w': 'wo', 'x': 'xo', 'y': 'yo',
  'z': 'zo',
  ' ': 'sho', '_': 'œ', '!': 'sco', '?': 'spo', '.': 'bla',
  '"': 'cho', '(': 'pra', ')': 'pla', '\\': 'gra',
  '0': 'za', '1': 'ha', '2': 'ta', '3': 'tra', '4': 'fa',
  '5': 'fla', '6': 'sa', '7': 'schla', '8': 'ga', '9': 'na',
};

String encryptJudoon(String input) {
  if (input.isEmpty) return "";

  input = input.trim();
  return input
      .split('')
      .map((char) => alphabetJudoon[char.toLowerCase()] ?? UNKNOWN_ELEMENT)
      .join(' ');
}

String decryptJudoon(String input) {
  if (input.isEmpty) return "";

  input = input.trim();
  final invertedDict = switchMapKeyValue(alphabetJudoon);

  return input
      .split(' ')
      .map((word) => invertedDict[word.toLowerCase()] ?? UNKNOWN_ELEMENT)
      .join('');
}
