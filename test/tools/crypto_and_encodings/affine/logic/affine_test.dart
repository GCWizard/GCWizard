import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/affine/logic/affine.dart';

void main() {
  
  group("Affine.encodeAffine:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'keyA' : 1, 'keyB': 0, 'expectedOutput' : ''},
      {'input' : 'Hallo', 'keyA' : 11, 'keyB': 5, 'expectedOutput' : 'EFWWD'},
      {'input' : 'Nummer 123 kommt', 'keyA' : 17, 'keyB': 10, 'expectedOutput' : 'XMGGAN  YOGGV'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyA: ${elem['keyA']}, keyB: ${elem['keyB']}', () {
        var _actual = encodeAffine(elem['input'] as String, elem['keyA'] as int, elem['keyB'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Affine.decodeAffine:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'keyA' : 1, 'keyB': 0, 'expectedOutput' : ''},
      {'input' : 'efWwd', 'keyA' : 11, 'keyB': 5, 'expectedOutput' : 'HALLO'},
      {'input' : 'XMGGAN YOGGV', 'keyA' : 17, 'keyB': 10, 'expectedOutput' : 'NUMMER KOMMT'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyA: ${elem['keyA']}, keyB: ${elem['keyB']}', () {
        var _actual = decodeAffine(elem['input'] as String, elem['keyA'] as int, elem['keyB'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}