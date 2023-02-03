import 'dart:math';

enum TranspositionMatrixFillMode { encryption, decryption }

List<List<String>> createTranspositionMatrix(String input, TranspositionMatrixFillMode fillMode,
    {int countRows, int countColumns, int countLettersPerCell: 1}) {
  if (input == null || input == '') return null;

  if (countRows == null && countColumns == null) return null;

  if (countLettersPerCell == null || countLettersPerCell <= 0) countLettersPerCell = 1;

  var necessaryCells = (input.length / countLettersPerCell).ceil();

  if (countColumns == null || countColumns < 1) {
    countRows = max(1, countRows ?? 1);
    countColumns = (necessaryCells / countRows).ceil(); //minimum columns for input length
  }

  if (countRows == null || countRows < 1) {
    countColumns = max(1, countColumns ?? 1);
    countRows = (necessaryCells / countColumns).ceil();
  }

  input = input.substring(
      0, min(input.length, countRows * countColumns * countLettersPerCell)); // if too few columns for text, trim text

  List<List<String>> matrix = List.generate(countColumns, (_) => List(countRows));

  int currentRow = 0;
  int currentColumn = 0;
  int i = 0;
  while (i < input.length) {
    if (currentRow * countColumns + currentColumn < necessaryCells) {
      var maxInputLengthInCurrentCell = (currentRow * countColumns + currentColumn + 1) * countLettersPerCell;

      var chunk;
      if (input.length - i < countLettersPerCell) {
        chunk = input.substring(i);
      } else if (input.length < maxInputLengthInCurrentCell)
        chunk = input.substring(i, i + countLettersPerCell - maxInputLengthInCurrentCell + input.length);
      else
        chunk = input.substring(i, i + countLettersPerCell);

      matrix[currentColumn][currentRow] = chunk;

      i += chunk.length;
    }

    if (fillMode == TranspositionMatrixFillMode.encryption) {
      currentColumn++;

      if (currentColumn >= countColumns) {
        currentColumn = 0;
        currentRow++;
      }
    } else {
      currentRow++;

      if (currentRow >= countRows) {
        currentRow = 0;
        currentColumn++;
      }
    }
  }

  return matrix;
}

String encryptTransposition(String input, {int countRows, int countColumns, int countLettersPerCell: 1}) {
  if (input == null || input.length == 0) return '';

  var matrix = createTranspositionMatrix(input, TranspositionMatrixFillMode.encryption,
      countColumns: countColumns, countRows: countRows, countLettersPerCell: countLettersPerCell);

  if (matrix == null) return ''; //TODO: Exception Handling

  var flattened = matrix.expand((column) => column).toList();
  flattened.removeWhere((element) => element == null);
  return flattened.join();
}

String decryptTransposition(String input, {int countRows, int countColumns, int countLettersPerCell: 1}) {
  if (input == null || input.length == 0) return '';

  var matrix = createTranspositionMatrix(input, TranspositionMatrixFillMode.decryption,
      countColumns: countColumns, countRows: countRows, countLettersPerCell: countLettersPerCell);

  if (matrix == null) return ''; //TODO: Exception Handling

  countColumns = matrix.length;
  countRows = matrix[0].length;

  var out = '';
  for (int i = 0; i < countRows; i++) {
    for (int j = 0; j < countColumns; j++) {
      if (matrix[j][i] != null) out += matrix[j][i];
    }
  }

  return out;
}
