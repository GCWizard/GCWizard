import 'package:gc_wizard/utils/alphabets.dart';

List<int> encryptCipherWheel(String input, int key) {

  input = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

  if (input.isEmpty) return <int>[];

  return input.split('').map((character) {
    var value = alphabet_AZ[character]!;
    value += key - 1;
    value %= 26;
    if (value == 0) value = 26;
    return value;
  }).toList();
}

String decryptCipherWheel(List<int> input, int key) {
  if (input.isEmpty) return '';

  return input.map((value) {
    value -= key - 1;
    value %= 26;
    if (value == 0) value = 26;

    return alphabet_AZIndexes[value];
  }).join();
}
