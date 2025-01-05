import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/nonogram/logic/util.dart';

void main() {
  group("util.trimLine:",() {
    List<Map<String,Object?>> _inputsToExpected = [
      //'trimLine'
      //'trimming'
      {//'does nothing if not needed'
        'line': [0, 0, 0],
        'hints': [0],
        'expectedOutput': ShiftResult([0, 0, 0], [0], TrimInfo([], [])),
      },
      {//'trims on the left'
        'line': [-1, 1, -1, 1, 0],
        'hints': [1, 1],
        'expectedOutput': ShiftResult([1, 0], [1], TrimInfo([-1, 1, -1], [])),
      },
      {//'trims on the right'
        'line': [0, 0, -1, -1],
        'hints': [1],
        'expectedOutput': ShiftResult([0, 0], [1], TrimInfo([], [-1, -1])),
      },
      {//'handles 1s on the left rim'
        'line': [-1, 1, 1, 0, 0, -1, -1],
        'hints': [2, 1],
        'expectedOutput': ShiftResult([1, 0, 0], [1, 1], TrimInfo([-1, 1], [-1, -1])),
      },
      {//'handles 1s on the right rim'
        'line': [-1, -1, 0, 0, 1, 1, 1, -1, -1],
        'hints': [1, 3],
        'expectedOutput': ShiftResult([0, 0, 1], [1, 1], TrimInfo([-1, -1], [1, 1, -1, -1])),
      },
      {//'trims on both ends'
        'line': [1, 1, -1, -1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, -1, -1, -1],
        'hints': [2, 4, 2, 5],
        'expectedOutput': ShiftResult([1, 0, 0, 1, 0, 0, 0, 1], [2, 2, 3], TrimInfo([1, 1, - 1, -1, 1, 1], [1, 1, -1, -1, -1])),
      },
      {//'handles complicated cases'
        'line': [-1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 0, -1, 0, -1, 1, 1, -1, 0, 0, 0, 0, 0, 0, -1, -1, -1, 1, -1, -1],
        'hints': [ 16, 2, 2, 1, 2, 1 ],
        'expectedOutput': ShiftResult([0, -1, 0, -1, 1, 1, -1, 0, 0, 0, 0, 0, 0], [2, 2, 1, 2], TrimInfo([-1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1], [-1, -1, -1, 1, -1, -1])),
      },
      {//'handles complicated cases 2'
        'line': [-1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, -1, -1, 1, 1, -1, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, 1, -1],
        'hints': [14, 1, 2, 2, 1, 1],
        'expectedOutput': ShiftResult([1, 0, 0, 0, -1, -1, 1, 1, -1, 0, 0, 0, 0, 0, 0], [1, 1, 2, 2, 1], TrimInfo([-1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], [-1, -1, -1, -1, 1, -1])),
      },
      {//'handles complicated cases 3'
        'line': [-1, 1, -1, -1, 1, -1, -1, -1, -1, -1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1],
        'hints': [1, 1, 2, 10, 4, 9],
        'expectedOutput': ShiftResult([1, 0, 1], [1, 1], TrimInfo([-1, 1, -1, -1, 1, -1, -1, -1, -1, -1, 1], [ 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1])),
      },
    ];

    for (var elem in _inputsToExpected) {
      test('line: ${elem['line']},hints: ${elem['hints']}',() {
        var _actual = trimLine(elem['line'] as List<int>, elem['hints'] as List<int>);

        expect(_actual.trimmedLine , (elem['expectedOutput'] as ShiftResult).trimmedLine);
        expect(_actual.trimmedHints , (elem['expectedOutput'] as ShiftResult).trimmedHints);
        expect(_actual.trimInfo?.left , (elem['expectedOutput'] as ShiftResult).trimInfo?.left);
        expect(_actual.trimInfo?.right , (elem['expectedOutput'] as ShiftResult).trimInfo?.right);
        //expect(_actual.toString() , elem['expectedOutput'].toString());
      });
    }
  });

  group("util.restoreLine:",() {
    List<Map<String,Object?>> _inputsToExpected = [
      //'restores trimmed lines'
      {
        'line': [0, 0, 0],
        'hints': [1],
      },
      {
        'line': [-1, 1, 0],
        'hints': [1],
      },
      {
        'line': [1, 0, -1, -1],
        'hints': [1],
      },
      {
        'line': [-1, -1, 0, 0, 1, -1, -1, -1],
        'hints': [1],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('line: ${elem['line']},hints: ${elem['hints']}',() {
        var _shiftResult = trimLine(elem['line'] as List<int>, elem['hints'] as List<int>);
        var _actual = restoreLine(_shiftResult.trimmedLine!, _shiftResult.trimInfo!);

        expect(_actual , elem['line']);
      });
    }
  });
}