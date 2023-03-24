import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/string_utils.dart';

String atbash(String input) {
  if (input.isEmpty) return '';

  input = removeAccents(input).toUpperCase();

  return input.split('').map((character) {
    var value = alphabet_AZ[character];
    if (value == null) return character;
    return alphabet_AZIndexes[27 - value];
  }).join();
}
