import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/logic/vigenere_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:path/path.dart' as path;

main() {
  generate_bigram();
}

/// https://www.guballa.de/implementierung-eines-vigenere-solvers
/// Link for bigram files (for other languages)
/// http://practicalcryptography.com/cryptanalysis/letter-frequencies-various-languages/

/// method to generate then bigrams files from a text file
bool generate_bigram() {
  var result = true;

  List<Map<String, dynamic>> _inputsToExpected = [
    // Attention: a file is done during execution

    /// generate English-bigrams- file ( Source file from http://practicalcryptography.com/media/cryptanalysis/files/english_bigrams.txt)
    {
      'input': 'english_bigrams.txt',
      'fileOut': 'english_bigrams.dart',
      'className': 'EnglishBigrams',
      'replacementList': null,
      'alphabet': "abcdefghijklmnopqrstuvwxyz",
      'errorCode': VigenereBreakerErrorCode.OK,
      'expectedOutput': ''
    },

    /// generate German bigrams file (Source file from http://practicalcryptography.com/media/cryptanalysis/files/german_bigrams.txt)
    {
      'input': 'german_bigrams.txt',
      'fileOut': 'german_bigrams.dart',
      'className': 'GermanBigrams',
      'replacementList': {'ä': 'ae', 'ö': 'oe', 'ü': 'ue', 'ß': 'ss'},
      'alphabet': "abcdefghijklmnopqrstuvwxyz",
      'errorCode': VigenereBreakerErrorCode.OK,
      'expectedOutput': ''
    },

    /// generate France bigrams file (Source file from http://practicalcryptography.com/media/cryptanalysis/files/french_bigrams.txt)
    //{'input' : 'french_bigrams.txt', 'fileOut' : 'french_bigrams.dart', 'className' : 'FrenchBigrams', 'replacementList' : {'æ': 'ae', 'à': 'a' , 'â': 'a', 'ç': 'c', 'è': 'e', 'é': 'e', 'ë': 'e', 'ê': 'e', 'î': 'i', 'ï': 'i', 'ô': 'o', 'œ': 'oe', 'ü': 'ue', 'û': 'u', 'ù': 'u', 'ÿ': 'ye', 'û': 'u'}, 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : VigenereBreakerErrorCode.OK, 'expectedOutput' : ''},
    /// generate Polish bigrams file (Source file from http://practicalcryptography.com/media/cryptanalysis/files/polish_bigrams.txt)
    //{'input' : 'polish_bigrams.txt', 'fileOut' : 'polish_bigrams.dart', 'className' : 'PolishBigrams', 'replacementList' : null, 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : VigenereBreakerErrorCode.OK, 'expectedOutput' : ''},
    /// generate Spanish bigrams file (Source file from http://practicalcryptography.com/media/cryptanalysis/files/spanish_bigrams.txt)
    //{'input' : 'spanish_bigrams.txt', 'fileOut' : 'spanish_bigrams.dart', 'className' : 'SpanishBigrams', 'replacementList' : {'ñ': 'n'}, 'alphabet' : "abcdefghijklmnopqrstuvwxyz", 'errorCode' : VigenereBreakerErrorCode.OK, 'expectedOutput' : ''},
  ];

  _inputsToExpected.forEach((elem) async {
    var filePath =
        path.current + "/lib/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/";
    var fileIn = File(normalizePath(filePath + elem['input']));
    var fileOut = File(normalizePath(filePath + elem['fileOut']));

    var _actual = await generateBigrams(fileIn, fileOut, elem['className'], elem['alphabet'], elem['replacementList']);

    result = result && (_actual.errorCode == VigenereBreakerErrorCode.OK);
  });

  return result;
}

