import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';

String encryptKamasutra(String input, String alphabet, {bool ignoreCase = true}) {
  if (input.isEmpty) return '';

  if (alphabet.length % 2 == 1) alphabet = alphabet.substring(0, alphabet.length - 1);

  if (alphabet.isEmpty) return input;

  return Rotator(alphabet: alphabet)
      .rotate(input, (alphabet.length / 2).floor(), removeUnknownCharacters: false, ignoreCase: ignoreCase);
}
