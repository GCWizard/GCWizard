// https://www.geocaching.com/geocache/GC9R4YE_barossa-121

import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';

String encodeSpellingAlphabets(String plain, SPELLING language) {

  if (plain.isEmpty) return '';

  List<String> result = [];
  var _alphabet = SPELLING_ALPHABETS[language]!;
  Map<String, String> alphabet = {};
  Map<String, String> alphabetLow = {};
  switch (language) {
    case SPELLING.GRC:
      for (var entry in _alphabet) {
        alphabet[entry.key.toUpperCase().split(',')[0]] =
            entry.value.toUpperCase();
        alphabetLow[entry.key.toUpperCase().split(',')[1]] =
            entry.value.toUpperCase();
      }
      break;
    case SPELLING.GRCLAT:
      for (var entry in _alphabet) {
        alphabet[entry.key.toUpperCase().split(',')[0]] =
            entry.value.toUpperCase();
        alphabetLow[entry.key.toUpperCase().split(',')[1]] =
            entry.value.toUpperCase();
      }
      break;
    default:
      alphabet = Map.fromEntries(_alphabet);
  }

  plain.toUpperCase().split('').forEach((letter) {
    if (alphabet[letter] != null) {
      result.add(alphabet[letter]!.toUpperCase());
    }
    if (language == SPELLING.GRCLAT || language == SPELLING.GRC) {
      if (alphabetLow[letter] != null) {
        result.add(alphabetLow[letter]!.toUpperCase());
      }
    }
  });
  return result.join(' ');
}

String decodeSpellingAlphabets(String chiffre, SPELLING language) {
  Map<String, String> alphabet = {};

  if (chiffre.isEmpty) return '';

  for (var entry in SPELLING_ALPHABETS[language]!) {
    alphabet[entry.value.toUpperCase()] = entry.key.split(',')[0];
  }

  return substitution(chiffre.toUpperCase(), alphabet, caseSensitive: false).replaceAll(' ', '');
}
