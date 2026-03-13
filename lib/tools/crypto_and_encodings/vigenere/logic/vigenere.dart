import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/string_utils.dart';

List<int> _toValueList(String text, String alphabet, int aValue) {
  return toUpperCaseWithSZ(text)
      .replaceAll(RegExp(r'[^' + alphabet + ']'), '')
      .split('').map((String char) {
        return alphabet.indexOf(char) + aValue;
      }).toList();
}

List<int> _getKey(String input, String key, int aValue, String alphabet, bool autokey, bool repeatKey) {
  if (key.isEmpty) {
    return <int>[];
  }

  var keyLetters = toUpperCaseWithSZ(key).replaceAll(RegExp(r'[^' + alphabet + ']'), '');
  if (keyLetters.isNotEmpty) {
    if (autokey) {
      key += input;
    } else {
      if (repeatKey) {
        while (key.length < input.length) {
          key += key;
        }
      }
    }

    return _toValueList(key, alphabet, aValue);
  }

  var keyNumbers = key.replaceAll(RegExp(r'[^0-9]'), '');
  if (keyNumbers.isNotEmpty) {
    var out = RegExp(r'-?\d+')
      .allMatches(key)
      .map((RegExpMatch match) => int.parse(match[0] ?? '0'))
      .toList();

    if (autokey) {
      out.addAll(_toValueList(input, alphabet, aValue));
    } else {
      if (repeatKey) {
        while (out.length < input.length) {
          out.addAll(List<int>.from(out));
        }
      }
    }

    return out;
  }

  return <int>[];
}

String encryptVigenere(String input, String key, bool autoKey, {int aValue = 0, bool ignoreNonLetters = true, Alphabet? alphabet, bool repeatKey = true}) {
  if (input.isEmpty) return '';
  if (key.isEmpty) return input;

  alphabet ??= alphabetAZ;
  var _alphabet = <String, int>{};
  var _letters = toUpperCaseWithSZ(alphabet.alphabet.keys.join());
  for (int i = 0; i < _letters.length; i++) {
    _alphabet.putIfAbsent(_letters[i], () => (i + 1));
  }

  var _key = _getKey(input, key, aValue, _letters, autoKey, repeatKey);
  var output = '';

  var rotator = Rotator(alphabet: _letters);

  var keyI = 0;
  for (var i = 0; i < input.length; i++) {
    if (ignoreNonLetters && !_alphabet.containsKey(toUpperCaseWithSZ(input[i]))) {
      output += input[i];
      continue;
    }

    var rot = 0;
    if (keyI < _key.length) {
      rot = _key[keyI];
      keyI++;
    }
    output += rotator.rotate(input[i], rot);
  }

  return output;
}

String decryptVigenere(String input, String key, bool autoKey, {int aValue = 0, bool ignoreNonLetters = true, Alphabet? alphabet, bool repeatKey = true}) {
  if (input.isEmpty) return '';
  if (key.isEmpty) return input;

  alphabet ??= alphabetAZ;
  var _alphabet = <String, int>{};
  var _letters = toUpperCaseWithSZ(alphabet.alphabet.keys.join());
  for (int i = 0; i < _letters.length; i++) {
    _alphabet.putIfAbsent(_letters[i], () => (i + 1));
  }

  var _key = _getKey(input, key, aValue, _letters, false, autoKey ? false : repeatKey);
  var output = '';

  var rotator = Rotator(alphabet: _letters);

  var keyI = 0;
  for (var i = 0; i < input.length; i++) {
    if (ignoreNonLetters && !_alphabet.containsKey(toUpperCaseWithSZ(input[i]))) {
      output += input[i];
      continue;
    }

    var rot = 0;
    if (keyI < _key.length) {
      rot = _key[keyI];
      keyI++;
    }

    var char = rotator.rotate(input[i], -rot);
    output += char;
    if (autoKey) {
      _key.add(_toValueList(char, _letters, aValue).first);
    }
  }

  return output;
}
