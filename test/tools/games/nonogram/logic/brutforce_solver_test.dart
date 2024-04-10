import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/nonogram/logic/bruteforce_solver.dart';

void main() {
  group("bruteForce.Solve:",() {
    List<Map<String,Object?>> _inputsToExpected = [
    //"describe": ["without gaps", {
      {//"works with empty line and one hint",
        'hints': [3],
        'line': [0, 0, 0, 0, 0],
        'expectedOutput': [0, 0, 1, 0, 0]
      },
      {
        'hints': [4],
        'line': [0, 0, 0, 0, 0],
        'expectedOutput': [0, 1, 1, 1, 0]
      },
      {
        'hints': [5],
        'line': [0, 0, 0, 0, 0],
        'expectedOutput': [1, 1, 1, 1, 1]
      },
      {
        'hints': [2],
        'line': [0, 0, 0, 0, 0],
        'expectedOutput': [0, 0, 0, 0, 0]
      },
      {//"works with empty line and multiple hints",
        'hints': [2, 2],
        'line': [0, 0, 0, 0, 0, 0],
        'expectedOutput': [0, 1, 0, 0, 1, 0]
      },
      {
        'hints': [4, 1, 1],
        'line': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        'expectedOutput': [0, 0, 1, 1, 0, 0, 0, 0, 0, 0]
      },
      {
        'hints': [2, 1],
        'line': [0, 0, 0, 0, 0, 0],
        'expectedOutput': [0, 0, 0, 0, 0, 0]
      },
      {//"works with partially filled line and one hint",
        'hints': [3],
        'line': [0, 1, 0, 0, 0, 0],
        'expectedOutput': [0, 1, 1, 0, -1, -1]
      },
      {
        'hints': [3],
        'line': [1, 0, 0, 0, 0],
        'expectedOutput': [1, 1, 1, -1, -1]
      },
      {
        'hints': [4],
        'line': [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        'expectedOutput': [-1, 0, 0, 0, 1, 0, 0, 0, -1, -1]
      },
      {
        'hints': [4],
        'line': [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
        'expectedOutput': [-1, -1, -1, 0, 1, 1, 1, 0, -1, -1]
      },
      {//"works with partially filled line and multiple hints",
        'hints': [3, 3],
        'line': [0, 1, 0, 0, 0, 0, 1, 0],
        'expectedOutput': [0, 1, 1, 0, 0, 1, 1, 0]
      },
      {
        'hints': [3, 3],
        'line': [0, 1, 0, 0, 0, 1, 0],
        'expectedOutput': [1, 1, 1, -1, 1, 1, 1]
      },
      {
        'hints': [3, 2],
        'line': [1, 0, 0, 0, 0, 1],
        'expectedOutput': [1, 1, 1, -1, 1, 1]
      },
      {
        'hints': [4, 1],
        'line': [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        'expectedOutput': [-1, 0, 0, 0, 1, 0, 0, 0, 0, 0]
      },
      {
        'hints': [4, 2],
        'line': [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
        'expectedOutput': [-1, 0, 0, 1, 1, 0, 1, 0, 0, 0]
      },
      //"describe": ["with gaps", {
      {//"works with one gap and some occupation and one hint",
        'hints': [1],
        'line': [0, 0, -1, 0, 1],
        'expectedOutput': [-1, -1, -1, -1, 1]
      },
      {//"works with multiple gaps and some occupation and multiple hints",
        'hints': [3, 3],
        'line': [0, 0, 0, -1, 1, 0, 0, -1, 0, 0, 0],
        'expectedOutput': [0, 0, 0, -1, 1, 1, 1, -1, 0, 0, 0]
      },
      {
        'hints': [3, 1, 3],
        'line': [0, 0, 0, -1, 1, 0, 0, -1, 0, 0, 0],
        'expectedOutput': [1, 1, 1, -1, 1, -1, -1, -1, 1, 1, 1]
      },
      {
        'hints': [2, 3, 7],
        'line': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0],
        'expectedOutput': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0]
      },
      {
        'hints': [2, 4, 1, 1],
        'line': [-1, -1, 1, 1, -1, -1, -1, -1, -1, 1, 1, 1, 1, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        'expectedOutput': [-1, -1, 1, 1, -1, -1, -1, -1, -1, 1, 1, 1, 1, -1, 0, -1, 1, -1, 0, 0, 0, 0, 0, 0, 0]
      },
      {
        'hints': [2, 4, 1, 1],
        'line': [-1, -1, -1, -1, 1, 1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        'expectedOutput': null
      },
      {//"works with complicated cases",
        'hints': [8, 1, 13, 4, 6, 9, 4, 3, 2, 4],
        'line': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        'expectedOutput': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }
    ];

    for (var elem in _inputsToExpected) {
      test('line: ${elem['line']},hints: ${elem['hints']}',() {
        var _actual = bruteForce().solve(elem['line'] as List<int>, elem['hints'] as List<int>);

        expect(_actual ,elem['expectedOutput']);
      });
    }
  });

}