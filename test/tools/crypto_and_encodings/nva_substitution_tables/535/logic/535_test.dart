import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/535/logic/535.dart';

void main() {
  group("535.encrypt535:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'aeinrs', 'expectedOutput' : '01234 58787'},
      {'input' : 'nord 453', 'expectedOutput' : '37046 28787'},
      {'input' : 'nachricht negativ', 'expectedOutput' : '95969 61387'},
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

      {'expectedOutput' : 'AEINRS..', 'input' : '01234 58787'},
      {'expectedOutput' : 'NORD..', 'input' : '37046 28787'},
      {'expectedOutput' : 'NACHRICHTNEGATIV.', 'input' : '95969 61387'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decrypt535(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}