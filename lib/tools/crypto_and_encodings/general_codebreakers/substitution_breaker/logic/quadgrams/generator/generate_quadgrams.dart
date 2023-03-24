part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';

// main() {
//   generate_quadgram();
// }

/// Link for corpus files (for other languages)
/// https://guballa.gitlab.io/SubstitutionBreaker/cli_explained.html#adding-more-languages
/// https://wortschatz.uni-leipzig.de/de/download/german#deu_newscrawl-public_2018

/// method to generate then quadgrams files from a text file
Future<bool> generate_quadgram() async {
  var result = true;

  List<Map<String, Object>> _inputsToExpected = [
    // Attention: a file is done during execution

    /// generate test-quadgram- file ( Source file from https://gitlab.com/guballa/SubstitutionBreaker/-/blob/development/tests/fixturefiles/quadgram_corpus.txt)
    //{'input' : 'quadgram_corpus.txt', 'fileOut' : 'quadgram_test.dart', 'className' : 'EnglishQuadgrams', 'assetName' : 'en.json', 'alphabet' : DEFAULT_ALPHABET, 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate German quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/deu_news_2015_1M.tar.gz -> deu_news_2015_1M-sentences.txt)
    //{'input' : 'deu_news_2015_1M-sentences.txt', 'fileOut' : 'german_quadgrams.dart', 'className' : 'GermanQuadgrams', 'assetName' : 'de.json', 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate France quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/fra_mixed_2009_1M.tar.gz -> fra_mixed_2009_1M-sentences.txt)
    //{'input' : 'fra_mixed_2009_1M-sentences.txt', 'fileOut' : 'france_quadgrams.dart', 'className' : 'FranceQuadgrams', 'assetName' : 'fr.json', 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate Russian quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/rus_newscrawl-public_2018_1M.tar.gz -> rus_newscrawl-public_2018_1M-sentences.txt)
    //{'input' : 'rus_newscrawl-public_2018_1M-sentences.txt', 'fileOut' : 'russian_quadgrams.dart', 'className' : 'RussianQuadgrams', 'assetName' : 'ru.json', 'alphabet' : "абвгдежзиклмнопрстуфхцчшэюя", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate Polish quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/pol_newscrawl_2018_1M.tar.gz -> pol_newscrawl_2018_1M-sentences.txt)
    //{'input' : 'pol_newscrawl_2018_1M-sentences.txt', 'fileOut' : 'polish_quadgrams.dart', 'className' : 'PolishQuadgrams', 'assetName' : 'pl.json', 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate Spanish quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/spa_newscrawl_2015_1M.tar.gz -> spa_newscrawl_2015_1M-sentences.txt)
    //{'input' : 'spa_newscrawl_2015_1M-sentences.txt', 'fileOut' : 'spanish_quadgrams.dart', 'className' : 'SpanishQuadgrams', 'assetName' : 'es.json', 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate Greek quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/ell_newscrawl_2017_1M.tar.gz -> ell_newscrawl_2017_1M-sentences.txt)
    //{'input' : 'ell_newscrawl_2017_1M-sentences.txt', 'fileOut' : 'greek_quadgrams.dart', 'className' : 'GreekQuadgrams', 'assetName' : 'gr.json', 'alphabet' : "αβγδεζηθικλμνξοπρστυφχψω", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
    /// generate Dutch quadgram file (Source file from https://pcai056.informatik.uni-leipzig.de/downloads/corpora/nld_news_2020_1M.tar.gz -> nld_news_2020_1M-sentences.txt)
    //{'input' : 'nld_news_2020_1M-sentences.txt', 'fileOut' : 'dutch_quadgrams.dart', 'className' : 'DutchQuadgrams', 'assetName' : 'nl.json', 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : ErrorCode.OK, 'expectedOutput' : ''},
  ];

  for (var elem in _inputsToExpected) {
    var filePath =
        current + "/lib/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/";
    var fileIn = File(normalizePath(filePath + (elem['input'] as String)));
    var fileOut = File(normalizePath(filePath + (elem['fileOut'] as String)));
    filePath = current + "/assets/quadgrams/";
    var fileAsset = File(normalizePath(filePath + (elem['assetName'] as String)));

    var _actual =
        await generateQuadgrams(fileIn, fileOut, fileAsset,
            elem['className'] as String,
            elem['assetName'] as String,
            elem['alphabet'] as String);

    result = result && (_actual.errorCode == BreakerErrorCode.OK);
  }

  return result;
}

BreakerResult generateFiles(File quadgram_fh, File asset_fh, String className, String assetName, String alphabet,
    double quadgram_sum, String max_chars, double max_val, List<double> quadgrams) {
  var sb = StringBuffer();
  var quadgrams_sum = 0;
  var quadgramsInt = List.filled(quadgrams.length, 0);
  for (int i = 0; i < quadgrams.length; i++) {
    quadgramsInt[i] = quadgrams[i].round();
    quadgrams_sum += quadgramsInt[i];
  }
  sb.write(
      "part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic.dart';\n");
  sb.write("\n");
  sb.write("class " + className + " extends Quadgrams {\n");
  sb.write("\n");
  sb.write("  " + className + "() {\n");
  sb.write("\n");
  sb.write("    alphabet = '" + alphabet + "';\n");
  sb.write("    nbr_quadgrams = " + quadgram_sum.round().toString() + ";\n");
  sb.write("    most_frequent_quadgram = '" + max_chars + "';\n");
  sb.write("    max_fitness = " + max_val.round().toString() + ";\n");
  sb.write("    average_fitness = " + (quadgrams_sum.toDouble() / pow(alphabet.length, 4)).toString() + ";\n");
  sb.write("    assetLocation = " '"assets/quadgrams/' + assetName + '";\n');
  sb.write("  }\n");
  sb.write("}\n");

  quadgram_fh.writeAsStringSync(sb.toString());

  asset_fh.writeAsStringSync(Quadgrams.quadgramsMapToString(Quadgrams.compressQuadgrams(quadgramsInt)));

  if (quadgrams_sum == 0 || max_val == 0) {
    return BreakerResult(alphabet: alphabet, fitness: max_val, errorCode: BreakerErrorCode.WRONG_GENERATE_TEXT);
  } else {
    return BreakerResult(alphabet: alphabet, fitness: max_val, errorCode: BreakerErrorCode.OK);
  }
}
