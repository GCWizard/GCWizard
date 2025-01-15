import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/cryptogram.dart';

void main() {
  // _formulaStateToString(FormulaState state) {
  //   switch (state) {
  //     case FormulaState.STATE_SINGLE_ERROR: return 'error';
  //     case FormulaState.STATE_EXPANDED_OK: return 'expanded_ok';
  //     case FormulaState.STATE_EXPANDED_ERROR: return 'expanded_error';
  //     case FormulaState.STATE_SINGLE_OK: return 'ok';
  //     case FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE: return 'expanded_exceededrange';
  //   }
  // }

  // _formulaSolverOutputToMap(FormulaSolverOutput output) {
  //   return {
  //     'state': _formulaStateToString(output.state),
  //     'output': output.results.map((result) {
  //       var out = <String, dynamic>{
  //         'result': result.result,
  //         'state': _formulaStateToString(result.state)
  //       };
  //       if (result.variables != null) {
  //         out.putIfAbsent('variables', () => result.variables);
  //       }
  //
  //       return out;
  //     }).toList()
  //   };
  // }

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
        var _actual = solveCryptogram(elem['formulas'] as List<String>); //, elem['values'] as Map<String, String>
        expect(_actual!.solutions, elem['expectedOutput']);

      });
    }
  });

}