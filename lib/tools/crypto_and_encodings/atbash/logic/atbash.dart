import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> HISTORICHEBREW = {
  'A': 'T',
  'B': 'S',
  'C': '',
  'D': 'Q',
  'G': 'R',
  'H': '(Z|O)',
  'I': 'M',
  'J': 'M',
  'K': 'L',
  'L': 'K',
  'M': '(I|J)',
  'N': 'T',
  'O': 'H',
  'P': 'W',
  'Q': 'D',
  'R': 'G',
  'S': 'B',
  'T': '(A|N)',
  'W': 'P',
  'Z': 'Z',
  "'": 'Z',
};
String atbash(String input, {bool historicHebrew = false}) {
  if (input.isEmpty) return '';

  input = removeAccents(input).toUpperCase();

  if (historicHebrew) {
    return input.split('').map((character) {
      var value = HISTORICHEBREW[character];
      if (value == null) return character;
      return value;
    }).join();
  } else {
    return input.split('').map((character) {
      var value = alphabet_AZ[character];
      if (value == null) return character;
      return alphabet_AZIndexes[27 - value];
    }).join();
  }
}
