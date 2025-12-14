import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/hva/logic/hva.dart';

void main() {
  group("HVA.encryptHVA:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'aeinrs', 'expectedOutput' : '01234 59090'},
      {'input' : 'nord 453', 'expectedOutput' : '38147 38944 45553 33899 09090'},
      {'input' : 'nachricht negativ', 'expectedOutput' : '65966 61390'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = encryptHVA(elem['input'] as String, elem['keyOneTimePad'] as String?, elem['1950'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("HVA.decryptHVA:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AEINRS..', 'input' : '01234 59090'},
      {'expectedOutput' : 'NORD453...', 'input' : '38147 38944 45553 33899 09090'},
      {'expectedOutput' : 'NACHRICHTNEGATIV.', 'input' : '65966 61390'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decryptHVA(elem['input'] as String, elem['keyOneTimePad'] as String?, elem['1950'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}