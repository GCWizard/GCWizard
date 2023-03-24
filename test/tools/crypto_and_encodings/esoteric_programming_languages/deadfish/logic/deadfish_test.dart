import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/logic/deadfish.dart';

void main() {
  group("Deadfish.encodeDeadfish:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Hallo Welt', 'expectedOutput' : 'iissiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioiiiiiiiiiiiiiiiiiiiiiiiiioiiiiiiiiiiiooiiiodddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddoiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioiiiiiiiiiiiiiioiiiiiiioiiiiiiiio'},
      {'input' : 'Test123', 'expectedOutput' : 'iissiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioiiiiiiiiiiiiiiiiioiiiiiiiiiiiiiioiodddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddoioio'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeDeadfish(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Deadfish.decodeDeadfish:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'Hallo Welt', 'input' : 'iisiiiisiiiiiiiioiiiiiiiiiiiiiiiiiiiiiiiiioiiiiiiiiiiiooiiiodddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddoiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioiiiiiiiiiiiiiioiiiiiiioiiiiiiiio'},
      {'expectedOutput' : 'H', 'input' : 'IISIIIISIIIIIIIIO'},

      {'expectedOutput' : '0 0', 'input' : 'Otto'},
      {'expectedOutput' : '0 0 0 1 0 1 2 2 4 3', 'input' : 'Otto, Odilo und Otila wohnen in Honolulu in ihrem orangenen Domizil'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeDeadfish(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
