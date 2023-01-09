import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/crypto_and_encodings/homophone.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/common_utils.dart';


void main() {
  group("Homophone.encryptGenerated:", () {
    List<Map<String, dynamic>> _inputsToExpected = [

      {'input' : null, 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 1, 'multiplier': 1, 'expectedOutput' : ''},
      {'input' : '', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 3, 'multiplier': 1, 'expectedOutput' : ''},

      {'input' : 'Test', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 1, 'multiplier': 3, 'expectedOutput': '58 48 37 58'},
      {'input' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetEnglish, 'rotation': 3, 'multiplier': 7, 'expectedOutput': '88 40 46 88'},
      {'input' : 'Test', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetSpanish2, 'rotation': 6, 'multiplier': 99, 'expectedOutput': '07 72 15 07'},
      {'input' : 'КОНТРОЛЬНАЯ РАБОТА', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetRussian1, 'rotation': 1, 'multiplier': 9, 'expectedOutput': '42 04 41 02 21 04 69 55 41 09 91 21 09 72 04 02 09'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, alphabet: ${elem['alphabet']}, rotation: ${elem['rotation']}, multiplier: ${elem['multiplier']}', () {
        var _actual;
        _actual = encryptHomophoneWithGeneratedKey(elem['input'], elem['alphabet'], elem['rotation'], elem['multiplier']);
        Map<String, String> map ;
        map = replaceMap(elem['rotation'], elem['multiplier'], elem['alphabet']);
        var output = changeOutput(_actual.output, map);
        expect(_actual.errorCode, elem['errorcode']);
        expect(output, elem['expectedOutput']);
      });
    });
  });

  group("Homophone.encryptKeyList:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : 'Test', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1,
        'keyList': '36 56 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 30 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99',
        'expectedOutput': '85 15 78 85'},
      {'input' : 'Test', 'errorcode': HomophoneErrorCode.CUSTOM_KEY_COUNT, 'alphabet': alphabetGerman1,
        'keyList': '36 56 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 30 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99 99',
        'expectedOutput': ''},

      {'input' : 'Test', 'errorcode': HomophoneErrorCode.CUSTOM_KEY_DUPLICATE, 'alphabet': alphabetGerman1,
        'keyList': '36 56 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 40 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99',
        'expectedOutput': '85 15 78 85'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, alphabet: ${elem['alphabet']}, keyList: ${elem['keyList']}', () {
        var _actual;
        _actual = encryptHomophoneWithKeyList(elem['input'], elem['alphabet'], textToIntList(elem['keyList']));
        Map<String, String> map ;
        map = replaceOwnMap(elem['keyList'], elem['alphabet']);
        var output = changeOutput(_actual.output, map);
        expect(_actual.errorCode, elem['errorcode']);
        expect(output, elem['expectedOutput']);
      });
    });
  });

  group("Homophone.encryptKeyMap:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : 'Test', 'errorcode': HomophoneErrorCode.OK, 'keyMap': {'E': [9], 'S': [80], 'T': [90]}, 'expectedOutput': '90 09 80 90'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, keyMap: ${elem['keyMap']}', () {
        var _actual;
        _actual = encryptHomophoneWithKeyMap(elem['input'], elem['keyMap']);
        Map<String, String> map ;
        map = replaceMap(elem['rotation'], elem['multiplier'], elem['alphabet']);
        var output = changeOutput(_actual.output, map);
        expect(_actual.errorCode, elem['errorcode']);
        expect(output, elem['expectedOutput']);
      });
    });
  });

  group("Homophone.decryptGenerated:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 1, 'multiplier': 1, 'expectedOutput' : ''},
      {'input' : '', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 3, 'multiplier': 1, 'expectedOutput' : ''},
      {'input' : 'T', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 3, 'multiplier': 1, 'expectedOutput' : ''},

      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1, 'rotation': 3, 'multiplier': 1, 'input': '93 24 86 88'},
      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetEnglish, 'rotation': 3, 'multiplier': 7, 'input': '30 03 74 09'},
      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetSpanish2, 'rotation': 6, 'multiplier': 99, 'input': '05 67 15 06'},
      {'expectedOutput' : 'КОНТРОЛЬНАЯРАБОТА', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetRussian1, 'rotation': 3, 'multiplier': 3, 'input': '20 95 65 55 19 77 32 91 65 24 06 13 21 30 95 52 18'},
      {'expectedOutput' : 'ΔΟΚΙΜ', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGreek1, 'rotation': 500, 'multiplier': 31, 'input': '27 60 64 54 19'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, alphabet: ${elem['alphabet']}, rotation: ${elem['rotation']}, multiplier: ${elem['multiplier']}', () {
        var _actual;
        _actual = decryptHomophoneWithGeneratedKey(elem['input'], elem['alphabet'], elem['rotation'], elem['multiplier']);
        expect(_actual.errorCode, elem['errorcode']);
        expect(_actual.output, elem['expectedOutput']);
      });
    });
  });

  group("Homophone.decryptKeyList:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1,
        'keyList': '36 56 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 30 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99',
        'input': '70 27 81 89'},
      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1,
        'keyList': '36 56 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 30 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99',
        'input': '70 27 81 89'},
      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK, 'alphabet': alphabetGerman1,
        'keyList': '36.56 2,3 4 5 6 7 8 9_10 11B12 13 14 15 16 17 18 19 30 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99',
        'input': '70 27 81 89'},
      {'expectedOutput' : '', 'errorcode': HomophoneErrorCode.CUSTOM_KEY_COUNT, 'alphabet': alphabetGerman1,
        'keyList': '36 56 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 30 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99 99',
        'input': '70 27 81 89'},

      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.CUSTOM_KEY_DUPLICATE, 'alphabet': alphabetGerman1,
        'keyList': '36.56 2,3 4 5 6 7 8 9_10 11B12 13 14 15 16 17 18 19 40 21 22 23 24 25 26 27 28 29 40 31 32 33 34 35 0 37 38 39 20 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 1 57 58 59 60 61 62 63 64 65 66 67 68 69 80 71 72 73 74 75 76 77 78 79 90 81 82 83 84 85 86 87 88 89 70 91 92 93 94 95 96 97 98 99',
        'input': '70 27 81 89'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']},alphabet: ${elem['alphabet']}, keyList: ${elem['keyList']}', () {
        var _actual;
        _actual = decryptHomophoneWithKeyList(elem['input'], elem['alphabet'], textToIntList(elem['keyList']));
        expect(_actual.errorCode, elem['errorcode']);
        expect(_actual.output, elem['expectedOutput']);
      });
    });
  });

  group("Homophone.decryptMap:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput' : 'TEST', 'errorcode': HomophoneErrorCode.OK,
        'keyMap': {'E': [9], 'S': [80], 'T': [90]}, 'input': '90 09 80 90'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, keyMap: ${elem['keyMap']}', () {
        var _actual;
        _actual = decryptHomophoneWithKeyMap(elem['input'], elem['keyMap']);
        expect(_actual.errorCode, elem['errorcode']);
        expect(_actual.output, elem['expectedOutput']);
      });
    });
  });
}

