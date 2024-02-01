//source: https://github.com/sebbeobe/piet_message_generator

part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

var _blockHeight = 12;
var _blockWidth = 12;
const _minBlockSize = 5;

final int _white = _knownColors.elementAt(18);
final int _black = _knownColors.elementAt(19);
late _colorStack _currentColor;

enum Alignment { topLeft, topRight, bottomLeft, bottomRight }

DrawableImageData generatePiet(String input) {
  var result = <MapEntry<int, List<int>>>[];

  _setBlockSize(input);
  _currentColor = _colorStack();
  var i = 0;
  input.split('').forEach((char) {
    var block = _drawBlock(char.runes.first, i);
    i++;
    result.add(block);
  });
  result.add(_drawEndBlock(i));

  var arrangment = _calcOutputArrangement(result.length);

  var resultLines = <List<int>>[];
  var row = 0;
  var column = 0;
  var direction = Alignment.topRight;
  var nextDirection = Alignment.topRight;
  var pixelIndex = 0;
  int? firstPixelColor;

  for (var mapEntry in result) {
    var block = mapEntry.value;
    if (mapEntry == result.last) {
      if (direction == Alignment.bottomLeft) block = _reverseBlock(block, _blockWidth);
    }

    if (firstPixelColor != null) {
      pixelIndex = _searchFirstPixelIndex(block, direction);
      if (pixelIndex >= 0) block[pixelIndex] = firstPixelColor;
    } else if (mapEntry != result.first) {
      block = _removeLastPixel(block);
    }

    nextDirection = _getNextBlockDirection(row, column, arrangment);

    pixelIndex = _searchLastWhitePixelIndex(block, nextDirection);
    if (pixelIndex >= 0) {
      block[pixelIndex] = mapEntry.key;
      firstPixelColor = null;
    } else {
      firstPixelColor = mapEntry.key;
    }

    resultLines = _addBlockToResult(block, resultLines, row, direction == Alignment.topRight);

    if (nextDirection == Alignment.topRight) {
      column++;
    } else if (nextDirection == Alignment.bottomRight) {
      row++;
    } else if (nextDirection == Alignment.bottomLeft) {
      column--;
    } else if (nextDirection == Alignment.topLeft) {
      row--;
    }

    direction = nextDirection;
  }

  return _convertToImage(resultLines);
}

void _setBlockSize(String input) {
  var _max = input.isEmpty ? 0 : input.runes.reduce(max);
  _max = max(_minBlockSize, sqrt(_max + 1).ceil());
  _blockHeight = _max;
  _blockWidth = _max;
}

DrawableImageData _convertToImage(List<List<int>> resultLines) {
  var lines = <String>[];
  var colorMap = <String, int>{};
  var colorMapSwitched = <int, String>{};
  var mapList = switchMapKeyValue(alphabet_AZ);

  for (var i = 0; i < _knownColors.length; i++) {
    if (mapList[i + 1] != null) {
      colorMap.addAll({mapList[i + 1]!: (_knownColors.elementAt(i) | 0xFF000000)});
      colorMapSwitched.addAll({_knownColors.elementAt(i): mapList[i + 1]!});
    }
  }

  for (var line in resultLines) {
    var row = '';
    for (var color in line) {
      row += colorMapSwitched[color] ?? '';
    }
    lines.add(row);
  }

  return DrawableImageData(lines, colorMap, bounds: 0, pointSize: 1);
}

List<List<int>> _addBlockToResult(List<int> block, List<List<int>> resultLines, int row, bool append) {
  var lines = _splitToLines(block, _blockWidth);
  row *= _blockHeight;
  if (resultLines.isEmpty) return lines;

  while (resultLines.length < row + _blockHeight) {
    resultLines.add(<int>[]);
  }

  for (var i = row; i < row + _blockHeight; i++) {
    if (append) {
      resultLines[i].addAll(lines[i - row]);
    } else {
      resultLines[i].insertAll(0, lines[i - row]);
    }
  }
  return resultLines;
}

