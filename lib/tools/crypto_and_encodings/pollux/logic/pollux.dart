import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/utils/string_utils.dart';

Map<String, String> _keyMap(String key) {
  var dots = '';
  var dashes = '';
  var spaces = '';

  if (key.isEmpty) {
    throw const FormatException('pollux_key_exception_empty');
  }

  if (key.length > 10) {
    key = key.substring(0, 10);
  }

  normalizeMorseCharacters(key).split('').asMap().entries.forEach((MapEntry<int, String> character) {
    if (['.'].contains(character.value)) {
      dots += character.key.toString();
      return;
    }
    if (['-'].contains(character.value)) {
      dashes += character.key.toString();
      return;
    }
    spaces += character.key.toString();
  });

  if (dots.isEmpty) {
    throw const FormatException('pollux_key_exception_no_dots');
  }
  if (dashes.isEmpty) {
    throw const FormatException('pollux_key_exception_no_dashes');
  }
  if (spaces.isEmpty) {
    throw const FormatException('pollux_key_exception_no_spaces');
  }

  return {'.': dots, '-': dashes, ' ': spaces};
}

String polluxEncrypt(String input, String key) {
  if (input.isEmpty) {
    return '';
  }

  input = input.toUpperCase().replaceAll(RegExp(r'\s'), '');
  var morse = encodeMorse(input).replaceAll(RegExp(r'[^.\-\s]'), '');
  var keyMap = _keyMap(key);

  var out = morse.split('').map((character) {
    var chars = keyMap[character]!;
    var index = Random().nextInt(chars.length);
    return chars[index];
  }).join();

  return insertEveryNthCharacter(out, 5, ' ');
}

String polluxDecrypt(String input, String key) {
  if (input.isEmpty) {
    return '';
  }

  input = input.replaceAll(RegExp(r'[^0-9]'), '');
  var keyMap = _keyMap(key);

  var morse = input.split('').map((character) {
    return keyMap.entries.firstWhere((e) => e.value.contains(character)).key;
  }).join();

  return decodeMorse(morse);
}
