import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:gc_wizard/utils/string_utils.dart' as strUtils;

const _emptyChar = '\t';
final _nonBreakingSpace = String.fromCharCode(0160);

enum FillGapMode { OFF, DOWN, TOP, LEFT, RIGHT }

enum SearchDirectionFlags {
  HORIZONTAL,
  VERTICAL,
  DIAGONAL,
  REVERSE;

  static bool hasFlag(int value, SearchDirectionFlags flag) {
    return value & (1 << flag.index) != 0;
  }

  static int setFlag(int value, SearchDirectionFlags flag) {
    return value | (1 << flag.index);
  }

  static int resetFlag(int value, SearchDirectionFlags flag) {
    return value & ~(1 << flag.index);
  }
}

String _normalizeInput(String text, bool noSpaces) {
  text = text.replaceAll(RegExp(r'[' + r'\f\t' + (noSpaces ? ' ]' : ']')), '');
  var lines = _splitLines(text);
  lines.removeWhere((line) => line.trim().isEmpty);
  return lines.join('\r\n');
}

List<String> normalizeAndSplitInputForView(String text, {bool noSpaces = true}) {
  var lines = _splitLines(_normalizeInput(text, noSpaces));
  var maxRowLength = _maxRowLength(lines);
  lines = lines.map((line) => _fillupLine(line, maxRowLength).replaceAll(_emptyChar, _nonBreakingSpace)).toList();
  return lines;
}

List<String> _splitLines(String text) {
  return const LineSplitter().convert(text);
}

List<Uint8List> searchWordList(String text, String wordList, int searchDirection, {bool noSpaces = true}) {
  if (text.isEmpty) return [];

  text = _normalizeInput(text.toUpperCase(), noSpaces);
  wordList = wordList.replaceAll(RegExp(r'\s'), '\n');
  var wordLines = _splitLines(wordList.toUpperCase());
  wordLines.removeWhere((line) => line.isEmpty);

  var result = _buildResultMatrix(text);
  if ((SearchDirectionFlags.hasFlag(searchDirection, SearchDirectionFlags.HORIZONTAL))) {
    result = _combineResultMatrix(result, _searchHorizontal(text, wordLines));
    if ((SearchDirectionFlags.hasFlag(searchDirection, SearchDirectionFlags.REVERSE))) {
      result = _combineResultMatrix(result, _searchHorizontalReverse(text, wordLines));
    }
  }
  if ((SearchDirectionFlags.hasFlag(searchDirection, SearchDirectionFlags.VERTICAL))) {
    result = _combineResultMatrix(result, _searchVertical(text, wordLines));
    if ((SearchDirectionFlags.hasFlag(searchDirection, SearchDirectionFlags.REVERSE))) {
      result = _combineResultMatrix(result, _searchVerticalReverse(text, wordLines));
    }
  }
  if ((SearchDirectionFlags.hasFlag(searchDirection, SearchDirectionFlags.DIAGONAL))) {
    result = _combineResultMatrix(result, _searchDiagonalLR(text, wordLines));
    result = _combineResultMatrix(result, _searchDiagonalRL(text, wordLines));
    if ((SearchDirectionFlags.hasFlag(searchDirection, SearchDirectionFlags.REVERSE))) {
      result = _combineResultMatrix(result, _searchDiagonalReverseLR(text, wordLines));
      result = _combineResultMatrix(result, _searchDiagonalReverseRL(text, wordLines));
    }
  }
  return result;
}

List<Uint8List> _searchWords(String text, List<String> wordList, int id) {
  var matrix = _buildResultMatrix(text);
  var regex = RegExp('(' + wordList.join('|') + ')');

  _splitLines(text).forEachIndexed((index, line) {
    var matches = regex.allMatches(line);
    for (var match in matches) {
      matrix[index] = _setResults(matrix[index], match.start, match.end, id);
    }
  });
  return matrix;
}

List<Uint8List> _searchHorizontal(String text, List<String> wordList) {
  return _searchWords(text, wordList, SearchDirectionFlags.setFlag(0, SearchDirectionFlags.HORIZONTAL));
}

List<Uint8List> _searchHorizontalReverse(String text, List<String> wordList) {
  return _searchHorizontal(text, _reversedWordList(wordList));
}

