import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';
import 'package:gc_wizard/utils/alphabets.dart';

void main() {
  /********** AlphabetValues ****************/

  group("AlphabetValues.textToValues:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},
      {'text' : '0123456789ZYXWVUTSRQPONMLKJIHGFEDCBA=?`(&/ ;', 'expectedOutput' : [null, null, null, null, null, null, null, null, null, null, 26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1, null, null, null, null, null, null, null, null]},
      {'text' : '01234abc56789', 'keepNumbers': true, 'expectedOutput' : [0,1,2,3,4,1,2,3,5,6,7,8,9]},
    ];

    for (var elem in _inputsToExpected) {
      test('alphabet: ${elem['alphabet']}, text: ${elem['text']}, keepNumbers: ${elem['keepNumbers']}', () {
        var keepNumbers = elem['keepNumbers'];

        List<int?> _actual;
        if (keepNumbers == null) {
          _actual = AlphabetValues().textToValues(elem['text'] as String);
        } else {
          _actual = AlphabetValues().textToValues(elem['text'] as String, keepNumbers: elem['keepNumbers'] as bool);
        }

        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("AlphabetValues.valuesToText:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'values' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26], 'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'},
      // {'values' : [42,26,25,24,23,22,21,20,19,18,17,16,15,14,null,13,12,11,10,9,8,7,6,5,4,3,2,1,0], 'expectedOutput' : UNKNOWN_ELEMENT + 'ZYXWVUTSRQPON<?>MLKJIHGFEDCBA<?>'},
    ];

    for (var elem in _inputsToExpected) {
      test('alphabetValues: ${elem['alphabetValues']}, values: ${elem['values']}', () {
        var _actual = AlphabetValues().valuesToText(elem['values'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("AlphabetValues.textToValuesAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text' : 'ABCCHDEFGHIJKLLLMNÑOPQRSTUVWXYZß', 'alphabet': alphabetSpanish1.alphabet, 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,14,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,null]},
      {'text' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'alphabet': alphabetGerman2.alphabet, 'expectedOutput' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,1,5,15,5,21,5,19,19]},
    ];

    for (var elem in _inputsToExpected) {
      test('alphabet: ${elem['alphabet']}, text: ${elem['text']}, alphabet: ${elem['alphabet']}', () {
        var _actual = AlphabetValues(alphabet: elem['alphabet'] as Map<String, String>?).textToValues(elem['text'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("AlphabetValues.valuesToTextAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'values' : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], 'alphabet': alphabetSpanish1.alphabet, 'expectedOutput' : 'ABCCHDEFGHIJKLLLMNÑOPQRSTUVWXYZ'},
      // {'values' : [42,26,25,24,23,22,21,20,19,18,17,16,15,14,null,13,12,11,10,9,8,7,6,5,4,3,2,1,0,38], 'alphabet': alphabetGerman3.alphabet, 'expectedOutput' : UNKNOWN_ELEMENT + 'ZYXWVUTSRQPON<?>MLKJIHGFEDCBA<?>ß'},
    ];

    for (var elem in _inputsToExpected) {
      test('alphabetValues: ${elem['alphabetValues']}, values: ${elem['values']}, alphabet: ${elem['alphabet']}', () {
        var _actual = AlphabetValues(alphabet: elem['alphabet'] as Map<String, String>?).valuesToText(elem['values'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
