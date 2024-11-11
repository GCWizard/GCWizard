import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/string_utils.dart';

void main() {
  group("StringUtils.insertCharacter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ABC', 'index': 0, 'character' : '', 'expectedOutput' : 'ABC'},

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
      {'input' : '', 'characters': '', 'expectedOutput' : 0},
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

  group("StringUtils.enumName", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'FileType.ZIP', 'expectedOutput' : 'ZIP'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = enumName(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.formatStringForDecimals_withEmpty", () {
    test('', () {
      var _actual = formatStringForDecimals();
      expect(_actual, '00.000###');
    });
  });

  group("StringUtils.formatStringForDecimals", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'integerPrecision' : -1, 'decimalPrecision' : -1, 'minDecimalPrecision' : -1, 'expectedOutput' : '0.0'},
      {'integerPrecision' : -1, 'decimalPrecision' : -1, 'minDecimalPrecision' : 1, 'expectedOutput' : '0.0'},
      {'integerPrecision' : -1, 'decimalPrecision' : 1, 'minDecimalPrecision' : -1, 'expectedOutput' : '0.0'},
      {'integerPrecision' : 0, 'decimalPrecision' : 0, 'minDecimalPrecision' : 0, 'expectedOutput' : '0.0'},
      {'integerPrecision' : 1, 'decimalPrecision' : 0, 'minDecimalPrecision' : 1, 'expectedOutput' : '0.0'},
      {'integerPrecision' : 2, 'decimalPrecision' : 0, 'minDecimalPrecision' : 0, 'expectedOutput' : '00.0'},
      {'integerPrecision' : 1, 'decimalPrecision' : 0, 'minDecimalPrecision' : 2, 'expectedOutput' : '0.0'},
      {'integerPrecision' : 1, 'decimalPrecision' : 1, 'minDecimalPrecision' : 2, 'expectedOutput' : '0.0'},
      {'integerPrecision' : 1, 'decimalPrecision' : 2, 'minDecimalPrecision' : 2, 'expectedOutput' : '0.00'},
      {'integerPrecision' : 1, 'decimalPrecision' : 3, 'minDecimalPrecision' : 2, 'expectedOutput' : '0.00#'},
      {'integerPrecision' : 1, 'decimalPrecision' : 3, 'minDecimalPrecision' : 3, 'expectedOutput' : '0.000'},
      {'integerPrecision' : 1, 'decimalPrecision' : 6, 'minDecimalPrecision' : 3, 'expectedOutput' : '0.000###'},
      {'integerPrecision' : 3, 'decimalPrecision' : 6, 'minDecimalPrecision' : 3, 'expectedOutput' : '000.000###'},
    ];

    for (var elem in _inputsToExpected) {
      test('integerPrecision: ${elem['integerPrecision']}, decimalPrecision: ${elem['decimalPrecision']}, minDecimalPrecision: ${elem['minDecimalPrecision']}', () {
        var _actual = formatStringForDecimals(
          integerPrecision: elem['integerPrecision'] as int,
          decimalPrecision: elem['decimalPrecision'] as int,
          minDecimalPrecision: elem['minDecimalPrecision'] as int,
        );
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.trimCharacterLeft", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'character': '', 'expectedOutput' : ''},
      {'input' : '', 'character': '0', 'expectedOutput' : ''},

      {'input' : '000123000', 'character': '0', 'expectedOutput' : '123000'},
      {'input' : '000123', 'character': '1', 'expectedOutput' : '000123'},
      {'input' : '0123', 'character': '0', 'expectedOutput' : '123'},
      {'input' : '  ABC', 'character': ' ', 'expectedOutput' : 'ABC'},
      {'input' : '  ABC', 'character': '', 'expectedOutput' : '  ABC'},
      {'input' : '0ABC', 'character': '0', 'expectedOutput' : 'ABC'},
      {'input' : 'AAA', 'character': 'A', 'expectedOutput' : ''},

      {'input' : 'ABCABCDEF', 'character': 'ABC', 'expectedOutput' : 'DEF'},
      {'input' : 'ABCABC', 'character': 'ABC', 'expectedOutput' : ''},
      {'input' : 'ABCAB', 'character': 'ABC', 'expectedOutput' : 'AB'},
      {'input' : 'AB', 'character': 'ABC', 'expectedOutput' : 'AB'},
      {'input' : 'ABD', 'character': 'ABC', 'expectedOutput' : 'ABD'},
      {'input' : 'XYZ123', 'character': 'ABC', 'expectedOutput' : 'XYZ123'},
      {'input' : 'XYZABC123', 'character': 'ABC', 'expectedOutput' : 'XYZABC123'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, character: ${elem['character']}, ', () {
        var _actual = trimCharactersLeft(elem['input'] as String, elem['character'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.trimCharacterRight", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'character': '', 'expectedOutput' : ''},
      {'input' : '', 'character': '0', 'expectedOutput' : ''},

      {'input' : '000123000', 'character': '0', 'expectedOutput' : '000123'},
      {'input' : '123000', 'character': '1', 'expectedOutput' : '123000'},
      {'input' : '1230', 'character': '0', 'expectedOutput' : '123'},
      {'input' : 'ABC  ', 'character': ' ', 'expectedOutput' : 'ABC'},
      {'input' : 'ABC  ', 'character': '', 'expectedOutput' : 'ABC  '},
      {'input' : 'ABC0', 'character': '0', 'expectedOutput' : 'ABC'},
      {'input' : 'AAA', 'character': 'A', 'expectedOutput' : ''},

      {'input' : 'DEFABCABC', 'character': 'ABC', 'expectedOutput' : 'DEF'},
      {'input' : 'ABCABC', 'character': 'ABC', 'expectedOutput' : ''},
      {'input' : 'ABABC', 'character': 'ABC', 'expectedOutput' : 'AB'},
      {'input' : 'AB', 'character': 'ABC', 'expectedOutput' : 'AB'},
      {'input' : 'ABD', 'character': 'ABC', 'expectedOutput' : 'ABD'},
      {'input' : 'XYZ123', 'character': 'ABC', 'expectedOutput' : 'XYZ123'},
      {'input' : 'XYZABC123', 'character': 'ABC', 'expectedOutput' : 'XYZABC123'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, character: ${elem['character']}, ', () {
        var _actual = trimCharactersRight(elem['input'] as String, elem['character'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.splitGroupsOfSameCharacters", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : <String>[]},
      {'input' : 'a', 'expectedOutput' : ['a']},
      {'input' : 'aa', 'expectedOutput' : ['aa']},
      {'input' : 'aab', 'expectedOutput' : ['aa', 'b']},
      {'input' : 'aba', 'expectedOutput' : ['a', 'b', 'a']},
      {'input' : 'aabcc', 'expectedOutput' : ['aa', 'b', 'cc']},
      {'input' : 'abbbcc', 'expectedOutput' : ['a', 'bbb', 'cc']},
      {'input' : 'ab1bb###cc22 aa', 'expectedOutput' : ['a', 'b', '1', 'bb', '###', 'cc', '22', ' ', 'aa']},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = splitGroupsOfSameCharacters(elem['input'] as String);
        expect(_actual.length, (elem['expectedOutput'] as List<String>).length);
        for (int i = 0; i < _actual.length; i++) {
          expect(_actual[i], (elem['expectedOutput'] as List<String>)[i]);
        }
      });
    }
  });

  var compressString1 = '{"id":1,"points":[{"uid":"1","lat":49.21387306534769,"lon":9.167703270198661,"format":"coords_dmm","color":"#9D4F00","sameColor":true,"isEditable":true},{"uid":"2","lat":48.9810459300513,"lon":9.662252083550984,"format":"coords_dmm","color":"#00E6AB","sameColor":true,"isEditable":true},{"uid":"3","lat":48.44437694269581,"lon":9.171790450474285,"format":"coords_dmm","color":"#A5AA00","sameColor":true,"isEditable":true},{"uid":"4","lat":48.849432434119365,"lon":8.170431282942687,"format":"coords_dmm","color":"#00729A","sameColor":true,"isEditable":true}],"polylines":[{"uid":"5","pointIDs":["4","1","2","3","4"],"color":"#F44336","type":"geodetic"}]}';
  var decompressString1 = 'eAGVkstuwjAQRf9luo3Q2DN+THZpAanfUEUVJSmKlGCUhAVC+ffahdLsgO2RfOfo+p6hqSBXGRxCsx8HyD/OcEwIFGTQbkbIWRZakXeE1hA7K5GHPeSyUNY5JO1Qibc2hnyHvktPYBtCXw2fVdfFlG1oQx/hiyx5jRjJsOnqtwsd+2OdQTOsqmbcfLX1hUzZn4a+afiFeIVshBCNopuFtVobjZ6MQfF81wJxZYvX5yxoZsHMFFtgbcV49V+GU06iHrJj7c1djcIUxbNl8EzDszBpJlZKyJqrh48eyKS018nQuwfqcFqKhzzKNJP21Db7er4UA9f5vC8T/rVM60lfl4pjKGf31rE+shGPp0MMhl0dqnpstjCV0w/mk7ub';

  group("StringUtils.compressString:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : compressString1, 'expectedOutput' : decompressString1},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = compressString(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("StringUtils.decompressString:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : decompressString1, 'expectedOutput' : compressString1},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decompressString(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}