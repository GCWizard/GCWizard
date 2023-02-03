import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble/logic/scrabble.dart';

void main() {
  group("Scrabble.textToLetterValues:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : []},
      {'input' : '', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : []},
      {'input' : ' ', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [0]},

      {'input' : 't', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [4]},
      {'input' : 'tl', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [4,3]},
      {'input' : 'tlh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [8]},
      {'input' : 'tlht', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [8,4]},
      {'input' : 'tlhtl', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [8,4,3]},
      {'input' : 'tlhtlh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [8,8]},
      {'input' : 'm', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2]},
      {'input' : 'mt', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,4]},
      {'input' : 'mtl', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,4,3]},
      {'input' : 'mtlh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,8]},
      {'input' : 'mtlhm', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,8,2]},
      {'input' : 'mtlhmt', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,8,2,4]},
      {'input' : 'mtlhmtl', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,8,2,4,3]},
      {'input' : 'mtlhmtlh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,8,2,8]},
      {'input' : 'mg', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,0]},
      {'input' : 'mgh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,3]},
      {'input' : 'mght', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,3,4]},
      {'input' : 'mghtl', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,3,4,3]},
      {'input' : 'mghtlh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,3,8]},
      {'input' : 'mghtlhg', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,3,8,0]},
      {'input' : 'mghtlhgh', 'scrabbleVersion': scrabbleID_KLINGON, 'expectedOutput' : [2,3,8,3]},

      {'input' : 'A', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1]},
      {'input' : 'A*', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 0]},
      {'input' : 'A*I', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 0, 1]},
      {'input' : 'A*IN', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 10]},
      {'input' : 'A*INA', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 10, 1]},
      {'input' : 'A*IN*', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 10, 0]},
      {'input' : 'A*IN*I', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 10, 0, 1]},
      {'input' : 'A*IN*IN', 'scrabbleVersion': scrabbleID_D_Gender, 'expectedOutput' : [1, 10, 10]},

    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, scrabbleVersion: ${elem['scrabbleVersion']}', () {
        var _actual = scrabbleTextToLetterValues(elem['input'], elem['scrabbleVersion']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}