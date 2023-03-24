import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _MAP = {
  '11': 'A',
  '12': 'B',
  '13': 'C',
  '14': 'D',
  '15': 'E',
  '16': 'F',
  '17': 'G',
  '18': 'H',
  '19': 'I',
  '21': 'J',
  '22': 'K',
  '23': 'L',
  '24': 'M',
  '25': 'N',
  '26': 'O',
  '27': 'P',
  '28': 'Q',
  '29': 'R',
  '31': 'S',
  '32': 'T',
  '33': 'U',
  '34': 'V',
  '35': 'W',
  '36': 'X',
  '37': 'Y',
  '38': 'Z',
  '39': ' '
};

String encodeFox(String input) {
  if (input.isEmpty) return '';

  var encodeMap = switchMapKeyValue(_MAP);

  return input
      .toUpperCase()
      .split('')
      .map((char) {
        var code = encodeMap[char];
        if (code == null) return '';

        return code;
      })
      .join(' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

String decodeFox(String input) {
  if (input.isEmpty) return '';

  input = input.replaceAll(RegExp(r'[^1-9]'), '');
  input = insertEveryNthCharacter(input, 2, ' ');

  return input.split(' ').map((code) {
    var char = _MAP[code];
    if (char == null) return '';

    return char;
  }).join();
}
