import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_crypt/logic/spelling_alphabets_crypt.dart';

void main() {
  group("SpellingAlphabets.encodeSpellingAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'language': SPELLING.NATO, 'expectedOutput' : ''},

      {'input' : 'gc wizard ist toll', 'language': SPELLING.NATO, 'expectedOutput' : 'GOLF CHARLIE WHISKEY INDIA ZULU ALFA ROMEO DELTA INDIA SIERRA TANGO TANGO OSCAR LIMA LIMA'},

      {'input' : 'gc wizard ist toll', 'language': SPELLING.GRC, 'expectedOutput' : 'ΊΣΚΙΟΣ ΖΕΥΣ ΑΣΤΉΡ ΊΣΚΙΟΣ ΤΊΓΡΗΣ ΤΊΓΡΗΣ ΟΣΜΉ'},
      {'input' : 'gc wizard ist toll', 'language': SPELLING.GRCLAT, 'expectedOutput' : 'ÍSKIOS ZEFS ASTÍR ÍSKIOS TÍGRIS TÍGRIS OSMÍ'},

      {'input' : 'gc wizard ist toll', 'language': SPELLING.RUS, 'expectedOutput' : 'СЕРГЕЙ АНТОН ТАМАРА ТАМАРА ОЛЬГА'},
      {'input' : 'gc wizard ist toll', 'language': SPELLING.RUSLAT, 'expectedOutput' : 'SERGEI ANTON TAMARA TAMARA OLGA'},
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

      {'expectedOutput' : 'GCWIZARDISTTOLL', 'language': SPELLING.NATO, 'input' : 'GOLF CHARLIE  WHISKEY INDIA ZULU ALFA ROMEO DELTA  INDIA SIERRA TANGO TANGO OSCAR LIMA LIMA'},

      {'expectedOutput' : 'IZAITTO', 'language': SPELLING.GRC, 'input' : 'ΊΣΚΙΟΣ ΖΕΥΣ ΑΣΤΉΡ ΊΣΚΙΟΣ ΤΊΓΡΗΣ ΤΊΓΡΗΣ ΟΣΜΉ'},
      {'expectedOutput' : 'IZAITTO', 'language': SPELLING.GRCLAT, 'input' : 'ÍSKIOS ZEFS ASTÍR ÍSKIOS TÍGRIS TÍGRIS OSMÍ'},

      {'expectedOutput' : 'CATTO', 'language': SPELLING.RUS, 'input' : 'СЕРГЕЙ АНТОН ТАМАРА ТАМАРА ОЛЬГА'},
      {'expectedOutput' : 'CATTO', 'language': SPELLING.RUSLAT, 'input' : 'SERGEI ANTON TAMARA TAMARA OLGA'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, language: ${elem['language']}', () {
        var _actual = decodeSpellingAlphabets(elem['input'] as String, elem['language'] as SPELLING,);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}
