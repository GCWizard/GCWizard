import 'dart:math';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/formula_solver/formula_parser.dart';
import 'package:gc_wizard/logic/tools/games/symbol_arithmetic/parser.dart';
import 'package:gc_wizard/persistence/formula_solver/model.dart';

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
        if (result.variables != null)
          out.putIfAbsent('variables', () => result.variables);

        return out;
      }).toList()
    };
  }

  group("SymbolArithmetic.solveSymbolArithmetic:", () {
    Map<String, String> values = {
      'A':'3', 'B':'20', 'C': '100', 'D': '5', 'E': 'Pi', 'F': '2 - 1', 'G': 'B - A + 1',
      'Q': '1', 'R': '0', 'S': '200', 'T': '20', 'U': '12', 'V': '9', 'W': '4', 'X': '30', 'Y':'4', 'Z': '50'
    };

    List<Map<String, dynamic>> _inputsToExpected = [
      {'formula' : null, 'values': null, 'expectedOutput' : {'state': 'error', 'output': [{'result': null, 'state': 'error'}]}},
      {'formula' : null, 'values': <String, String>{}, 'expectedOutput' : {'state': 'error', 'output': [{'result': null, 'state': 'error'}]}},
      {'formula' : null, 'expectedOutput' : {'state': 'error', 'output': [{'result': null, 'state': 'error'}]}},
      {'formula' : '', 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'formula' : ' ', 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'formula' : 'A', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'A', 'state': 'error'}]}},
      {'formula' : 'A', 'values': null, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'A', 'state': 'error'}]}},
      // {'formula' : '0', 'values': null, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}},
      // {'formula' : 'A', 'values': <String, String>{}, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'A', 'state': 'error'}]}},
      // {'formula' : '0', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}},
      //
      // {'formula' : 'A', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      // {'formula' : 'AB', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '320', 'state': 'ok'}]}},
      // {'formula' : 'A+B', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      // {'formula' : 'A + B', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      // {'formula' : '[A + B]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      // {'formula' : '[A] + [B]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3 + 20', 'state': 'ok'}]}},
      // {'formula' : 'AB + C', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '420', 'state': 'ok'}]}},
      // {'formula' : '(AB) + C', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '420', 'state': 'ok'}]}},
      // {'formula' : 'A(B + C)', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '3(20 + 100)', 'state': 'error'}]}},
      // {'formula' : '[A][(B + C)]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3120', 'state': 'ok'}]}},
      // {'formula' : 'A*(B + C)', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '360', 'state': 'ok'}]}},
      // {'formula' : '[]', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '[]', 'state': 'error'}]}},
      // {'formula' : '()', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '()', 'state': 'error'}]}},
      // {'formula' : '?!', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '?!', 'state': 'error'}]}},
      // {'formula' : 'A []', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '3 []', 'state': 'error'}]}},
      // {'formula' : 'N []', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'N []', 'state': 'error'}]}},
      // {'formula' : 'N', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'N', 'state': 'error'}]}},
      // {'formula' : 'E', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      // {'formula' : 'e', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      // {'formula' : 'Pi', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      // {'formula' : 'pi', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      // {'formula' : 'pi * A', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '9.424777960769', 'state': 'ok'}]}},
      // {'formula' : 'E * PI', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '9.869604401089', 'state': 'ok'}]}},
      // {'formula' : 'E [PI]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': 'E 3.14159265359', 'state': 'ok'}]}},
      // {'formula' : '[A*B*2].[C+d+D];', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '120.110;', 'state': 'ok'}]}},
      // {'formula' : 'N 52 [QR].[S+T*U*2] E 12 [V*W].[XY + Z]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': 'N 52 10.680 E 12 36.354', 'state': 'ok'}]}},
      // {'formula' : 'N 42 [A].[AB0] E 13 [BB].[(A+B)*100]', 'values': {'A': '1'}, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'N 42 1.[1B0] E 13 [BB].[(1+B)*100]', 'state': 'error'}]}},
      //
      // //Trim empty space
      // {'formula' : 'sin(0) ', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}}, //Not working because S in Values and so the s of sin will be replaced
      //
      // //math library testing
      // {'formula' : '36^(1:2)', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '6', 'state': 'ok'}]}},
      // {'formula' : 'phi × 2', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.2360679775', 'state': 'ok'}]}},
      // {'formula' : 'log(100,10)', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.5', 'state': 'ok'}]}},
      // {'formula' : 'log(10,100)', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      // {'formula' : 'pi', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      // {'formula' : '\u1D28 * \u03A0', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '9.869604401089', 'state': 'ok'}]}},
      // {'formula' : '\u03a6 * \u03c6 + 1', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.61803398875', 'state': 'ok'}]}},
      // {'formula' : 'A + 1', 'values': {'A': '\u03a6'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2.61803398875', 'state': 'ok'}]}},
      //
      // //Referencing values
      // {'formula' : 'F', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      // {'formula' : 'G', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '18', 'state': 'ok'}]}},
      // {'formula' : '[G] + [F]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '18 + 1', 'state': 'ok'}]}},
      // {'formula' : '[G + F]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '19', 'state': 'ok'}]}},
      //
      // // special characters
      // {'formula' : 'A\u0009+\u00A0B', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},

    ];

    _inputsToExpected.forEach((elem) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        var _actual = solveSymbolArithmetic(elem['formula'], elem['values']);
        expect(_actual, elem['expectedOutput']);

        // if (elem['values'] == null) {
        //   var _actual = FormulaParser().parse(elem['formula'], null);
        //   expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
        // } else {
        //   var values = <FormulaValue>[];
        //   elem['values'].entries.forEach((value) {
        //     values.add(FormulaValue(value.key, value.value));
        //   });
        //   var _actual = FormulaParser().parse(elem['formula'], values);
        //   expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
        // }
      });
    });
  });

}