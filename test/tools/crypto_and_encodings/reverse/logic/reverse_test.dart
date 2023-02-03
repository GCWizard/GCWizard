import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

void main() {
  group("Reverse.reverse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'expectedOutput' : 'Äcba9876/&%CBA'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = reverse(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}