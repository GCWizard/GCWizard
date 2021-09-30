import 'package:gc_wizard/utils/common_utils.dart';

enum GaussWeberTelegraphMode { GAUSS_WEBER_ORIGINAL, GAUSS_WEBER_ALTERNATIVE, SCHILLING_CANNSTATT }

Map<String, String> _GAUSS_WEBER_ORIGINAL = {
  'A': '+',
  'B': '-',
  'C': '++',
  'D': '+-',
  'E': '-+',
  'F': '--',
  'G': '+++',
  'H': '++-',
  'I': '+-+',
  'K': '+--',
  'L': '-++',
  'M': '-+-',
  'N': '--+',
  'O': '---',
  'P': '++++',
  'Q': '+++-',
  'R': '++-+',
  'S': '++--',
  'T': '+-++',
  'U': '+-+-',
  'V': '+--+',
  'W': '+---',
  'X': '-+++',
  'Y': '-++-',
  'Z': '-+-+'
};

Map<String, String> _GAUSS_WEBER_ALTERNATIVE = {
  'A': 'r',
  'B': 'll',
  'C': 'rrr',
  'D': 'rrl',
  'E': 'l',
  'F': 'rlr',
  'G': 'lrr',
  'H': 'lll',
  'I': 'rr',
  'K': 'rrr',
  'L': 'llr',
  'M': 'lrl',
  'N': 'rll',
  'O': 'rl',
  'P': 'rrrr',
  'R': 'rrrl',
  'S': 'rrlr',
  'T': 'rlrr',
  'U': 'lr',
  'V': 'rlr',
  'W': 'lrrr',
  'Z': 'rrll',
  '0': 'rlrl',
  '1': 'rllr',
  '2': 'lrrl',
  '3': 'lrlr',
  '4': 'llrr',
  '5': 'lllr',
  '6': 'llrl',
  '7': 'lrll',
  '8': 'rlll',
  '9': 'llll'
};

Map<String, String> _SCHILLING_CANNSTATT = {
  'A': 'rl',
  'B': 'rrr',
  'C': 'rll',
  'D': 'rrl',
  'E': 'r',
  'F': 'rrrr',
  'G': 'llll',
  'H': 'rlll',
  'I': 'rr',
  'J': 'rrll',
  'K': 'rrrl',
  'L': 'lrrr',
  'M': 'lrl',
  'N': 'lr',
  'O': 'rlr',
  'P': 'llrr',
  'Q': 'lllr',
  'R': 'lrr',
  'S': 'll',
  'T': 'l',
  'U': 'llr',
  'V': 'lll',
  'W': 'rlrl',
  'X': 'lrlr',
  'Y': 'rllr',
  'Z': 'rlrr',
  '0': 'lrrl',
  '1': 'rlrlr',
  '2': 'rrlrr',
  '3': 'rlllr',
  '4': 'lrrrl',
  '5': 'lrrll',
  '6': 'lrlrl',
  '7': 'rrllr',
  '8': 'rllrr',
  '9': 'llrll',
  '&': 'rrlr',
  'schillingcanstatt_stop': 'lrll',
  'schillingcanstatt_goon': 'lrrl',
  'schillingcanntatt_finish': 'llrl'
};

String decodeGaussWeberTelegraph(String input, GaussWeberTelegraphMode mode) {
  if (input == null || input.isEmpty) return '';

  Map<String, String> map;
  switch (mode) {
    case GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL:
      map = switchMapKeyValue(_GAUSS_WEBER_ORIGINAL);
      break;
    case GaussWeberTelegraphMode.GAUSS_WEBER_ALTERNATIVE:
      map = switchMapKeyValue(_GAUSS_WEBER_ALTERNATIVE);
      break;
    case GaussWeberTelegraphMode.SCHILLING_CANNSTATT:
      map = switchMapKeyValue(_SCHILLING_CANNSTATT);
      break;
    default:
      return '';
  }

  return input.toLowerCase().split(RegExp(r'\s+')).map((code) {
    if (code == null || code.isEmpty) return '';

    var character = map[code];
    if (character == null || character.isEmpty) return '';

    return character;
  }).join();
}

String encodeGaussWeberTelegraph(String input, GaussWeberTelegraphMode mode) {
  if (input == null || input.isEmpty) return '';

  Map<String, String> map;
  switch (mode) {
    case GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL:
      map = _GAUSS_WEBER_ORIGINAL;
      break;
    case GaussWeberTelegraphMode.GAUSS_WEBER_ALTERNATIVE:
      map = _GAUSS_WEBER_ALTERNATIVE;
      break;
    case GaussWeberTelegraphMode.SCHILLING_CANNSTATT:
      map = _SCHILLING_CANNSTATT;
      break;
    default:
      return '';
  }

  return input
      .toUpperCase()
      .split('')
      .map((char) {
        if (char == null || char.isEmpty) return '';

        var code = map[char];
        if (code == null || code.isEmpty) return '';

        return code;
      })
      .join(' ')
      .replaceAll(RegExp('\s+'), ' ');
}
