import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/affine/logic/affine.dart';

void main() {
  
  group("Affine.encodeAffine:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'keyA' : 1, 'keyB': 0, 'expectedOutput' : ''},
      {'input' : 'Hallo', 'keyA' : 11, 'keyB': 5, 'expectedOutput' : 'EFWWD'},
      {'input' : 'Nummer 123 kommt', 'keyA' : 17, 'keyB': 10, 'expectedOutput' : 'XMGGAN  YOGGV'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, keyA: ${elem['keyA']}, keyB: ${elem['keyB']}', () {
        var _actual = encodeAffine(elem['input'], elem['keyA'], elem['keyB']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Affine.decodeAffine:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'keyA' : 1, 'keyB': 0, 'expectedOutput' : ''},
      {'input' : 'efWwd', 'keyA' : 11, 'keyB': 5, 'expectedOutput' : 'HALLO'},
      {'input' : 'XMGGAN YOGGV', 'keyA' : 17, 'keyB': 10, 'expectedOutput' : 'NUMMER KOMMT'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, keyA: ${elem['keyA']}, keyB: ${elem['keyB']}', () {
        var _actual = decodeAffine(elem['input'], elem['keyA'], elem['keyB']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

}