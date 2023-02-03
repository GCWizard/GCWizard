import 'package:gc_wizard/utils/alphabets.dart';

List<int> encryptCipherWheel(String input, int key) {
  if (input == null) return <int>[];

  input = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

  if (input.length == 0) return <int>[];

  return input.split('').map((character) {
    var value = alphabet_AZ[character];
    value += key - 1;
    value %= 26;
    if (value == 0) value = 26;
    return value;
  }).toList();
}

String decryptCipherWheel(List<int> input, int key) {
  if (input == null || input.length == 0) return '';

  return input.map((value) {
    value -= key - 1;
    value %= 26;
    if (value == 0) value = 26;

    return alphabet_AZIndexes[value];
  }).join();
}
