// import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/external_libs/guballa/breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/logic/english_bigrams.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/logic/french_bigrams.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/logic/german_bigrams.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/logic/spanish_bigrams.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/guballa/logic/breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/logic/vigenere_breaker.dart';

class Bigrams {
  static const int maxAlphabetLength = 32;

  late String alphabet;
  Map<String, String>? replacementList;
  // The bigram with the lowest probability receives the value 0, the one with the greatest probability receives the value 1000000
  late List<List<int>> bigrams;
}

Bigrams? getBigrams(VigenereBreakerAlphabet alphabet) {
  switch (alphabet) {
    case VigenereBreakerAlphabet.ENGLISH:
      return EnglishBigrams();
    case VigenereBreakerAlphabet.GERMAN:
      return GermanBigrams();
    case VigenereBreakerAlphabet.SPANISH:
      return SpanishBigrams();
    case VigenereBreakerAlphabet.FRENCH:
      return FrenchBigrams();
    default:
      return null;
  }
}

double? calc_fitnessBigrams(String txt, Bigrams? bigrams) {
  if (txt.isEmpty) return null;

  if (bigrams == null) return null;

  var fitness = 0;
  var plain_bin = <int>[];

  iterateText(txt, bigrams.alphabet).forEach((char) {
    plain_bin.add(char);
  });

  if (plain_bin.length < 2) {
    return null;
  }

  for (var idx = 0; idx < (plain_bin.length - 1); idx++) {
    var ch1 = plain_bin[idx];
    var ch2 = plain_bin[idx + 1];
    if (ch1 >= 0 && ch2 >= 0) fitness += bigrams.bigrams[ch1][ch2];
  }

  return fitness / 10000 / (plain_bin.length - 1);
}