Map<String, String> fillMap(int startIndex, int count, int offset, Map<String, String> map){
  for (int i = 1; i <= count; ++i) {
    map.addAll({((startIndex + i * offset) % 100).toString().padLeft(2, '0'): startIndex.toString().padLeft(2, '0') });
  }
  
  return map;
}

Map<String, String> fillMapOwn(int startIndex, int startOffset, int count, int offset, Map<String, String> map){
  for (int i = 1; i <= count; ++i) {
    map.addAll({((startIndex+ startOffset + i * offset) % 100).toString().padLeft(2, '0'): startIndex.toString().padLeft(2, '0') });
  }

  return map;
}

// create substition Table
// to change random number to first number in the row
Map<String, String> replaceMap(int rotation, int multiplier, Alphabet alphabet){
  var map = Map<String, String>();

  if (alphabet == alphabetGerman1) {
    switch (rotation) {
      case 1:
        switch (multiplier) {
          case 3:
            var offset = multiplier;
            map = fillMap(3, 5, offset, map);
            map = fillMap(21, 1, offset, map);
            map = fillMap(21, 1, offset, map);
            map = fillMap(27, 1, offset, map);
            map = fillMap(33, 4, offset, map);
            map = fillMap(48, 16, offset, map);
            map = fillMap(99, 1, offset, map);
            map = fillMap(5, 2, offset, map);
            map = fillMap(14, 4, offset, map);
            map = fillMap(29, 7, offset, map);
            map = fillMap(59, 2, offset, map);
            map = fillMap(68, 1, offset, map);
            map = fillMap(74, 9, offset, map);
            map = fillMap(4, 1, offset, map);
            map = fillMap(16, 6, offset, map);
            map = fillMap(37, 6, offset, map);
            map = fillMap(58, 5, offset, map);
        }
    }
  } else if (alphabet == alphabetEnglish) {
    switch (rotation) {
      case 3:
        switch (multiplier) {
          case 7:
            var offset = multiplier;
            map = fillMap(21, 7, offset, map);
            map = fillMap(77, 1, offset, map);
            map = fillMap(91, 2, offset, map);
            map = fillMap(12, 3, offset, map);
            map = fillMap(40, 11, offset, map);
            map = fillMap(24, 1, offset, map);
            map = fillMap(38, 1, offset, map);
            map = fillMap(52, 5, offset, map);
            map = fillMap(94, 5, offset, map);
            map = fillMap(50, 3, offset, map);
            map = fillMap(78, 1, offset, map);
            map = fillMap(92, 5, offset, map);
            map = fillMap(34, 6, offset, map);
            map = fillMap(83, 1, offset, map);
            map = fillMap(4, 5, offset, map);
            map = fillMap(46, 5, offset, map);
            map = fillMap(88, 8, offset, map);
            map = fillMap(51, 2, offset, map);
            map = fillMap(79, 1, offset, map);
            map = fillMap(0, 1, offset, map);
        }
    }
  } else if (alphabet == alphabetRussian1) {
    switch (rotation) {
      case 1:
        switch (multiplier) {
          case 9:
            var offset = multiplier;
            map = fillMap(09, 6, offset, map);
            map = fillMap(72, 1, offset, map);
            map = fillMap(90, 3, offset, map);
            map = fillMap(35, 2, offset, map);
            map = fillMap(62, 8, offset, map);
            map = fillMap(70, 6, offset, map);
            map = fillMap(42, 2, offset, map);
            map = fillMap(69, 4, offset, map);
            map = fillMap(14, 2, offset, map);
            map = fillMap(41, 6, offset, map);
            map = fillMap(04, 10, offset, map);
            map = fillMap(03, 1, offset, map);
            map = fillMap(21, 3, offset, map);
            map = fillMap(57, 4, offset, map);
            map = fillMap(02, 5, offset, map);
            map = fillMap(56, 1, offset, map);
            map = fillMap(37, 1, offset, map);
            map = fillMap(55, 1, offset, map);
            map = fillMap(91, 1, offset, map);
        }
    }
  } else if (alphabet == alphabetSpanish2) {
    switch (rotation) {
      case 6:
        switch (multiplier) {
          case 99:
            var offset = multiplier;
            map = fillMap(94, 11, offset, map);
            map = fillMap(81, 3, offset, map);
            map = fillMap(77, 4, offset, map);
            map = fillMap(72, 12, offset, map);
            map = fillMap(56, 5, offset, map);
            map = fillMap(48, 4, offset, map);
            map = fillMap(43, 2, offset, map);
            map = fillMap(40, 5, offset, map);
            map = fillMap(33, 7, offset, map);
            map = fillMap(25, 1, offset, map);
            map = fillMap(22, 6, offset, map);
            map = fillMap(15, 7, offset, map);
            map = fillMap(07, 3, offset, map);
            map = fillMap(03, 3, offset, map);
        }
    }
  } else if (alphabet == alphabetGreek1) {
    switch (rotation) {
      case 500:
        switch (multiplier) {
          case 31:
            var offset = multiplier;
            map = fillMap(00, 12, offset, map);
            map = fillMap(34, 1, offset, map);
            map = fillMap(96, 1, offset, map);
            map = fillMap(58, 8, offset, map);
            map = fillMap(68, 4, offset, map);
            map = fillMap(54, 8, offset, map);
            map = fillMap(33, 3, offset, map);
            map = fillMap(57, 1, offset, map);
            map = fillMap(19, 2, offset, map);
            map = fillMap(12, 5, offset, map);
            map = fillMap(29, 8, offset, map);
            map = fillMap(08, 3, offset, map);
            map = fillMap(32, 3, offset, map);
            map = fillMap(56, 6, offset, map);
            map = fillMap(73, 7, offset, map);
            map = fillMap(21, 3, offset, map);
            map = fillMap(38, 1, offset, map);
        }
    }
  }

  return map;
}

