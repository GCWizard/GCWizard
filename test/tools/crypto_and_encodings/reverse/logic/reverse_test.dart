import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

void main() {
  group("Reverse.reverse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'expectedOutput' : 'Äcba9876/&%CBA'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = reverse(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}