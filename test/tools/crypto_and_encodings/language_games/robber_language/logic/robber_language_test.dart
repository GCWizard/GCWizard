import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/robber_language/logic/robber_language.dart';

void main() {
  group('robber_language.encryptRobberLanguage:', () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},

      {'input' : 'Hallo Welt', 'expectedOutput' : 'hohalollolo woweloltot'},
      {'input' : 'Robber', 'expectedOutput' : 'rorobobboberor'},
      {'input' : 'ab', 'expectedOutput' : 'abob'},
      {'input' : 'ba', 'expectedOutput' : 'boba'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encryptRobberLanguage(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group('robber_language.decryptRobberLanguage:', () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},

      {'expectedOutput' : 'hallo welt', 'input' : 'hohalollolo woweloltot'},
      {'expectedOutput' : 'robber', 'input' : 'rorobobboberor'},
      {'expectedOutput' : 'ab', 'input' : 'abob'},
      {'expectedOutput' : 'ba', 'input' : 'boba'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decryptRobberLanguage(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}