import 'dart:collection';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/symbolism.dart';

void main() {

  group("VerbalArithmetic.solveSymbolism:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'formulas' : {''}.toList(), 'expectedOutput' : <HashMap<String, int>>[]},
      {'formulas' : {' '}.toList(), 'expectedOutput' : <HashMap<String, int>>[]},
      {'formulas' : {'E-(2)'}.toList(), 'expectedOutput' : {'E': 2}},
      {'formulas' : {'E'}.toList(), 'expectedOutput' : <HashMap<String, int>>[]},
      {'formulas' : {
        'ABCB+DEAF=GFFB',
        'AEEF+AHG=AGIG',
        'EBB*AH=HGCF',
        'ABCB-AEEF=EBB',
        'DEAF/AHG=AH',
        'GFFB+AGIG=HGCF'}.toList(),
        'expectedOutput' : {'F': 0, 'A': 1, 'E': 3, 'B': 6, 'H': 5, 'D': 2, 'C': 9, 'I': 8, 'G': 4}
      },
      {'formulas' : {
        'GJ*DJ=LBAC',
        'BJKD+BCCK=DJKB',
        'BJLH-GF=BHJL',
        'BJKD-GJ=BJLH',
        'BCCK/DJ=GF',
        'DJKB-LBAC=BHJL'}.toList(),
        'expectedOutput' : {'F': 4, 'A': 0, 'J': 7, 'K': 8, 'B': 1, 'H': 6, 'D': 3, 'C': 9, 'G': 5, 'L': 2}
      },
    ];

    for (var elem in _inputsToExpected) {
      test('formulas: ${elem['formulas']}', () {
        var allSolutions = elem['allSolutions'] != null;
        var leadingZeros = elem['leadingZeros'] != null;
        var _actual = solveSymbolism(elem['formulas'] as List<String>, allSolutions, leadingZeros);
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