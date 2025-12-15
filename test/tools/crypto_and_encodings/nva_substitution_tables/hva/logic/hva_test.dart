import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/hva/logic/hva.dart';

void main() {
  group("HVA.encryptHVA1950:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'rinste', 'expectedOutput' : '10265 83838'},
      {'input' : 'bericht bestätigen treff nord 456 ost 123', 'expectedOutput' : '92453 62491 98354 44555 66635 49653 51112 22333'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = encryptHVA(elem['input'] as String, elem['keyOneTimePad'] as String?, true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("HVA.encryptHVA1970:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'seaitn', 'expectedOutput' : '79825 43232'},
      {'input' : 'bericht bestätigen treff nord 456 ost 123', 'expectedOutput' : '14135 17966 66401 17643 84445 55666 38017 53811 12223 33383 23232'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = encryptHVA(elem['input'] as String, elem['keyOneTimePad'] as String?, false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("HVA.decryptHVA1950:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'RINSTE..', 'input' : '10265 83838'},
      {'expectedOutput' : 'BERICHTBESTÄTIGENTREFFNORD456OST123', 'input' : '92453 62491 98354 44555 66635 49653 51112 22333'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decryptHVA(elem['input'] as String, elem['keyOneTimePad'] as String?, true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("HVA.decryptHVA19/0:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SEAITN..', 'input' : '79825 43232'},
      {'expectedOutput' : 'BERICHTBESTÄTIGENTREFFNORD456OST123...', 'input' : '14135 17966 66401 17643 84445 55666 38017 53811 12223 33383 23232'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decryptHVA(elem['input'] as String, elem['keyOneTimePad'] as String?, false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}