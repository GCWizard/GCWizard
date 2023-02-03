import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

void main() {
  group("CommonUtils.insertCharacter:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'index': 0, 'character' : 'A', 'expectedOutput' : null},
      {'input' : 'ABC', 'index': 0, 'character' : null, 'expectedOutput' : 'ABC'},

      {'input' : 'ABC', 'index': -1, 'character' : 'D', 'expectedOutput' : 'DABC'},
      {'input' : 'ABC', 'index': 0, 'character' : 'D', 'expectedOutput' : 'DABC'},
      {'input' : 'ABC', 'index': 1, 'character' : 'D', 'expectedOutput' : 'ADBC'},
      {'input' : 'ABC', 'index': 2, 'character' : 'D', 'expectedOutput' : 'ABDC'},
      {'input' : 'ABC', 'index': 3, 'character' : 'D', 'expectedOutput' : 'ABCD'},
      {'input' : 'ABC', 'index': 4, 'character' : 'D', 'expectedOutput' : 'ABCD'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, input: ${elem['index']}, input: ${elem['character']}', () {
        var _actual = insertCharacter(elem['input'], elem['index'], elem['character']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.insertSpaceEveryNthCharacter:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : '', 'n': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'n': null, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'n': 0, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'n': 1, 'expectedOutput' : 'A B C'},
      {'input' : 'ABCDEF', 'n': 2, 'expectedOutput' : 'AB CD EF'},
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'expectedOutput' : 'ABC DEF GHI J'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, n: ${elem['n']}', () {
        var _actual = insertSpaceEveryNthCharacter(elem['input'], elem['n']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.insertEveryNthCharacter:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'textToInsert': '', 'expectedOutput' : 'ABCDEFGHIJ'},
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'textToInsert': '1', 'expectedOutput' : 'ABC1DEF1GHI1J'},
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'textToInsert': '123', 'expectedOutput' : 'ABC123DEF123GHI123J'},
      {'input' : 'ABCDEFGHI', 'n': 3, 'textToInsert': '123', 'expectedOutput' : 'ABC123DEF123GHI'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, n: ${elem['n']}, textToInsert: ${elem['textToInsert']}', () {
        var _actual = insertEveryNthCharacter(elem['input'], elem['n'], elem['textToInsert']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.switchMapKeyValue:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'map' : null, 'expectedOutput': null},
      {'map' : {}, 'expectedOutput': {}},
      {'map' : <String, String>{}, 'expectedOutput': <String, String>{}},
      {'map' : <int, int>{}, 'expectedOutput': <int, int>{}},
      {'map' : <String, int>{}, 'expectedOutput': <int, String>{}},
      {'map' : <int, String>{}, 'expectedOutput': <String, int>{}},

      {'map' : {'A': 'B'}, 'expectedOutput': {'B': 'A'}},
      {'map' : {'A': 'B', 'C': 'D'}, 'expectedOutput': {'B': 'A', 'D': 'C'}},
      {'map' : {'A': 1}, 'expectedOutput': {1: 'A'}},
      {'map' : {'A': 1, 'C': 2}, 'expectedOutput': {1: 'A', 2: 'C'}},
      {'map' : {1: 'B'}, 'expectedOutput': {'B': 1}},
      {'map' : {1: 'B', 2: 'D'}, 'expectedOutput': {'B': 1, 'D': 2}},

      {'map' : {'A': null}, 'expectedOutput': {null: 'A'}},
      {'map' : {'A': 'A'}, 'expectedOutput': {'A': 'A'}},
      {'map' : {null: 'A'}, 'expectedOutput': {'A': null}},
      {'map' : {null: null}, 'expectedOutput': {null: null}},
      {'map' : {'A': 1, 'B': 1}, 'expectedOutput': {1: 'B'}},
      {'map' : {'A': 1, 'B': 1}, 'keepFirstOccurence': true, 'expectedOutput': {1: 'A'}},
      {'map' : {1: 'A', 1: 'B'}, 'expectedOutput': {'B': 1}}, //input map will be reduced to {1: 'B'}
    ];

    _inputsToExpected.forEach((elem) {
      test('map: ${elem['map']}, keepFirstOccurence: ${elem['keepFirstOccurence']}', () {
        var _actual;
        if (elem['keepFirstOccurence'] == null)
          _actual = switchMapKeyValue(elem['map']);
        else
          _actual = switchMapKeyValue(elem['map'], keepFirstOccurence: elem['keepFirstOccurence']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.textToBinaryList:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text' : null, 'expectedOutput' : []},
      {'text' : '', 'expectedOutput' : []},
      {'text' : '234', 'expectedOutput' : []},
      {'text' : 'ASD', 'expectedOutput' : []},

      {'text' : '1', 'expectedOutput' : ['1']},
      {'text' : '01', 'expectedOutput' : ['01']},
      {'text' : '01 101', 'expectedOutput' : ['01', '101']},
      {'text' : '01 101 0', 'expectedOutput' : ['01', '101', '0']},

      {'text' : '1dasjk1123ssd12jd10ak', 'expectedOutput' : ['1', '11', '1', '10']},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = textToBinaryList(elem['text']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.modulo:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'value' : 0, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : -1, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : -2, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : 1, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : 2, 'modulator': 1, 'expectedOutput' : 0},

      {'value' : 0, 'modulator': 2, 'expectedOutput' : 0},
      {'value' : -1, 'modulator': 2, 'expectedOutput' : 1},
      {'value' : -2, 'modulator': 2, 'expectedOutput' : 0},
      {'value' : 1, 'modulator': 2, 'expectedOutput' : 1},
      {'value' : 2, 'modulator': 2, 'expectedOutput' : 0},

      {'value' : 0.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : -1.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : -2.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : 1.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : 2.0, 'modulator': 1, 'expectedOutput' : 0.0},

      {'value' : 0.0, 'modulator': 2, 'expectedOutput' : 0.0},
      {'value' : -1.0, 'modulator': 2, 'expectedOutput' : 1.0},
      {'value' : -2.0, 'modulator': 2, 'expectedOutput' : 0.0},
      {'value' : 1.0, 'modulator': 2, 'expectedOutput' : 1.0},
      {'value' : 2.0, 'modulator': 2, 'expectedOutput' : 0.0},

      {'value' : 0, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : -1, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : -2, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : 1, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : 2, 'modulator': 1.0, 'expectedOutput' : 0.0},

      {'value' : 0, 'modulator': 2.0, 'expectedOutput' : 0.0},
      {'value' : -1, 'modulator': 2.0, 'expectedOutput' : 1.0},
      {'value' : -2, 'modulator': 2.0, 'expectedOutput' : 0.0},
      {'value' : 1, 'modulator': 2.0, 'expectedOutput' : 1.0},
      {'value' : 2, 'modulator': 2.0, 'expectedOutput' : 0.0},

      {'value' : 0, 'modulator': 2.5, 'expectedOutput' : 0.0},
      {'value' : -1, 'modulator': 2.5, 'expectedOutput' : 1.5},
      {'value' : -2, 'modulator': 2.5, 'expectedOutput' : 0.5},
      {'value' : 1, 'modulator': 2.5, 'expectedOutput' : 1.0},
      {'value' : 2, 'modulator': 2.5, 'expectedOutput' : 2.0},
      {'value' : 2.5, 'modulator': 2.5, 'expectedOutput' : 0.0},
      {'value' : 2.6, 'modulator': 2.5, 'expectedOutput' : 0.10000000000000009},
    ];

    _inputsToExpected.forEach((elem) {
      test('value: ${elem['value']}, modulator:  ${elem['modulator']}', () {
        var _actual = modulo(elem['value'], elem['modulator']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.doubleEquals:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'a' : null, 'b': null, 'tolerance': 1e-10, 'expectedOutput' : true},
      {'a' : null, 'b': 1.0, 'tolerance': 1e-10, 'expectedOutput' : false},
      {'a' : 1.0, 'b': null, 'tolerance': 1e-10, 'expectedOutput' : false},

      {'a' : 1.0, 'b': 1.0, 'tolerance': 1e-10, 'expectedOutput' : true},
      {'a' : 1.123, 'b': 1.123, 'tolerance': 1e-10, 'expectedOutput' : true},
      {'a' : 52.1231554889286231, 'b': 52.1231554889286231, 'tolerance': 1e-10, 'expectedOutput' : true},
      {'a' : 52.123, 'b': 52.132, 'tolerance': 1e-2, 'expectedOutput' : true},
      {'a' : 52.123, 'b': 52.133, 'tolerance': 1e-2, 'expectedOutput' : false},
    ];

    _inputsToExpected.forEach((elem) {
      test('a: ${elem['a']}, b: ${elem['b']}, tolerance: ${elem['tolerance']}', () {
        var _actual = doubleEquals(elem['a'], elem['b'], tolerance: elem['tolerance']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.isUpperCase:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'letter' : null, 'expectedOutput' : false},
      {'letter' : '', 'expectedOutput' : false},

      {'letter' : 'A', 'expectedOutput' : true},
      {'letter' : 'AA', 'expectedOutput' : true},

      {'letter' : 'AAa', 'expectedOutput' : false},
      {'letter' : 'a', 'expectedOutput' : false},
      {'letter' : 'aA', 'expectedOutput' : false},

      {'letter' : 'ß', 'expectedOutput' : false},
    ];

    _inputsToExpected.forEach((elem) {
      test('letter: ${elem['letter']}', () {
        var _actual = isUpperCase(elem['letter']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.removeDuplicateCharacters:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'AA', 'expectedOutput' : 'A'},
      {'input' : 'A1A', 'expectedOutput' : 'A1'},
      {'input' : 'A1A1', 'expectedOutput' : 'A1'},
      {'input' : 'A11A', 'expectedOutput' : 'A1'},

      {'input' : 'remove Duplicate Characters', 'expectedOutput' : 'remov DuplicatChs'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = removeDuplicateCharacters(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.hasDuplicateCharacters:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : false},
      {'input' : '', 'expectedOutput' : false},

      {'input' : 'A1', 'expectedOutput' : false},
      {'input' : 'A1a', 'expectedOutput' : false},

      {'input' : 'AA', 'expectedOutput' : true},
      {'input' : 'A1A', 'expectedOutput' : true},
      {'input' : 'A1A1', 'expectedOutput' : true},
      {'input' : 'A11A', 'expectedOutput' : true},

      {'input' : 'remove Duplicate Characters', 'expectedOutput' : true},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = hasDuplicateCharacters(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.countCharacters:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'characters': null, 'expectedOutput' : 0},
      {'input' : '', 'characters': 'a', 'expectedOutput' : 0},

      {'input' : 'ABC', 'characters': 'A', 'expectedOutput' : 1},
      {'input' : 'ABC', 'characters': 'AB', 'expectedOutput' : 2},
      {'input' : 'ABC', 'characters': 'ABC', 'expectedOutput' : 3},
      {'input' : 'ABC', 'characters': 'ABCD', 'expectedOutput' : 3},

      {'input' : 'ABCABC', 'characters': 'A', 'expectedOutput' : 2},
      {'input' : 'ABCABC', 'characters': 'AB', 'expectedOutput' : 4},
      {'input' : 'ABCABC', 'characters': 'ABC', 'expectedOutput' : 6},
      {'input' : 'ABCABC', 'characters': 'ABCD', 'expectedOutput' : 6},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, characters: ${elem['characters']}', () {
        var _actual = countCharacters(elem['input'], elem['characters']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.allSameCharacters:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : null},

      {'input' : 'a', 'expectedOutput' : true},
      {'input' : 'aaa', 'expectedOutput' : true},
      {'input' : 'aaaaa', 'expectedOutput' : true},
      {'input' : '999', 'expectedOutput' : true},

      {'input' : 'aA', 'expectedOutput' : false},
      {'input' : 'a a', 'expectedOutput' : false},
      {'input' : '9977', 'expectedOutput' : false},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = allSameCharacters(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.isOnlyLetters:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : false},
      {'input' : '', 'expectedOutput' : false},

      {'input' : 'a', 'expectedOutput' : true},
      {'input' : 'aaa', 'expectedOutput' : true},
      {'input' : 'AaaA', 'expectedOutput' : true},
      {'input' : 'ABCÄÖÜß\u1e9eàé', 'expectedOutput' : true},

      {'input' : 'a a', 'expectedOutput' : false},
      {'input' : 'a1', 'expectedOutput' : false},
      {'input' : '11', 'expectedOutput' : false},
      {'input' : 'a.x', 'expectedOutput' : false}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = isOnlyLetters(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.isOnlyNumerals:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : false},
      {'input' : '', 'expectedOutput' : false},

      {'input' : '0', 'expectedOutput' : true},
      {'input' : '000', 'expectedOutput' : true},
      {'input' : '1001', 'expectedOutput' : true},

      {'input' : '0 1', 'expectedOutput' : false},
      {'input' : 'a1', 'expectedOutput' : false},
      {'input' : '0.1', 'expectedOutput' : false}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = isOnlyNumerals(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.round:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'precision': 0, 'expectedOutput' : null},
      {'input' : 0.0, 'precision': 0, 'expectedOutput' : 0},

      {'input' : 0.1, 'precision': 0, 'expectedOutput' : 0},
      {'input' : 0.9, 'precision': 0, 'expectedOutput' : 1},
      {'input' : -0.1, 'precision': 0, 'expectedOutput' : 0},
      {'input' : -0.9, 'precision': 0, 'expectedOutput' : -1},

      {'input' : 0.1, 'precision': 1, 'expectedOutput' : 0.1},
      {'input' : 0.9, 'precision': 1, 'expectedOutput' : 0.9},
      {'input' : -0.1, 'precision': 1, 'expectedOutput' : -0.1},
      {'input' : -0.9, 'precision': 1, 'expectedOutput' : -0.9},

      {'input' : 0.11, 'precision': 1, 'expectedOutput' : 0.1},
      {'input' : 0.19, 'precision': 1, 'expectedOutput' : 0.2},
      {'input' : 0.91, 'precision': 1, 'expectedOutput' : 0.9},
      {'input' : 0.99, 'precision': 1, 'expectedOutput' : 1.0},
      {'input' : -0.11, 'precision': 1, 'expectedOutput' : -0.1},
      {'input' : -0.19, 'precision': 1, 'expectedOutput' : -0.2},
      {'input' : -0.91, 'precision': 1, 'expectedOutput' : -0.9},
      {'input' : -0.99, 'precision': 1, 'expectedOutput' : -1.0},

      {'input' : 1.257, 'precision': 2, 'expectedOutput' : 1.26},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, precision: ${elem['precision']}', () {
        var _actual = round(elem['input'], precision: elem['precision']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.extractIntegerFromText:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : null},

      {'input' : 'a', 'expectedOutput' : null},
      {'input' : '12', 'expectedOutput' : 12},
      {'input' : '123,4', 'expectedOutput' : 1234},
      {'input' : '123,4', 'expectedOutput' : 1234},

      {'input' : '1 2', 'expectedOutput' : 12},
      {'input' : 'a1', 'expectedOutput' : 1},
      {'input' : '1a2', 'expectedOutput' : 12}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = extractIntegerFromText(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.separateDecimalPlaces:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},

      {'input' : 0.0, 'expectedOutput' : 0},
      {'input' : 1.2, 'expectedOutput' : 2},
      {'input' : .2, 'expectedOutput' : 2},
      {'input' : 1.0, 'expectedOutput' : 0},
      {'input' : 123.4, 'expectedOutput' : 4},
      {'input' : 12.345, 'expectedOutput' : 345},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = fractionPartAsInteger(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.normalizeCharacters", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '\u0009\u000B\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2007\u2008\u2009\u200A\u202F\u205F\u3000', 'expectedOutput' : '                 '},
      {'input' : '\u201e\u201f\u201d\u201c', 'expectedOutput' : '""""'},
      {'input' : '\u201b\u201a\u2019\u2018', 'expectedOutput' : '\'\'\'\''},
      {'input' : '—–˗−‒', 'expectedOutput' : '-----'},

      {'input' : '—\u2019\u2005\u201c', 'expectedOutput' : '-\' "'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = normalizeCharacters(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.removeControlCharacters", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '\u0000\u0001\u001f', 'expectedOutput' : ''},
      {'input' : '\u0000\u0020\u001f', 'expectedOutput' : ' '},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = removeControlCharacters(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}