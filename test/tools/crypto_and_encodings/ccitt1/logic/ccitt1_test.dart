import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("CCITT1.encodeCCITT1:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '4 9 13'},
      {'input' : 'abC', 'expectedOutput' : '4 9 13'},
      {'input' : 'A B C', 'expectedOutput' : '4 16 9 16 13'},
      {'input' : 'ÄÁÉEäáée', 'expectedOutput' : '4 2 4 6 2 4 2 4 6 2'},

      {'input' : '123', 'expectedOutput' : '8 4 2 1'},
      {'input' : '1 2 3', 'expectedOutput' : '8 4 8 2 8 1'},
      {'input' : '.=7/', 'expectedOutput' : '8 20 30 10 29'},

      {'input' : 'AB12', 'expectedOutput' : '4 9 8 4 2'},
      {'input' : 'AB 12', 'expectedOutput' : '4 9 8 4 2'},
      {'input' : '12AB', 'expectedOutput' : '8 4 2 16 4 9'},
      {'input' : '12 AB', 'expectedOutput' : '8 4 2 16 4 9'},
      {'input' : '12AB12', 'expectedOutput' : '8 4 2 16 4 9 8 4 2'},
      {'input' : '12 AB 12', 'expectedOutput' : '8 4 2 16 4 9 8 4 2'},
      {'input' : 'AB12AB', 'expectedOutput' : '4 9 8 4 2 16 4 9'},
      {'input' : 'AB 12 AB', 'expectedOutput' : '4 9 8 4 2 16 4 9'},
      {'input' : 'A B1 2', 'expectedOutput' : '4 16 9 8 4 8 2'},
      {'input' : 'A B 1 2', 'expectedOutput' : '4 16 9 8 4 8 2'},
      {'input' : 'ABC ABC ABC ABC', 'expectedOutput' : '4 9 13 16 4 9 13 16 4 9 13 16 4 9 13'},

      {'input' : 'A-', 'expectedOutput' : '4 20'},
      {'input' : '2-', 'expectedOutput' : '8 2 25'},
      {'input' : 'A-2', 'expectedOutput' : '4 20 8 2'},
      {'input' : '2-A', 'expectedOutput' : '8 2 25 16 4'},
      {'input' : 'A-2-A', 'expectedOutput' : '4 20 8 2 25 16 4'},
      {'input' : '2-A-2', 'expectedOutput' : '8 2 25 16 4 20 8 2'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'], TeletypewriterCodebook.BAUDOT_54123);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CCITT1.decodeCCITT1:", () { // Mark test
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [4, 9, 13]},
      {'expectedOutput' : 'A B C', 'input' : [4, 16, 9, 16, 13]},
      {'expectedOutput' : 'AEÉ', 'input' : [4, 2, 6]},

      {'expectedOutput' : '189', 'input' : [8, 4, 9, 13]},
      {'expectedOutput' : '123', 'input' : [8, 4, 2, 1]},
      {'expectedOutput' : '1 2 3', 'input' : [8, 4, 8, 2, 8, 1]},
      {'expectedOutput' : '.=7/', 'input' : [8, 20, 30, 10, 29]},
      {'expectedOutput' : '.=7/', 'input' : [8, 20, 30, 17]}, // Mark test

      {'expectedOutput' : 'AB 12', 'input' : [4, 9, 8, 4, 2]},
      {'expectedOutput' : '12 AB', 'input' : [8, 4, 2, 16, 4, 9]},
      {'expectedOutput' : '12 AB 12', 'input' : [8, 4, 2, 16, 4, 9, 8, 4, 2]},
      {'expectedOutput' : 'AB 12 AB', 'input' : [4, 9, 8, 4, 2, 16, 4, 9]},
      {'expectedOutput' : 'A B 1 2', 'input' : [4, 16, 9, 8, 4, 8, 2]},
      {'expectedOutput' : 'ABC ABC ABC ABC', 'input' : [4, 9, 13, 16, 4, 9, 13, 16, 4, 9, 13, 16, 4, 9, 13]},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'], TeletypewriterCodebook.BAUDOT_54123);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}