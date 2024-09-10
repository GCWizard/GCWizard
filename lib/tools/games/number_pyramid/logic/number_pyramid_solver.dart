import 'dart:math';

import 'package:gc_wizard/tools/games/number_pyramid/logic/external_libs/dennistreysa/pyramid.dart';

enum NumberPyramidFillType { USER_FILLED, CALCULATED }

class NumberPyramidBoardValue {
  NumberPyramidFillType type;
  int? value;

  NumberPyramidBoardValue(this.value, this.type);
}

class NumberPyramid {
  late List<List<NumberPyramidBoardValue?>> pyramid;
  List<_NumberPyramidSolution>? solutions;
  int rowCount = 1;

  NumberPyramid(this.rowCount, {NumberPyramid? pyramid, List<List<int?>>? pyramidList}) {
    if (pyramidList != null) {
      rowCount = pyramidList.length;
    }
    rowCount = max(1, rowCount);

    this.pyramid = List<List<NumberPyramidBoardValue?>>.generate(
        rowCount, (index) => List<NumberPyramidBoardValue?>.generate(index + 1, (index) => null));

    if (pyramid != null) {
      for (var layer = 0; layer < min(pyramid.getRowsCount(), rowCount); layer++) {
        for (var brick = 0; brick < this.pyramid[layer].length; brick++) {
          if (pyramid.pyramid[layer][brick] != null) {
            setValue(brick, layer, pyramid.getValue(brick, layer),
                pyramid.getFillType(brick, layer) ?? NumberPyramidFillType.CALCULATED);
          }
        }
      }
    } else if (pyramidList != null) {
      for (var layer = 0; layer < min(pyramidList.length, rowCount); layer++) {
        for (var brick = 0; brick < min(pyramidList[layer].length, this.pyramid[layer].length); brick++) {
          if (pyramidList[layer][brick] != null) {
            setValue(brick, layer, pyramidList[layer][brick], NumberPyramidFillType.USER_FILLED);
          }
        }
      }
    }
  }

  int getRowsCount() {
    return rowCount;
  }

  int getColumnsCount(int row) {
    return row + 1;
  }

  int? getValue(int x, int y) {
    if (!validPosition(x, y) || pyramid[y][x] == null) {
      return null;
    }
    return pyramid[y][x]?.value;
  }

  /// return value changed
  bool setValue(int x, int y, int? value, NumberPyramidFillType type) {
    int? oldValue;
    bool valueChanged = false;
    if (!validPosition(x, y)) return false;

    oldValue = getValue(x, y);
    if (value != oldValue) {
      valueChanged = true;
    }

    pyramid[y][x] = NumberPyramidBoardValue(value, type);

    return valueChanged;
  }

  NumberPyramidFillType? getFillType(int x, int y) {
    if (!validPosition(x, y)) return null;

    return (pyramid[y][x] == null || pyramid[y][x]!.type == NumberPyramidFillType.CALCULATED)
        ? NumberPyramidFillType.CALCULATED
        : NumberPyramidFillType.USER_FILLED;
  }

  bool validPosition(int x, int y) {
    return !(y < 0 || y >= pyramid.length || x < 0 || x >= pyramid[y].length);
  }

  void solvePyramid(int maxSolutions) {
    var solutions = solve(_solveableBoard(), maxSolutions: maxSolutions);
    if (solutions == null) {
      this.solutions = null;
      return;
    }

    this.solutions = solutions.map((solution) => _NumberPyramidSolution(solution)).toList();
  }

  List<List<int?>> _solveableBoard() {
    var _pyramid = <List<int?>>[];
    for (var y = 0; y < pyramid.length; y++) {
      var row = <int?>[];
      for (var x = 0; x < pyramid[y].length; x++) {
        row.add(getFillType(x, y) == NumberPyramidFillType.USER_FILLED ? getValue(x, y) : null);
      }
      _pyramid.add(row);
    }
    return _pyramid;
  }

  void removeCalculated() {
    for (var y = 0; y < pyramid.length; y++) {
      for (var x = 0; x < pyramid[y].length; x++) {
        if (getFillType(x, y) == NumberPyramidFillType.CALCULATED) {
          setValue(x, y, null, NumberPyramidFillType.CALCULATED);
        }
      }
    }
  }

  void mergeSolution(int solutionIndex) {
    if (solutions == null || solutionIndex < 0 || solutionIndex >= solutions!.length) return;
    for (var y = 0; y < pyramid.length; y++) {
      for (var x = 0; x < pyramid[y].length; x++) {
        if (getFillType(x, y) == NumberPyramidFillType.USER_FILLED) continue;
        setValue(x, y, solutions![solutionIndex].getValue(x, y), NumberPyramidFillType.CALCULATED);
      }
    }
  }
}

class _NumberPyramidSolution {
  final List<List<int?>> solution;

  _NumberPyramidSolution(this.solution);

  int? getValue(int x, int y) {
    if (y < 0 || y >= solution.length || x < 0 || x >= solution[y].length) return null;
    return solution[y][x];
  }
}
