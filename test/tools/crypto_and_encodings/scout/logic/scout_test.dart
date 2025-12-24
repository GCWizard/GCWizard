import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/scout/logic/scout.dart';

void main() {
  group("Scoutchiffer.decode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'Ss', 'expectedOutput' : 'A'},
      {'input' : 'Ss Cs Os', 'expectedOutput' : 'A B C'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: "${elem['input']}"', () {
        var _actual = decodeScout(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }

    test("RangeException", () {
      expect(() => decodeScout('Xx'), throwsA(TypeMatcher<RangeException>()));
    });
  });

  group("Scoutchiffer.encode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'a', 'expectedOutput' : 'Ss'},
      {'input' : 'abc', 'expectedOutput' : 'Ss Cs Os'},
      {'input' : 'ABC', 'expectedOutput' : 'Ss Cs Os'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: "${elem['input']}"', () {
        var _actual = encodeScout(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }

    test("RangeException", () {
      expect(() => encodeScout('1'), throwsA(TypeMatcher<RangeException>()));
    });
  });
}