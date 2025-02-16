// https://www.geocaching.com/geocache/GC9R4YE_barossa-121

import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';

String encodeSpellingAlphabets(String plain, SPELLING language) {
  List<String> result = [];
  var _alphabet = SPELLING_ALPHABETS[language]!;
  var alphabet =  Map.fromEntries(_alphabet);

  if (plain.isEmpty) return '';

  plain.toUpperCase().split('').forEach((letter) {
    if (alphabet[letter] != null) {
      result.add(alphabet[letter]!.toUpperCase());
    }
  });
  return result.join(' ');
}

String decodeSpellingAlphabets(String chiffre, SPELLING language) {
  Map<String, String> alphabet = {};

  if (chiffre.isEmpty) return '';

  for (var entry in SPELLING_ALPHABETS[language]!) {
    alphabet[entry.value.toUpperCase()] = entry.key;
  }

  return substitution(chiffre.toUpperCase(), alphabet, caseSensitive: false).replaceAll(' ', '');
}