List<Uint8List> _searchVertical(String text, List<String> wordList) {
  var lines = _splitLines(text);
  var maxRowLength = _maxRowLength(lines);
  var verticalText = List<String>.generate(maxRowLength, (index) => '');

  for (var line in lines) {
    line = _fillupLine(line, maxRowLength);
    line.split('').forEachIndexed((columnIndex, char) {
      verticalText[columnIndex] += char;
    });
  }

  var result =
      _searchWords(verticalText.join('\n'), wordList, SearchDirectionFlags.setFlag(0, SearchDirectionFlags.VERTICAL));
  var matrix = _buildResultMatrix(text);

  lines.forEachIndexed((rowIndex, line) {
    line.split('').forEachIndexed((columnIndex, char) {
      matrix[rowIndex][columnIndex] = result[columnIndex][rowIndex];
    });
  });

  return matrix;
}

List<Uint8List> _searchVerticalReverse(String text, List<String> wordList) {
  return _searchVertical(text, _reversedWordList(wordList));
}

List<Uint8List> _searchDiagonalLR(String text, List<String> wordList) {
  var lines = _splitLines(text);
  int maxRowLength = _maxRowLength(lines);
  var diagonalText = List<String>.generate(_getDiagonalRowIndexLR(lines.length, 0, maxRowLength), (index) => '');
  var diagonalTextMap = List<List<Point<int>>>.generate(diagonalText.length, (index) => <Point<int>>[]);

  lines.forEachIndexed((rowIndex, line) {
    line = _fillupLine(line, maxRowLength);
    line.split('').forEachIndexed((columnIndex, char) {
      var row = _getDiagonalRowIndexLR(rowIndex, columnIndex, maxRowLength);
      diagonalTextMap[row].add(Point<int>(columnIndex, rowIndex));
      diagonalText[row] += char;
    });
  });

  var result =
      _searchWords(diagonalText.join('\n'), wordList, SearchDirectionFlags.setFlag(0, SearchDirectionFlags.DIAGONAL));

  return _buildDiagonalResultMatrix(text, result, diagonalTextMap);
}

List<Uint8List> _searchDiagonalReverseLR(String text, List<String> wordList) {
  return _searchDiagonalLR(text, _reversedWordList(wordList));
}

List<Uint8List> _searchDiagonalRL(String text, List<String> wordList) {
  var lines = _splitLines(text);
  int maxRowLength = _maxRowLength(lines);
  var diagonalText =
      List<String>.generate(_getDiagonalRowIndexRL(lines.length - 1, maxRowLength, maxRowLength), (index) => '');
  var diagonalTextMap = List<List<Point<int>>>.generate(diagonalText.length, (index) => <Point<int>>[]);

  lines.forEachIndexed((rowIndex, line) {
    line = _fillupLine(line, maxRowLength);
    line.split('').forEachIndexed((columnIndex, char) {
      var row = _getDiagonalRowIndexRL(rowIndex, columnIndex, maxRowLength);
      diagonalTextMap[row].add(Point<int>(columnIndex, rowIndex));
      diagonalText[row] += char;
    });
  });

  var result =
      _searchWords(diagonalText.join('\n'), wordList, SearchDirectionFlags.setFlag(0, SearchDirectionFlags.DIAGONAL));

  return _buildDiagonalResultMatrix(text, result, diagonalTextMap);
}

List<Uint8List> _searchDiagonalReverseRL(String text, List<String> wordList) {
  return _searchDiagonalRL(text, _reversedWordList(wordList));
}

List<Uint8List> _buildDiagonalResultMatrix(
    String text, List<Uint8List> result, List<List<Point<int>>> diagonalTextMap) {
  var matrix = _buildResultMatrix(text);

  result.forEachIndexed((rowIndex, line) {
    line.forEachIndexed((columnIndex, value) {
      var cell = diagonalTextMap[rowIndex][columnIndex];
      if (matrix.length > cell.y && matrix[cell.y].length > cell.x) {
        matrix[cell.y][cell.x] = value;
      }
    });
  });
  return matrix;
}

int _getDiagonalRowIndexLR(int rowIndex, int columnIndex, int columnCount) {
  return columnIndex - rowIndex >= 0 ? columnIndex - rowIndex : columnCount - (columnIndex - rowIndex) - 1;
}

int _getDiagonalRowIndexRL(int rowIndex, int columnIndex, int columnCount) {
  return rowIndex + columnIndex;
}

String _fillupLine(String line, int maxRowLength) {
  if (line.length < maxRowLength) {
    for (var columnIndex = line.length; columnIndex < maxRowLength; columnIndex++) {
      line += _emptyChar;
    }
  }
  return line;
}

