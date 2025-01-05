import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/nonogram/logic/gap_distributor.dart';

void main() {
  group("Nonogram.gap_distributor:",() {
    List<Map<String,Object?>> _inputsToExpected = [
      {// works, one gap, one hint
        'line': [0, 0, 0, 0, 0],
        'hints': [2],
        'expectedOutputGaps': [[0, 5]], 'expectedOutputDistributions': [[[2]]],
      },
      {// two hints, one gap, one hint
        'line': [0, 0, 0, 0, 0],
        'hints': [2, 2],
        'expectedOutputGaps': [[0, 5]], 'expectedOutputDistributions': [[[2, 2]]],
      },
      {// works with short hint, one gap, one hint
        'line': [0, 0, 0, 0, -1, 0, 0, 0],
        'hints': [2],
        'expectedOutputGaps': [[0, 4], [5, 8]], 'expectedOutputDistributions': [[<int>[], [2]], [[2], <int>[]]],
      },
      {// works with long hint, one gap, one hint
        'line': [0, 0, -1, 0, 0, 0, -1, 0, 0, 0],
        'hints': [3],
        'expectedOutputGaps': [[0, 2], [3, 6], [7, 10]], 'expectedOutputDistributions': [[<int>[], <int>[], [3]], [<int>[], [3], <int>[]]],
      },
      {// works with 2,1, one gap, one hint
        'line': [0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0],
        'hints': [2, 1],
        'expectedOutputGaps': [[0, 5], [7, 12]], 'expectedOutputDistributions': [[<int>[], [2, 1]], [[2], [1]], [[2, 1], <int>[]]],
      },
      {// works with 2,2, one gap, one hint
        'line': [0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0],
        'hints': [2, 2],
        'expectedOutputGaps': [[0, 5], [7, 12]], 'expectedOutputDistributions': [[<int>[], [2, 2]], [[2], [2]], [[2, 2], <int>[]]],
      },
      {// works with 2,3, one gap, one hint
        'line': [0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0],
        'hints': [2, 3],
        'expectedOutputGaps': [[0, 5], [7, 12]], 'expectedOutputDistributions': [[[2], [3]]],
      },
      {// one hint, one gap, distributing in non-empty gap
        'line': [0, 0, 1, 0, 0],
        'hints': [2],
        'expectedOutputGaps': [[0, 5]], 'expectedOutputDistributions': [[[2]]],
      },
      {// two hints, one gap
        'line': [0, 1, 0, 0, 0],
        'hints': [2, 2],
        'expectedOutputGaps': [[0, 5]], 'expectedOutputDistributions': [[[2, 2]]],
      },
      {// works with impossible, one gap
        'line': [0, 0, 1, 0],
        'hints': [2, 2],
        'expectedOutputGaps' : null,
      },
      {// complicated case, one gap
      'line': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1],
      'hints': [2, 2],
      'expectedOutputGaps' : null,
      },
      {// multiple gaps, one gap
        'line': [0, 0, 0, 0, -1, 0, 1, 0],
        'hints': [2],
        'expectedOutputGaps': [[0, 4], [5, 8]], 'expectedOutputDistributions': [[<int>[], [2]]],
      },
      {// works with long hint, one gap
        'line': [0, 0, -1, 0, 1, 0, -1, 0, 0, 0],
        'hints': [3, 3],
        'expectedOutputGaps': [[0, 2], [3, 6], [7, 10]], 'expectedOutputDistributions': [[<int>[], [3], [3]]],
      },
      {// two hints, one gap
        'line': [0, 0, 1, 0, 0, -1, -1, 0, 0, 0, 0, 0],
        'hints': [2, 1],
        'expectedOutputGaps': [[0, 5], [7, 12]], 'expectedOutputDistributions': [[[2], [1]], [[2, 1], <int>[]]],
      },
      {// works with 2,2, one gap
        'line': [0, 1, 0, 0, 0, -1, -1, 0, 0, 0, 1, 0],
        'hints': [2, 2],
        'expectedOutputGaps': [[0, 5], [7, 12]], 'expectedOutputDistributions': [[[2], [2]]],
      },
      {// works with 2,3, one gap
        'line': [0, 0, 1, 0, 0, -1, -1, 0, 0, 1, 0, 0],
        'hints': [2, 3],
        'expectedOutputGaps': [[0, 5], [7, 12]], 'expectedOutputDistributions': [[[2], [3]]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('line: ${elem['line']},hints: ${elem['hints']}',() {
        var _actual = gapDistributor(elem['line'] as List<int>, elem['hints'] as List<int>);

        expect(_actual?.gaps ,elem['expectedOutputGaps']);
        expect(_actual?.distributions ,elem['expectedOutputDistributions']);
      });
    }
  });
}