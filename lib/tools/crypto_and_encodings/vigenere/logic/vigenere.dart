import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class _KeyOutput {
  String key;
  String type;

  _KeyOutput(this.type, this.key);
}

_KeyOutput? _getKey(String key, int aValue, String alphabet) {
  if (key.isEmpty) return null;

  var keyLetters = toUpperCaseWithSZ(key).replaceAll(RegExp(r'[^' + alphabet + ']'), '');
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

String encryptVigenere(String input, String key, bool autoKey, {int aValue = 0, bool ignoreNonLetters = true, Alphabet? alphabet}) {
  if (input.isEmpty) return '';

  alphabet ??= alphabetAZ;
  var _alphabet = <String, int>{};
  var _letters = toUpperCaseWithSZ(alphabet.alphabet.keys.join());
  for (int i = 0; i < _letters.length; i++) {
    _alphabet.putIfAbsent(_letters[i], () => (i + 1));
  }

  var checkedKey = _getKey(key, aValue, _letters);
  if (checkedKey == null) return input;

  key = checkedKey.key;
  var aOffset = 1 - aValue;

  String output = '';

  if (autoKey) {
    key += toUpperCaseWithSZ(input).replaceAll(RegExp(r'[^' + _letters + ']'), '');
  } else {
    while (key.length < input.length) {
      key += key;
    }
  }

  int keyOffset = 0;

  for (int i = 0; i < input.length; ++i) {
    if (ignoreNonLetters && !_alphabet.containsKey(toUpperCaseWithSZ(input[i]))) {
      keyOffset++;
      output += input[i];

      continue;
    }

    if (i - keyOffset >= key.length) break;

    var rotator = _alphabet[key[i - keyOffset]] ?? 0;
    if (checkedKey.type == 'letters') rotator -= aOffset;

    output += Rotator(alphabet: _letters).rotate(input[i], rotator);
  }

  return output;
}

String decryptVigenere(String input, String key, bool autoKey, {int aValue = 0, bool ignoreNonLetters = true, Alphabet? alphabet}) {
  if (input.isEmpty) return '';
  alphabet ??= alphabetAZ;
  var _alphabet = <String, int>{};
  var _letters = toUpperCaseWithSZ(alphabet.alphabet.keys.join());
  for (int i = 0; i < _letters.length; i++) {
    _alphabet.putIfAbsent(_letters[i], () => (i + 1));
  }

  var checkedKey = _getKey(key, aValue, _letters);
  if (checkedKey == null) return input;

  key = checkedKey.key;

  var aOffset = 1;
  if (checkedKey.type == 'letters') aOffset -= aValue;

  String originalKey = key;
  String output = '';

  if (!autoKey) {
    while (key.length < input.length) {
      key += key;
    }
  }

  int keyOffset = 0;

  for (int i = 0; i < input.length; ++i) {
    if (ignoreNonLetters && !_alphabet.containsKey(toUpperCaseWithSZ(input[i]))) {
      keyOffset++;
      output += input[i];

      continue;
    }

    int position;
    if (autoKey) {
      String s = originalKey + toUpperCaseWithSZ(output).replaceAll(RegExp(r'[^' + _letters + ']'), '');

      if (i - keyOffset >= s.length) break;

      position = _alphabet[s[i - keyOffset]] ?? 0;
    } else {
      if (i - keyOffset >= key.length) break;

      position = _alphabet[key[i - keyOffset]] ?? 0;
    }

    var rotator = -position;
    if (checkedKey.type == 'letters') rotator += aOffset;

    output += Rotator(alphabet: _letters).rotate(input[i], rotator);
  }

  return output;
}
