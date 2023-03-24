import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/string_utils.dart';

void main() {
  group("StringUtils.insertCharacter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'index': 0, 'character' : 'A', 'expectedOutput' : null},
      // {'input' : 'ABC', 'index': 0, 'character' : null, 'expectedOutput' : 'ABC'},

      {'input' : 'ABC', 'index': -1, 'character' : 'D', 'expectedOutput' : 'DABC'},
      {'input' : 'ABC', 'index': 0, 'character' : 'D', 'expectedOutput' : 'DABC'},
      {'input' : 'ABC', 'index': 1, 'character' : 'D', 'expectedOutput' : 'ADBC'},
      {'input' : 'ABC', 'index': 2, 'character' : 'D', 'expectedOutput' : 'ABDC'},
      {'input' : 'ABC', 'index': 3, 'character' : 'D', 'expectedOutput' : 'ABCD'},
      {'input' : 'ABC', 'index': 4, 'character' : 'D', 'expectedOutput' : 'ABCD'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, input: ${elem['index']}, input: ${elem['character']}', () {
        var _actual = insertCharacter(elem['input'] as String, elem['index'] as int, elem['character'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.insertSpaceEveryNthCharacter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'n': 0, 'expectedOutput' : ''},
      // {'input' : 'ABC', 'n': null, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'n': 0, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'n': 1, 'expectedOutput' : 'A B C'},
      {'input' : 'ABCDEF', 'n': 2, 'expectedOutput' : 'AB CD EF'},
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'expectedOutput' : 'ABC DEF GHI J'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, n: ${elem['n']}', () {
        var _actual = insertSpaceEveryNthCharacter(elem['input'] as String, elem['n'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.insertEveryNthCharacter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'textToInsert': '', 'expectedOutput' : 'ABCDEFGHIJ'},
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'textToInsert': '1', 'expectedOutput' : 'ABC1DEF1GHI1J'},
      {'input' : 'ABCDEFGHIJ', 'n': 3, 'textToInsert': '123', 'expectedOutput' : 'ABC123DEF123GHI123J'},
      {'input' : 'ABCDEFGHI', 'n': 3, 'textToInsert': '123', 'expectedOutput' : 'ABC123DEF123GHI'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, n: ${elem['n']}, textToInsert: ${elem['textToInsert']}', () {
        var _actual = insertEveryNthCharacter(elem['input'] as String, elem['n'] as int, elem['textToInsert'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.isUpperCase:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'letter' : null, 'expectedOutput' : false},
      {'letter' : '', 'expectedOutput' : false},

      {'letter' : 'A', 'expectedOutput' : true},
      {'letter' : 'AA', 'expectedOutput' : true},

      {'letter' : 'AAa', 'expectedOutput' : false},
      {'letter' : 'a', 'expectedOutput' : false},
      {'letter' : 'aA', 'expectedOutput' : false},

      {'letter' : 'ß', 'expectedOutput' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('letter: ${elem['letter']}', () {
        var _actual = isUpperCase(elem['letter'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.removeDuplicateCharacters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'AA', 'expectedOutput' : 'A'},
      {'input' : 'A1A', 'expectedOutput' : 'A1'},
      {'input' : 'A1A1', 'expectedOutput' : 'A1'},
      {'input' : 'A11A', 'expectedOutput' : 'A1'},

      {'input' : 'remove Duplicate Characters', 'expectedOutput' : 'remov DuplicatChs'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = removeDuplicateCharacters(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.hasDuplicateCharacters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : false},
      {'input' : '', 'expectedOutput' : false},

      {'input' : 'A1', 'expectedOutput' : false},
      {'input' : 'A1a', 'expectedOutput' : false},

      {'input' : 'AA', 'expectedOutput' : true},
      {'input' : 'A1A', 'expectedOutput' : true},
      {'input' : 'A1A1', 'expectedOutput' : true},
      {'input' : 'A11A', 'expectedOutput' : true},

      {'input' : 'remove Duplicate Characters', 'expectedOutput' : true},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = hasDuplicateCharacters(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.countCharacters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'characters': null, 'expectedOutput' : 0},
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

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, characters: ${elem['characters']}', () {
        var _actual = countCharacters(elem['input'] as String, elem['characters'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.allSameCharacters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : false},

      {'input' : 'a', 'expectedOutput' : true},
      {'input' : 'aaa', 'expectedOutput' : true},
      {'input' : 'aaaaa', 'expectedOutput' : true},
      {'input' : '999', 'expectedOutput' : true},

      {'input' : 'aA', 'expectedOutput' : false},
      {'input' : 'a a', 'expectedOutput' : false},
      {'input' : '9977', 'expectedOutput' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = allSameCharacters(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.isOnlyLetters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : false},
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

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = isOnlyLetters(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.isOnlyNumerals:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : false},
      {'input' : '', 'expectedOutput' : false},

      {'input' : '0', 'expectedOutput' : true},
      {'input' : '000', 'expectedOutput' : true},
      {'input' : '1001', 'expectedOutput' : true},

      {'input' : '0 1', 'expectedOutput' : false},
      {'input' : 'a1', 'expectedOutput' : false},
      {'input' : '0.1', 'expectedOutput' : false}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = isOnlyNumerals(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.extractIntegerFromText:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : 0},

      {'input' : 'a', 'expectedOutput' : 0},
      {'input' : '12', 'expectedOutput' : 12},
      {'input' : '123,4', 'expectedOutput' : 1234},
      {'input' : '123,4', 'expectedOutput' : 1234},

      {'input' : '1 2', 'expectedOutput' : 12},
      {'input' : 'a1', 'expectedOutput' : 1},
      {'input' : '1a2', 'expectedOutput' : 12}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = extractIntegerFromText(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.normalizeCharacters", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '\u0009\u000B\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2007\u2008\u2009\u200A\u202F\u205F\u3000', 'expectedOutput' : '                 '},
      {'input' : '\u201e\u201f\u201d\u201c', 'expectedOutput' : '""""'},
      {'input' : '\u201b\u201a\u2019\u2018', 'expectedOutput' : '\'\'\'\''},
      {'input' : '—–˗−‒', 'expectedOutput' : '-----'},

      {'input' : '—\u2019\u2005\u201c', 'expectedOutput' : '-\' "'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = normalizeCharacters(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.removeControlCharacters", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '\u0000\u0001\u001f', 'expectedOutput' : ''},
      {'input' : '\u0000\u0020\u001f', 'expectedOutput' : ' '},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = removeControlCharacters(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}