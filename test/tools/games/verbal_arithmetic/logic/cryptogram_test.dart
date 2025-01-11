import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/alphametics_.dart';

void main() {
  _formulaStateToString(FormulaState state) {
    switch (state) {
      case FormulaState.STATE_SINGLE_ERROR: return 'error';
      case FormulaState.STATE_EXPANDED_OK: return 'expanded_ok';
      case FormulaState.STATE_EXPANDED_ERROR: return 'expanded_error';
      case FormulaState.STATE_SINGLE_OK: return 'ok';
      case FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE: return 'expanded_exceededrange';
    }
  }

  _formulaSolverOutputToMap(FormulaSolverOutput output) {
    return {
      'state': _formulaStateToString(output.state),
      'output': output.results.map((result) {
        var out = <String, dynamic>{
          'result': result.result,
          'state': _formulaStateToString(result.state)
        };
        if (result.variables != null) {
          out.putIfAbsent('variables', () => result.variables);
        }

        return out;
      }).toList()
    };
  }

  group("Alphametics.solve:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      // {'input' : '', 'expectedOutput' : ''},
      // {'input' : ' ', 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'input' : 'BASE + BALL = GAMES', 'expectedOutput' : '7483 + 7455 = 14938'},
      // {'input' : 'BIG + CAT = LION', 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},
      // {'input' : 'ELEVEN + NINE + FIVE + FIVE = THIRTY', 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},
      // {'input' : 'SEND+MORE=MONEY', 'expectedOutput' : '9567+1085=10652'},
      // {'input' : 'THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE + TIS + A + LIE + THE + TALE + OF + THE + LAST + FIRE + HORSES + LATE + AFTER + THE + FIRST + FATHERS + FORESEE + THE + HORRORS + THE + LAST + FREE + TROLL + TERRIFIES + THE + HORSES + OF + FIRE + THE + TROLL + RESTS + AT + THE + HOLE + OF + LOSSES + IT + IS + THERE + THAT + SHE + STORES + ROLES + OF + LEATHERS + AFTER + SHE + SATISFIES + HER + HATE + OFF + THOSE + FEARS + A + TASTE + RISES + AS + SHE + HEARS + THE + LEAST + FAR + HORSE + THOSE + FAST + HORSES + THAT + FIRST + HEAR + THE + TROLL + FLEE + OFF + TO + THE + FOREST + THE + HORSES + THAT + ALERTS + RAISE + THE + STARES + OF + THE + OTHERS + AS + THE + TROLL + ASSAILS + AT + THE + TOTAL + SHIFT + HER + TEETH + TEAR + HOOF + OFF + TORSO + AS + THE + LAST + HORSE + FORFEITS + ITS + LIFE + THE + FIRST + FATHERS + HEAR + OF + THE + HORRORS + THEIR + FEARS + THAT + THE + FIRES + FOR + THEIR + FEASTS + ARREST + AS + THE + FIRST + FATHERS + RESETTLE + THE + LAST + OF + THE + FIRE + HORSES + THE + LAST + TROLL + HARASSES + THE + FOREST + HEART + FREE + AT + LAST + OF + THE + LAST + TROLL + ALL + OFFER + THEIR + FIRE + HEAT + TO + THE + ASSISTERS + FAR + OFF + THE + TROLL + FASTS + ITS + LIFE + SHORTER + AS + STARS + RISE + THE + HORSES + REST + SAFE + AFTER + ALL + SHARE + HOT + FISH + AS + THEIR + AFFILIATES + TAILOR + A + ROOFS + FOR + THEIR + SAFE = FORTRESSES', 'expectedOutput' : '9874 + 1 + 5730 + 980305630 + 563 + 122 + 874963704 + 7 + 9022 + 1 + 9120 + 9819 + 512475704 + 794 + 97920 + 974 + 1 + 270 + 980 + 9120 + 65 + 980 + 2149 + 5730 + 863404 + 2190 + 15903 + 980 + 57349 + 5198034 + 5630400 + 980 + 8633634 + 980 + 2149 + 5300 + 93622 + 903375704 + 980 + 863404 + 65 + 5730 + 980 + 93622 + 30494 + 19 + 980 + 8620 + 65 + 264404 + 79 + 74 + 98030 + 9819 + 480 + 496304 + 36204 + 65 + 20198034 + 15903 + 480 + 419745704 + 803 + 8190 + 655 + 98640 + 50134 + 1 + 91490 + 37404 + 14 + 480 + 80134 + 980 + 20149 + 513 + 86340 + 98640 + 5149 + 863404 + 9819 + 57349 + 8013 + 980 + 93622 + 5200 + 655 + 96 + 980 + 563049 + 980 + 863404 + 9819 + 120394 + 31740 + 980 + 491304 + 65 + 980 + 698034 + 14 + 980 + 93622 + 1441724 + 19 + 980 + 96912 + 48759 + 803 + 90098 + 9013 + 8665 + 655 + 96346 + 14 + 980 + 2149 + 86340 + 56350794 + 794 + 2750 + 980 + 57349 + 5198034 + 8013 + 65 + 980 + 8633634 + 98073 + 50134 + 9819 + 980 + 57304 + 563 + 98073 + 501494 + 133049 + 14 + 980 + 57349 + 5198034 + 30409920 + 980 + 2149 + 65 + 980 + 5730 + 863404 + 980 + 2149 + 93622 + 81314404 + 980 + 563049 + 80139 + 5300 + 19 + 2149 + 65 + 980 + 2149 + 93622 + 122 + 65503 + 98073 + 5730 + 8019 + 96 + 980 + 144749034 + 513 + 655 + 980 + 93622 + 51494 + 794 + 2750 + 4863903 + 14 + 49134 + 3740 + 980 + 863404 + 3049 + 4150 + 15903 + 122 + 48130 + 869 + 5748 + 14 + 98073 + 1557271904 + 917263 + 1 + 36654 + 563 + 98073 + 4150 = 5639304404'},
      // {'input' : 'THREE+THREE+ TWO+TWO+ ONE=ELEVEN', 'expectedOutput' : '84611+84611+ 803+803+ 391=171219'},
      // {'input' : '8308440 + 8333218 + 8302040 + 8333260 = 33276958', 'expectedOutput' : 'LBRLQQR + LBBBESL + LBRERQR + LBBBEVR = BBEKVMGL'},
      // {'input' : 'ZEROES + ONES = BINARY', 'expectedOutput' : '698392 + 3192 = 701584'},
      // {'input' : 'COUPLE + COUPLE = QUARTET', 'expectedOutput' : '653924 + 653924 = 1307848'},
      // {'input' : 'DO + YOU + FEEL = LUCKY', 'expectedOutput' : '57 + 870 + 9441 = 10368'},
      // {'input' : 'ELEVEN + NINE + FIVE + FIVE = THIRTY', 'expectedOutput' : '797275 + 5057 + 4027 + 4027 = 810386'},
    ];

    _inputsToExpected.forEach((elem) {
      test('formulas: ${elem['input']}', () {
        var _actual = getOutput(elem['input'] as String, Solve(elem['input'] as String));
        expect(_actual, elem['expectedOutput']);
      });
    });
  });


  group("SymbolArithmetic.solveSymbolArithmetic:", () {
    Map<String, String> values = {
      'A':'3', 'B':'20', 'C': '100', 'D': '5', 'E': '1-3'
    };
    Map<String, String> values1 = {
      'baum':'0-100', 'schneemann':'0-100', 'stern': '0-100', 'schlitten': '0-100', 'weihnachtsmann': '0-100', 'glocken': '0-100'
    };
    Map<String, String> values2 = {
      'mutze':'0-100', 'glocken':'0-100', 'stern': '0-100', 'kugel': '0-100', 'baum': '0-100', 'kerze': '0-100'
    };
    Map<String, String> values3 = {
      'schnee':'0-100', 'mann':'0-100', 'schleife': '0-100', 'baum': '0-100'
    };

    List<Map<String, dynamic>> _inputsToExpected = [
      // {'formulas' : null, 'values': null, 'expectedOutput' : {'state': 'error', 'output': [{'result': null, 'state': 'error'}]}},
      // {'formulas' : null, 'values': <String, String>{}, 'expectedOutput' : {'state': 'error', 'output': [{'result': null, 'state': 'error'}]}},
      // {'formulas' : null, 'expectedOutput' : {'state': 'error', 'output': [{'result': null, 'state': 'error'}]}},
      // {'formulas' : {''}.toList(), 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      // {'formulas' : {' '}.toList(), 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'formulas' : {'E-(2)'}.toList(), 'values': values, 'expectedOutput' : {'state': 'ok', 'variables': -1.0}},
      {'formulas' : {'E'}.toList(), 'values': values, 'expectedOutput' : {'state': 'ok', 'variables': 1.0}},
      {'formulas' : {'baum*schneemann+stern-schlitten*baum-glocken-(41)',
        'glocken+weihnachtsmann*stern+schneemann+stern+weihnachtsmann-(26)',
        'stern+glocken*stern-glocken*glocken+stern-(24)',
        'schneemann+baum*stern+stern*baum-schlitten-(65)',
        'glocken-schlitten+stern*baum+baum-stern-(27)',
        'schneemann*stern+stern-weihnachtsmann+glocken*baum-(77)',
        'baum*glocken+stern*schneemann-glocken*schneemann-(53)',
        'schneemann+weihnachtsmann*glocken*baum-schlitten+stern-(24)',
        'stern+stern*stern+stern*stern-stern-(98)',
        'schlitten*schneemann+glocken+stern*baum+weihnachtsmann-(31)',
        'baum+stern*glocken+baum*baum-glocken-(32)',
        'glocken*weihnachtsmann+stern-schlitten+stern*baum-(37)'}.toList(), 'values': values1, 'expectedOutput' : {'state': 'ok',
        'variables': '{{baum: 4}{schneemann: 9}{stern: 7}{schlitten: 0}{weihnachtsmann: 1}{glocken: 2}}'}},

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
        'kugel+kugel+kugel+kugel+kugel+kugel-(48)'}.toList(), 'values': values2, 'expectedOutput' : {'state': 'ok',
        'variables': '{{mutze: 4}{glocken: 16}{stern: 1}{kugel: 8}{baum: 12}{kerze: 19}}'}},

      {'formulas' : {'schnee*mann-(1428)',
        'schleife-baum-(12)',
        'schnee*schleife-(840)',
        'mann-baum-(33)'}.toList(), 'values': values3, 'expectedOutput' : {'state': 'ok',
        'variables': '{{schnee: 21}{mann: 68}{schleife: 40}}'}},
    ];

    for (var elem in _inputsToExpected) {
      test('formulas: ${elem['formula']}, values: ${elem['values']}', () {
        var _actual = solveSymbolArithmetic(elem['formulas'] as List<String>, elem['values'] as Map<String, String>);
        expect(_actual, elem['expectedOutput']);

      });
    }
  });

}