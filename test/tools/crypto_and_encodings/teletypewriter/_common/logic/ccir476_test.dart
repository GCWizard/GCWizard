import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

void main() {
  group("CCIR476.encodeCCIR476:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC', 'expectedOutput' : '71 114 29'},
      {'input' : 'abC', 'expectedOutput' : '71 114 29'},
      {'input' : 'A B C', 'expectedOutput' : '71 92 114 92 29'},
      {'input' : 'ÄÁÉEäáée', 'expectedOutput' : '71 86 71 86 86 71 86 71 86 86'},

      {'input' : '123', 'expectedOutput' : '54 46 39 86'},
      {'input' : '1 2 3', 'expectedOutput' : '54 46 127 92 54 39 127 92 54 86'},
      {'input' : '.=7/', 'expectedOutput' : '54 57 60 78 58'},

      {'input' : 'AB12', 'expectedOutput' : '71 114 54 46 39'},
      {'input' : 'AB 12', 'expectedOutput' : '71 114 92 54 46 39'},
      {'input' : '12AB', 'expectedOutput' : '54 46 39 127 71 114'},
      {'input' : '12 AB', 'expectedOutput' : '54 46 39 127 92 71 114'},
      {'input' : '12AB12', 'expectedOutput' : '54 46 39 127 71 114 54 46 39'},
      {'input' : '12 AB 12', 'expectedOutput' : '54 46 39 127 92 71 114 92 54 46 39'},
      {'input' : 'AB12AB', 'expectedOutput' : '71 114 54 46 39 127 71 114'},
      {'input' : 'AB 12 AB', 'expectedOutput' : '71 114 92 54 46 39 127 92 71 114'},
      {'input' : 'A B1 2', 'expectedOutput' : '71 92 114 54 46 127 92 54 39'},
      {'input' : 'A B 1 2', 'expectedOutput' : '71 92 114 92 54 46 127 92 54 39'},
      {'input' : 'ABC ABC ABC ABC', 'expectedOutput' : '71 114 29 92 71 114 29 92 71 114 29 92 71 114 29'},

      {'input' : 'A-', 'expectedOutput' : '71 54 71'},
      {'input' : '2-', 'expectedOutput' : '54 39 71'},
      {'input' : 'A-2', 'expectedOutput' : '71 54 71 39'},
      {'input' : '2-A', 'expectedOutput' : '54 39 71 127 71'},
      {'input' : 'A-2-A', 'expectedOutput' : '71 54 71 39 71 127 71'},
      {'input' : '2-A-2', 'expectedOutput' : '54 39 71 127 71 54 71 39'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeTeletypewriter(elem['input'] as String, TeletypewriterCodebook.CCIR476);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CCIR476.decodeCCIR476:", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC', 'input' : [71, 114, 29]},
      {'expectedOutput' : 'A B C', 'input' : [71, 92, 114, 92, 29]},

      {'expectedOutput' : '189', 'input' : [54, 46, 77, 113]},
      {'expectedOutput' : '123', 'input' : [54, 46, 39, 86]},
      {'expectedOutput' : '1 2 3', 'input' : [54, 46, 127, 92, 54, 39, 127, 92, 54, 86]},
      {'expectedOutput' : '.=7/', 'input' : [54, 57, 60, 78, 58]},

      {'expectedOutput' : 'AB 12', 'input' : [71, 114, 92, 54, 46, 39]},
      {'expectedOutput' : '12 AB', 'input' : [54, 46, 39, 127, 92, 71, 114]},
      {'expectedOutput' : '12 AB 12', 'input' : [54, 46, 39, 127, 92, 71, 114, 92, 54, 46, 39]},
      {'expectedOutput' : 'AB 12 AB', 'input' : [71, 114, 92, 54, 46, 39, 127, 92, 71, 114]},
      {'expectedOutput' : 'A B 1 2', 'input' : [71, 92, 114, 92, 54, 46, 127, 92, 54, 39]},
      {'expectedOutput' : 'ABC ABC ABC ABC', 'input' : [71, 114, 29, 92, 71, 114, 29, 92, 71, 114, 29, 92, 71, 114, 29]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTeletypewriter(elem['input'] as List<int>, TeletypewriterCodebook.CCIR476);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}