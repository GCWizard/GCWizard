import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/Juno/logic/Juno.dart';

void main() {
  group("Juno.encryptJuno:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'aeinrs', 'expectedOutput' : '01234 59090'},
      {'input' : 'nord 453', 'expectedOutput' : '38147 38944 45553 33899 09090'},
      {'input' : 'nachricht negativ', 'expectedOutput' : '65966 61390'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = encryptJuno(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Juno.decryptJuno:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AEINRS..', 'input' : '01234 59090'},
      {'expectedOutput' : 'NORD453...', 'input' : '38147 38944 45553 33899 09090'},
      {'expectedOutput' : 'NACHRICHTNEGATIV.', 'input' : '65966 61390'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decryptJuno(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}