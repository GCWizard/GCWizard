import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity_words.dart';
import 'package:gc_wizard/utils/string_utils.dart';

void main(){

  group("VanityWords.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty input
      {'input' : null, 'language' : NumeralWordsLanguage.DEU,
        'expectedOutput' : [VanityWordsDecodeOutput('?', '', '', false)]},
      {'input' : '', 'language' : NumeralWordsLanguage.DEU,
        'expectedOutput' : [VanityWordsDecodeOutput('', '', '', false)]},
      // faulty input
      {'input' : 'e', 'language' : NumeralWordsLanguage.DEU,
        'expectedOutput' : [VanityWordsDecodeOutput('?', '', '', false)]},
      {'input' : 'fünfundzwanzig', 'language' : NumeralWordsLanguage.LAT,
        'expectedOutput' : <VanityWordsDecodeOutput>[]},
      // mixed input
      {'input' : '8437676386e', 'language' : NumeralWordsLanguage.DEU,
        'expectedOutput' : [
          VanityWordsDecodeOutput('8437', 'VIER', '4', false),
          VanityWordsDecodeOutput('?', '', '', false),
          VanityWordsDecodeOutput('?', '', '', false),
          VanityWordsDecodeOutput('6386', 'NEUN', '9', false),
          VanityWordsDecodeOutput('?', '', '', false),
        ]},
      // languages
      {'input' : '6855 3467 9934 996 3734 8437 38363 3863 73247 743236 2248 6386', 'language' : NumeralWordsLanguage.DEU,
        'expectedOutput' : [
          VanityWordsDecodeOutput('6855', 'NULL', '0', false),
          VanityWordsDecodeOutput('3467', 'EINS', '1', false),
          VanityWordsDecodeOutput('9934', 'ZWEI', '2', false),
          VanityWordsDecodeOutput('996', 'ZWO', '2', false),
          VanityWordsDecodeOutput('3734', 'DREI', '3', false),
          VanityWordsDecodeOutput('8437', 'VIER', '4', false),
          VanityWordsDecodeOutput('38363', 'FUENF', '5', false),
          VanityWordsDecodeOutput('3863', 'FÜNF', '5', false),
          VanityWordsDecodeOutput('73247', 'SECHS', '6', false),
          VanityWordsDecodeOutput('743236', 'SIEBEN', '7', false),
          VanityWordsDecodeOutput('2248', 'ACHT', '8', false),
          VanityWordsDecodeOutput('6386', 'NEUN', '9', false),
        ]},
      // ambigous
      {'input' : '9376 53336 392 3943 743336 67436 39439432 8779 298379 7342 79372', 'language' : NumeralWordsLanguage.POL,
        'expectedOutput' : [
          VanityWordsDecodeOutput('9376', 'ZERO', '0', false),
          VanityWordsDecodeOutput('53336', 'JEDEN', '1', false),
          VanityWordsDecodeOutput('392', 'DWA', '2', false),
          VanityWordsDecodeOutput('3943', 'DWIE', '2', false),
          VanityWordsDecodeOutput('743336', 'SIEDEM', '7', false),
          VanityWordsDecodeOutput('67436', 'OSIEM', '8', false),
          VanityWordsDecodeOutput('3943', 'DWIE', '2', true),
          VanityWordsDecodeOutput('39439432', 'DZIEWIĘĆ', '9', true),
        ]},
    ];

    for (var elem in _inputsToExpected) { // Mark test
      test('input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeVanityWords(removeAccents(elem['input'].toString().toLowerCase()), elem['language'] as NumeralWordsLanguage);
        var list = elem['expectedOutput'] as List<VanityWordsDecodeOutput>;
        var length = list.length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, list[i].number);
          expect(_actual[i].numWord, list[i].numWord);
          expect(_actual[i].digit, list[i].digit);
        }
      });
    }
  });
}