Alignment _getNextBlockDirection(int row, int column, List<List<int>> outputArrangement) {
  var index = outputArrangement[row][column] + 1;

  if ((column + 1 < outputArrangement[row].length) && (outputArrangement[row][column + 1] == index)) {
    return Alignment.topRight;
  } else if ((row + 1 < outputArrangement.length) && (outputArrangement[row + 1][column] == index)) {
    return Alignment.bottomRight;
  } else if ((column - 1 >= 0) && (outputArrangement[row][column - 1] == index)) {
    return Alignment.bottomLeft;
  } else if ((row - 1 >= 0) && (outputArrangement[row - 1][column] == index)) {
    return Alignment.topLeft;
  } else {
    return Alignment.topRight;
  }
}

List<List<int>> _calcOutputArrangement(int blockCount) {
  var sqr = sqrt(blockCount);
  var columnCount = blockCount <= 2
      ? 2
      : blockCount <= 4
          ? 2
          : sqr.ceil();
  columnCount = blockCount; //only 1 row
  var rowCount = (blockCount / columnCount).ceil();
  var lines = <List<int>>[];
  var direction = Alignment.topRight;
  var row = 0;
  var column = 0;

  for (var i = 0; i < rowCount; i++) {
    lines.add(List.filled(columnCount, -1));
  }

  for (var i = 0; i < rowCount * columnCount; i++) {
    lines[row][column] = i;

    if (direction == Alignment.topRight) {
      column++;
      if ((column >= columnCount) || (lines[row][column] != -1)) {
        direction = Alignment.bottomRight;
        row++;
        column--;
      }
    } else if (direction == Alignment.bottomRight) {
      row++;
      if ((row >= rowCount) || (lines[row][column] != -1)) {
        direction = Alignment.bottomLeft;
        row--;
        column--;
      }
    } else if (direction == Alignment.bottomLeft) {
      column--;
      if ((column < 0) || (lines[row][column] != -1)) {
        direction = Alignment.topLeft;
        row--;
        column++;
      }
    } else if (direction == Alignment.topLeft) {
      row--;
      if ((row < 0) || (lines[row][column] != -1)) {
        direction = Alignment.topRight;
        row++;
        column++;
      }
    }
  }

  return lines;
}

int _searchLastWhitePixelIndex(List<int> block, Alignment alignment) {
  int index;
  int index1;
  if (alignment == Alignment.topRight) {
    for (var i = _blockWidth - 2; i >= 0; i--) {
      index = _calcIndex(0, i, _blockWidth);
      index1 = _calcIndex(0, i + 1, _blockWidth);
      if ((block[index] != _white) && (block[index1] == _white)) {
        return index1;
      } else if ((block[index] != _white) && (block[index1] != _white)) {
        return -1;
      }
    }
    return _calcIndex(0, 0, _blockWidth);
  } else if (alignment == Alignment.bottomRight) {
    for (var i = _blockHeight - 2; i >= 0; i--) {
      index = _calcIndex(i, _blockWidth - 1, _blockWidth);
      index1 = _calcIndex(i + 1, _blockWidth - 1, _blockWidth);
      if ((block[index] != _white) && (block[index + 1] == _white)) {
        return index1;
      } else if ((block[index] != _white) && (block[index1] != _white)) {
        return -1;
      }
    }
    return _calcIndex(0, _blockWidth - 1, _blockWidth);
  } else if (alignment == Alignment.bottomLeft) {
    for (var i = 1; i < _blockWidth - 1; i--) {
      index = _calcIndex(_blockHeight - 1, i, _blockWidth);
      index1 = _calcIndex(_blockHeight - 1, i - 1, _blockWidth);
      if ((block[index] != _white) && (block[index1] == _white)) {
        return index1;
      } else if ((block[index] != _white) && (block[index1] != _white)) {
        return -1;
      }
    }
    return _calcIndex(0, _blockWidth - 1, _blockWidth);
  } else if (alignment == Alignment.topLeft) {
    for (var i = 1; i < _blockHeight - 1; i--) {
      index = _calcIndex(i, 0, _blockWidth);
      index1 = _calcIndex(i - 1, 0, _blockWidth);
      if ((block[index] != _white) && (block[index1] == _white)) {
        return index1;
      } else if ((block[index] != _white) && (block[index1] != _white)) {
        return -1;
      }
    }
    return _calcIndex(_blockHeight - 1, 0, _blockWidth);
  } else {
    return 0;
  }
}

