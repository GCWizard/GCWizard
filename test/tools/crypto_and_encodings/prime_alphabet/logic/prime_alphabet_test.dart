import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/prime_alphabet/logic/prime_alphabet.dart';
import 'package:gc_wizard/utils/constants.dart';

void main() {
  group("PrimeAlphabet.decryptPrimeAlphabetWithoutOffset:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <int>[], 'expectedOutput' : ''},

      {'input' : [2,3,5,89,97,101], 'expectedOutput' : 'ABCXYZ'},
      // {'input' : [2,null,5,89,97,101], 'expectedOutput' : 'A<?>CXYZ'},
      {'input' : [2,103,241], 'expectedOutput' : 'AAA'},

      {'input' : [-1,0,1,2,3,4,5,42,89,97,100,101], 'expectedOutput' : '<?><?><?>AB<?>C<?>XY<?>Z'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decryptPrimeAlphabet(elem['input'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("PrimeAlphabet.decryptPrimeAlphabetWithOffset:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : [3,5,89,97,101], 'firstRecognizedPrime': 3, 'expectedOutput' : 'ABWXY'},
      {'input' : [3,5,89,97,101], 'firstRecognizedPrime': 4, 'expectedOutput' : UNKNOWN_ELEMENT + 'AVWX'},
      {'input' : [3,5,89,97,101], 'firstRecognizedPrime': 5, 'expectedOutput' : UNKNOWN_ELEMENT + 'AVWX'},
      {'input' : [-1,0,1,2,3,4,5,42,89,97,100,101], 'firstRecognizedPrime': 3, 'expectedOutput' : '<?><?><?><?>A<?>B<?>WX<?>Y'},

      {'input' : [-1,0,1,2,3,4,5,42,89,97,100,101], 'firstRecognizedPrime': 3, 'expectedOutput' : '<?><?><?><?>A<?>B<?>WX<?>Y'},

      {'input' : [103,107,109,229,233,239], 'firstRecognizedPrime': 103, 'expectedOutput' : 'ABCXYZ'},
      {'input' : [103,107,109,229,233,239,839,677,887], 'firstRecognizedPrime': 103, 'expectedOutput' : 'ABCXYZPSX'},
      {'input' : [3,5,89,97,101,103,107,109,229,233,239], 'firstRecognizedPrime': 103, 'expectedOutput' : '<?><?><?><?><?>ABCXYZ'},

      {'input' : [103,107,109,229,233,239], 'firstRecognizedPrime': 89, 'expectedOutput' : 'DEFABC'},
      {'input' : [103,107,109,229,233,239,839,677,887], 'firstRecognizedPrime': 89, 'expectedOutput' : 'DEFABCSVA'},
      {'input' : [3,5,89,97,101,103,107,109,229,233,239], 'firstRecognizedPrime': 89, 'expectedOutput' : '<?><?>ABCDEFABC'},

      {'input' : [103,107,109,229,233,239], 'firstRecognizedPrime': 84, 'expectedOutput' : 'DEFABC'},
      {'input' : [103,107,109,229,233,239,839,677,887], 'firstRecognizedPrime': 84, 'expectedOutput' : 'DEFABCSVA'},
      {'input' : [3,5,89,97,101,103,107,109,229,233,239], 'firstRecognizedPrime': 84, 'expectedOutput' : '<?><?>ABCDEFABC'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, firstRecognizedPrime: ${elem['firstRecognizedPrime']}', () {
        if (elem['firstRecognizedPrime'] == null) {
          var _actual = decryptPrimeAlphabet(elem['input'] as List<int>);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = decryptPrimeAlphabet(
              elem['input'] as List<int>, firstRecognizedPrime: elem['firstRecognizedPrime'] as int);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("PrimeAlphabet.encryptPrimeAlphabetWithoutOffset:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : <int>[]},

      {'input' : 'ABCXYZ', 'expectedOutput' : [2,3,5,89,97,101]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encryptPrimeAlphabet(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("PrimeAlphabet.encryptPrimeAlphabetWithOffset:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : <int>[]},

      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 103,  'expectedOutput' : [3, 5, 7, 11, 89, 97, 101, 103]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 101,  'expectedOutput' : [3, 5, 7, 11, 89, 97, 101, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 2,  'lastRecognizedPrime': 97,  'expectedOutput' : [2, 3, 5, 7, 83, 89, 97, null]},

      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 4,  'lastRecognizedPrime': 107,  'expectedOutput' : [5, 7, 11, 13, 97, 101, 103, 107]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 5,  'lastRecognizedPrime': 107,  'expectedOutput' : [5, 7, 11, 13, 97, 101, 103, 107]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 6,  'lastRecognizedPrime': 107,  'expectedOutput' : [7, 11, 13, 17, 101, 103, 107, null]},

      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 102,  'expectedOutput' : [3, 5, 7, 11, 89, 97, 101, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 101,  'expectedOutput' : [3, 5, 7, 11, 89, 97, 101, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 100,  'expectedOutput' : [3, 5, 7, 11, 89, 97, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 98,  'expectedOutput' : [3, 5, 7, 11, 89, 97, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 97,  'expectedOutput' : [3, 5, 7, 11, 89, 97, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 3,  'lastRecognizedPrime': 96,  'expectedOutput' : [3, 5, 7, 11, 89, null, null, null]},

      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 4,  'lastRecognizedPrime': 100,  'expectedOutput' : [5, 7, 11, 13, 97, null, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 5,  'lastRecognizedPrime': 100,  'expectedOutput' : [5, 7, 11, 13, 97, null, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 6,  'lastRecognizedPrime': 100,  'expectedOutput' : [7, 11, 13, 17, null, null, null, null]},

      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 240,  'lastRecognizedPrime': 398,  'expectedOutput' : [241, 251, 257, 263, 379, 383, 389, 397]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 242,  'lastRecognizedPrime': 396,  'expectedOutput' : [251, 257, 263, 269, 383, 389, null, null]},

      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 461,  'lastRecognizedPrime': 460,  'expectedOutput' : []},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 460,  'lastRecognizedPrime': 461,  'expectedOutput' : [461, null, null, null, null, null, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 461,  'lastRecognizedPrime': 461,  'expectedOutput' : [461, null, null, null, null, null, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 461,  'lastRecognizedPrime': 462,  'expectedOutput' : [461, null, null, null, null, null, null, null]},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 461,  'lastRecognizedPrime': 463,  'expectedOutput' : [461, 463, null, null, null, null, null, null]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, firstRecognizedPrime: ${elem['firstRecognizedPrime']}, lastRecognizedPrime: ${elem['lastRecognizedPrime']}', () {
        if (elem['firstRecognizedPrime'] == null || elem['lastRecognizedPrime'] == null) {
          var _actual = encryptPrimeAlphabet(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = encryptPrimeAlphabet(elem['input'] as String, firstRecognizedPrime: elem['firstRecognizedPrime'] as int, lastRecognizedPrime: elem['lastRecognizedPrime'] as int);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("PrimeAlphabet.encryptPrimeAlphabetHomophone:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 2,  'lastRecognizedPrime': 1097},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 2,  'lastRecognizedPrime': 233},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 401,  'lastRecognizedPrime': 1097},
      {'input' : 'ABCDWXYZ',  'firstRecognizedPrime': 461,  'lastRecognizedPrime': 1097},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, firstRecognizedPrime: ${elem['firstRecognizedPrime']}, lastRecognizedPrime: ${elem['lastRecognizedPrime']}', () {
        var _actual = encryptPrimeAlphabet(elem['input'] as String, firstRecognizedPrime: elem['firstRecognizedPrime'] as int, lastRecognizedPrime: elem['lastRecognizedPrime'] as int);
        expect(decryptPrimeAlphabet(_actual, firstRecognizedPrime: elem['firstRecognizedPrime'] as int), elem['input'] as String);
      });
    }
  });
}