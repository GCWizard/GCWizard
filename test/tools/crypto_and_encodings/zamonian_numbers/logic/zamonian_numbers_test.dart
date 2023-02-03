import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/zamonian_numbers/logic/zamonian_numbers.dart';

void main() {
  group("ZamonianNumbers.encode:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '0 1 2 3', 'expectedOutput' : '0 1 2 3'},
      {'input' : '8', 'expectedOutput' : '10'},
      {'input' : '8 9 1', 'expectedOutput' : '10 11 1'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeZamonian(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("ZamonianNumbers.decode:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '0 1 2 3', 'expectedOutput' : '0 1 2 3'},
      {'input' : '10', 'expectedOutput' : '8'},
      {'input' : '10 11 1', 'expectedOutput' : '8 9 1'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeZamonian(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}