// create substition Table
// to change random number to first number in the row
Map<String, String> replaceOwnMap(String keyList, Alphabet alphabet){
  var map = Map<String, String>();

  if (alphabet == alphabetGerman1) {
    var offset = 1;
    map = fillMap(36, 1, 20, map);
    map = fillMap(36, 1, 20, map);
    map = fillMapOwn(36, 66, 4, offset, map);
    map = fillMap(06, 1, offset, map);
    map = fillMap(08, 1, offset, map);
    map = fillMap(10, 4, offset, map);
    map = fillMap(15, 4, offset, map);
    map = fillMap(15, 1, 15, map);
    map = fillMapOwn(15, 6, 9, offset, map);
    map = fillMap(15, 1, 15, map);
    map = fillMapOwn(15, 16, 1, offset, map);
    map = fillMap(32, 1, offset, map);
    map = fillMap(34, 1, offset, map);
    map = fillMap(34, 1, 66, map);
    map = fillMap(37, 2, offset, map);
    map = fillMap(37, 1, -17, map);
    map = fillMap(37, 1, 4, map);
    map = fillMap(42, 7, offset, map);
    map = fillMap(52, 2, offset, map);
    map = fillMap(55, 1, 46, map);
    map = fillMap(57, 9, offset, map);
    map = fillMap(67, 1, offset, map);
    map = fillMap(71, 6, offset, map);
    map = fillMap(78, 6, offset, map);
    map = fillMap(85, 4, offset, map);
    map = fillMap(85, 1, -15, map);
    map = fillMap(91, 3, offset, map);
  }

  return map;
}

String changeOutput(String input, Map<String, String> replaceNumbers){
  if (replaceNumbers != null)
    replaceNumbers.forEach((key, value){
      input = substitution(input, replaceNumbers);
    });
  return input;
}