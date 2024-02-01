import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/utils/string_utils.dart';

void main(){

  // language: NumeralWordsLanguage.ALL;
  // bool decodeModeEntireParts = true => decodeMode = false

    group("NumeralWords.decodeNumeralwordsEntireWordsDEU:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      {'input' : 'huit dwa seize six one two eins',
        'language' : NumeralWordsLanguage.ALL,
        'decodeMode' : true,
        'expectedOutput' : [
          NumeralWordsDecodeOutput('8', 'huit', 'common_language_french'),
          NumeralWordsDecodeOutput('2', 'dwa', 'common_language_bulgarian'),
          NumeralWordsDecodeOutput('', '', 'common_language_polish'),
          NumeralWordsDecodeOutput('', '', 'common_language_russian'),
          NumeralWordsDecodeOutput('16', 'seize', 'common_language_french'),
          NumeralWordsDecodeOutput('6', 'six', 'common_language_english'),
          NumeralWordsDecodeOutput('', '', 'common_language_french'),
          NumeralWordsDecodeOutput('1', 'one', 'common_language_english'),
          NumeralWordsDecodeOutput('2', 'two', 'common_language_english'),
          NumeralWordsDecodeOutput('1', 'eins', 'common_language_german'),
        ]
      },

      {'input' : 'fuenf fünf kvin cinq пять lul five zéro',
        'language' : NumeralWordsLanguage.ALL,
        'decodeMode' : false,
        'expectedOutput' : [
          NumeralWordsDecodeOutput('5', 'fuenf', 'common_language_german'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('5', 'fuenf', 'common_language_german'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('5', 'kvin', 'common_language_esperanto'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('5', 'cinq', 'common_language_french'),
          NumeralWordsDecodeOutput('3', 'ci', 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('5', 'пять', 'numeralwords_language_kyr'),
          NumeralWordsDecodeOutput('5', 'lul', 'common_language_volapuek'),
          NumeralWordsDecodeOutput('5', 'five', 'common_language_english'),
          NumeralWordsDecodeOutput('', 'five', 'numeralwords_language_sco'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('0', 'zero', 'common_language_czech'),
          NumeralWordsDecodeOutput('', 'zero', 'common_language_english'),
          NumeralWordsDecodeOutput('', 'zero', 'common_language_french'),
          NumeralWordsDecodeOutput('', 'zero', 'common_language_italian'),
          NumeralWordsDecodeOutput('', 'zero', 'numeralwords_language_jap'),
          NumeralWordsDecodeOutput('7', 'ze', 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput('', 'zero', 'numeralwords_language_meg'),
          NumeralWordsDecodeOutput('', 'zero', 'common_language_polish'),
          NumeralWordsDecodeOutput('', 'zero', 'common_language_portuguese'),
          NumeralWordsDecodeOutput('', 'zero', 'common_language_romanian'),
          NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),

        ]
      },
      {'input' : 'fuenf fünf kvin cinq пять lul five zéro',
        'language' : NumeralWordsLanguage.ALL,
        'decodeMode' : true,
        'expectedOutput' : [
          NumeralWordsDecodeOutput('5', 'fuenf', 'common_language_german'),
          NumeralWordsDecodeOutput('5', 'fuenf', 'common_language_german'),
          NumeralWordsDecodeOutput('5', 'kvin', 'common_language_esperanto'),
          NumeralWordsDecodeOutput('5', 'cinq', 'common_language_french'),
          NumeralWordsDecodeOutput('5', 'пять', 'numeralwords_language_kyr'),
          NumeralWordsDecodeOutput('5', 'lul', 'common_language_volapuek'),
          NumeralWordsDecodeOutput('5', 'five', 'common_language_english'),
          NumeralWordsDecodeOutput('', '', 'numeralwords_language_sco'),
          NumeralWordsDecodeOutput('0', 'zero', 'common_language_czech'),
          NumeralWordsDecodeOutput('', '', 'common_language_english'),
          NumeralWordsDecodeOutput('', '', 'common_language_french'),
          NumeralWordsDecodeOutput('', '', 'common_language_italian'),
          NumeralWordsDecodeOutput('', '', 'numeralwords_language_jap'),
          NumeralWordsDecodeOutput('', '', 'numeralwords_language_meg'),
          NumeralWordsDecodeOutput('', '', 'common_language_polish'),
          NumeralWordsDecodeOutput('', '', 'common_language_portuguese'),
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeNumeralwords(input: elem['input'] as String, language: elem['language'] as NumeralWordsLanguage, decodeModeWholeWords: elem['decodeMode'] as bool);
        var length = (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].number);
          expect(_actual[i].numWord, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].numWord);
          expect(_actual[i].language, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].language);
        }
      });
    }
  });

  group("NumeralWords.decodeNumeralwordsEntireWordsAsParts:", () {
    List<Map<String, Object?>> _inputsToExpected = [
       {'input' : 'huit cinq seize sis one two eins', 'language' : NumeralWordsLanguage.ALL, 'decodeMode' : false,
         'expectedOutput' : [
           NumeralWordsDecodeOutput('8', 'huit', 'common_language_french'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('5', 'cinq', 'common_language_french'),
           NumeralWordsDecodeOutput('3', 'ci', 'numeralwords_language_loj'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('6', 'sei', 'numeralwords_language_bas'),
           NumeralWordsDecodeOutput('16', 'seize', 'common_language_french'),
           NumeralWordsDecodeOutput('', 'sei', 'common_language_italian'),
           NumeralWordsDecodeOutput('3', 'se', 'common_language_korean'),
           NumeralWordsDecodeOutput('3', 'se', 'numeralwords_language_per'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('7', 'ze', 'numeralwords_language_loj'),
           NumeralWordsDecodeOutput('6', 'zes', 'common_language_dutch'),
           NumeralWordsDecodeOutput('4', 'si', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('', 'si', 'common_language_thai_rtgs'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('9', 'so', 'numeralwords_language_loj'),
           NumeralWordsDecodeOutput('1', 'one', 'common_language_english'),
           NumeralWordsDecodeOutput('100', 'on', 'common_language_korean'),
           NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('10', 'on', 'numeralwords_language_tur'),
           NumeralWordsDecodeOutput('4', 'net', 'common_language_korean'),
           NumeralWordsDecodeOutput('', 'ne', 'common_language_korean'),
           NumeralWordsDecodeOutput('2', 'two', 'common_language_english'),
           NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('1', 'eins', 'common_language_german'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
         ]
       },
      {'input' : 'huit cinq seize sis one two eins',
        'language' : NumeralWordsLanguage.ALL,
        'decodeMode' : true,
        'expectedOutput' : [
          NumeralWordsDecodeOutput('8', 'huit', 'common_language_french'),
          NumeralWordsDecodeOutput('5', 'cinq', 'common_language_french'),
          NumeralWordsDecodeOutput('16', 'seize', 'common_language_french'),
          NumeralWordsDecodeOutput('1', 'one', 'common_language_english'),
          NumeralWordsDecodeOutput('2', 'two', 'common_language_english'),
          NumeralWordsDecodeOutput('1', 'eins', 'common_language_german'),
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeNumeralwords(input: elem['input'] as String, language: elem['language'] as NumeralWordsLanguage, decodeModeWholeWords: elem['decodeMode'] as bool);
        var length = (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].number);
          expect(_actual[i].numWord, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].numWord);
          expect(_actual[i].language, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].language);
        }
      });
    }
  });

  group("NumeralWords.decodeNumeralwordsWordParts:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'Susi wacht einsam während Vater und Mutter zweifelnd Sand sieben. Null Bock, denkt sich Jörg. Ich lasse fünfe grade sein und kegel lieber alle Neune!',
        'language' : NumeralWordsLanguage.ALL,
        'decodeMode' : false,
        'expectedOutput' : [
          NumeralWordsDecodeOutput('4', 'si', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('', 'si', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('1', 'wa', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('8', 'acht', 'common_language_german'),
          NumeralWordsDecodeOutput('', 'acht', 'common_language_dutch'),
          NumeralWordsDecodeOutput('1', 'eins', 'common_language_german'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('3', 'sam', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('4', 'sa', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('', 'sam', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput('1', 'wa', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('1', 'ae', 'numeralwords_language_sco'),
          NumeralWordsDecodeOutput('2', 're', 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('2', 'dva', 'common_language_czech'),
          NumeralWordsDecodeOutput('', 'dva', 'common_language_slovak'),
          NumeralWordsDecodeOutput('1', 'at', 'numeralwords_language_dot'),
          NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('1', 'un', 'common_language_french'),
          NumeralWordsDecodeOutput('5', 'mu', 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('2', 'zwei', 'common_language_german'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('3', 'san', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('', 'san', 'numeralwords_language_jap'),
          NumeralWordsDecodeOutput('4', 'sa', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('4', 'si', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('7', 'sieben', 'common_language_german'),
          NumeralWordsDecodeOutput('', 'si', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('0', 'null', 'common_language_german'),
          NumeralWordsDecodeOutput('', 'nul', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'nul', 'common_language_dutch'),
          NumeralWordsDecodeOutput('', 'null', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'nul', 'common_language_russian'),
          NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('4', 'si', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('', 'si', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('3', 'se', 'common_language_korean'),
          NumeralWordsDecodeOutput('', 'se', 'numeralwords_language_per'),
          NumeralWordsDecodeOutput('5', 'fuenf', 'common_language_german'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('°', 'grad', 'common_language_german'),
          NumeralWordsDecodeOutput('', 'grad', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'grad', 'common_language_romanian'),
          NumeralWordsDecodeOutput('', 'grad', 'common_language_russian'),
          NumeralWordsDecodeOutput('', 'grad', 'common_language_swedish'),
          NumeralWordsDecodeOutput('grad', 'grad', 'common_language_volapuek'),
          NumeralWordsDecodeOutput('6', 'sei', 'numeralwords_language_bas'),
          NumeralWordsDecodeOutput('', 'sei', 'common_language_italian'),
          NumeralWordsDecodeOutput('3', 'se', 'common_language_korean'),
          NumeralWordsDecodeOutput('3', 'se', 'numeralwords_language_per'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('1', 'un', 'common_language_french'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput('9', 'neun', 'common_language_german'),
          NumeralWordsDecodeOutput('4', 'ne', 'common_language_korean'),
          NumeralWordsDecodeOutput('1', 'un', 'common_language_french'),
          NumeralWordsDecodeOutput('', 'une', 'common_language_french'),
          NumeralWordsDecodeOutput('4', 'ne', 'common_language_korean'),
        ]},

       {'input' : 'Hui trällert Balthasar. Null Bock auf nichts sondern den Sessel hüten um nicht die gute Laune zu verlieren. Und wahrlich, das ist ok.', 'language' : NumeralWordsLanguage.ALL, 'decodeMode' : false,
         'expectedOutput' : [
           NumeralWordsDecodeOutput('8', 'huit', 'common_language_french'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('1', 'ae', 'numeralwords_language_sco'),
           NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('8', 'ba', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('3', 'ba', 'numeralwords_language_vie'),
           NumeralWordsDecodeOutput('1', 'bal', 'common_language_volapuek'),
           NumeralWordsDecodeOutput('5', 'ha', 'common_language_thai_rtgs'),
           NumeralWordsDecodeOutput('4', 'sa', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('0', 'null', 'common_language_german'),
           NumeralWordsDecodeOutput('', 'nul', 'common_language_danish'),
           NumeralWordsDecodeOutput('', 'nul', 'common_language_dutch'),
           NumeralWordsDecodeOutput('', 'null', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('', 'nul', 'common_language_russian'),
           NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('9', 'ni', 'common_language_danish'),
           NumeralWordsDecodeOutput('2', 'ni', 'numeralwords_language_jap'),
           NumeralWordsDecodeOutput('', 'ni', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('9', 'so', 'numeralwords_language_loj'),
           NumeralWordsDecodeOutput('100', 'on', 'common_language_korean'),
           NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('10', 'on', 'numeralwords_language_tur'),
           NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
           NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
           NumeralWordsDecodeOutput('6', 'ses', 'common_language_esperanto'),
           NumeralWordsDecodeOutput('3', 'se', 'common_language_korean'),
           NumeralWordsDecodeOutput('3', 'se', 'numeralwords_language_per'),
           NumeralWordsDecodeOutput('3', 'se', 'common_language_korean'),
           NumeralWordsDecodeOutput('', 'se', 'numeralwords_language_per'),
           NumeralWordsDecodeOutput('10', 'ten', 'common_language_english'),
           NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
           NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
           NumeralWordsDecodeOutput('1', 'um', 'common_language_portuguese'),
           NumeralWordsDecodeOutput('9', 'ni', 'common_language_danish'),
           NumeralWordsDecodeOutput('2', 'ni', 'numeralwords_language_jap'),
           NumeralWordsDecodeOutput('', 'ni', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('9', 'gu', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('2', 'tel', 'common_language_volapuek'),
           NumeralWordsDecodeOutput('4', 'lau', 'numeralwords_language_bas'),
           NumeralWordsDecodeOutput('1', 'un', 'common_language_french'),
           NumeralWordsDecodeOutput('', 'une', 'common_language_french'),
           NumeralWordsDecodeOutput('4', 'ne', 'common_language_korean'),
           NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('2', 'er', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('2', 're', 'numeralwords_language_loj'),
           NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
           NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
           NumeralWordsDecodeOutput('1', 'un', 'common_language_french'),
           NumeralWordsDecodeOutput('2', 'dwa', 'common_language_bulgarian'),
           NumeralWordsDecodeOutput('', 'dwa', 'common_language_polish'),
           NumeralWordsDecodeOutput('', 'dwa', 'common_language_russian'),
           NumeralWordsDecodeOutput('1', 'wa', 'numeralwords_language_kli'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('4', 'si', 'numeralwords_language_chi'),
           NumeralWordsDecodeOutput('', 'si', 'common_language_thai_rtgs'),
           NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
           NumeralWordsDecodeOutput('100', 'sto', 'common_language_bulgarian'),
           NumeralWordsDecodeOutput('', 'sto', 'common_language_czech'),
           NumeralWordsDecodeOutput('', 'sto', 'common_language_polish'),
           NumeralWordsDecodeOutput('', 'sto', 'common_language_russian'),
           NumeralWordsDecodeOutput('', 'sto', 'common_language_slovak'),
           NumeralWordsDecodeOutput('2', 'to', 'common_language_danish'),
           NumeralWordsDecodeOutput('', 'to', 'common_language_norwegian'),
           NumeralWordsDecodeOutput('8', 'ok', 'common_language_esperanto'),
           NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
         ]
       },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeNumeralwords(input: elem['input'] as String, language: elem['language'] as NumeralWordsLanguage, decodeModeWholeWords: elem['decodeMode'] as bool);
        var length = (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].number);
          expect(_actual[i].numWord, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].numWord);
          expect(_actual[i].language, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].language);
        }
      });
    }
  });

  group("NumeralWords.GC97P76:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': 'hat nocht arat hai bir dau mann satu hamar',
        'language': NumeralWordsLanguage.ALL,
        'decodeMode': true,
        'expectedOutput': [
          NumeralWordsDecodeOutput('6', 'hat', 'numeralwords_language_ung'),
          NumeralWordsDecodeOutput('0', 'nocht', 'numeralwords_language_sco'),
          NumeralWordsDecodeOutput('4', 'arat', 'numeralwords_language_amh'),
          NumeralWordsDecodeOutput('2', 'hai', 'numeralwords_language_vie'),
          NumeralWordsDecodeOutput('1', 'bir', 'numeralwords_language_tur'),
          NumeralWordsDecodeOutput('2', 'dau', 'numeralwords_language_meg'),
          NumeralWordsDecodeOutput('0', 'mann', 'numeralwords_language_bre'),
          NumeralWordsDecodeOutput('1', 'satu', 'numeralwords_language_ind'),
          NumeralWordsDecodeOutput('10', 'hamar', 'numeralwords_language_bas'),
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeNumeralwords(input: removeAccents(elem['input'].toString().toLowerCase()), language: elem['language'] as NumeralWordsLanguage, decodeModeWholeWords: elem['decodeMode'] as bool);
        var length = (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].number);
          expect(_actual[i].numWord, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].numWord);
          expect(_actual[i].language, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].language);
        }
      });
    }
  });

  group("NumeralWords.Klingon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {// GC8J08H
        'input': "north         cha'maH-jav         cha' wa'vatlh 'ej loSmaH-Hut       chan         nineteen        pagh-wej-chorgh",
        'language': NumeralWordsLanguage.ALL,
        'decodeMode': false,
        'expectedOutput': [
          NumeralWordsDecodeOutput('numeralwords_n', 'north', 'common_language_english'),
          NumeralWordsDecodeOutput('', 'no', 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput("2", "cha", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("20", "chamah", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('5', 'ha', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput('6', 'jav', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("2", "cha", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('5', 'ha', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput("1", "wa", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("100", "wavatlh", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('1', 'at', 'numeralwords_language_dot'),
          NumeralWordsDecodeOutput('8', 'osm', 'common_language_czech'),
          NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput("2", "cha", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("numeralwords_e", 'chan', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('1', 'han', 'numeralwords_language_ceq'),
          NumeralWordsDecodeOutput('', 'han', 'common_language_korean'),
          NumeralWordsDecodeOutput('5', 'ha', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput('9', 'ni', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'nine', 'common_language_english'),
          NumeralWordsDecodeOutput("19", 'nineteen', 'common_language_english'),
          NumeralWordsDecodeOutput('2', 'ni', 'numeralwords_language_jap'),
          NumeralWordsDecodeOutput('', 'ni', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'nine', 'numeralwords_language_sco'),
          NumeralWordsDecodeOutput('2', 'i', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('4', 'net', 'common_language_korean'),
          NumeralWordsDecodeOutput('', 'ne', 'common_language_korean'),
          NumeralWordsDecodeOutput('1', 'een', 'common_language_dutch'),
          NumeralWordsDecodeOutput('2', 'ee', 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('1', 'en', 'common_language_danish'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_norwegian'),
          NumeralWordsDecodeOutput('', 'en', 'common_language_swedish'),
          NumeralWordsDecodeOutput("0", 'pagh', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('1', 'pa', 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput("3", 'wej', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("8", 'chorgh', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('5', 'o', 'common_language_sino_korean'),
        ]
      },
      {// GC8J08H
        'input': "north         cha'maH-jav         cha' wa'vatlh 'ej loSmaH-Hut       chan         nineteen        pagh-wej-chorgh",
        'language': NumeralWordsLanguage.ALL,
        'decodeMode': true,
        'expectedOutput': [
          NumeralWordsDecodeOutput('numeralwords_n', 'north', 'common_language_english'),
          NumeralWordsDecodeOutput("26", "cha'mah jav", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("2", "cha'", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("100", "wa'vatlh", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('49', 'losmah hut', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("numeralwords_e", 'chan', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("19", 'nineteen', 'common_language_english'),
          NumeralWordsDecodeOutput("0", 'pagh', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("3", 'wej', 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("8", 'chorgh', 'numeralwords_language_kli'),
        ]
      },
      {
        'input': "vaghbIp loSvatlh wa' chan nau cha'mah wej",
        'language': NumeralWordsLanguage.ALL,
        'decodeMode': false,
        'expectedOutput': [
          NumeralWordsDecodeOutput("5", "vagh", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("2", "bi", 'numeralwords_language_bas'),
          NumeralWordsDecodeOutput("8", "bi", 'numeralwords_language_loj'),
          NumeralWordsDecodeOutput("2", "i", 'common_language_sino_korean'),
          NumeralWordsDecodeOutput("5", "o", 'common_language_sino_korean'),
          NumeralWordsDecodeOutput('1', 'at', 'numeralwords_language_dot'),
          NumeralWordsDecodeOutput("1", "wa", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("2", "cha", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("numeralwords_e", "chan", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('1', 'han', 'numeralwords_language_ceq'),
          NumeralWordsDecodeOutput('', 'han', 'common_language_korean'),
          NumeralWordsDecodeOutput('5', 'ha', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput("9", "nau", 'common_language_esperanto'),
          NumeralWordsDecodeOutput("", "nau", 'numeralwords_language_meg'),
          NumeralWordsDecodeOutput("2", "cha", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("20", "chamah", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput('5', 'ha', 'common_language_thai_rtgs'),
          NumeralWordsDecodeOutput("3", "wej", 'numeralwords_language_kli'),
        ]
      },
      {
        'input': "vaghbIp loSvatlh wa' chan nau cha'mah wej",
        'language': NumeralWordsLanguage.ALL,
        'decodeMode': true,
        'expectedOutput': [
          NumeralWordsDecodeOutput("500401", "vaghbip losvatlh wa'", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("numeralwords_e", "chan", 'numeralwords_language_kli'),
          NumeralWordsDecodeOutput("9", "nau", 'common_language_esperanto'),
          NumeralWordsDecodeOutput("", "", 'numeralwords_language_meg'),
          NumeralWordsDecodeOutput("23", "cha'mah wej", 'numeralwords_language_kli'),
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeNumeralwords(input: removeAccents(elem['input'].toString().toLowerCase()), language: elem['language'] as NumeralWordsLanguage, decodeModeWholeWords: elem['decodeMode'] as bool);
        var length = (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].number);
          expect(_actual[i].numWord, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].numWord);
          expect(_actual[i].language, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].language);
        }
      });
    }
  });

  group("NumeralWords.unicode languages:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': 'шестнадцать 十八 じゅうしち 이십 열다섯 百 единайсет สามสิบ',
        'language': NumeralWordsLanguage.ALL,
        'decodeMode': false,
        'expectedOutput': [
          NumeralWordsDecodeOutput('6', 'шест', 'numeralwords_language_bul_kyr'),
          NumeralWordsDecodeOutput('16', 'шестнадцать', 'numeralwords_language_kyr'),
          NumeralWordsDecodeOutput('10', '十', 'numeralwords_language_chi_symbol'),
          NumeralWordsDecodeOutput('18', '十八', 'numeralwords_language_chi_symbol'),
          NumeralWordsDecodeOutput('', '十', 'common_language_hanja'),
          NumeralWordsDecodeOutput('18', '十八', 'common_language_hanja'),
          NumeralWordsDecodeOutput('', '十', 'numeralwords_language_vie_hantu'),
          NumeralWordsDecodeOutput('8', '八', 'numeralwords_language_chi_symbol'),
          NumeralWordsDecodeOutput('', '八', 'common_language_hanja'),
          NumeralWordsDecodeOutput('', '八', 'numeralwords_language_vie_hantu'),
          NumeralWordsDecodeOutput('10', 'じゅう', 'numeralwords_language_jap_hiragana'),
          NumeralWordsDecodeOutput('14', 'じゅうし', 'numeralwords_language_jap_hiragana'),
          NumeralWordsDecodeOutput('17', 'じゅうしち', 'numeralwords_language_jap_hiragana'),
          NumeralWordsDecodeOutput('4', 'し', 'numeralwords_language_jap_hiragana'),
          NumeralWordsDecodeOutput('7', 'しち', 'numeralwords_language_jap_hiragana'),
          NumeralWordsDecodeOutput('2', '이', 'common_language_hangul_sino_korean'),
          NumeralWordsDecodeOutput('20', '이십', 'common_language_hangul_sino_korean'),
          NumeralWordsDecodeOutput('10', '십', 'common_language_hangul_sino_korean'),
          NumeralWordsDecodeOutput('10', '열', 'common_language_hangul_korean'),
          NumeralWordsDecodeOutput('15', '열다섯', 'common_language_hangul_korean'),
          NumeralWordsDecodeOutput('5', '다섯', 'common_language_hangul_korean'),
          NumeralWordsDecodeOutput('100', '百', 'numeralwords_language_chi_symbol'),
          NumeralWordsDecodeOutput('', '百', 'common_language_hanja'),
          NumeralWordsDecodeOutput('1', 'един', 'numeralwords_language_bul_kyr'),
          NumeralWordsDecodeOutput('11', 'единайсет', 'numeralwords_language_bul_kyr'),
          NumeralWordsDecodeOutput('3', 'สาม', 'common_language_thai'),
          NumeralWordsDecodeOutput('30', 'สามสิบ', 'common_language_thai'),
          NumeralWordsDecodeOutput('10', 'สิบ', 'common_language_thai'),
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, decodeMode: ${elem['decodeMode']}', () {
        var _actual = decodeNumeralwords(input: removeAccents(elem['input'].toString().toLowerCase()), language: elem['language'] as NumeralWordsLanguage, decodeModeWholeWords: elem['decodeMode'] as bool);
        var length = (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i].number, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].number);
          expect(_actual[i].numWord, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].numWord);
          expect(_actual[i].language, (elem['expectedOutput'] as List<NumeralWordsDecodeOutput>)[i].language);
        }
      });
    }
  });
  
}