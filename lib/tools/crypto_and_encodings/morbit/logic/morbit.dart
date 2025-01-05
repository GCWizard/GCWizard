import 'dart:collection';

import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/utils/string_utils.dart';

Map<String, String> _keyMap(String key) {
  if (key.length > 9) {
    key = key.substring(0, 9);
  }

  var list = key.split('').asMap().entries.toList();
  list.sort((a, b) {
    return a.value.compareTo(b.value);
  });

  var map = SplayTreeMap<int, int>();
  list.asMap().entries.forEach((element) {
    map.putIfAbsent(element.value.key, () => element.key);
  });

  var sortedIndexes = map.values.toList();
  while (sortedIndexes.length < 9) {
    sortedIndexes.add(sortedIndexes.length);
  }

  const initChars1 = '...---   ';
  const initChars2 = '.- .- .- ';
  var out = <String, String>{};

  for (var i = 0; i < 9; i++) {
    out.putIfAbsent(initChars1[i] + initChars2[i], () => (sortedIndexes[i] + 1).toString());
  }

  return out;
}

String morbitEncrypt(String input, String key) {
  if (input.isEmpty) {
    return '';
  }

  input = input.toUpperCase();
  var morse = encodeMorse(input).replaceAll(RegExp(r'[^.\-\s]'), '');
  if (morse.length % 2 == 1) {
    morse += ' ';
  }
  var keyMap = _keyMap(key);

  morse = insertEveryNthCharacter(morse, 2, '%');
  var out = morse.split('%').map((character) {
    return keyMap[character]!;
  }).join();

  return insertEveryNthCharacter(out, 5, ' ');
}

String morbitDecrypt(String input, String key) {
  if (input.isEmpty) {
    return '';
  }

  input = input.replaceAll(RegExp(r'[^0-9]'), '');
  var keyMap = _keyMap(key);

  var morse = input.split('').map((character) {
    return keyMap.entries.firstWhere((e) => e.value.contains(character)).key;
  }).join();

  return decodeMorse(morse.replaceAll('  ', ' | '));
}