int _searchFirstPixelIndex(List<int> block, Alignment alignment) {
  if (alignment == Alignment.topRight) {
    return _calcIndex(0, 0, _blockWidth);
  } else if (alignment == Alignment.bottomRight) {
    return _calcIndex(0, _blockWidth - 1, _blockWidth);
  } else if (alignment == Alignment.bottomLeft) {
    return _calcIndex(0, _blockWidth - 1, _blockWidth);
  } else if (alignment == Alignment.topLeft) {
    return _calcIndex(_blockHeight - 1, 0, _blockWidth);
  } else {
    return 0;
  }
}

List<int> _removeLastPixel(List<int> block) {
  var index = block.indexWhere((pixel) => pixel == _white);
  if (index >= 0) {
    var index1 = block.indexWhere((pixel) => (pixel != _white), index);
    if (index1 >= 0) block[index1] = _white;
  } else {
    block.last = _white;
  }

  return block;
}

MapEntry<int, List<int>> _drawBlock(int size, int num) {
  var block = List.filled(_blockHeight * _blockWidth, _white);

  if (num != 0) {
    _currentColor.writeOutputColor();
    size++;
  }

  var rem = size % _blockWidth;
  var rows = (size / _blockWidth).ceil();
  if (rows > 0) rows--;
  block.fillRange(0, _calcIndex(rows, _blockWidth, _blockWidth), _currentColor.RGB());

  if (rem != 0) {
    block.fillRange(_calcIndex(rows, 0, _blockWidth), _calcIndex(rows, _blockWidth - rem, _blockWidth), _white);
  }

  return MapEntry<int, List<int>>(_currentColor.pushColor(), block);
}

MapEntry<int, List<int>> _drawEndBlock(int num) {
  var block = List.filled(_blockHeight * _blockWidth, _white);

  block[_calcIndex(0, 1, 5)] = _currentColor.writeOutputColor();
  block[_calcIndex(0, 3, _blockWidth)] = _black;
  block[_calcIndex(1, 1, _blockWidth)] = _black;
  block[_calcIndex(1, 3, _blockWidth)] = _black;
  block[_calcIndex(2, 0, _blockWidth)] = _black;
  block.fillRange(_calcIndex(2, 1, _blockWidth), _calcIndex(2, 4, _blockWidth), _currentColor.writeOutputColor());
  block[_calcIndex(2, 4, _blockWidth)] = _black;
  block.fillRange(_calcIndex(3, 1, _blockWidth), _calcIndex(3, 4, _blockWidth), _black);

  return MapEntry<int, List<int>>(_white, block);
}

List<List<int>> _splitToLines(List<int> block, int width) {
  var lines = <List<int>>[];
  for (var i = 0; i < _blockHeight; i++) {
    lines.add(block.sublist(i * _blockWidth, (i + 1) * _blockWidth));
  }

  return lines;
}

List<int> _reverseBlock(List<int> block, int width) {
  var lines = _splitToLines(block, width);
  var result = <int>[];

  for (var line in lines) {
    result.addAll(line.reversed);
  }

  return result;
}

int _calcIndex(int row, int column, int width) {
  return row * width + column;
}

class _colorStack {
  final _colorTable = [1, 0];

  int RGB() {
    return _knownColors.elementAt(_colorTable[1] * 3 + _colorTable[0]);
  }

  int pushColor() {
    _colorTable[0] = (_colorTable[0] + 1) % 3;
    return RGB();
  }

  int writeOutputColor() {
    _colorTable[0] = (_colorTable[0] + 2) % 3;
    _colorTable[1] = (_colorTable[1] + 5) % 6;
    return RGB();
  }
}
