import 'package:gc_wizard/utils/collection_utils.dart';

enum BeghilosType {LOWER_G_TO_SIX, NINE_TO_SIX}

final _AlphabetMap_LOWER_G_TO_SIX = {
  'b': '8',
  'e': '3',
  'H': '4',
  'i': '1',
  'l': '7',
  'o': '0',
  's': '5',
  'z': '2',

  'B': '8',
  'E': '3',
  'G': '9',
  'g': '6',
  'h': '4',
  'I': '1',
  'L': '7',
  'O': '0',
  'S': '5',
  'Z': '2',
  ' ': ' ',
  '.': '.'
};

final _AlphabetMap_NINE_TO_SIX = {
  'b': '8',
  'e': '3',
  'H': '4',
  'i': '1',
  'l': '7',
  'o': '0',
  's': '5',
  'z': '2',

  'B': '8',
  'E': '3',
  'G': '9',
  'g': '6',
  '6': '9',
  '9': '6',
  'h': '4',
  'I': '1',
  'L': '7',
  'O': '0',
  'S': '5',
  'Z': '2',
  ' ': ' ',
  '.': '.'
};

String decodeBeghilos(String input, BeghilosType type) {
  var alphabetMap = Map<String, String>.from(type == BeghilosType.LOWER_G_TO_SIX ? _AlphabetMap_LOWER_G_TO_SIX : _AlphabetMap_NINE_TO_SIX);
  return _translateBeghilos(input, alphabetMap);
}

String encodeBeghilos(String input, BeghilosType type) {
  return _translateBeghilos(input, switchMapKeyValue(type == BeghilosType.LOWER_G_TO_SIX ? _AlphabetMap_LOWER_G_TO_SIX : _AlphabetMap_NINE_TO_SIX));
}

String _translateBeghilos(String input, Map<String, String> alphabetMap) {
  if (input.isEmpty) return '';

  var output = input.split('').map((letter) {
    return alphabetMap.containsKey(letter) ? alphabetMap[letter] : '';
  }).join();

   output = output.trim();
  return output.split('').reversed.join('');
}
