import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/houdini/logic/houdini.dart';

void main() {
  group("Houdini.decodeHoudini:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : null},

      {'input' : 'BE QUICK SAY PRAY QUICKLY', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : {0: '0318', 10: '10318'}},
      {'input' : 'ABC QUICK 1023 PRAYXYZ', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : {0: 'ABCQUICK10231XYZ', 10: 'ABCQUICK10231XYZ'}},

      {'input' : 'BE QUICK SAY PRAY QUICKLY', 'mode': HoudiniMode.LETTERS, 'expectedOutput' : {0: 'JCAH'}},
      {'input' : 'ABC QUICK 1023 PRAYXYZ', 'mode': HoudiniMode.LETTERS, 'expectedOutput' : {0: 'ABCQUICK1023AXYZ'}}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = decodeHoudini(elem['input'] as String, elem['mode'] as HoudiniMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Houdini.encodeHoudini:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : null},

      {'input' : '0318', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : {0: 'BE QUICK SAY PRAY QUICKLY', 10: 'BE QUICK SAY PRAY QUICKLY'}},
      {'input' : '10318', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : {0: 'PRAY BE QUICK SAY PRAY QUICKLY', 10: 'BE QUICK SAY PRAY QUICKLY'}},
      {'input' : 'ABCQUICK10231XYZ', 'mode': HoudiniMode.NUMBERS, 'expectedOutput' : {0: 'ABCQUICKPRAY BE QUICK ANSWER SAY PRAY XYZ', 10: 'ABCQUICKBE QUICK ANSWER SAY PRAY XYZ'}},

      {'input' : 'JCAH', 'mode': HoudiniMode.LETTERS, 'expectedOutput' : {0: 'BE QUICK SAY PRAY QUICKLY'}},
      {'input' : 'ABCQUICK1023AXYZ', 'mode': HoudiniMode.LETTERS, 'expectedOutput' : {0: 'PRAY ANSWER SAY QULOOK SAY K1023PRAY XYZ'}}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = encodeHoudini(elem['input'] as String, elem['mode'] as HoudiniMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}