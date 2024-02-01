import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("CCITT1.encodeCCITT1:", () {
    List<Map<String, Object?>> _inputsToExpected = [
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

      {'input' : 'A-', 'expectedOutput' : '4 8 25'},
      {'input' : '2-', 'expectedOutput' : '8 2 25'},
      {'input' : 'A-2', 'expectedOutput' : '4 8 25 2'},
      {'input' : '2-A', 'expectedOutput' : '8 2 25 16 4'},
      {'input' : 'A-2-A', 'expectedOutput' : '4 8 25 2 25 16 4'},
      {'input' : '2-A-2', 'expectedOutput' : '8 2 25 16 4 8 25 2'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.BAUDOT_54123);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CCITT1.decodeCCITT1:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [4, 9, 13]},
      {'expectedOutput' : 'A B C', 'input' : [4, 16, 9, 16, 13]},
      {'expectedOutput' : 'AEÉ', 'input' : [4, 2, 6]},

      {'expectedOutput' : '189', 'input' : [8, 4, 9, 13]},
      {'expectedOutput' : '123', 'input' : [8, 4, 2, 1]},
      {'expectedOutput' : '1 2 3', 'input' : [8, 4, 8, 2, 8, 1]},
      {'expectedOutput' : '.=7/', 'input' : [8, 20, 30, 10, 29]},
      {'expectedOutput' : '.=;', 'input' : [8, 20, 30, 17]}, // Mark test

      {'expectedOutput' : 'AB 12', 'input' : [4, 9, 8, 4, 2]},
      {'expectedOutput' : '12 AB', 'input' : [8, 4, 2, 16, 4, 9]},
      {'expectedOutput' : '12 AB 12', 'input' : [8, 4, 2, 16, 4, 9, 8, 4, 2]},
      {'expectedOutput' : 'AB 12 AB', 'input' : [4, 9, 8, 4, 2, 16, 4, 9]},
      {'expectedOutput' : 'A B 1 2', 'input' : [4, 16, 9, 8, 4, 8, 2]},
      {'expectedOutput' : 'ABC ABC ABC ABC', 'input' : [4, 9, 13, 16, 4, 9, 13, 16, 4, 9, 13, 16, 4, 9, 13]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.BAUDOT_54123);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CCITT1.encodeCCITT_ITA1_UK:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'A 1', 'expectedOutput' : '1 8 1'},
      {'input' : '3', 'expectedOutput' : '8 6'},
      {'input' : '¹', 'expectedOutput' : '8 11'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.CCITT_ITA1_UK);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CCITT1.decodeCCITT_ITA1_UK:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'A 1', 'input' : [1, 8, 1]},
      {'expectedOutput' : '3', 'input' : [8, 6]},
      {'expectedOutput' : '¹', 'input' : [8, 11]},
      {'expectedOutput' : '¹', 'input' : [8, 23]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.CCITT_ITA1_UK);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}