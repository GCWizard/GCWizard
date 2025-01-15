import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametic.dart';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/helper.dart';

void main() {

  group("Alphametics.solve:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      // {'input' : '', 'expectedOutput' : ''},
      // {'input' : ' ', 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'input' : 'BASE + BALL = GAMES', 'expectedOutput' : '7483 + 7455 = 14938'},
      // {'input' : 'BIG + CAT = LION', 'expectedOutput' : '204 + 859 = 1063'}, //mehrere Lösungen '324 + 956 = 1280', ..
      // {'input' : 'ELEVEN + NINE + FIVE + FIVE = THIRTY', 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},
      // {'input' : 'SEND+MORE=MONEY', 'expectedOutput' : '9567+1085=10652'},
      // {'input' : 'THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE + TIS + A + LIE + THE + TALE + OF + THE + LAST + FIRE + HORSES + LATE + AFTER + THE + FIRST + FATHERS + FORESEE + THE + HORRORS + THE + LAST + FREE + TROLL + TERRIFIES + THE + HORSES + OF + FIRE + THE + TROLL + RESTS + AT + THE + HOLE + OF + LOSSES + IT + IS + THERE + THAT + SHE + STORES + ROLES + OF + LEATHERS + AFTER + SHE + SATISFIES + HER + HATE + OFF + THOSE + FEARS + A + TASTE + RISES + AS + SHE + HEARS + THE + LEAST + FAR + HORSE + THOSE + FAST + HORSES + THAT + FIRST + HEAR + THE + TROLL + FLEE + OFF + TO + THE + FOREST + THE + HORSES + THAT + ALERTS + RAISE + THE + STARES + OF + THE + OTHERS + AS + THE + TROLL + ASSAILS + AT + THE + TOTAL + SHIFT + HER + TEETH + TEAR + HOOF + OFF + TORSO + AS + THE + LAST + HORSE + FORFEITS + ITS + LIFE + THE + FIRST + FATHERS + HEAR + OF + THE + HORRORS + THEIR + FEARS + THAT + THE + FIRES + FOR + THEIR + FEASTS + ARREST + AS + THE + FIRST + FATHERS + RESETTLE + THE + LAST + OF + THE + FIRE + HORSES + THE + LAST + TROLL + HARASSES + THE + FOREST + HEART + FREE + AT + LAST + OF + THE + LAST + TROLL + ALL + OFFER + THEIR + FIRE + HEAT + TO + THE + ASSISTERS + FAR + OFF + THE + TROLL + FASTS + ITS + LIFE + SHORTER + AS + STARS + RISE + THE + HORSES + REST + SAFE + AFTER + ALL + SHARE + HOT + FISH + AS + THEIR + AFFILIATES + TAILOR + A + ROOFS + FOR + THEIR + SAFE = FORTRESSES', 'expectedOutput' : '9874 + 1 + 5730 + 980305630 + 563 + 122 + 874963704 + 7 + 9022 + 1 + 9120 + 9819 + 512475704 + 794 + 97920 + 974 + 1 + 270 + 980 + 9120 + 65 + 980 + 2149 + 5730 + 863404 + 2190 + 15903 + 980 + 57349 + 5198034 + 5630400 + 980 + 8633634 + 980 + 2149 + 5300 + 93622 + 903375704 + 980 + 863404 + 65 + 5730 + 980 + 93622 + 30494 + 19 + 980 + 8620 + 65 + 264404 + 79 + 74 + 98030 + 9819 + 480 + 496304 + 36204 + 65 + 20198034 + 15903 + 480 + 419745704 + 803 + 8190 + 655 + 98640 + 50134 + 1 + 91490 + 37404 + 14 + 480 + 80134 + 980 + 20149 + 513 + 86340 + 98640 + 5149 + 863404 + 9819 + 57349 + 8013 + 980 + 93622 + 5200 + 655 + 96 + 980 + 563049 + 980 + 863404 + 9819 + 120394 + 31740 + 980 + 491304 + 65 + 980 + 698034 + 14 + 980 + 93622 + 1441724 + 19 + 980 + 96912 + 48759 + 803 + 90098 + 9013 + 8665 + 655 + 96346 + 14 + 980 + 2149 + 86340 + 56350794 + 794 + 2750 + 980 + 57349 + 5198034 + 8013 + 65 + 980 + 8633634 + 98073 + 50134 + 9819 + 980 + 57304 + 563 + 98073 + 501494 + 133049 + 14 + 980 + 57349 + 5198034 + 30409920 + 980 + 2149 + 65 + 980 + 5730 + 863404 + 980 + 2149 + 93622 + 81314404 + 980 + 563049 + 80139 + 5300 + 19 + 2149 + 65 + 980 + 2149 + 93622 + 122 + 65503 + 98073 + 5730 + 8019 + 96 + 980 + 144749034 + 513 + 655 + 980 + 93622 + 51494 + 794 + 2750 + 4863903 + 14 + 49134 + 3740 + 980 + 863404 + 3049 + 4150 + 15903 + 122 + 48130 + 869 + 5748 + 14 + 98073 + 1557271904 + 917263 + 1 + 36654 + 563 + 98073 + 4150 = 5639304404'},
      // {'input' : 'THREE+THREE+ TWO+TWO+ ONE=ELEVEN', 'expectedOutput' : '84611+84611+ 803+803+ 391=171219'},
      // {'input' : 'LBRLQQR + LBBBESL + LBRERQR + LBBBEVR = BBEKVMGL', 'expectedOutput' : '8308440 + 8333218 + 8302040 + 8333260 = 33276958'},
      // {'input' : 'ZEROES + ONES = BINARY', 'expectedOutput' : '698392 + 3192 = 701584'},
      // {'input' : 'COUPLE + COUPLE = QUARTET', 'expectedOutput' : '653924 + 653924 = 1307848'},
      // {'input' : 'DO + YOU + FEEL = LUCKY', 'expectedOutput' : '57 + 870 + 9441 = 10368'},
      // {'input' : 'ELEVEN + NINE + FIVE + FIVE = THIRTY', 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},

      {'input' : 'A + B = 99', 'expectedOutput' : null},
    ];

    _inputsToExpected.forEach((elem) {
      test('formulas: ${elem['input']}', () {
 var equation = Formula(elem['input'] as String);
// var values = PossibleValues.initPossibleValues(equation.usedMembers, true);
//
// removeLeadingZero([equation], values);
//
//         var _actual = values.getOutput(equation.formula, Alphametics01.solve(equation, values)!.first);
//         var equation = Formula(elem['input'] as String);
        var _actual = solveAlphametic(elem['input'] as String);
        if (_actual != null) {
          var result = _actual.formulas.first.getOutput(_actual.solutions!);
          expect(result, elem['expectedOutput']);
        } else {
          expect(_actual, elem['expectedOutput']);
        }


      });
    });
  });


}