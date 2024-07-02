import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("BAUDOT.encodeBAUDOT_12345", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '16 6 22'},
      {'input' : 'abC', 'expectedOutput' : '16 6 22'},
      {'input' : 'a b C', 'expectedOutput' : '16 6 22'},

      {'input' : '123', 'expectedOutput' : ''},
      {'input' : '1 2 3', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.BAUDOT_12345);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BAUDOT.decodeBAUDOT_12345", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [16, 6, 22]},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.BAUDOT_12345);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });


  group("BAUDOT.encodeBAUDOT_54123", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '4 9 13'},
      {'input' : 'abC', 'expectedOutput' : '4 9 13'},
      {'input' : 'a b C', 'expectedOutput' : '4 16 9 16 13'},

      {'input' : '123', 'expectedOutput' : '8 4 2 1'},
      {'input' : '1 2 3', 'expectedOutput' : '8 4 8 2 8 1'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.BAUDOT_54123);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BAUDOT.decodeBAUDOT_54123", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [4, 9, 13]},
      {'expectedOutput' : 'A B C', 'input' : [4, 16, 9, 16, 13]},

      {'expectedOutput' : '123', 'input' : [8, 4, 2, 1]},
      {'expectedOutput' : '1 2 3', 'input' : [8, 4, 8, 2, 8, 1]},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.BAUDOT_54123);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
  
}