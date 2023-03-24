import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("CCITT2.encodeCCITT2:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '3 25 14'},
      {'input' : 'abC', 'expectedOutput' : '3 25 14'},
      {'input' : 'A B C', 'expectedOutput' : '3 4 25 4 14'},

      {'input' : '123', 'expectedOutput' : '27 23 19 1'},
      {'input' : '1 2 3', 'expectedOutput' : '27 23 4 19 4 1'},
      {'input' : '.=7/', 'expectedOutput' : '27 28 30 7 29'},

      {'input' : 'AB12', 'expectedOutput' : '3 25 27 23 19'},
      {'input' : '12AB', 'expectedOutput' : '27 23 19 31 3 25'},
      {'input' : '12AB12', 'expectedOutput' : '27 23 19 31 3 25 27 23 19'},
      {'input' : 'AB12AB', 'expectedOutput' : '3 25 27 23 19 31 3 25'},
      {'input' : 'A B1 2', 'expectedOutput' : '3 4 25 27 23 4 19'},

      {'input' : 'AB-?', 'expectedOutput' : '3 25 27 3 25'},
      {'input' : '-?AB', 'expectedOutput' : '27 3 25 31 3 25'},
      {'input' : '-?AB-?', 'expectedOutput' : '27 3 25 31 3 25 27 3 25'},
      {'input' : 'AB-?AB', 'expectedOutput' : '3 25 27 3 25 31 3 25'},
      {'input' : 'A B- ?', 'expectedOutput' : '3 4 25 27 3 4 25'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.CCITT_ITA2_1931);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CCITT2.decodeCCITT2:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [3, 25, 14]},
      {'expectedOutput' : 'A B C', 'input' : [3, 4, 25, 4, 14]},

      {'expectedOutput' : '123', 'input' : [27, 23, 19, 1]},
      {'expectedOutput' : '1 2 3', 'input' : [27, 23, 4, 19, 4, 1]},
      {'expectedOutput' : '.=7/', 'input' : [27, 28, 30, 7, 29]},

      {'expectedOutput' : 'AB12', 'input' : [3, 25, 27, 23, 19]},
      {'expectedOutput' : '12AB', 'input' : [27, 23, 19, 31, 3, 25]},
      {'expectedOutput' : '12AB12', 'input' : [27, 23, 19, 31, 3, 25, 27, 23, 19]},
      {'expectedOutput' : 'AB12AB', 'input' : [3, 25, 27, 23, 19, 31, 3, 25]},
      {'expectedOutput' : 'A B1 2', 'input' : [3, 4, 25, 27, 23, 4, 19]},

      {'expectedOutput' : 'AB-?', 'input' : [3, 25, 27, 3, 25]},
      {'expectedOutput' : '-?AB', 'input' : [27, 3, 25, 31, 3, 25]},
      {'expectedOutput' : '-?AB-?', 'input' : [27, 3, 25, 31, 3, 25, 27, 3, 25]},
      {'expectedOutput' : 'AB-?AB', 'input' : [3, 25, 27, 3, 25, 31, 3, 25]},
      {'expectedOutput' : 'A B- ?', 'input' : [3, 4, 25, 27, 3, 4, 25]},

      {'expectedOutput' : '', 'input' : [0, 32]},
      {'expectedOutput' : 'AB', 'input' : [0, 3, 32, 25]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.CCITT_ITA2_1931);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}