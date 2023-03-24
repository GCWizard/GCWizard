import 'package:gc_wizard/utils/collection_utils.dart';

// https://de.wikipedia.org/wiki/Affine_Chiffre
// https://en.wikipedia.org/wiki/Affine_cipher

const _AZToAffineDigit = {
  'A': 0,
  'B': 1,
  'C': 2,
  'D': 3,
  'E': 4,
  'F': 5,
  'G': 6,
  'H': 7,
  'I': 8,
  'J': 9,
  'K': 10,
  'L': 11,
  'M': 12,
  'N': 13,
  'O': 14,
  'P': 15,
  'Q': 16,
  'R': 17,
  'S': 18,
  'T': 19,
  'U': 20,
  'V': 21,
  'W': 22,
  'X': 23,
  'Y': 24,
  'Z': 25
};
final _AffineDigitToAZ = switchMapKeyValue(_AZToAffineDigit);

final _reverseKeyA = {1: 1, 3: 9, 5: 21, 7: 15, 9: 3, 11: 19, 15: 7, 17: 23, 19: 11, 21: 5, 23: 17, 25: 25};

String encodeAffine(String input, int keyA, int keyB) {
  int? affinePlain;
  String? affineCipher;

  if (input.isEmpty) return '';

  return input.toUpperCase().split('').map((character) {
    if (character == ' ') return ' ';

    affinePlain = _AZToAffineDigit[character];
    if (affinePlain == null) return '';

    affinePlain = (keyA * affinePlain! + keyB) % 26;

    affineCipher = _AffineDigitToAZ[affinePlain];
    return affineCipher ?? '';
  }).join();
}

String decodeAffine(String input, int keyA, int keyB) {
  if (input.isEmpty) return '';

  int? affineCipher;
  String? affinePlain;

  return input.toUpperCase().split('').map((character) {
    if (character == ' ') return ' ';

    affineCipher = _AZToAffineDigit[character];
    if (affineCipher == null) return '';

    affineCipher = _reverseKeyA[keyA]! * (affineCipher! - keyB) % 26;

    affinePlain = _AffineDigitToAZ[affineCipher];
    return affinePlain ?? '';
  }).join();
}
