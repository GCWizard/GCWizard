import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/kamasutra/logic/kamasutra.dart';

void main() {
  group("Kamasutra.encryptKamasutra:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'alphabet': '', 'ignoreCase': true, 'expectedOutput' : ''},
      {'input' : '', 'alphabet': 'AB', 'ignoreCase': true, 'expectedOutput' : ''},

      {'input' : 'ABC', 'alphabet': '', 'ignoreCase': true, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'alphabet': 'A', 'ignoreCase': true, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'alphabet': 'AB', 'ignoreCase': true, 'expectedOutput' : 'BAC'},
      {'input' : 'ABC', 'alphabet': 'ABC', 'ignoreCase': true, 'expectedOutput' : 'BAC'},
      {'input' : 'ABCD', 'alphabet': 'ABC', 'ignoreCase': true, 'expectedOutput' : 'BACD'},
      {'input' : 'ABCD', 'alphabet': 'ABCD', 'ignoreCase': true, 'expectedOutput' : 'CDAB'},

      {'input' : 'ABC', 'alphabet': 'ab', 'ignoreCase': true, 'expectedOutput' : 'BAC'},
      {'input' : 'ABCD', 'alphabet': 'abcd', 'ignoreCase': true, 'expectedOutput' : 'CDAB'},
      {'input' : 'abc', 'alphabet': 'AB', 'ignoreCase': true, 'expectedOutput' : 'bac'},
      {'input' : 'abcd', 'alphabet': 'ABCD', 'ignoreCase': true, 'expectedOutput' : 'cdab'},

      {'input' : 'ABC', 'alphabet': 'ab', 'ignoreCase': false, 'expectedOutput' : 'ABC'},
      {'input' : 'ABCD', 'alphabet': 'abcd', 'ignoreCase': false, 'expectedOutput' : 'ABCD'},
      {'input' : 'abc', 'alphabet': 'AB', 'ignoreCase': false, 'expectedOutput' : 'abc'},
      {'input' : 'abcd', 'alphabet': 'ABCD', 'ignoreCase': false, 'expectedOutput' : 'abcd'},

      {'input' : 'abcd123XYZA', 'alphabet': 'ABCDEFGH', 'ignoreCase': true, 'expectedOutput' : 'efgh123XYZE'},
      {'input' : 'abcd123XYZA', 'alphabet': 'ABCDEFGH', 'ignoreCase': false, 'expectedOutput' : 'abcd123XYZE'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, alphabet: ${elem['alphabet']}, ignoreCase : ${elem['ignoreCase']}', () {
        var _actual = encryptKamasutra(elem['input'] as String, elem['alphabet'] as String, ignoreCase: elem['ignoreCase'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}