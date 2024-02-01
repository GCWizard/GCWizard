import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("ALGOL.encodeALGOL:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '3 25 14'},
      {'input' : 'abC', 'expectedOutput' : '3 25 14'},
      {'input' : 'A B C', 'expectedOutput' : '3 4 25 4 14'},
      {'input' : 'ÄÁÉEäáée', 'expectedOutput' : '3 1 3 1 1 3 1 3 1 1'},

      {'input' : '123', 'expectedOutput' : '62 23 19 1'},
      {'input' : '1 2 3', 'expectedOutput' : '62 23 4 19 4 1'},
      {'input' : '.=7/', 'expectedOutput' : '62 28 30 7 29'},
      {'input' : '.=;', 'expectedOutput' : '62 28 30 11'},

      {'input' : 'AB12', 'expectedOutput' : '3 25 62 23 19'},
      {'input' : 'AB 12', 'expectedOutput' : '3 25 4 62 23 19'},
      {'input' : '12AB', 'expectedOutput' : '62 23 19 54 3 25'},
      {'input' : '12 AB', 'expectedOutput' : '62 23 19 4 54 3 25'},
      {'input' : '12AB12', 'expectedOutput' : '62 23 19 54 3 25 62 23 19'},
      {'input' : '12 AB 12', 'expectedOutput' : '62 23 19 4 54 3 25 4 62 23 19'},
      {'input' : 'AB12AB', 'expectedOutput' : '3 25 62 23 19 54 3 25'},
      {'input' : 'AB 12 AB', 'expectedOutput' : '3 25 4 62 23 19 4 54 3 25'},
      {'input' : 'A B1 2', 'expectedOutput' : '3 4 25 62 23 4 19'},
      {'input' : 'A B 1 2', 'expectedOutput' : '3 4 25 4 62 23 4 19'},
      {'input' : 'ABC ABC ABC ABC', 'expectedOutput' : '3 25 14 4 3 25 14 4 3 25 14 4 3 25 14'},

      {'input' : 'A-', 'expectedOutput' : '3 62 3'},
      {'input' : '2-', 'expectedOutput' : '62 19 3'},
      {'input' : 'A-2', 'expectedOutput' : '3 62 3 19'},
      {'input' : '2-A', 'expectedOutput' : '62 19 3 54 3'},
      {'input' : 'A-2-A', 'expectedOutput' : '3 62 3 19 3 54 3'},
      {'input' : '2-A-2', 'expectedOutput' : '62 19 3 54 3 62 3 19'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.ALGOL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ALGOL.decodeALGOL:", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : ' DF', 'input' : [4, 9, 13]},
      {'expectedOutput' : ' TDTF', 'input' : [4, 16, 9, 16, 13]},
      {'expectedOutput' : ' \rI', 'input' : [4, 2, 6]},

      {'expectedOutput' : '\n DF', 'input' : [8, 4, 9, 13]},
      {'expectedOutput' : '\n \rE', 'input' : [8, 4, 2, 1]},
      {'expectedOutput' : '1 2 3', 'input' : [62, 23, 4, 19, 4, 1]},
      {'expectedOutput' : '.=7/', 'input' : [62, 28, 30, 7, 29]},
      {'expectedOutput' : '.=;', 'input' : [62, 28, 30, 11]}, // Mark test

      {'expectedOutput' : 'AB 12', 'input' : [3, 25, 4, 62, 23, 19]},
      {'expectedOutput' : '12 AB', 'input' : [62, 23, 19, 4, 54, 3, 25]},
      {'expectedOutput' : '12 AB 12', 'input' : [62, 23, 19, 4, 54, 3, 25, 4, 62, 23, 19]},
      {'expectedOutput' : 'AB 12 AB', 'input' : [3, 25, 4, 62, 23, 19, 4, 54, 3, 25]},
      {'expectedOutput' : 'A B 1 2', 'input' : [3, 4, 25, 4, 62, 23, 4, 19]},
      {'expectedOutput' : 'ABC ABC ABC ABC', 'input' : [3, 25, 14, 4, 3, 25, 14, 4, 3, 25, 14, 4, 3, 25, 14]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.ALGOL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}