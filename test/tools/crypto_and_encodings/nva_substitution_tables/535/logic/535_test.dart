import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/535/logic/535.dart';

void main() {
  group("535.encrypt535:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'aeinrs', 'expectedOutput' : '01234 59090'},
      {'input' : 'nord 453', 'expectedOutput' : '38147 38944 45553 33899 09090'},
      {'input' : 'nachricht negativ', 'expectedOutput' : '65966 61390'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = encrypt535(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("535.decrypt535:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'aeinrs..', 'input' : '01234 59090'},
      {'expectedOutput' : 'nord 453...', 'input' : '38147 38944 45553 33899 09090'},
      {'expectedOutput' : 'nachricht negativ.', 'input' : '65966 61390'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decrypt535(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}