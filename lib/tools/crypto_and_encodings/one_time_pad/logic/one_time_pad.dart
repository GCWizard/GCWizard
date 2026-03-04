import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';

String encryptOneTimePad(String input, String key, {int keyOffset = 0}) {
  var output = encryptVigenere(input, key, false, repeatKey: false, aValue: 1 + keyOffset);

  return output.toUpperCase();
}

String decryptOneTimePad(String input, String key, {int keyOffset = 0}) {
  var output = decryptVigenere(input, key, false, repeatKey: false, aValue: 1 + keyOffset);

  return output.toUpperCase();
}
