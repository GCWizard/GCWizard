import 'dart:math';

String encodeZalgoText(String text, int intensity) {
  final Random rnd = Random();
  final StringBuffer result = StringBuffer();

  for (final ch in text.runes) {
    for (int i = 0; i < intensity; i++) {
      // 768–879 is the Unicode combining diacritical marks range
      result.writeCharCode(rnd.nextInt(880 - 768) + 768);
    }
    result.writeCharCode(ch); // Add the original character
  }

  return result.toString();
}

String decodeZalgoText(String text) {

  for (int i = 768; i <= 880; i++) {
    text = text.replaceAll(String.fromCharCode(i), '');
  }
  return text;
}