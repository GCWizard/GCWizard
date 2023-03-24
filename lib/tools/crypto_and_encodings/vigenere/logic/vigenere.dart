import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class _KeyOutput {
  String key;
  String type;

  _KeyOutput(this.type, this.key);
}

_KeyOutput? _getKey(String key, int aValue) {
  if (key.isEmpty) return null;

  var keyLetters = key.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  if (keyLetters.isNotEmpty) {
    return _KeyOutput('letters', keyLetters);
  }

  var keyNumbers = key.replaceAll(RegExp(r'[^\s0-9,\-]'), '').split(RegExp(r'[\s,]+')).map((keyNumber) {
    var number = int.tryParse(keyNumber);
    if (number == null) return '';

    while (number! <= 0) {
      number += 26;
    }
    while (number! > 26) {
      number -= 26;
    }
    var letter = alphabet_AZIndexes[number];
    return letter ?? '';
  }).join();

  if (keyNumbers.isNotEmpty) {
    return _KeyOutput('numbers', keyNumbers);
  }

  return null;
}

String encryptVigenere(String input, String key, bool autoKey, {int aValue = 0, bool ignoreNonLetters = true}) {
  if (input.isEmpty) return '';

  var checkedKey = _getKey(key, aValue);
  if (checkedKey == null) return input;

  key = checkedKey.key;
  var aOffset = (alphabet_AZ['A'] ?? 0) - aValue;

  String output = '';

  if (autoKey) {
    key += input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  } else {
    while (key.length < input.length) {
      key += key;
    }
  }

  int keyOffset = 0;

  for (int i = 0; i < input.length; ++i) {
    if (ignoreNonLetters && !alphabet_AZ.containsKey(input[i].toUpperCase())) {
      keyOffset++;
      output += input[i];

      continue;
    }

    if (i - keyOffset >= key.length) break;

    var rotator = alphabet_AZ[key[i - keyOffset]] ?? 0;
    if (checkedKey.type == 'letters') rotator -= aOffset;

    output += Rotator().rotate(input[i], rotator);
  }

  return output;
}

String decryptVigenere(String input, String key, bool autoKey, {int aValue = 0, bool ignoreNonLetters = true}) {
  if (input.isEmpty) return '';

  var checkedKey = _getKey(key, aValue);
  if (checkedKey == null) return input;

  key = checkedKey.key;

  var aOffset = 1;
  if (checkedKey.type == 'letters') aOffset = (alphabet_AZ['A'] ?? 0) - aValue;

  String originalKey = key;
  String output = '';

  if (!autoKey) {
    while (key.length < input.length) {
      key += key;
    }
  }

  int keyOffset = 0;

  for (int i = 0; i < input.length; ++i) {
    if (ignoreNonLetters && !alphabet_AZ.containsKey(input[i].toUpperCase())) {
      keyOffset++;
      output += input[i];

      continue;
    }

    int position;
    if (autoKey) {
      String s = originalKey + output.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

      if (i - keyOffset >= s.length) break;

      position = alphabet_AZ[s[i - keyOffset]] ?? 0;
    } else {
      if (i - keyOffset >= key.length) break;

      position = alphabet_AZ[key[i - keyOffset]] ?? 0;
    }

    var rotator = -position;
    if (checkedKey.type == 'letters') rotator += aOffset;

    output += Rotator().rotate(input[i], rotator);
  }

  return output;
}
