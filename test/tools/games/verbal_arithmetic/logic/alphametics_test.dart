import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametics.dart';

void main() {

  group("Alphametics.solveAlphametic:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : [''], 'expectedOutput' : 'InvalidEquation'},
      {'input' : [' '], 'expectedOutput' : 'InvalidEquation'},
      {'input' : [' ', ''], 'expectedOutput' : 'InvalidEquation'},
      {'input' : ['ABCDE + FGHIJ = AGHIK'], 'expectedOutput' : 'TooManyLetters'},
      {'input' : ['A + B = 99'], 'expectedOutput' : ''},
      {'input' : ['BASE + BALL === GAMES'], 'expectedOutput' : 'InvalidEquation'},
      {'input' : ['BÄSE + BÄLL = GÄMES'], 'expectedOutput' : ''},
      {'input' : ['BASE + BALL == GAMES', ' '], 'expectedOutput' : '7483 + 7455 == 14938'},
      {'input' : ['BASE ++ BALL == GAMES'], 'expectedOutput' : '7483 ++ 7455 == 14938'},
      {'input' : ['BIG + CAT = LION'], 'expectedOutput' : '204 + 859 = 1063'}, //many solutions '324 + 956 = 1280', ..
      {'input' : ['ELEVEN + NINE + FIVE + FIVE = THIRTY'], 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},
      {'input' : ['SEND+MORE=MONEY'], 'expectedOutput' : '9567+1085=10652'},
      // {'input' : ['THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE + TIS + A + LIE + THE + TALE + OF + THE + LAST + FIRE + HORSES + LATE + AFTER + THE + FIRST + FATHERS + FORESEE + THE + HORRORS + THE + LAST + FREE + TROLL + TERRIFIES + THE + HORSES + OF + FIRE + THE + TROLL + RESTS + AT + THE + HOLE + OF + LOSSES + IT + IS + THERE + THAT + SHE + STORES + ROLES + OF + LEATHERS + AFTER + SHE + SATISFIES + HER + HATE + OFF + THOSE + FEARS + A + TASTE + RISES + AS + SHE + HEARS + THE + LEAST + FAR + HORSE + THOSE + FAST + HORSES + THAT + FIRST + HEAR + THE + TROLL + FLEE + OFF + TO + THE + FOREST + THE + HORSES + THAT + ALERTS + RAISE + THE + STARES + OF + THE + OTHERS + AS + THE + TROLL + ASSAILS + AT + THE + TOTAL + SHIFT + HER + TEETH + TEAR + HOOF + OFF + TORSO + AS + THE + LAST + HORSE + FORFEITS + ITS + LIFE + THE + FIRST + FATHERS + HEAR + OF + THE + HORRORS + THEIR + FEARS + THAT + THE + FIRES + FOR + THEIR + FEASTS + ARREST + AS + THE + FIRST + FATHERS + RESETTLE + THE + LAST + OF + THE + FIRE + HORSES + THE + LAST + TROLL + HARASSES + THE + FOREST + HEART + FREE + AT + LAST + OF + THE + LAST + TROLL + ALL + OFFER + THEIR + FIRE + HEAT + TO + THE + ASSISTERS + FAR + OFF + THE + TROLL + FASTS + ITS + LIFE + SHORTER + AS + STARS + RISE + THE + HORSES + REST + SAFE + AFTER + ALL + SHARE + HOT + FISH + AS + THEIR + AFFILIATES + TAILOR + A + ROOFS + FOR + THEIR + SAFE = FORTRESSES', 'expectedOutput' : '9874 + 1 + 5730 + 980305630 + 563 + 122 + 874963704 + 7 + 9022 + 1 + 9120 + 9819 + 512475704 + 794 + 97920 + 974 + 1 + 270 + 980 + 9120 + 65 + 980 + 2149 + 5730 + 863404 + 2190 + 15903 + 980 + 57349 + 5198034 + 5630400 + 980 + 8633634 + 980 + 2149 + 5300 + 93622 + 903375704 + 980 + 863404 + 65 + 5730 + 980 + 93622 + 30494 + 19 + 980 + 8620 + 65 + 264404 + 79 + 74 + 98030 + 9819 + 480 + 496304 + 36204 + 65 + 20198034 + 15903 + 480 + 419745704 + 803 + 8190 + 655 + 98640 + 50134 + 1 + 91490 + 37404 + 14 + 480 + 80134 + 980 + 20149 + 513 + 86340 + 98640 + 5149 + 863404 + 9819 + 57349 + 8013 + 980 + 93622 + 5200 + 655 + 96 + 980 + 563049 + 980 + 863404 + 9819 + 120394 + 31740 + 980 + 491304 + 65 + 980 + 698034 + 14 + 980 + 93622 + 1441724 + 19 + 980 + 96912 + 48759 + 803 + 90098 + 9013 + 8665 + 655 + 96346 + 14 + 980 + 2149 + 86340 + 56350794 + 794 + 2750 + 980 + 57349 + 5198034 + 8013 + 65 + 980 + 8633634 + 98073 + 50134 + 9819 + 980 + 57304 + 563 + 98073 + 501494 + 133049 + 14 + 980 + 57349 + 5198034 + 30409920 + 980 + 2149 + 65 + 980 + 5730 + 863404 + 980 + 2149 + 93622 + 81314404 + 980 + 563049 + 80139 + 5300 + 19 + 2149 + 65 + 980 + 2149 + 93622 + 122 + 65503 + 98073 + 5730 + 8019 + 96 + 980 + 144749034 + 513 + 655 + 980 + 93622 + 51494 + 794 + 2750 + 4863903 + 14 + 49134 + 3740 + 980 + 863404 + 3049 + 4150 + 15903 + 122 + 48130 + 869 + 5748 + 14 + 98073 + 1557271904 + 917263 + 1 + 36654 + 563 + 98073 + 4150 = 5639304404']},
      {'input' : ['THREE+THREE+ TWO+TWO+ ONE=ELEVEN'], 'expectedOutput' : '84611+84611+ 803+803+ 391=171219'},
      {'input' : ['LBRLQQR + LBBBESL + LBRERQR + LBBBEVR = BBEKVMGL'], 'expectedOutput' : '8308440 + 8333218 + 8302040 + 8333260 = 33276958'},
      {'input' : ['ZEROES + ONES = BINARY'], 'expectedOutput' : '698392 + 3192 = 701584'},
      {'input' : ['COUPLE + COUPLE = QUARTET'], 'expectedOutput' : '653924 + 653924 = 1307848'},
      {'input' : ['DO + YOU + FEEL = LUCKY'], 'expectedOutput' : '57 + 870 + 9441 = 10368'},
      {'input' : ['ELEVEN + NINE + FIVE + FIVE = THIRTY'], 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},
      {'input' : ['abcde * A = eeeeee'], 'expectedOutput' : '79365 * 7 = 555555'},
      {'input' : ['abcde * 7 = eeeeee'], 'expectedOutput' : ''},
      {'input' : ['A = A'], 'allSolutions': true, 'expectedOutput' : '1 = 1', 'expectedOutputCount' : 9},
      {'input' : ['A = A'], 'allSolutions': true, 'allowLeadingZeros': true, 'expectedOutput' : '0 = 0', 'expectedOutputCount' : 10},
      {'input' : ['a9bc - 4bdc = de5f'], 'expectedOutput' : '7982 - 4832 = 3150'},
      {'input' : ['7a12 + bcd = 7bd7'], 'expectedOutput' : '7012 + 345 = 7357'},

      {'input' : [
        'ABCB+DEAF=GFFB',
        'AEEF+AHG=AGIG',
        'EBB*AH=HGCF',
        'ABCB-AEEF=EBB',
        'DEAF/AHG=AH',
        'GFFB+AGIG=HGCF'],
        'expectedOutput' : '1696+2310=4006/n1330+154=1484/n366*15=5490/n1696-1330=366/n2310/154=15/n4006+1484=5490'
      },
      {'input' : [
        'GJ*DJ=LBAC',
        'BJKD+BCCK=DJKB',
        'BJLH-GF=BHJL',
        'BJKD-GJ=BJLH',
        'BCCK/DJ=GF',
        'DJKB-LBAC=BHJL'],
        'expectedOutput' : '57*37=2109/n1783+1998=3781/n1726-54=1672/n1783-57=1726/n1998/37=54/n3781-2109=1672'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('formulas: ${elem['input']}', () {
        var allSolutions = elem['allSolutions'] != null;
        var allowLeadingZeros = elem['allowLeadingZeros'] != null;
        var _actual = solveAlphametic(elem['input'] as List<String>, allSolutions, allowLeadingZeros);
        if (_actual != null) {
          var result = (_actual.solutions.isEmpty) ? _actual.error : _actual.equations.map((equation) => equation.getOutput(_actual.solutions.first)).join('/n');
          expect(result, elem['expectedOutput']);
          if (allSolutions) {
            expect(_actual.solutions.length, elem['expectedOutputCount']);
          }
        } else {
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });


}