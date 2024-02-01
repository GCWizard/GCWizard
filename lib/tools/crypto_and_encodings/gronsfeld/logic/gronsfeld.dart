import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/alphabets.dart';

String encryptGronsfeld(String input, String key, bool autoKey, {int aValue = 0}) {
  key = _digitsToAlpha(key);

  return encryptVigenere(input, key, autoKey, aValue: aValue);
}

String decryptGronsfeld(String input, String key, bool autoKey, {int aValue = 0}) {
  key = _digitsToAlpha(key);

  return decryptVigenere(input, key, autoKey, aValue: aValue);
}

String _digitsToAlpha(String input, {int? aValue = 0, bool? removeNonDigits = true}) {
  aValue ??= 0;

  removeNonDigits ??= false;

  final letters = Rotator().rotate(Rotator.defaultAlphabetAlpha, aValue);

  return input.split('').map((character) {
    var value = alphabet_09[character];

    if (value == null) {
      if (removeNonDigits!) {
        return '';
      } else {
        return character;
      }
    }

    return letters[value];
  }).join();
}