Future<VigenereBreakerResult> generateBigrams(
    File source_fh, File bigrams_fh, String className, String alphabet, Map<String, String> replacementList) async {
  alphabet = alphabet.toLowerCase();

  var list = _fillSourceList(source_fh);
  list = _replaceBigramEntrys(list, alphabet, replacementList);
  var bigrams = _fillBigramArray(list, alphabet);
  int nbr_bigrams = 0;
  int min_bigrams = 1000000;
  int max_bigrams = 0;
  for (var row = 0; row < bigrams.length; row++) {
    for (var column = 0; column < bigrams[row].length; column++) {
      if (bigrams[row][column] != 0) {
        nbr_bigrams += bigrams[row][column];
        min_bigrams = min(min_bigrams, bigrams[row][column]);
        max_bigrams = max(max_bigrams, bigrams[row][column]);
      }
    }
    ;
  }
  ;
  bigrams = _scaleBigrams(bigrams);

  return _generateFile(
      bigrams_fh, className, alphabet, replacementList, bigrams, nbr_bigrams, min_bigrams, max_bigrams);
}

VigenereBreakerResult _generateFile(File bigrams_fh, String className, String alphabet,
    Map<String, String> replacementList, List<List<int>> bigrams, int nbr_bigrams, int min_bigrams, int max_bigrams) {
  var sb = new StringBuffer();
  var replacementListString = "null";
  var first = true;

  if (replacementList != null && replacementList.length > 0) {
    var sb = new StringBuffer();
    sb.write("{");
    replacementList.forEach((key, value) {
      if (first)
        first = false;
      else
        sb.write(',');
      sb.write("'" + key + "': '" + value + "'");
    });
    sb.write("}");
    replacementListString = sb.toString();
  }

  sb.write("import 'package:gc_wizard/logic/tools/crypto_and_encodings/vigenere_breaker/bigrams/bigrams.dart';\n");
  sb.write("\n");
  sb.write("class " + className + " extends Bigrams {\n");
  sb.write("\n");
  sb.write("  " + className + "() {\n");
  sb.write("\n");
  sb.write("    alphabet = '" + alphabet + "';\n");
  sb.write("    replacementList = " + replacementListString + ";\n");
  sb.write("    bigrams = " + bigramsListToString(bigrams, alphabet) + ";\n");
  sb.write("  }\n");
  sb.write("}\n");

  bigrams_fh.writeAsStringSync(sb.toString());

  if (bigrams == null || bigrams.length == 0)
    return VigenereBreakerResult(alphabet: alphabet, errorCode: VigenereBreakerErrorCode.WRONG_GENERATE_TEXT);
  else
    return VigenereBreakerResult(alphabet: alphabet, errorCode: VigenereBreakerErrorCode.OK);
}

String bigramsListToString(List<List<int>> bigrams, String alphabet) {
  var sb = new StringBuffer();
  var idx = 0;
  bool first = true;
  String out = '';

  sb.write("[");
  sb.write("\n");

  sb.write('  //');
  alphabet.split('').forEach((char) {
    sb.write(char.toUpperCase().padLeft(8));
  });
  sb.write("\n");

  bigrams.forEach((row) {
    sb.write("    [");
    first = true;
    row.forEach((val) {
      if (first)
        first = false;
      else
        sb.write(',');
      if (val == null) val = 0;
      out = val.toString().padLeft(7);
      sb.write(out);
    });
    sb.write(" ],");
    sb.write(" //");
    sb.write(alphabet[idx].toUpperCase());
    sb.write("\n");
    idx += 1;
  });
  sb.write("    ]");

  return sb.toString();
}

Map<String, int> _fillSourceList(File source_fh) {
  var list = Map<String, int>();
  String text = source_fh.readAsStringSync();

  RegExp regExp = new RegExp(r"(\S\S)(\s)([0-9]*)");
  Iterable<Match> matches = regExp.allMatches(text);
  for (Match match in matches) {
    list.addAll({match.group(1).toLowerCase(): int.tryParse(match.group(3))});
  }
  return list;
}

Map<String, int> _replaceBigramEntrys(
    Map<String, int> bigramsSource, String alphabet, Map<String, String> replacementList) {
  if (replacementList == null || replacementList.length == 0) return bigramsSource;

  for (var i = bigramsSource.length - 1; i >= 0; i--) {
    if (replacementList.keys.contains(bigramsSource.keys.elementAt(i)[0]) ||
        replacementList.keys.contains(bigramsSource.keys.elementAt(i)[1])) {
      var entry = substitution(bigramsSource.keys.elementAt(i), replacementList);
      var lastKey = '';
      for (var x = 0; x < entry.length - 1; x++) {
        var key = entry[x] + entry[x + 1];
        if (bigramsSource.containsKey(key)) {
          if (lastKey != key) bigramsSource[key] += bigramsSource.values.elementAt(i);
          lastKey = key;
        } else
          print("Error generate bigram: " + entry + " ->" + key + ' (missing key)');
      }
      bigramsSource.remove(bigramsSource.keys.elementAt(i));
    }
  }
  return bigramsSource;
}

