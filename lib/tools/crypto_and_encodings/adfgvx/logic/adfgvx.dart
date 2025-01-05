import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/transposition.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum _ADFGVXMode { ADFGX, ADFGVX }

class ADFGVXReturnType {
  String? output;
  String? polybiosGrid;

  ADFGVXReturnType({this.output, this.polybiosGrid});
}

ADFGVXReturnType? encryptADFGX(String input, String substitutionKey, String transpositionKey,
    {PolybiosMode polybiosMode = PolybiosMode.ZA90, String? alphabet}) {
  return _encrypt(input, substitutionKey, transpositionKey, _ADFGVXMode.ADFGX, polybiosMode, alphabet);
}

ADFGVXReturnType? encryptADFGVX(String input, String substitutionKey, String transpositionKey,
    {PolybiosMode polybiosMode = PolybiosMode.ZA90, String? alphabet}) {
  return _encrypt(input, substitutionKey, transpositionKey, _ADFGVXMode.ADFGVX, polybiosMode, alphabet);
}

ADFGVXReturnType? _encrypt(String input, String substitutionKey, String transpositionKey, _ADFGVXMode mode,
    PolybiosMode polybiosMode, String? alphabet) {
  if (input.isEmpty) return ADFGVXReturnType(output: '');

  var adfgvxMode = mode.toString().split('.')[1]; //mode.toString() == _ADFGVX.ADFGX
  alphabet = createPolybiosAlphabet(adfgvxMode.length,
      firstLetters: substitutionKey, mode: polybiosMode, fillAlphabet: alphabet);
  if (alphabet == null) return null;

  var polybiosOutput = encryptPolybios(input, adfgvxMode, mode: PolybiosMode.CUSTOM, fillAlphabet: alphabet);
  if (polybiosOutput == null) return null;

  var polybiosEncoded = polybiosOutput.output.replaceAll(' ', '');
  if (transpositionKey.isEmpty) {
    return ADFGVXReturnType(
        output: insertSpaceEveryNthCharacter(polybiosEncoded, 5), polybiosGrid: polybiosOutput.grid);
  }

  transpositionKey = transpositionKey.toUpperCase();

  var matrix = createTranspositionMatrix(polybiosEncoded, TranspositionMatrixFillMode.encryption,
      countColumns: transpositionKey.length);
  if (matrix == null) return null;

  var transpositionKeySorted = transpositionKey.split('');
  transpositionKeySorted.sort();

  var newIndexes = List<int>.generate(transpositionKey.length, (_) => -1);
  transpositionKey.split('').asMap().forEach((index, character) {
    var characterPosition = transpositionKeySorted.indexOf(character);
    transpositionKeySorted[characterPosition] = String.fromCharCode(0);
    newIndexes[characterPosition] = index;
  });

  String out = '';
  for (int i = 0; i < newIndexes.length; i++) {
    for (var character in matrix[newIndexes[i]]) {
      out += character;
    }
  }

  return ADFGVXReturnType(output: insertSpaceEveryNthCharacter(out, 5), polybiosGrid: polybiosOutput.grid);
}

ADFGVXReturnType? decryptADFGX(String input, String substitutionKey, String transpositionKey,
    {PolybiosMode polybiosMode = PolybiosMode.ZA90, String? alphabet}) {
  return _decrypt(input, substitutionKey, transpositionKey, _ADFGVXMode.ADFGX, polybiosMode, alphabet);
}

ADFGVXReturnType? decryptADFGVX(String input, String substitutionKey, String transpositionKey,
    {PolybiosMode polybiosMode = PolybiosMode.ZA90, String? alphabet}) {
  return _decrypt(input, substitutionKey, transpositionKey, _ADFGVXMode.ADFGVX, polybiosMode, alphabet);
}

ADFGVXReturnType? _decrypt(String input, String substitutionKey, String transpositionKey, _ADFGVXMode mode,
    PolybiosMode polybiosMode, String? alphabet) {
  if (input.isEmpty) return null;

  input = input.toUpperCase().replaceAll(RegExp(r'\s*'), '');

  String? transposed;
  if (transpositionKey.isNotEmpty) {
    transpositionKey = transpositionKey.toUpperCase();

    var transpositionKeySorted = transpositionKey.split('');
    transpositionKeySorted.sort();

    var newIndexes = List<int>.generate(transpositionKey.length, (_) => -1);
    transpositionKey.split('').asMap().forEach((index, character) {
      var characterPosition = transpositionKeySorted.indexOf(character);
      transpositionKeySorted[characterPosition] = String.fromCharCode(0);
      newIndexes[index] = characterPosition;
    });

    var countColumns = transpositionKey.length;
    var countRows = (input.length / transpositionKey.length).ceil();
    List<List<String>> matrix = List.generate(countColumns, (_) => List<String>.filled(countRows, ''));

    int i = 0;
    for (int j = 0; j < newIndexes.length; j++) {
      var index = newIndexes.indexOf(j);
      var maxRow = countRows;

      var fillColumn = false;
      if ((countRows - 1) * countColumns + index + 1 > input.length) {
        maxRow -= 1;
        fillColumn = true;
      }

      var chunk = input.substring(i, i + maxRow);
      if (fillColumn) chunk += String.fromCharCode(0);

      matrix[index] = chunk.split('');
      i += maxRow;
    }

    transposed = '';
    for (int i = 0; i < countRows; i++) {
      for (int j = 0; j < countColumns; j++) {
        if (matrix[j][i] != String.fromCharCode(0)) transposed = transposed! + matrix[j][i];
      }
    }
  }

  transposed ??= input;

  var adfgvxMode = mode.toString().split('.')[1];
  alphabet = createPolybiosAlphabet(adfgvxMode.length,
      firstLetters: substitutionKey, mode: polybiosMode, fillAlphabet: alphabet);
  if (alphabet == null) return null;

  var polybiosOutput = decryptPolybios(transposed, adfgvxMode, mode: PolybiosMode.CUSTOM, fillAlphabet: alphabet);

  if (polybiosOutput == null) return null;

  return ADFGVXReturnType(output: polybiosOutput.output, polybiosGrid: polybiosOutput.grid);
}
