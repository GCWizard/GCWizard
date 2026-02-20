import 'dart:math';

String zalgo_text(String text, int intensity) {
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

void main() {
  print(zalgo_text("Hello, World!", 8));
}