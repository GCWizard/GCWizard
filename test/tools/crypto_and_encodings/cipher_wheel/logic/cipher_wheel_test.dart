import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/cipher_wheel/logic/cipher_wheel.dart';

void main() {
  group("CipherWheel.encryptCipherWheel:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'key': 1, 'expectedOutput' : []},
      {'input' : '', 'key': 1, 'expectedOutput' : []},

      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 1, 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 0, 'expectedOutput' : [26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 8, 'expectedOutput' : [8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,1,2,3,4,5,6,7]},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 26, 'expectedOutput' : [26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encryptCipherWheel(elem['input'], elem['key']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CipherWheel.decryptCipherWheel:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput' : '', 'key': 1, 'input' : null},
      {'expectedOutput' : '', 'key': 1, 'input' : <int>[]},

      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 1, 'input' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 0, 'input' : [26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 8, 'input' : [8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,1,2,3,4,5,6,7]},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key': 26, 'input' : [26,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decryptCipherWheel(elem['input'], elem['key']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}