import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/spoon_language/logic/spoon_language.dart';

void main() {
  group('spoon_language.encryptSpoonLanguage:', () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Hallo Welt', 'expectedOutput' : 'halewallolewo welewelt'},
      {'input' : 'Auto', 'expectedOutput' : 'aulewautolewo'},
      {'input' : 'Ein', 'expectedOutput' : 'eilewein'},
      {'input' : 'eie', 'expectedOutput' : 'eileweielewe'},
      {'input' : 'Öl', 'expectedOutput' : 'ölewöl'},
      {'input' : 'aie', 'expectedOutput' : 'alewaielewie'},
      {'input' : 'ieeu', 'expectedOutput' : 'ielewieeuleweu'},
      {'input' : 'a', 'expectedOutput' : 'alewa'},
      {'input' : 'e', 'expectedOutput' : 'elewe'},
      {'input' : 'i', 'expectedOutput' : 'ilewi'},
      {'input' : 'o', 'expectedOutput' : 'olewo'},
      {'input' : 'u', 'expectedOutput' : 'ulewu'},
      {'input' : 'ä', 'expectedOutput' : 'älewä'},
      {'input' : 'ö', 'expectedOutput' : 'ölewö'},
      {'input' : 'ü', 'expectedOutput' : 'ülewü'},
      {'input' : 'au', 'expectedOutput' : 'aulewau'},
      {'input' : 'ei', 'expectedOutput' : 'eilewei'},
      {'input' : 'eu', 'expectedOutput' : 'euleweu'},
      {'input' : 'ie', 'expectedOutput' : 'ielewie'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encryptSpoonLanguage(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('spoon_language.decryptSpoonLanguage:', () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'hallo welt', 'input' : 'halewallolewo welewelt'},
      {'expectedOutput' : 'auto', 'input' : 'aulewautolewo'},
      {'expectedOutput' : 'ein', 'input' : 'eilewein'},
      {'expectedOutput' : 'eie', 'input' : 'eileweielewe'},
      {'expectedOutput' : 'öl', 'input' : 'ölewöl'},
      {'expectedOutput' : 'aie', 'input' : 'alewaielewie'},
      {'expectedOutput' : 'ieeu', 'input' : 'ielewieeuleweu'},
      {'expectedOutput' : 'a', 'input' : 'alewa'},
      {'expectedOutput' : 'e', 'input' : 'elewe'},
      {'expectedOutput' : 'i', 'input' : 'ilewi'},
      {'expectedOutput' : 'o', 'input' : 'olewo'},
      {'expectedOutput' : 'u', 'input' : 'ulewu'},
      {'expectedOutput' : 'ä', 'input' : 'älewä'},
      {'expectedOutput' : 'ö', 'input' : 'ölewö'},
      {'expectedOutput' : 'ü', 'input' : 'ülewü'},
      {'expectedOutput' : 'au', 'input' : 'aulewau'},
      {'expectedOutput' : 'ei', 'input' : 'eilewei'},
      {'expectedOutput' : 'eu', 'input' : 'euleweu'},
      {'expectedOutput' : 'ie', 'input' : 'ielewie'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decryptSpoonLanguage(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}