import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/nonogram/logic/push_solver.dart';

void main() {
  group("Nonogram.push_left:",() {
    List<Map<String,Object?>> _inputsToExpected = [
      {// works with a single hint on an empty line
        'line': [0, 0, 0, 0, 0],
        'hints': [3],
        'expectedOutput':  [1, 1, 1, 0, 0],
      },
      {
        'line': [0, 0, 0],
        'hints': [3],
        'expectedOutput': [1, 1, 1],
      },
      {
        'line': [0, 0],
        'hints': [3],
        'expectedOutput': null,
      },
      {// works with multiple hints on an empty line
        'line': [0, 0, 0, 0, 0],
        'hints': [1, 2],
        'expectedOutput': [1, 0, 1, 1, 0],
      },
      {
        'line':  [0, 0, 0, 0, 0, 0, 0, 0],
        'hints': [3, 1, 1],
        'expectedOutput': [1, 1, 1, 0, 1, 0, 1, 0],
      },
      {
        'line': [0, 0, 0, 0],
        'hints': [2, 2],
        'expectedOutput': null,
      },
      {// works with a single hint on a partially filled line
        'line': [0, 1, 0, 0, 0],
        'hints': [3],
        'expectedOutput': [1, 1, 1, 0, 0],
      },
      {
        'line': [0, 1, 0],
        'hints': [3],
        'expectedOutput': [1, 1, 1],
      },
      {
        'line': [0, 0, 0, 1, 0, 0],
        'hints': [3],
        'expectedOutput':  [0, 1, 1, 1, 0, 0],
      },
      {
        'line': [0, 1, 0, 1, 0, 0],
        'hints': [2],
        'expectedOutput' : null,
      },
      {// complicated case, one gap
        'line': [0, 0, 0, 1, 1, 0],
        'hints': [3],
        'expectedOutput' : [0, 0, 1, 1, 1, 0],
      },
      {
        'line': [0, 0, 1, 0, 1, 0],
        'hints': [4],
        'expectedOutput': [0, 1, 1, 1, 1, 0],
      },
      {
        'line': [0, 1],
        'hints': [3],
        'expectedOutput': null,
      },
      {
        'line': [1, 0, 1, 0, 1, 0, 1],
        'hints': [2],
        'expectedOutput': null,
      },
      {// works with multiple hints on a partially filled line
        'line': [0, 1, 0, 0, 0],
        'hints': [3, 1],
        'expectedOutput': [1, 1, 1, 0, 1],
      },
      {
        'line': [0, 1, 0, 1, 0, 1],
        'hints': [3, 1],
        'expectedOutput': [0, 1, 1, 1, 0, 1],
      },
      {
        'line': [0, 0, 0, 1, 1, 0, 0, 0, 0],
        'hints': [2, 3, 1],
        'expectedOutput': [1, 1, 0, 1, 1, 1, 0, 1, 0],
      },
      {
        'line': [0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0],
        'hints': [3, 3, 1],
        'expectedOutput': [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0],
      },
      {
        'line':  [0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1],
        'hints': [3, 3, 1],
        'expectedOutput': null,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('line: ${elem['line']},hints: ${elem['hints']}',() {
        var _actual = pushSolver.pushLeft(elem['line'] as List<int>, elem['hints'] as List<int>);

        expect(_actual ,elem['expectedOutput']);
      });
    }
  });


  group("Nonogram.push_solver:",() {
    List<Map<String,Object?>> _inputsToExpected = [
      {//'with gaps, works with one gap and occupation
        'line':  [0, 0, -1, 0, 1],
        'hints': [1],
        'expectedOutput': [-1, -1, -1, -1, 1],
      },
      {//'without gaps, works with empty line and one hint
        'line':  [0, 0, 0, 0, 0],
        'hints': [3],
        'expectedOutput': [0, 0, 1, 0, 0],
      },
      {
        'line':  [0, 0, 0, 0, 0],
        'hints': [4],
        'expectedOutput': [0, 1, 1, 1, 0],
      },
      {
        'line':  [0, 0, 0, 0, 0],
        'hints': [5],
        'expectedOutput': [1, 1, 1, 1, 1],
      },
      {
        'line':  [0, 0, 0, 0, 0],
        'hints': [2],
        'expectedOutput': [0, 0, 0, 0, 0],
      },
      {// works with empty line and multiple hints
        'line':  [0, 0, 0, 0, 0, 0],
        'hints':  [2, 2],
        'expectedOutput': [0, 1, 0, 0, 1, 0],
      },
      {// works with empty line and multiple hints
        'line':  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        'hints': [4, 1, 1],
        'expectedOutput': [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
      },
      {
        'line': [0, 0, 0, 0, 0, 0],
        'hints': [2, 1],
        'expectedOutput': [0, 0, 0, 0, 0, 0],
      },
      {// works with partially filled line and one hint
        'line': [0, 1, 0, 0, 0, 0],
        'hints': [3],
        'expectedOutput': [0, 1, 1, 0, -1, -1],
      },
      {
        'line': [1, 0, 0, 0, 0],
        'hints': [3],
        'expectedOutput': [1, 1, 1, -1, -1],
      },
      {
        'line': [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        'hints': [4],
        'expectedOutput': [-1, 0, 0, 0, 1, 0, 0, 0, -1, -1],
      },
      {
        'line': [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
        'hints': [4],
        'expectedOutput': [-1, -1, -1, 0, 1, 1, 1, 0, -1, -1],
      },
      {// works with partially filled line and multiple hints
        'line': [0, 1, 0, 0, 0, 0, 1, 0],
        'hints': [3, 3],
        'expectedOutput': [0, 1, 1, 0, 0, 1, 1, 0],
      },
      {
        'line': [0, 1, 0, 0, 0, 1, 0],
        'hints': [3, 3],
        'expectedOutput': [1, 1, 1, -1, 1, 1, 1],
      },
      {
        'line': [1, 0, 0, 0, 0, 1],
        'hints': [3, 2],
        'expectedOutput': [1, 1, 1, -1, 1, 1],
      },
      {
        'line': [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        'hints': [4, 1],
        'expectedOutput': [-1, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      },
      {
        'line': [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
        'hints': [4, 2],
        'expectedOutput': [-1, 0, 0, 1, 1, 0, 1, 0, 0, 0],
      },
      {// with gaps, works with one gap and some occupation and one hint
        'line': [0, 0, -1, 0, 1],
        'hints': [1],
        'expectedOutput': [-1, -1, -1, -1, 1],
      },
      {// works with multiple gaps and some occupation and multiple hints
        'line': [0, 0, 0, -1, 1, 0, 0, -1, 0, 0, 0],
        'hints': [3, 1, 3],
        'expectedOutput': [1, 1, 1, -1, 1, -1, -1, -1, 1, 1, 1],
      },
      {// works with multiple gaps and some occupation and multiple hints 2
        'line': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0],
        'hints': [2, 3, 7],
        'expectedOutput': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0],
      },
      {// works with multiple gaps and some occupation and multiple hints 3
        'line': [-1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, -1, -1, 1, 1, -1, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 1, -1],
        'hints': [14, 1, 2, 2, 1, 1],
        'expectedOutput': [-1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 0, 0, -1, -1, 1, 1, -1, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 1, -1],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('line: ${elem['line']},hints: ${elem['hints']}',() {
        var _actual = pushSolver().solve(elem['line'] as List<int>, elem['hints'] as List<int>);

        expect(_actual ,elem['expectedOutput']);
      });
    }
  });
}