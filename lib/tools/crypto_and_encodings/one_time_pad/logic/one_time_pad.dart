import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';
import 'package:gc_wizard/utils/alphabets.dart';

String encryptOneTimePad(String input, String key, {int keyOffset}) {
  if (input == null) return '';

  if (key == null) return input;

  input = input.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');
  key = key.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');

  if (input.length == 0) return '';

  if (key.length == 0) return input;

  if (keyOffset == null) keyOffset = 0;

  var output = '';
  for (int i = 0; i < input.length; ++i) {
    var characterToRotate = input[i];

    if (i >= key.length) {
      output += characterToRotate;
      continue;
    }

    var rotateValue = alphabet_AZ[key[i]] + keyOffset;
    output += Rotator().rotate(characterToRotate, rotateValue);
  }

  return output;
}

String decryptOneTimePad(String input, String key, {int keyOffset}) {
  if (input == null) return '';

  if (key == null) return input;

  input = input.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');
  key = key.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');

  if (input.length == 0) return '';

  if (key.length == 0) return input;

  if (keyOffset == null) keyOffset = 0;

  var output = '';
  for (int i = 0; i < input.length; ++i) {
    var characterToRotate = input[i];

    if (i >= key.length) {
      output += characterToRotate;
      continue;
    }

    var rotateValue = -1 * (alphabet_AZ[key[i]] + keyOffset);
    output += Rotator().rotate(characterToRotate, rotateValue);
  }

  return output;
}
