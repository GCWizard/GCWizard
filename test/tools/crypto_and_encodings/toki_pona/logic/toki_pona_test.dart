import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/toki_pona/logic/toki_pona.dart';

void main() {
  group("TokiPona.decodeTokiPona:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'akesi esun ilo oko uta','expectedOutput' : 'a e i o u'},
      {'input' : 'wan tu tu wan tu tu luka','expectedOutput' : '1 2 2 1 2 2 5'},

      {'input' : 'mute tu wan','expectedOutput' : '20 2 1'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTokiPona(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Houdini.encodeHoudini:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'mode': TokiPonaMode.NUMBERS, 'expectedOutput' : ''},
      {'input' : '', 'mode': TokiPonaMode.DIGITS, 'expectedOutput' : ''},
      {'input' : '', 'mode': TokiPonaMode.LETTERS, 'expectedOutput' : ''},

      {'input' : '0318', 'mode': TokiPonaMode.DIGITS, 'expectedOutput' : 'ala tu wan wan luka tu wan'},
      {'input' : '10 3 1 20 100', 'mode': TokiPonaMode.NUMBERS, 'expectedOutput' : 'luka luka tu wan wan mute ale'},
      {'input' : 'ABCQUICK10231XYZ', 'mode': TokiPonaMode.NUMBERS, 'expectedOutput' : 'ABCQUICK10231XYZ'},

      {'input' : '23 4', 'mode': TokiPonaMode.LETTERS, 'expectedOutput' : '23 4'},
      {'input' : 'ABCQUICK1023AXYZ', 'mode': TokiPonaMode.LETTERS, 'expectedOutput' : 'akesi bcquta ilo ckala 1023akesi xyz'},
      {'input' : 'aeiou', 'mode': TokiPonaMode.LETTERS, 'expectedOutput' : 'akesi esun ilo oko uta'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = encodeTokiPona(elem['input'] as String, elem['mode'] as TokiPonaMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}