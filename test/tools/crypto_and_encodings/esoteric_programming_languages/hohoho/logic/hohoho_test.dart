import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/hohoho/logic/hohoho.dart';

void main() {
  group("Hohoho.interpretHohoho:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'code' : '', 'expectedOutput' : ''},
      {'code' : 'ABC123;', 'expectedOutput' : ''},
      {'code' : '++', 'expectedOutput' : ''},

      // https://www.geocaching.com/geocache/GC9GFQM_hohoho
      {'code' : 'Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohohohohohohohohohohohohohoho! Hohohohohoho! Hohohohohoho! Hoho! Ho! Ho! Hoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho! Ho! Ho! Hoho! Hohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Ho! Ho!',
        'expectedOutput' : '42710/05659'},
      // https://hohoho.jakobsenkl.pw/
      {'code' : 'Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohohohohohohohohohohohohohohohohohohohoho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hohohohohohohohohohohohohohohohohohohohohohohohohohohohohoho! Ho! Hohoho! Ho! Ho! Hohohohohohohohohohohohohohohohohohohohohohohohohohoho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hohohohohohohohohohohoho! Ho! Hohoho! Ho! Ho! Hohohohohohohohoho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hohohohohohohohohohohoho! Ho! Hohoho! Ho! Ho! Hohohohohohohohohohohoho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Ho! Ho!',
        'expectedOutput' : 'merry xmas'},

      //Input copy
      {'code' : 'Hoho! Ho! Hohohoho! Hoho! Hoho! Hohoho! Ho!', 'input': 'ABC123', 'expectedOutput' : 'ABC123'},
      //ROT13: adopted https://en.wikipedia.org/w/index.php?title=Brainf**k&oldid=944639112#ROT13
      {'code' : 'hohoho! Hoho! Ho! Ho! Ho! Ho! Hohohohohoho! Hohoho! Ho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohohohohoho! Hoho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohohoho! Hohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Hohohohoho! Hohoho! Ho! Hoho! Ho! Hoho! Ho! Hohohoho! Hoho! Ho! Ho! Hohoho! Hohoho! Ho! Hoho! Ho! Ho! Hoho! Ho! Hohohohohoho! Ho! Ho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Hohohoho! Hoho! Ho! Hoho! Ho! Hoho! Ho! Hoho! Ho! Hoho! Ho! Hohohohohoho! Hohoho! Ho! Ho! Hoho! Ho! Hoho! Ho! Hoho! Hohohohohohohoho! Ho! Ho! Ho! Ho! Ho! Hohohohohohohoho! Hohohohohoho! Hohohoho! Ho! Hohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohohoho! Hohoho! Hohoho! Hoho! Ho! Ho! Hohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Ho! Hohoho! Ho! Hohohohoho! Hohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohohoho! Ho! Ho! Hoho! Hohoho! Ho! Ho! Ho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohohoho! Hoho! Ho! Hoho! Ho! Hoho! Ho! Hoho! Ho! Hoho! Ho! Hohohohohoho! Ho! Ho! Hoho! Ho! Hoho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Ho! Ho! Hoho! Hohohohohoho! Hohohohohohoho! Ho! Hoho! Ho! Ho! Hohohohohohohoho! Ho! Ho! Hoho! Ho! Hohohoho! Hoho! Ho! Hoho! Ho! Ho! Hohohoho! Ho! Hoho! Ho! Hohohoho! Ho! Hoho! Ho! Hohohohohohoho! Ho! Ho! Hoho! Ho! Hohohoho! Hoho! Ho! Hoho! Ho! Ho! Hohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohohohohohoho! Hohoho! Hoho! Ho! Ho! Hohohohohohohoho! Hoho! Ho! Hoho! Hoho! Hohohohohohohoho! Hoho! Ho! Hohohoho! Hoho! Ho! Ho! Ho! Hohoho! Ho', 'input': 'ABC123', 'expectedOutput' : 'NOP123'},

    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = interpretHohoho(elem['code'] as String, STDIN: elem['input'] as String?).output;
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Hohoho.generateHohoho:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      {'expectedOutput' : 'Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohohohohohohohohohohohohohoho! Hohohohohoho! Hohohohohoho! Hoho! Ho! Ho! Hoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho! Ho! Ho! Hoho! Hohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho!',
        'OutputText' : '42710/05659'},

      {'expectedOutput' : 'Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Hohohohohohohohohohohohoho! Ho! Hohohohohohoho! Hoho! Ho! Hoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Hohohohohohohohohohohohohohohohohohohohohohohohohohohoho! Ho! Hohohohohohoho! Hoho! Ho! Hohohohohohohohohohohohohohohohohohohohohohohohohoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Hohohohohohohohohoho! Ho! Hohohohohohoho! Hoho! Ho! Hohohohohohohoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Hohohohohohohohohohohohoho! Ho! Hohohohohohoho! Hoho! Ho! Hoho! Hoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho!',
        'OutputText' : 'merry xmas'},

    ];

    for (var elem in _inputsToExpected) {
      test('OutputText: ${elem['OutputText']}}', () {
        var _actual = generateHohoho(elem['OutputText'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}