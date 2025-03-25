import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/alphabets.dart';

String encryptLarrabee(String input, String key) {
  return encryptVigenere(input, key, false);
}

String decryptLarrabee(String input, String key) {
  return decryptVigenere(input, key, false);
}

String replaceNumbers(String input) {
  var replacment = alphabet_AZ;
  var matches = RegExp(r'\d+').allMatches(input).toList();
  for (var match in matches.reversed) {
var number =match.toString().split('').map((number) => replacment[])
  }

}