int _maxRowLength(List<String> lines) {
  int maxRowLength = 0;
  for (var line in lines) {
    maxRowLength = max(maxRowLength, line.length);
  }
  return maxRowLength;
}

List<String> _reversedWordList(List<String> wordList) {
  return wordList.map((word) => strUtils.reverse(word)).toList();
}

Uint8List _setResults(Uint8List line, int start, int end, int value) {
  line.setRange(start, end, List<int>.generate(end - start, (index) => value));
  return line;
}

List<Uint8List> _combineResultMatrix(List<Uint8List> baseMatrix, List<Uint8List> newMatrix) {
  for (var row = 0; row < min(baseMatrix.length, newMatrix.length); row++) {
    for (var column = 0; column < min(baseMatrix[row].length, newMatrix[row].length); column++) {
      baseMatrix[row][column] = baseMatrix[row][column] | newMatrix[row][column];
    }
  }
  return baseMatrix;
}

List<Uint8List> _buildResultMatrix(String text) {
  var matrix = <Uint8List>[];

  _splitLines(text).forEach((line) {
    matrix.add(Uint8List(line.length));
  });
  return matrix;
}

List<String> fillSpaces(String text, List<Uint8List> markedMatrix, FillGapMode mode) {
  var lines = _splitLines(_normalizeInput(text, false));

  lines = _deleteMarkedLetters(lines, markedMatrix);
  switch (mode) {
    case FillGapMode.DOWN:
      lines = _fillGapModeDown(lines);
      break;
    case FillGapMode.TOP:
      lines = _fillGapModeTop(lines);
      break;
    case FillGapMode.RIGHT:
      _fillGapModeRight(lines);
      break;
    case FillGapMode.LEFT:
      lines = _fillGapModeLeft(lines);
      break;
    default:
      break;
  }

  return lines;
}

List<String> _deleteMarkedLetters(List<String> lines, List<Uint8List> markedMatrix) {
  for (var row = lines.length - 1; row >= 0; row--) {
    for (var column = 0; column < lines[row].length; column++) {
      if (row < markedMatrix.length && column < markedMatrix[row].length && markedMatrix[row][column] != 0) {
        lines[row] = lines[row].replaceRange(column, column + 1, _nonBreakingSpace);
      }
    }
  }
  return lines;
}

List<String> _fillGapModeDown(List<String> lines) {
  for (var row = lines.length - 1; row > 0; row--) {
    for (var column = 0; column < lines[row].length; column++) {
      var counter = 0;
      while (lines[row][column] == _nonBreakingSpace && counter < row) {
        counter++;
        lines = _fillGap(lines, row, column, row - counter, column);
      }
    }
  }
  return lines;
}

List<String> _fillGapModeTop(List<String> lines) {
  for (var row = 0; row < lines.length - 1; row++) {
    for (var column = 0; column < lines[row].length; column++) {
      var counter = 0;
      while (lines[row][column] == _nonBreakingSpace && counter < lines.length - row) {
        counter++;
        lines = _fillGap(lines, row, column, row + counter, column);
      }
    }
  }
  return lines;
}

List<String> _fillGapModeRight(List<String> lines) {
  for (var row = 0; row < lines.length; row++) {
    for (var column = lines[row].length - 1; column > 0; column--) {
      var counter = 0;
      while (lines[row][column] == _nonBreakingSpace && counter < column) {
        counter++;
        lines = _fillGap(lines, row, column, row, column - counter);
      }
    }
  }
  return lines;
}

List<String> _fillGapModeLeft(List<String> lines) {
  for (var row = 0; row < lines.length; row++) {
    for (var column = 0; column < lines[row].length - 1; column++) {
      var counter = 0;
      while (lines[row][column] == _nonBreakingSpace && counter < lines[row].length - column) {
        counter++;
        lines = _fillGap(lines, row, column, row, column + counter);
      }
    }
  }
  return lines;
}

List<String> _fillGap(List<String> lines, int row, int column, int row2, int column2) {
  if (_isValidPosition(lines, row, column) && _isValidPosition(lines, row2, column2)) {
    lines[row] = lines[row].replaceRange(column, column + 1, lines[row2][column2]);
    lines[row2] = lines[row2].replaceRange(column2, column2 + 1, _nonBreakingSpace);
  }
  return lines;
}

bool _isValidPosition(List<String> lines, int row, int column) {
  return (row >= 0 && row < lines.length && column >= 0 && column < lines[row].length);
}
