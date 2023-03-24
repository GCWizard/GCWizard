import 'package:gc_wizard/utils/collection_utils.dart';

final _AlphabetMap = {
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
final _AlphabetMapExtension = {'b': '8', 'e': '3', 'H': '4', 'i': '1', 'l': '7', 'o': '0', 's': '5', 'z': '2'};

String decodeBeghilos(String input) {
  var alphabetMap = Map<String, String>.from(_AlphabetMap);
  alphabetMap.addAll(_AlphabetMapExtension);
  return _translateBeghilos(input, alphabetMap);
}

String encodeBeghilos(String input) {
  return _translateBeghilos(input, switchMapKeyValue(_AlphabetMap));
}

String _translateBeghilos(String input, Map<String, String> alphabetMap) {
  if (input.isEmpty) return '';

  var output = input.split('').map((letter) {
    return alphabetMap.containsKey(letter) ? alphabetMap[letter] : '';
  }).join();

  output = output.trim();
  return output.split('').reversed.join('');
}
