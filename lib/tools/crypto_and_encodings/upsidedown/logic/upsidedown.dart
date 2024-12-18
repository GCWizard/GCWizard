// https://de.wikipedia.org/wiki/Upside_Down_Text
// https://en.wikipedia.org/wiki/Transformation_of_text#Upside-down_text

import 'package:gc_wizard/utils/collection_utils.dart';

const Map<String, String> ENCODE_FLIP_ROTATE = {
  '0': '0',
  '1': '⇂',
  //'2': '↊',
  '2': 'ζ', // u+03B6
  //'3': '↋',
  '3': 'Ɛ',
  '4': '߈',
  '5': 'ဌ',
  //'5': '\u20C0',
  '6': '9',
  //'7': '𝘓',
  '7': 'L',
  '8': '8',
  '9': '6',
  'a': 'ɐ',
  'b': 'q',
  'c': 'ɔ',
  'd': 'p',
  'e': 'ǝ',
  'f': 'ɟ',
  'g': 'ᵷ',
  'h': 'ɥ',
  'i': '!',
  'j': 'ſ̣',
  'k': 'ʞ',
  'l': 'l',
  'm': 'ɯ',
  'n': 'u',
  'o': 'o',
  'p': 'd',
  'q': 'b',
  'r': 'ɹ',
  's': 's',
  't': 'ʇ',
  'u': 'n',
  'v': 'ʌ',
  'w': 'ʍ',
  'x': 'x',
  'y': 'ʎ',
  'z': 'z',
  'A': 'Ɐ',
  'B': 'ꓭ',
  'C': 'Ɔ',
  'D': 'ꓷ',
  'E': 'E',
  'F': 'Ⅎ',
  'G': '⅁',
  'H': 'H',
  'I': 'I',
  'J': 'ꓩ',
  'K': 'ꓘ',
  'L': '⅂',
  'M': 'ꟽ',
  'N': 'N',
  'O': 'O',
  'P': 'Ԁ',
  'Q': 'Ꝺ',
  'R': 'ꓤ',
  'S': 'S',
  'T': 'Ʇ',
  'U': 'Ո',
  'V': 'Ʌ',
  'W': 'M',
  'X': 'X',
  'Y': '⅄',
  'Z': 'Z',
  ' ': ' ',
  '.': '˙',
  ':': ':',
  ',': "'",
  '-': '-',
  '_': '‾',
  '+': '+',
  '*': '*',
  '#': '#',
  '~': '~',
  '?': '¿',
  '!': '¡',
  '/': '\\',
  '\\': '/',
  '[': ']',
  ']': '[',
  '(': ')',
  ')': '(',
  '=': '=',
  '"': '„',
  '&': '⅋',
  '>': '<',
  '<': '>',
  '«': '»',
  '»': '«',
};
Map<String, String> DECODE_FLIP_ROTATE = switchMapKeyValue(ENCODE_FLIP_ROTATE);

String decodeUpsideDownText(String input) {
  String result = '';
  input = input.replaceAll('ſ̣', 'j').split('').reversed.join('');

  for (int i = 0; i < input.length; i++) {
    if (DECODE_FLIP_ROTATE[input[i]].toString() != 'null') {
      result = result + DECODE_FLIP_ROTATE[input[i]].toString();
    } else {
      result = result + input[i];
    }
  }

  return result;
}

String encodeUpsideDownText(String input) {
  String result = '';
  input = input.split('').reversed.join('');

  for (int i = 0; i < input.length; i++) {
    if (ENCODE_FLIP_ROTATE[input[i]] != null) {
      result = result + ENCODE_FLIP_ROTATE[input[i]]!;
    } else {
      result = result + input[i];
    }
  }

  return result;
}
