import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/fox/logic/fox.dart';

void main() {
  group("Fox.encodeFox:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC XYZ', 'expectedOutput' : '11 12 13 39 36 37 38'},
      {'input' : 'AbcxyZ', 'expectedOutput' : '11 12 13 36 37 38'},
      {'input' : 'ABC123XYZ', 'expectedOutput' : '11 12 13 36 37 38'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeFox(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Fox.decodeFox:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'ABC XYZ', 'input' : '11 12 13 39 36 37 38'},
      {'expectedOutput' : 'ABCXYZ', 'input' : '11 12 13 36 37 38'},

      {'expectedOutput' : 'ABCXYZ', 'input' : '1112133637383'},
      {'expectedOutput' : 'ABDYZ', 'input' : '111214463738'},
      {'expectedOutput' : 'ABDY', 'input' : '1112144637ab'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeFox(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}