List<List<int>> _fillBigramArray(Map<String, int> bigramsSource, String alphabet) {
  var bigrams = List<List<int>>(alphabet.length);

  for (var row = 0; row < bigrams.length; row++) bigrams[row] = List.filled(bigrams.length, 0);

  bigramsSource.forEach((key, value) {
    var row = _charIndex(key[0], alphabet);
    var column = _charIndex(key[1], alphabet);
    if ((row >= 0) && (column >= 0))
      bigrams[row][column] += value;
    else
      print("Error generate bigram: " + key + ' (bigram not valid)');
  });
  return bigrams;
}

List<List<int>> _scaleBigramsX(List<List<int>> bigrams) {
  double quadgram_sum = 0;
  double quadgram_min = 10000000;

  List<List<double>> _bigrams = List<List<double>>();
  for (var row = 0; row < bigrams.length; row++) {
    _bigrams.add(List<double>(bigrams[row].length));
    for (var column = 0; column < bigrams[row].length; column++) {
      _bigrams[row][column] = bigrams[row][column].toDouble();
    }
  }

  for (var row = 0; row < _bigrams.length; row++) {
    for (var column = 0; column < _bigrams[row].length; column++) {
      if (_bigrams[row][column] != 0) {
        quadgram_sum += _bigrams[row][column];
        quadgram_min = min(quadgram_min, _bigrams[row][column]);
      }
    }
    ;
  }
  ;
  var offset = log(quadgram_min / 10 / quadgram_sum);

  double prop = 0;
  double new_val = 0;
  double norm = 0;

  for (var row = 0; row < _bigrams.length; row++) {
    for (var column = 0; column < _bigrams[row].length; column++) {
      if (_bigrams[row][column] != 0) {
        prop = _bigrams[row][column] / quadgram_sum; // in Prozent
        new_val = log(prop) - offset;
        _bigrams[row][column] = new_val;
        norm += prop * new_val;
      }
    }
    ;
  }
  ;

  for (var row = 0; row < _bigrams.length; row++) {
    for (var column = 0; column < _bigrams[row].length; column++) {
      if (_bigrams[row][column] != 0) _bigrams[row][column] = (_bigrams[row][column] / norm * 1000);
    }
    ;
  }
  ;

  for (var row = 0; row < bigrams.length; row++) {
    for (var column = 0; column < bigrams[row].length; column++) {
      bigrams[row][column] = _bigrams[row][column].floor();
    }
  }

  return bigrams;
}

List<List<int>> _scaleBigrams(List<List<int>> bigrams) {
  const int maximum = 1000000;
  var minValue = maximum;
  var maxValue = 0;
  var sum = 0;

  for (var row = 0; row < bigrams.length; row++) {
    for (var column = 0; column < bigrams[row].length; column++) {
      if (bigrams[row][column] == 0) bigrams[row][column] = 1;

      maxValue = max(maxValue, bigrams[row][column]);
      minValue = min(minValue, bigrams[row][column]);
      sum += bigrams[row][column];
    }
    ;
  }
  ;

  var minValueD = log(minValue / sum);
  var maxValueD = log(maxValue / sum);
  var scale = maximum / (maxValueD - minValueD);

  for (var row = 0; row < bigrams.length; row++) {
    for (var column = 0; column < bigrams.length; column++) {
      bigrams[row][column] = ((log(bigrams[row][column] / sum) - minValueD) * scale).floor();
    }
  }
  return bigrams;
}

int _charIndex(String char, String alphabet) {
  int index = -1;

  char = char[0].toLowerCase();
  index = alphabet.indexOf(char);
  if (index >= 0)
    return index;
  else
    return -1;
}
