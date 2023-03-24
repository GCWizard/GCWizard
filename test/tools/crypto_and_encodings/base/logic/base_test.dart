import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';

void main() {

  group("Base58.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '3429289555', 'expectedOutput' : '6e31iZ'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase58(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base58.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '6e31iZ', 'expectedOutput' : '3429289555'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase58(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base91.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'This is an encoded string', 'expectedOutput' : 'nX,<:WRT%yV%!5:maref3+1RrUb64^M'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase91(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base91.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'nX,<:WRT%yV%!5:maref3+1RrUb64^M', 'expectedOutput' : 'This is an encoded string'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase91(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base122.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'GC Wizard', 'expectedOutput' : '#Pd;%ta9ހ'},
      {'input' : 'cache bei nord 123 ost 567', 'expectedOutput' : '1X,6C\x14@b2Z\$\x06s=dd\x10\fң\x19\x01^s:\b\x06S1ߜ'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase122(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base122.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '#Pd;%ta9ހ', 'expectedOutput' : 'GC Wizard'},
      {'input' : '1X,6C\x14@b2Z\$\x06s=dd\x10\fң\x19\x01^s:\b\x06S1ߜ', 'expectedOutput' : 'cache bei nord 123 ost 567'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase122(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}