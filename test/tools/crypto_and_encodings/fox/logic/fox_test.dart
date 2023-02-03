import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/fox/logic/fox.dart';

void main() {
  group("Fox.encodeFox:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC XYZ', 'expectedOutput' : '11 12 13 39 36 37 38'},
      {'input' : 'AbcxyZ', 'expectedOutput' : '11 12 13 36 37 38'},
      {'input' : 'ABC123XYZ', 'expectedOutput' : '11 12 13 36 37 38'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeFox(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Fox.decodeFox:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC XYZ', 'input' : '11 12 13 39 36 37 38'},
      {'expectedOutput' : 'ABCXYZ', 'input' : '11 12 13 36 37 38'},

      {'expectedOutput' : 'ABCXYZ', 'input' : '1112133637383'},
      {'expectedOutput' : 'ABDYZ', 'input' : '111214463738'},
      {'expectedOutput' : 'ABDY', 'input' : '1112144637ab'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeFox(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}