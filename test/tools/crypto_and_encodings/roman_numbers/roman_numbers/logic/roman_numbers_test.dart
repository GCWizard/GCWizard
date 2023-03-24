import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';

void main() {
  group("RomanNumbers.encodeRomanNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : -1, 'expectedOutput' : ''},
      {'input' : 0, 'expectedOutput' : ''},

      {'input' : 1, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'I'},
      {'input' : 2, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'II'},
      {'input' : 3, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'III'},
      {'input' : 4, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'IV'},
      {'input' : 5, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'V'},
      {'input' : 6, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'VI'},
      {'input' : 7, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'VII'},
      {'input' : 8, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'VIII'},
      {'input' : 9, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'IX'},
      {'input' : 10, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'X'},
      {'input' : 11, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XI'},
      {'input' : 14, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XIV'},
      {'input' : 15, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XV'},
      {'input' : 19, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XIX'},
      {'input' : 20, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XX'},
      {'input' : 24, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XXIV'},
      {'input' : 25, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XXV'},
      {'input' : 49, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XLIX'},
      {'input' : 50, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'L'},
      {'input' : 88, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'LXXXVIII'},
      {'input' : 99, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'XCIX'},
      {'input' : 100, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'C'},
      {'input' : 400, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'CD'},
      {'input' : 444, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'CDXLIV'},
      {'input' : 500, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'D'},
      {'input' : 1000, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'M'},
      {'input' : 3888, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'MMMDCCCLXXXVIII'},
      {'input' : 3999, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'MMMCMXCIX'},
      {'input' : 5111, 'type': RomanNumberType.USE_SUBTRACTION_RULE, 'expectedOutput' : 'MMMMMCXI'},

      {'input' : 1, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'I'},
      {'input' : 2, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'II'},
      {'input' : 3, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'III'},
      {'input' : 4, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'IIII'},
      {'input' : 5, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'V'},
      {'input' : 6, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'VI'},
      {'input' : 7, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'VII'},
      {'input' : 8, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'VIII'},
      {'input' : 9, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'VIIII'},
      {'input' : 10, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'X'},
      {'input' : 11, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XI'},
      {'input' : 14, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XIIII'},
      {'input' : 15, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XV'},
      {'input' : 19, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XVIIII'},
      {'input' : 20, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XX'},
      {'input' : 24, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XXIIII'},
      {'input' : 25, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XXV'},
      {'input' : 49, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'XXXXVIIII'},
      {'input' : 50, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'L'},
      {'input' : 88, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'LXXXVIII'},
      {'input' : 99, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'LXXXXVIIII'},
      {'input' : 100, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'C'},
      {'input' : 400, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'CCCC'},
      {'input' : 444, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'CCCCXXXXIIII'},
      {'input' : 500, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'D'},
      {'input' : 1000, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'M'},
      {'input' : 3888, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'MMMDCCCLXXXVIII'},
      {'input' : 3999, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'MMMDCCCCLXXXXVIIII'},
      {'input' : 5111, 'type': RomanNumberType.ONLY_ADDITION, 'expectedOutput' : 'MMMMMCXI'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, type: ${elem['type']}', () {
        if (elem['type'] == null) {
          var _actual = encodeRomanNumbers(elem['input'] as int);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = encodeRomanNumbers(elem['input'] as int, type: elem['type'] as RomanNumberType);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("RomanNumbers.decodeRomanNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : null},
      {'input' : 'Ab', 'expectedOutput' : null},
      {'input' : 'AbI', 'expectedOutput' : 1},
      {'input' : 'AbMI', 'expectedOutput' : 1001},

      {'expectedOutput' : 1, 'input' : 'I', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 2, 'input' : 'ii', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 3, 'input' : 'IiI', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 4, 'input' : 'IV', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 5, 'input' : 'V', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 6, 'input' : 'VI', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 7, 'input' : 'viI', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 8, 'input' : 'VIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 9, 'input' : 'IX', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 10, 'input' : 'X', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 11, 'input' : 'XI', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 14, 'input' : 'XIV', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 15, 'input' : 'XV', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 19, 'input' : 'XIX', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 20, 'input' : 'XX', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 24, 'input' : 'xxiv', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 25, 'input' : 'XXV', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 49, 'input' : 'XLIX', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 50, 'input' : 'L', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 88, 'input' : 'LXXXVIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 99, 'input' : 'XCIX', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 100, 'input' : 'C', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 400, 'input' : 'CD', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 444, 'input' : 'CDXLIV', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 500, 'input' : 'D', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 1000, 'input' : 'M', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 3888, 'input' : 'MMMDCCCLXXXVIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 3999, 'input' : 'MMMCMXCIX', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 5111, 'input' : 'MMMMMCXI', 'type': RomanNumberType.USE_SUBTRACTION_RULE},

      {'expectedOutput' : 4, 'input' : 'iiii', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 9, 'input' : 'VIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 14, 'input' : 'XIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 19, 'input' : 'XVIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 24, 'input' : 'XXIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 49, 'input' : 'XXXXVIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 99, 'input' : 'LXXXXVIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 400, 'input' : 'CCCC', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 444, 'input' : 'CCCCXXxxiiII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 3999, 'input' : 'MMMDCCCCLXXXXVIIII', 'type': RomanNumberType.USE_SUBTRACTION_RULE},

      //wrong input -> simple addition
      {'expectedOutput' : 1001, 'input' : 'IM', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 511, 'input' : 'XDI', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 1106, 'input' : 'MVIC', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 1104, 'input' : 'MIVC', 'type': RomanNumberType.USE_SUBTRACTION_RULE},

      //chronogram
      {'expectedOutput' : 2006, 'input' : 'AMORE MATVRITAS', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 2004, 'input' : 'AMORE MATIRVTAS', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 904, 'input' : 'ACORE MATIRVTAS', 'type': RomanNumberType.USE_SUBTRACTION_RULE},

      //chronogram wrong input -> simple addition
      {'expectedOutput' : 1106, 'input' : 'MATVRITAS ACORE', 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'expectedOutput' : 1104, 'input' : 'MATIRVTAS ACORE', 'type': RomanNumberType.USE_SUBTRACTION_RULE},

      //Test Cases from Chronogram
      {'input' : 'ALICIMAAMADMIDIAILACMIICLIIIDIMCAMMIDIIDIACADDIDADIILDMICALMLII', 'expectedOutput' : 14321, 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'input' : 'habemus Papam', 'expectedOutput' : 2000, 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'input' : 'Christvs dvx; ergo trivmphvs', 'expectedOutput' : 1628, 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'input' : 'Christus dux; ergo triumphus', 'expectedOutput' : 1612, 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'input' : 'SIT LARIBVS NOSTRIS OPTO CONCORDIA CONSTANS NOSTER ET ASSIDVO LVCEAT IGNE FOCVS', 'expectedOutput' : 1424, 'type': RomanNumberType.USE_SUBTRACTION_RULE},
      {'input' : 'SVRGE O IEHOVA ATQVE DISPERGE INIMICOS TVOS', 'expectedOutput' : 1623, 'type': RomanNumberType.USE_SUBTRACTION_RULE},

      {'expectedOutput' : 1, 'input' : 'I', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 2, 'input' : 'ii', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 3, 'input' : 'IiI', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 6, 'input' : 'IV', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 5, 'input' : 'V', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 6, 'input' : 'VI', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 7, 'input' : 'viI', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 8, 'input' : 'VIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 11, 'input' : 'IX', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 10, 'input' : 'X', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 11, 'input' : 'XI', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 16, 'input' : 'XIV', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 15, 'input' : 'XV', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 21, 'input' : 'XIX', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 20, 'input' : 'XX', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 26, 'input' : 'xxiv', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 25, 'input' : 'XXV', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 71, 'input' : 'XLIX', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 50, 'input' : 'L', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 88, 'input' : 'LXXXVIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 121, 'input' : 'XCIX', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 100, 'input' : 'C', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 600, 'input' : 'CD', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 666, 'input' : 'CDXLIV', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 500, 'input' : 'D', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 1000, 'input' : 'M', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 3888, 'input' : 'MMMDCCCLXXXVIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 4221, 'input' : 'MMMCMXCIX', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 5111, 'input' : 'MMMMMCXI', 'type': RomanNumberType.ONLY_ADDITION},

      {'expectedOutput' : 4, 'input' : 'iiii', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 9, 'input' : 'VIIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 14, 'input' : 'XIIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 19, 'input' : 'XVIIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 24, 'input' : 'XXIIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 49, 'input' : 'XXXXVIIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 99, 'input' : 'LXXXXVIIII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 400, 'input' : 'CCCC', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 444, 'input' : 'CCCCXXxxiiII', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 3999, 'input' : 'MMMDCCCCLXXXXVIIII', 'type': RomanNumberType.ONLY_ADDITION},

      //wrong input -> simple addition
      {'expectedOutput' : 1001, 'input' : 'IM', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 511, 'input' : 'XDI', 'type': RomanNumberType.ONLY_ADDITION},

      //chronogram
      {'expectedOutput' : 2006, 'input' : 'AMORE MATVRITAS', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 1106, 'input' : 'ACORE MATIRVTAS', 'type': RomanNumberType.ONLY_ADDITION},

      //chronogram wrong input -> simple addition
      {'expectedOutput' : 2006, 'input' : 'MATVRITAS AMORE', 'type': RomanNumberType.ONLY_ADDITION},
      {'expectedOutput' : 1106, 'input' : 'MATIRVTAS ACORE', 'type': RomanNumberType.ONLY_ADDITION},

      //Test Cases from Chronogram
      {'input' : 'ALICIMAAMADMIDIAILACMIICLIIIDIMCAMMIDIIDIACADDIDADIILDMICALMLII', 'expectedOutput' : 14921, 'type': RomanNumberType.ONLY_ADDITION},
      {'input' : 'habemus Papam', 'expectedOutput' : 2000, 'type': RomanNumberType.ONLY_ADDITION},
      {'input' : 'Christvs dvx; ergo trivmphvs', 'expectedOutput' : 1632, 'type': RomanNumberType.ONLY_ADDITION},
      {'input' : 'Christus dux; ergo triumphus', 'expectedOutput' : 1612, 'type': RomanNumberType.ONLY_ADDITION},
      {'input' : 'SIT LARIBVS NOSTRIS OPTO CONCORDIA CONSTANS NOSTER ET ASSIDVO LVCEAT IGNE FOCVS', 'expectedOutput' : 1626, 'type': RomanNumberType.ONLY_ADDITION},
      {'input' : 'SVRGE O IEHOVA ATQVE DISPERGE INIMICOS TVOS', 'expectedOutput' : 1625, 'type': RomanNumberType.ONLY_ADDITION},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, type: ${elem['type']}', () {
        if (elem['type'] == null) {
          var _actual = decodeRomanNumbers(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = decodeRomanNumbers(elem['input'] as String, type: elem['type'] as RomanNumberType);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });
}