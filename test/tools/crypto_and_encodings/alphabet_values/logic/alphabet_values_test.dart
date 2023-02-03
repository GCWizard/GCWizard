import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';

void main() {
  /********** AlphabetValues ****************/

  group("AlphabetValues.textToValues:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},
      {'text' : '0123456789ZYXWVUTSRQPONMLKJIHGFEDCBA=?`(&/ ;', 'expectedOutput' : [null, null, null, null, null, null, null, null, null, null, 26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1, null, null, null, null, null, null, null, null]},
      {'text' : '01234abc56789', 'keepNumbers': true, 'expectedOutput' : [0,1,2,3,4,1,2,3,5,6,7,8,9]},
    ];

    _inputsToExpected.forEach((elem) {
      test('alphabet: ${elem['alphabet']}, text: ${elem['text']}, keepNumbers: ${elem['keepNumbers']}', () {
        var keepNumbers = elem['keepNumbers'];

        var _actual;
        if (keepNumbers == null)
          _actual = AlphabetValues().textToValues(elem['text']);
        else
          _actual = AlphabetValues().textToValues(elem['text'], keepNumbers: elem['keepNumbers']);

        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("AlphabetValues.valuesToText:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'values' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26], 'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'},
      {'values' : [42,26,25,24,23,22,21,20,19,18,17,16,15,14,null,13,12,11,10,9,8,7,6,5,4,3,2,1,0], 'expectedOutput' : '<?>ZYXWVUTSRQPON<?>MLKJIHGFEDCBA<?>'},
    ];

    _inputsToExpected.forEach((elem) {
      test('alphabetValues: ${elem['alphabetValues']}, values: ${elem['values']}', () {
        var _actual = AlphabetValues().valuesToText(elem['values']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("AlphabetValues.textToValuesAlphabets:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text' : 'ABCCHDEFGHIJKLLLMNÑOPQRSTUVWXYZß', 'alphabet': alphabetSpanish1.alphabet, 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,14,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,null]},
      {'text' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'alphabet': alphabetGerman2.alphabet, 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,1,5,15,5,21,5,19,19]},
    ];

    _inputsToExpected.forEach((elem) {
      test('alphabet: ${elem['alphabet']}, text: ${elem['text']}, alphabet: ${elem['alphabet']}', () {
        var _actual = AlphabetValues(alphabet: elem['alphabet']).textToValues(elem['text']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("AlphabetValues.valuesToTextAlphabets:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'values' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], 'alphabet': alphabetSpanish1.alphabet, 'expectedOutput' : 'ABCCHDEFGHIJKLLLMNÑOPQRSTUVWXYZ'},
      {'values' : [42,26,25,24,23,22,21,20,19,18,17,16,15,14,null,13,12,11,10,9,8,7,6,5,4,3,2,1,0,38], 'alphabet': alphabetGerman3.alphabet, 'expectedOutput' : '<?>ZYXWVUTSRQPON<?>MLKJIHGFEDCBA<?>ß'},
    ];

    _inputsToExpected.forEach((elem) {
      test('alphabetValues: ${elem['alphabetValues']}, values: ${elem['values']}, alphabet: ${elem['alphabet']}', () {
        var _actual = AlphabetValues(alphabet: elem['alphabet']).valuesToText(elem['values']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}
