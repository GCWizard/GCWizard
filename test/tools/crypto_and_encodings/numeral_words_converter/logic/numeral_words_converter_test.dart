import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/utils/string_utils.dart';

void main(){

  group("decode Navi:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty input
      { 'input': null, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_navi')},
      { 'input': '', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: '')},
      // faulty input
      { 'input': 'vomsadfun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_navi')},
      // https://forum.learnnavi.org/navi-lernen/das-navi-zahlensystem/#:~:text=Das%20Na%27vi%20hat%20zwei%20Lehnw%C3%B6rter%20aus%20dem%20Englischen.,Ziffern%2C%20wie%20z.%20B.%20Telefonnummern%2C%20Autokennzeichen%2C%20IDs%20etc.
      { 'input': 'volaw', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 9, numbersystem: '', title: '', error: '')},
      { 'input': 'vomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 10, numbersystem: '', title: '', error: '')},
      { 'input': 'tsivol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 32, numbersystem: '', title: '', error: '')},
      { 'input': 'puvomrr', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 53, numbersystem: '', title: '', error: '')},
      { 'input': 'zamaw', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 65, numbersystem: '', title: '', error: '')},
      { 'input': 'zasing', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 68, numbersystem: '', title: '', error: '')},
      { 'input': 'puzam', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 384, numbersystem: '', title: '', error: '')},
      { 'input': 'kizavomrr', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 461, numbersystem: '', title: '', error: '')},
      { 'input': 'kizapuvomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 498, numbersystem: '', title: '', error: '')},
    // https://de.wikipedia.org/wiki/Na%E2%80%99vi-Sprache#Zahlen
      { 'input': 'tsivolaw', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 33, numbersystem: '', title: '', error: '')},
    // https://james-camerons-avatar.fandom.com/de/wiki/Oktale_Arithmetik
      { 'input': 'pxevozamkizampxevomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 2010, numbersystem: '', title: '', error: '')},
      { 'input': 'mezazampxevozamtsìzammevol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 10000, numbersystem: '', title: '', error: '')},
    // https://www.geocaching.com/geocache/GC2FVKX_pankepark-sudpanke-bnd?guid=0f760dd5-bd97-4c57-86de-fe7ff2f779d8
      { 'input': 'kizazampuvozamtsìzampuvopey', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 32051, numbersystem: '', title: '', error: '')},
      { 'input': 'mrrzazampxevozampuzamvol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 22408, numbersystem: '', title: '', error: '')},
    // selmade
      { 'input': 'mrrzazamrrvozapuzamrrvol', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 23464, numbersystem: '', title: '', error: '')},
      { 'input': 'mrrzazamrrvozapuzamun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 23424, numbersystem: '', title: '', error: '')},
      { 'input': 'mevozapxezamevomun', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 1234, numbersystem: '', title: '', error: '')},
      { 'input': 'zazamevozapuzapuvopey', 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumber(number: 5555, numbersystem: '', title: '', error: '')},

    ];

    for (var elem in _inputsToExpected) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, ', () {
        var _actual = decodeNumeralWordToNumber(elem['language'] as NumeralWordsLanguage, removeAccents(elem['input'].toString().toLowerCase()));
        if (_actual.error == 'numeralwords_converter_error_navi') {
          expect(_actual.error, (elem['expectedOutput'] as OutputConvertToNumber).error);
        } else {
          expect(_actual.number, (elem['expectedOutput'] as OutputConvertToNumber).number);
        }
      });
    }
  });

  group("encode Navi:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // zero input
      { 'input': 0, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'kew', targetNumberSystem: '', title: '', errorMessage: '')},
      // https://forum.learnnavi.org/navi-lernen/das-navi-zahlensystem/#:~:text=Das%20Na%27vi%20hat%20zwei%20Lehnw%C3%B6rter%20aus%20dem%20Englischen.,Ziffern%2C%20wie%20z.%20B.%20Telefonnummern%2C%20Autokennzeichen%2C%20IDs%20etc.
      { 'input': 9, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'volaw', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 10, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'vomun', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 32, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'tsìvol', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 53, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'puvomrr', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 65, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'zamaw', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 68, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'zasìng', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 384, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'puzam', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 461, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'kizavomrr', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 498, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'kizapuvomun', targetNumberSystem: '', title: '', errorMessage: '')},
      // https://de.wikipedia.org/wiki/Na%E2%80%99vi-Sprache#Zahlen
      { 'input': 33, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'tsìvolaw', targetNumberSystem: '', title: '', errorMessage: '')},
      // https://james-camerons-avatar.fandom.com/de/wiki/Oktale_Arithmetik
      { 'input': 2010, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'pxevozakizapxevomun', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 10000, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'mezazapxevozatsìzamevol', targetNumberSystem: '', title: '', errorMessage: '')},
      // https://www.geocaching.com/geocache/GC2FVKX_pankepark-sudpanke-bnd?guid=0f760dd5-bd97-4c57-86de-fe7ff2f779d8
      { 'input': 32051, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'kizazapuvozatsìzapuvopey', targetNumberSystem: '', title: '', errorMessage: '')},
      { 'input': 22408, 'language': NumeralWordsLanguage.NAVI,        'expectedOutput': OutputConvertToNumeralWord(numeralWord: 'mrrzazapxevozapuzavol', targetNumberSystem: '', title: '', errorMessage: '')},
    ];

    for (var elem in _inputsToExpected) {
      test(
          'input: ${elem['input']}, language: ${elem['language']}, ', () {
        var _actual = encodeNumberToNumeralWord(elem['language'] as NumeralWordsLanguage, elem['input'] as int);
        if (_actual.error == 'numeralwords_converter_error_navi') {
          expect(_actual.error, (elem['expectedOutput'] as OutputConvertToNumeralWord).error);
        } else {
          expect(_actual.numeralWord, (elem['expectedOutput'] as OutputConvertToNumeralWord).numeralWord);
        }
      });
    }
  });

}