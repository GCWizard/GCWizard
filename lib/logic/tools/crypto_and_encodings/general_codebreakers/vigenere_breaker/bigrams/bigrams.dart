import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/guballa.de/breaker.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/english_bigrams.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/french_bigrams.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/german_bigrams.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/spanish_bigrams.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/vigenere_breaker.dart';

class Bigrams {
  static const int maxAlphabetLength = 32;

  String alphabet;
  Map<String, String> replacementList;
  // The bigram with the lowest probability receives the value 0, the one with the greatest probability receives the value 1000000
  List<List<int>> bigrams;
}

Bigrams getBigrams(VigenereBreakerAlphabet alphabet) {
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

double calc_fitnessBigrams(String txt, Bigrams bigrams) {
  if (txt == null || txt == '') return null;

  if ((bigrams == null) || (bigrams.alphabet == null) || (bigrams.bigrams == null)) return null;

  var fitness = 0;
  var plain_bin = <int>[];

  iterateText(txt, bigrams.alphabet).forEach((char) {
    plain_bin.add(char);
  });

  if (plain_bin.length < 2)
    // More than two characters from the given alphabet are required
    return null;

  for (var idx = 0; idx < (plain_bin.length - 1); idx++) {
    var ch1 = plain_bin[idx];
    var ch2 = plain_bin[idx + 1];
    if (ch1 >= 0 && ch2 >= 0) fitness += bigrams.bigrams[ch1][ch2];
  }

  return fitness / 10000 / (plain_bin.length - 1);
}
