import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/enclosed_areas/logic/enclosed_areas.dart';

void main() {
  group("EnclosedAreas.with4:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '._*&%><', 'expectedOutput' : '4'},

      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : '10'},
      {'input' : 'abcdefghijklmnopqrstuvwxyzäöüß', 'expectedOutput' : '10'},
      {'input' : '0123456789', 'expectedOutput' : '6'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß 0123456789', 'expectedOutput' : '10 6'},
      {'input' : '._*&%><', 'expectedOutput' : '4'},
      {'input' : '1082158111 2355712317° 2111355772 2309215781.1603217532 0229798165 7273291356', 'expectedOutput' : '5 1 0 6 6 2'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeEnclosedAreas(elem['input'] as String, with4: true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("EnclosedAreas.without4:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : '10'},
      {'input' : 'abcdefghijklmnopqrstuvwxyzäöüß', 'expectedOutput' : '10'},
      {'input' : '0123456789', 'expectedOutput' : '5'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß 0123456789', 'expectedOutput' : '10 5'},
      {'input' : '._*&%><', 'expectedOutput' : '4'},
   ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeEnclosedAreas(elem['input'] as String, with4: false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("EnclosedAreas.onlyNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : ''},
      {'input' : 'abcdefghijklmnopqrstuvwxyzäöüß', 'expectedOutput' : ''},
      {'input' : '0123456789', 'expectedOutput' : '6'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß 0123456789', 'expectedOutput' : '6'},
      {'input' : '._*&%><', 'expectedOutput' : ''},
      {'input' : '1082158111 2355712317° 2111355772 2309215781.1603217532 0229798165 7273291356', 'expectedOutput' : '5 0 0 4 2 6 2'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeEnclosedAreas(elem['input'] as String, with4: true, onlyNumbers: true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
