import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_crypt/logic/spelling_alphabets_crypt.dart';

void main() {
  group("SpellingAlphabets.encodeSpellingAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'language': SPELLING.NATO, 'expectedOutput' : ''},

      {'input' : 'gc wizard ist toll', 'language': SPELLING.NATO, 'expectedOutput' : 'GOLF CHARLIE WHISKEY INDIA ZULU ALFA ROMEO DELTA INDIA SIERRA TANGO TANGO OSCAR LIMA LIMA'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, language: ${elem['language']}', () {
        var _actual = encodeSpellingAlphabets(elem['input'] as String, elem['language'] as SPELLING,);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("SpellingAlphabets.decodeSpellingAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'language': SPELLING.NATO, 'expectedOutput' : ''},

      {'expectedOutput' : 'GCWIZARDISTTOLL', 'language': SPELLING.NATO, 'input' : 'GOLF CHARLIE  WHISKEY INDIA ZULU ALPHA ROMEO DELTA  INDIA SIERRA TANGO TANGO OSCAR LIMA LIMA'},
      {'expectedOutput' : 'GCWIZARDISTTOLL', 'language': SPELLING.NATO, 'input' : 'GOLF CHARLIE  WHISKEY INDIA ZULU ALFA ROMEO DELTA  INDIA SIERRA TANGO TANGO OSCAR LIMA LIMA'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, language: ${elem['language']}', () {
        var _actual = decodeSpellingAlphabets(elem['input'] as String, elem['language'] as SPELLING,);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}
