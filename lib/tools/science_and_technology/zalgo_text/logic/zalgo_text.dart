import 'dart:math';

const _ranges = [
  [0x0300, 0x036F], //default range
  [0x1AB0, 0x1AFF],
  [0x1DC0, 0x1DFF],
  [0x20D0, 0x20FF],
  [0x2DE0, 0x2DFF],
  [0xFE20, 0xFE2F],
];

String encodeZalgoText(String text, int intensity) {
  final Random rnd = Random();
  final StringBuffer result = StringBuffer();

  for (final ch in text.runes) {
    for (int i = 0; i < intensity; i++) {
      // 768–879 is the Unicode combining diacritical marks range
      result.writeCharCode(rnd.nextInt(_ranges[0][1] - _ranges[0][0]) + _ranges[0][0]);
    }
    result.writeCharCode(ch); // Add the original character
  }

  return result.toString();
}

String decodeZalgoText(String text) {

  for (var range in _ranges) {
    for (int i = range[0]; i <= range[1]; i++) {
      text = text.replaceAll(String.fromCharCode(i), '');
    }
  }
  return text;
}