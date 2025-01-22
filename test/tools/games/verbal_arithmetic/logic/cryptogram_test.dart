import 'dart:collection';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/cryptogram.dart';

void main() {

  group("VerbalArithmetic.solveSymbolArithmetic:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'formulas' : {''}.toList(), 'expectedOutput' : <HashMap<String, int>>[]},
      {'formulas' : {' '}.toList(), 'expectedOutput' : <HashMap<String, int>>[]},
      {'formulas' : {'E-(2)'}.toList(), 'expectedOutput' : {'E': 2}},
      {'formulas' : {'E'}.toList(), 'expectedOutput' : {'E': 0}},
      // {'formulas' : {'baum*schneemann+stern-schlitten*baum-glocken=41',
      //   'glocken+weihnachtsmann*stern+schneemann+stern+weihnachtsmann=26',
      //   'stern+glocken*stern-glocken*glocken+stern=24',
      //   'schneemann+baum*stern+stern*baum-schlitten=65',
      //   'glocken-schlitten+stern*baum+baum-stern=27',
      //   'schneemann*stern+stern-weihnachtsmann+glocken*baum=77',
      //   'baum*glocken+stern*schneemann-glocken*schneemann=53',
      //   'schneemann+weihnachtsmann*glocken*baum-schlitten+stern=24',
      //   'stern+stern*stern+stern*stern-stern=98',
      //   'schlitten*schneemann+glocken+stern*baum+weihnachtsmann=31',
      //   'baum+stern*glocken+baum*baum-glocken=32',
      //   'glocken*weihnachtsmann+stern-schlitten+stern*baum=37'}.toList(),
      //   'expectedOutput' : {'SCHLITTEN': 0, 'SCHNEEMANN': 9, 'WEIHNACHTSMANN': 1, 'STERN': 7, 'GLOCKEN': 2, 'BAUM': 4}
      // },

      {'formulas' : {'mutze+mutze+glocken+glocken+stern+kugel-(49)',
        'kerze+stern+kerze+baum+kugel+kugel-(67)',
        'kugel+baum+stern+kerze+kugel+kugel-(56)',
        'mutze+mutze+mutze+mutze+baum+kugel-(36)',
        'kugel+baum+baum+kugel+baum+kugel-(60)',
        'mutze+mutze+mutze+mutze+stern+kugel-(25)',
        'mutze+kerze+kugel+mutze+kugel+mutze-(47)',
        'mutze+stern+baum+mutze+baum+mutze-(37)',
        'glocken+kerze+stern+mutze+baum+mutze-(56)',
        'glocken+baum+kerze+mutze+kugel+mutze-(63)',
        'stern+kugel+kugel+baum+baum+stern-(42)',
        'kugel+kugel+kugel+kugel+kugel+kugel-(48)'}.toList(),
        'expectedOutput' : {'MUTZE': 4, 'KUGEL': 8, 'STERN': 1, 'GLOCKEN': 16, 'KERZE': 19, 'BAUM': 12}
      },

      {'formulas' : {'schnee*mann=1428',
        'schleife-baum=12',
        'schnee*schleife=840',
        'mann-baum=33'}.toList(),
        'expectedOutput' : {'SCHLEIFE': 30, 'SCHNEE': 28, 'MANN': 51, 'BAUM': 18}
      },
      {'formulas' : {'schne5*mann=1428',
        'schle9fe-b1um=12',
        'schne5*schle9fe=840',
        'mann-b1um=33'}.toList(),
        'expectedOutput' : {'SCHLE9FE': 30, 'B1UM': 18, 'SCHNE5': 28, 'MANN': 51}
      },
    ];

    for (var elem in _inputsToExpected) {
      test('formulas: ${elem['formulas']}', () {
        var _actual = solveCryptogram(elem['formulas'] as List<String>);
        if (_actual != null && _actual.solutions.isNotEmpty) {
          expect(_actual.solutions.first, elem['expectedOutput']);
        } else if (_actual != null && _actual.solutions.isEmpty) {
            expect(_actual.solutions, elem['expectedOutput']);
        } else {
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });
}