import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/chicken_language.dart';

void main() {
  group('chicken_language.encryptChickenLanguage:', () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},

      {'input' : 'Hallo Welt', 'expectedOutput' : 'hahadefallohodefo wehedefelt'},
      {'input' : 'Auto', 'expectedOutput' : 'auhaudefautohodefo'},
      {'input' : 'Ein', 'expectedOutput' : 'eiheidefein'},
      {'input' : 'eie', 'expectedOutput' : 'eiheidefeiehedefe'},
      {'input' : 'Öl', 'expectedOutput' : 'öhödeföl'},
      {'input' : 'aie', 'expectedOutput' : 'ahadefaiehiedefie'},
      {'input' : 'ieeu', 'expectedOutput' : 'iehiedefieeuheudefeu'},
      {'input' : 'a', 'expectedOutput' : 'ahadefa'},
      {'input' : 'e', 'expectedOutput' : 'ehedefe'},
      {'input' : 'i', 'expectedOutput' : 'ihidefi'},
      {'input' : 'o', 'expectedOutput' : 'ohodefo'},
      {'input' : 'u', 'expectedOutput' : 'uhudefu'},
      {'input' : 'ä', 'expectedOutput' : 'ähädefä'},
      {'input' : 'ö', 'expectedOutput' : 'öhödefö'},
      {'input' : 'ü', 'expectedOutput' : 'ühüdefü'},
      {'input' : 'au', 'expectedOutput' : 'auhaudefau'},
      {'input' : 'ei', 'expectedOutput' : 'eiheidefei'},
      {'input' : 'eu', 'expectedOutput' : 'euheudefeu'},
      {'input' : 'ie', 'expectedOutput' : 'iehiedefie'},

    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encryptChickenLanguage(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group('chicken_language.decryptChickenLanguage:', () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},

      {'expectedOutput' : 'hallo welt', 'input' : 'hahadefallohodefo wehedefelt'},
      {'expectedOutput' : 'auto', 'input' : 'auhaudefautohodefo'},
      {'expectedOutput' : 'ein', 'input' : 'eiheidefein'},
      {'expectedOutput' : 'eie', 'input' : 'eiheidefeiehedefe'},
      {'expectedOutput' : 'öl', 'input' : 'öhödeföl'},
      {'expectedOutput' : 'aie', 'input' : 'ahadefaiehiedefie'},
      {'expectedOutput' : 'ieeu', 'input' : 'iehiedefieeuheudefeu'},
      {'expectedOutput' : 'a', 'input' : 'ahadefa'},
      {'expectedOutput' : 'e', 'input' : 'ehedefe'},
      {'expectedOutput' : 'i', 'input' : 'ihidefi'},
      {'expectedOutput' : 'o', 'input' : 'ohodefo'},
      {'expectedOutput' : 'u', 'input' : 'uhudefu'},
      {'expectedOutput' : 'ä', 'input' : 'ähädefä'},
      {'expectedOutput' : 'ö', 'input' : 'öhödefö'},
      {'expectedOutput' : 'ü', 'input' : 'ühüdefü'},
      {'expectedOutput' : 'au', 'input' : 'auhaudefau'},
      {'expectedOutput' : 'ei', 'input' : 'eiheidefei'},
      {'expectedOutput' : 'eu', 'input' : 'euheudefeu'},
      {'expectedOutput' : 'ie', 'input' : 'iehiedefie'},
      {'expectedOutput' : 'ahedefa', 'input' : 'ahedefa'},
      {'expectedOutput' : 'auhadefa', 'input' : 'auhadefa'},
      {'expectedOutput' : 'au', 'input' : 'ahadefau'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decryptChickenLanguage(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}