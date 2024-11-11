// https://www.history.navy.mil/research/library/online-reading-room/title-list-alphabetically/n/navajo-code-talker-dictionary.html
// https://www.ancestrycdn.com/aa-k12/1112/assets/Navajo-Code-Talkers-dictionary.pdf

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/navajo/logic/navajo_dictionary.dart';

String _shrinkText(String input) {
  return substitution(input, _NAVAJO_FOLD_MAP);
}

String _enfoldText(String input) {
  return substitution(input, switchMapKeyValue(_NAVAJO_FOLD_MAP));
}

String decodeNavajo(String cipherText, bool useOnlyAlphabet) {
  List<String> result = <String>[];
  if (cipherText.isEmpty) return '';

  cipherText = cipherText.toUpperCase().replaceAll(RegExp(r'\s{3,}'), '  ').replaceAll('.', ' . ').trim();

  cipherText.split('  ').forEach((element) {
    element.split(' ').forEach((element) {
      var entry = _NAVAJO_ALPHABET.firstWhereOrNull((entry) => entry.value == element);
      if (entry == null) {
        if (useOnlyAlphabet) {
          result.add(UNKNOWN_ELEMENT);
        } else {
          var entry = _NAVAJO_DICTIONARY.firstWhereOrNull((entry) => entry.value == element);
          if (entry == null) {
            result.add(UNKNOWN_ELEMENT);
          } else {
            result.add(_enfoldText(entry.key));
            result.add(' ');
          }
        }
      } else {
        result.add(entry.key);
      }
    });
    result.add(' ');
  });
  return _enfoldText(result.join('').trim());
}

String encodeNavajo(String plainText, bool useOnlyAlphabet) {
  List<String> result = <String>[];
  if (plainText.isEmpty) return '';
  var dictionary =  Map.fromEntries(_NAVAJO_DICTIONARY);

  _shrinkText(plainText.toUpperCase()).split(' ').forEach((element) {
    if (useOnlyAlphabet) {
      result.add(encodeLetterWise(element));
    } else if (dictionary[element] == null) {
      result.add(encodeLetterWise(element));
    } else {
      result.add(dictionary[element]!);
    }
    result.add('');
  });
  return result.join(' ').trim();
}

String encodeLetterWise(String plainText) {
  List<String> result = <String>[];
  plainText.split('').forEach((element) {
    var entrys = _NAVAJO_ALPHABET.where((entry) => entry.key == element);
    if (entrys.isEmpty) {
      result.add(element);
    } else {
      result.add(entrys.elementAt(Random().nextInt(entrys.length)).value);
    }
  });
  return result.join(' ');
}

List<MapEntry<String, String>> navajoAlphabet() {
  return _NAVAJO_ALPHABET.whereNot((entry) => entry.key == '.').toList();
}

List<MapEntry<String, String>> navajoDictionary() {
  var _enfoldMap = switchMapKeyValue(_NAVAJO_FOLD_MAP);
  return _NAVAJO_DICTIONARY.map((entry) {
    if (_enfoldMap[entry.key] == null) {
      return entry;
    } else {
      return MapEntry<String, String>(_enfoldMap[entry.key]!, entry.value);
    }
  }).toList();
}
