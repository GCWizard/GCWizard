import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/number_pyramid/logic/number_pyramid_solver.dart';

void main() {
  group("Sudoku.solve:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : [[null], [null, null], [3, null, 4], [null, 2, 2, null]],
        'expectedOutput' : [[15], [7, 8], [3, 4, 4], [1, 2, 2, 2]],
        'solutionCount': 1
      },
      {'input' : [[null], [null, null], [3, null, 4], [null, 2, null, null]],
        'expectedOutput' : [[11], [5, 6], [3, 2, 4], [1, 2, 0, 4]],
        'solutionCount': 5
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {

        var _actual = NumberPyramid(0, pyramidList: elem['input'] as List<List<int?>>);
        _actual.solvePyramid(10);
        expect(_actual.solutions?[0].solution, elem['expectedOutput']);
        expect(_actual.solutions?.length, elem['solutionCount']);
      });
    }
  });
}