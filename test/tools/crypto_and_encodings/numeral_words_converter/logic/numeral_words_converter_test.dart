import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/utils/string_utils.dart';

void main(){

  group("decode Navi:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      // empty input
      { 'input': null, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(0, '', '', 'numeralwords_converter_error_navi')},
      { 'input': '', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(0, '', '', '')},
      // faulty input
      { 'input': 'vomsadfun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(0, '', '', 'numeralwords_converter_error_navi')},
      // https://forum.learnnavi.org/navi-lernen/das-navi-zahlensystem/#:~:text=Das%20Na%27vi%20hat%20zwei%20Lehnw%C3%B6rter%20aus%20dem%20Englischen.,Ziffern%2C%20wie%20z.%20B.%20Telefonnummern%2C%20Autokennzeichen%2C%20IDs%20etc.
      { 'input': 'volaw', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(9, '', '', '')},
      { 'input': 'vomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(10, '', '', '')},
      { 'input': 'tsivol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(32, '', '', '')},
      { 'input': 'puvomrr', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(53, '', '', '')},
      { 'input': 'zamaw', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(65, '', '', '')},
      { 'input': 'zasing', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(68, '', '', '')},
      { 'input': 'puzam', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(384, '', '', '')},
      { 'input': 'kizavomrr', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(461, '', '', '')},
      { 'input': 'kizapuvomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(498, '', '', '')},
    // https://de.wikipedia.org/wiki/Na%E2%80%99vi-Sprache#Zahlen
      { 'input': 'tsivolaw', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(33, '', '', '')},
    // https://james-camerons-avatar.fandom.com/de/wiki/Oktale_Arithmetik
      { 'input': 'pxevozamkizampxevomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(2010, '', '', '')},
      { 'input': 'mezazampxevozamtsìzamevol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(10000, '', '', '')},
    // https://www.geocaching.com/geocache/GC2FVKX_pankepark-sudpanke-bnd?guid=0f760dd5-bd97-4c57-86de-fe7ff2f779d8
      { 'input': 'kizazampuvozamtsìzampuvopey', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(32051, '', '', '')},
      { 'input': 'mrrzazampxevozampuzamvol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(22408, '', '', '')},
    ];

    _inputsToExpected.forEach((elem) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, ', () {
        var _actual = decodeNumeralWordToNumber(elem['language'], removeAccents(elem['input'].toString().toLowerCase()));
        if (_actual.error == 'numeralwords_converter_error_navi')
          expect(_actual.error, elem['expectedOutput'].error);
        else
          expect(_actual.number, elem['expectedOutput'].number);
      });
    });
  });

  group("encode Navi:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      // zero input
      { 'input': null, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('', '', '', 'numeralwords_converter_error_navi')},
      { 'input': 0, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('kew', '', '', '')},
      // https://forum.learnnavi.org/navi-lernen/das-navi-zahlensystem/#:~:text=Das%20Na%27vi%20hat%20zwei%20Lehnw%C3%B6rter%20aus%20dem%20Englischen.,Ziffern%2C%20wie%20z.%20B.%20Telefonnummern%2C%20Autokennzeichen%2C%20IDs%20etc.
      { 'input': 9, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('volaw', '', '', '')},
      { 'input': 10, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('vomun', '', '', '')},
      { 'input': 32, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('tsìvol', '', '', '')},
      { 'input': 53, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('puvomrr', '', '', '')},
      { 'input': 65, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('zamaw', '', '', '')},
      { 'input': 68, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('zasìng', '', '', '')},
      { 'input': 384, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('puzam', '', '', '')},
      { 'input': 461, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('kizavomrr', '', '', '')},
      { 'input': 498, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('kizapuvomun', '', '', '')},
      // https://de.wikipedia.org/wiki/Na%E2%80%99vi-Sprache#Zahlen
      { 'input': 33, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('tsìvolaw', '', '', '')},
      // https://james-camerons-avatar.fandom.com/de/wiki/Oktale_Arithmetik
      { 'input': 2010, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('pxevozakizapxevomun', '', '', '')},
      { 'input': 10000, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('mezazapxevozatsìzamevol', '', '', '')},
      // https://www.geocaching.com/geocache/GC2FVKX_pankepark-sudpanke-bnd?guid=0f760dd5-bd97-4c57-86de-fe7ff2f779d8
      { 'input': 32051, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('kizazapuvozatsìzapuvopey', '', '', '')},
      { 'input': 22408, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord('mrrzazapxevozapuzavol', '', '', '')},
    ];

    _inputsToExpected.forEach((elem) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, ', () {
        var _actual = encodeNumberToNumeralWord(elem['language'], elem['input']);
        if (_actual.error == 'numeralwords_converter_error_navi')
          expect(_actual.error, elem['expectedOutput'].error);
        else
          expect(_actual.numeralWord, elem['expectedOutput'].numeralWord);
      });
    });
  });

}