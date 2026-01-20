import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/wordoku/logic/wordoku_solver.dart';

void main() {
  group("Sudoku.solve:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      //{'input' : [['', '', 'E', '', 'N', '', '', 'R', ''], ['G', '', '', '', '', '', 'W', '', 'S'], ['S', '', '', '', '', '', '', '', 'E'], ['', 'R', '', '', '', '', '', '', ''], ['', 'H', '', '', 'U', 'G', '', '', ''], ['', 'U', '', '', 'A', '', 'S', '', 'N'], ['R', '', '', '', '', '', '', '', 'A'], ['', '', '', '', '', 'A', '', 'H', ''], ['N', '', '', 'E', 'W', '', '', '', '']],
      {'input' : [['', 'G', 'S', '', '', '', 'R', '', 'N'], ['', '', '', 'R', 'H', 'U', '', '', ''], ['E', '', '', '', '', '', '', '', ''], ['', '', '', '', '', '', '', '', 'E'], ['N', '', '', '', 'U', 'A', '', '', 'W'], ['', '', '', '', 'G', '', '', 'A', ''], ['', 'W', '', '', '', 'S', '', '', ''], ['R', '', '', '', '', '', '', 'H', ''], ['', 'S', 'E', '', '', 'N', 'A', '', '']],
        'expectedOutput' :  [['H', 'G', 'S', 'A', 'E', 'W', 'R', 'U', 'N'], ['W', 'A', 'N', 'R', 'H', 'U', 'S', 'E', 'G'], ['E', 'R', 'U', 'S', 'N', 'G', 'H', 'W', 'A'], ['G', 'U', 'A', 'W', 'S', 'H', 'N', 'R', 'E'], ['N', 'H', 'R', 'E', 'U', 'A', 'G', 'S', 'W'], ['S', 'E', 'W', 'N', 'G', 'R', 'U', 'A', 'H'], ['A', 'W', 'H', 'G', 'R', 'S', 'E', 'N', 'U'], ['R', 'N', 'G', 'U', 'A', 'E', 'W', 'H', 'S'], ['U', 'S', 'E', 'H', 'W', 'N', 'A', 'G', 'R']],
        'solutionCount': 1
      },
      {'input' : [['', '', '', '', '', 'T', '', '', 'E'], ['', 'E', 'A', '', 'S', '', 'M', 'Y', ''], ['H', '', 'I', 'M', 'Y', '', 'A', '', ''], ['', 'H', '', '', '', '', 'I', 'E', 'Y'], ['', 'T', '', '', '', '', '', 'S', ''], ['P', 'M', 'Y', '', '', '', '', 'H', ''], ['', '', 'P', '', 'E', 'H', 'S', '', 'T'], ['', 'A', 'H', '', 'T', '', 'Y', 'P', ''], ['M', '', '', 'I', '', '', '', '', '']],
        'expectedOutput' :  [['S', 'Y', 'M', 'P', 'A', 'T', 'H', 'I', 'E'], ['T', 'E', 'A', 'H', 'S', 'I', 'M', 'Y', 'P'], ['H', 'P', 'I', 'M', 'Y', 'E', 'A', 'T', 'S'], ['A', 'H', 'S', 'T', 'M', 'P', 'I', 'E', 'Y'], ['I', 'T', 'E', 'Y', 'H', 'A', 'P', 'S', 'M'], ['P', 'M', 'Y', 'E', 'I', 'S', 'T', 'H', 'A'], ['Y', 'I', 'P', 'A', 'E', 'H', 'S', 'M', 'T'], ['E', 'A', 'H', 'S', 'T', 'M', 'Y', 'P', 'I'], ['M', 'S', 'T', 'I', 'P', 'Y', 'E', 'A', 'H']],
        'solutionCount': 1
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = WordokuBoard(board: elem['input'] as List<List<String?>>);
        _actual.solveWordoku(10);
        expect(_actual.solutions?[0].solution, elem['expectedOutput']);
        expect(_actual.solutions?.length, elem['solutionCount']);
      });
    }
  });
}