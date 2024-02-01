// https://www.geocaching.com/geocache/GC9R4YE_barossa-121

import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';

String encodeSpellingAlphabets(String plain, SPELLING language) {
  List<String> result = [];
  Map<String, String> alphabet = SPELLING_ALPHABETS[language]!;

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

  SPELLING_ALPHABETS[language]!.forEach((key, value) {
    alphabet[value.toUpperCase()] = key;
  });

  return substitution(chiffre.toUpperCase(), alphabet, caseSensitive: false).replaceAll(' ', '');
}
