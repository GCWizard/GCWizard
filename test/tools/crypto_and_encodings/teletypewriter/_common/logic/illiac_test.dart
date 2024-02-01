import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("ILLIAC.encodeILLIAC:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '22 19 29'},
      {'input' : 'abC', 'expectedOutput' : '22 19 29'},
      {'input' : 'A B C', 'expectedOutput' : '22 31 19 31 29'},
      {'input' : 'ÄÁÉEäáée', 'expectedOutput' : '22 3 22 3 3 22 3 22 3 3'},

      {'input' : '123', 'expectedOutput' : '27 1 2 3'},
      {'input' : '1 2 3', 'expectedOutput' : '27 1 31 2 31 3'},
      {'input' : '.=7/', 'expectedOutput' : '27 26 25 7 23'},

      {'input' : 'AB12', 'expectedOutput' : '22 19 27 1 2'},
      {'input' : 'AB 12', 'expectedOutput' : '22 19 31 27 1 2'},
      {'input' : '12AB', 'expectedOutput' : '27 1 2 20 22 19'},
      {'input' : '12 AB', 'expectedOutput' : '27 1 2 31 20 22 19'},
      {'input' : '12AB12', 'expectedOutput' : '27 1 2 20 22 19 27 1 2'},
      {'input' : '12 AB 12', 'expectedOutput' : '27 1 2 31 20 22 19 31 27 1 2'},
      {'input' : 'AB12AB', 'expectedOutput' : '22 19 27 1 2 20 22 19'},
      {'input' : 'AB 12 AB', 'expectedOutput' : '22 19 31 27 1 2 31 20 22 19'},
      {'input' : 'A B1 2', 'expectedOutput' : '22 31 19 27 1 31 2'},
      {'input' : 'A B 1 2', 'expectedOutput' : '22 31 19 31 27 1 31 2'},
      {'input' : 'ABC ABC ABC ABC', 'expectedOutput' : '22 19 29 31 22 19 29 31 22 19 29 31 22 19 29'},

      {'input' : 'A-', 'expectedOutput' : '22 27 11'},
      {'input' : '2-', 'expectedOutput' : '27 2 11'},
      {'input' : 'A-2', 'expectedOutput' : '22 27 11 2'},
      {'input' : '2-A', 'expectedOutput' : '27 2 11 20 22'},
      {'input' : 'A-2-A', 'expectedOutput' : '22 27 11 2 11 20 22'},
      {'input' : '2-A-2', 'expectedOutput' : '27 2 11 20 22 27 11 2'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.ILLIAC);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ILLIAC.decodeILLIAC:", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [22, 19, 29]},
      {'expectedOutput' : 'A B C', 'input' : [22, 31, 19, 31, 29]},
      {'expectedOutput' : 'RWY', 'input' : [4, 2, 6]},

      {'expectedOutput' : '189', 'input' : [27, 1, 8, 9]},
      {'expectedOutput' : '123', 'input' : [27, 1, 2, 3]},
      {'expectedOutput' : '1 2 3', 'input' : [27, 1, 31, 2, 31, 3]},
      {'expectedOutput' : '.=7/', 'input' : [27, 26, 25, 7, 23]},

      {'expectedOutput' : 'AB 12', 'input' : [22, 19, 31, 27, 1, 2]},
      {'expectedOutput' : '12 AB', 'input' : [27, 1, 2, 31, 20, 22, 19]},
      {'expectedOutput' : '12 AB 12', 'input' : [27, 1, 2, 31, 20, 22, 19, 31, 27, 1, 2]},
      {'expectedOutput' : 'AB 12 AB', 'input' : [22, 19, 31, 27, 1, 2, 31, 20, 22, 19]},
      {'expectedOutput' : 'A B 1 2', 'input' : [22, 31, 19, 31, 27, 1, 31, 2]},
      {'expectedOutput' : 'ABC ABC ABC ABC', 'input' : [22, 19, 29, 31, 22, 19, 29, 31, 22, 19, 29, 31, 22, 19, 29]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.ILLIAC);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}