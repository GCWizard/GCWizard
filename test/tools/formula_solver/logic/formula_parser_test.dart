import 'dart:math';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';

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

  group("FormulaParser.parse:", () {
    Map<String, String> values = {
      'A':'3', 'B':'20', 'C': '100', 'D': '5', 'E': 'Pi', 'F': '2 - 1', 'G': 'B - A + 1',
      'Q': '1', 'R': '0', 'S': '200', 'T': '20', 'U': '12', 'V': '9', 'W': '4', 'X': '30', 'Y':'4', 'Z': '50'
    };

    List<Map<String, Object?>> _inputsToExpected = [
      {'formula' : '', 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'formula' : ' ', 'expectedOutput' : {'state': 'error', 'output': [{'result': '', 'state': 'error'}]}},
      {'formula' : 'A', 'values': <String, String>{}, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'A', 'state': 'error'}]}},
      {'formula' : '0', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}},

      {'formula' : 'A', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'AB', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '320', 'state': 'ok'}]}},
      {'formula' : 'A+B', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      {'formula' : 'A + B', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      {'formula' : '[A + B]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      {'formula' : '[A] + [B]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3 + 20', 'state': 'ok'}]}},
      {'formula' : 'AB + C', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '420', 'state': 'ok'}]}},
      {'formula' : '(AB) + C', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '420', 'state': 'ok'}]}},
      {'formula' : 'A(B + C)', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '3(20 + 100)', 'state': 'error'}]}},
      {'formula' : '[A][(B + C)]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3120', 'state': 'ok'}]}},
      {'formula' : 'A*(B + C)', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '360', 'state': 'ok'}]}},
      {'formula' : '[]', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '[]', 'state': 'error'}]}},
      {'formula' : '()', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '()', 'state': 'error'}]}},
      {'formula' : '?!', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '?!', 'state': 'error'}]}},
      {'formula' : 'A []', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': '3 []', 'state': 'error'}]}},
      {'formula' : 'N []', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'N []', 'state': 'error'}]}},
      {'formula' : 'N', 'values': values, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'N', 'state': 'error'}]}},
      {'formula' : 'E', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      {'formula' : 'e', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      {'formula' : 'Pi', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      {'formula' : 'pi', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      {'formula' : 'pi * A', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '9.424777960769', 'state': 'ok'}]}},
      {'formula' : 'E * PI', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '9.869604401089', 'state': 'ok'}]}},
      {'formula' : 'E [PI]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': 'E 3.14159265359', 'state': 'ok'}]}},
      {'formula' : '[A*B*2].[C+d+D];', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '120.110;', 'state': 'ok'}]}},
      {'formula' : 'N 52 [QR].[S+T*U*2] E 12 [V*W].[XY + Z]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': 'N 52 10.680 E 12 36.354', 'state': 'ok'}]}},
      {'formula' : 'N 42 [A].[AB0] E 13 [BB].[(A+B)*100]', 'values': {'A': '1'}, 'expectedOutput' : {'state': 'error', 'output': [{'result': 'N 42 1.[1B0] E 13 [BB].[(1+B)*100]', 'state': 'error'}]}},

      //Trim empty space
      {'formula' : 'sin(0) ', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}}, //Not working because S in Values and so the s of sin will be replaced

      //math library testing
      {'formula' : '36^(1:2)', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '6', 'state': 'ok'}]}},
      {'formula' : 'phi × 2', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.2360679775', 'state': 'ok'}]}},
      {'formula' : 'log(100,10)', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.5', 'state': 'ok'}]}},
      {'formula' : 'log(10,100)', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'pi', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.14159265359', 'state': 'ok'}]}},
      {'formula' : '\u1D28 * \u03A0', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '9.869604401089', 'state': 'ok'}]}},
      {'formula' : '\u03a6 * \u03c6 + 1', 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3.61803398875', 'state': 'ok'}]}},
      {'formula' : 'A + 1', 'values': {'A': '\u03a6'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2.61803398875', 'state': 'ok'}]}},

      //Referencing values
      {'formula' : 'F', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      {'formula' : 'G', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '18', 'state': 'ok'}]}},
      {'formula' : '[G] + [F]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '18 + 1', 'state': 'ok'}]}},
      {'formula' : '[G + F]', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '19', 'state': 'ok'}]}},

      // special characters
      {'formula' : 'A\u0009+\u00A0B', 'values': values, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},

    ];

    for (var elem in _inputsToExpected) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        if (elem['values'] == null) {
          var _actual = FormulaParser().parse(elem['formula'] as String, []);
          expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
        } else {
          var values = <FormulaValue>[];
          for (var value in (elem['values'] as Map<String, String>).entries) {
            values.add(FormulaValue(value.key, value.value));
          }
          var _actual = FormulaParser().parse(elem['formula'] as String, values);
          expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
        }
      });
    }
  });

  group("FormulaParser.parse - Functionnames contain variables:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'formula' : 'sin(i)', 'values': <String, String>{'i': '${pi/2}'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      {'formula' : 'SIN (i)', 'values': <String, String>{'i': '${pi/2}'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      {'formula' : 'sin  (I)', 'values': <String, String>{'i': '${pi/2}'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},

      {'formula' : 'A + sin  (I)', 'values': <String, String>{'a': '2', 'i': '${pi/2}'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : '2 + sin  (I)', 'values': <String, String>{'a': '2', 'i': '${pi/2}'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : '2 + sin  (I) + S', 'values': <String, String>{'i': '${pi/2}'}, 'expectedOutput' : {'state': 'error', 'output': [{'result': '2 + sin  (1.5707963267948966) + S', 'state': 'error'}]}},
      {'formula' : '2 + sin  (I) + S', 'values': <String, String>{'s': '2', 'i': '${pi/2}'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '5', 'state': 'ok'}]}},

      {'formula' : 'sin(sqrt2)', 'values': <String, String>{'s': '3'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.987765945993', 'state': 'ok'}]}},
      {'formula' : 'sin(pi)', 'values': <String, String>{'s': '3'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}},
      {'formula' : 'e(e)', 'values': <String, String>{'e': '2'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '7.389056098931', 'state': 'ok'}]}},

      {'formula' : 'arcsin(0.2) + sin(2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1.110655347616', 'state': 'ok'}]}},
      {'formula' : 'sin(2) + arcsin(0.2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1.110655347616', 'state': 'ok'}]}},
      {'formula' : 'arcsin(sin(0.2))', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.2', 'state': 'ok'}]}},
      {'formula' : 'sin(arcsin(0.2))', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.2', 'state': 'ok'}]}},
      {'formula' : 'sin(arcsin(0.2))', 'values': <String, String>{'sin': '0.1'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.2', 'state': 'ok'}]}},
      {'formula' : 'sin(arcsin(sin))', 'values': <String, String>{'sin': '0.1'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.1', 'state': 'ok'}]}},

      {'formula' : 'sindeg(90)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      {'formula' : 'sinDeg(90)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      {'formula' : 'SINDEG(90)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
      {'formula' : 'round(1.257, 2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1.26', 'state': 'ok'}]}},
      {'formula' : 'csi(99,88)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '7', 'state': 'ok'}]}},
      {'formula' : 'csi(99) + csi(88)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '16', 'state': 'ok'}]}},
      {'formula' : 'cs(cs(455))', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '5', 'state': 'ok'}]}},
      {'formula' : 'round(round(4.555, 2), 3)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '4.56', 'state': 'ok'}]}},
      {'formula' : 'nth(42,2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'nth(1234,2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'nth(1234,2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'nth(1234,2,3)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '23', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.,2)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.,2,6)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '234', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.1,2,6)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '234.1', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.1,5,6)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0.1', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.1,5)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.1,5,5)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '0', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.1,-1,5)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1234', 'state': 'ok'}]}},
      {'formula' : 'nth(1234.1, 4, -1)', 'values': <String, String>{}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '4', 'state': 'ok'}]}},
      {'formula' : 'A + nth  (1234.  , cs (  11  ))', 'values': <String, String>{'a': '2000'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2002', 'state': 'ok'}]}},
    ];

    for (var elem in _inputsToExpected) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        var values = <FormulaValue>[];
        for (var value in (elem['values'] as Map<String, String>).entries) {
          values.add(FormulaValue(value.key, value.value));
        }
        var _actual = FormulaParser().parse(elem['formula'] as String, values);
        expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
      });
    }
  });

  group("FormulaParser.parse - Variables contain Functions:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'formula' : 'A', 'values': {'A': '1 + 2'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'B', 'values': {'A': '1', 'B': 'A + 1'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'B', 'values': {'B': 'A + 1', 'A': '1'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2', 'state': 'ok'}]}},
      {'formula' : 'A', 'values': {'A': 'cs(12)'}, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'D', 'values': [
          FormulaValue('C', '1', type: FormulaValueType.FIXED),
          FormulaValue('D', 'cs(12)', type: FormulaValueType.FIXED),
        ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'D', 'values': [
        FormulaValue('D', 'cs(12)', type: FormulaValueType.FIXED),
        FormulaValue('C', '1', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'D', 'values': [
        FormulaValue('A', '12', type: FormulaValueType.FIXED),
        FormulaValue('C', '1', type: FormulaValueType.FIXED),
        FormulaValue('D', 'cs(A)', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'cs(D) + sqrt(a)', 'values': [
        FormulaValue('A', '400', type: FormulaValueType.FIXED),
        FormulaValue('D', 'sqrt(A)', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '22', 'state': 'ok'}]}},
      {'formula' : 'sqrt(D)', 'values': [
        FormulaValue('A', '400', type: FormulaValueType.FIXED),
        FormulaValue('D', 'sqrt(cs(A))', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1.414213562373', 'state': 'ok'}]}},
      {'formula' : 'sqrt(D)', 'values': [
        FormulaValue('A', 'ABC', type: FormulaValueType.TEXT),
        FormulaValue('D', 'cs(bww(A))', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '2.449489742783', 'state': 'ok'}]}},
      {'formula' : 'sqrt(D)', 'values': [
        FormulaValue('A', 'sqrt(121)', type: FormulaValueType.FIXED),
        FormulaValue('D', 'cs(A)', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1.414213562373', 'state': 'ok'}]}},
    ];

    for (var elem in _inputsToExpected) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        var values = <FormulaValue>[];
        if (elem['values'] is List<FormulaValue>) {
          values = elem['values'] as List<FormulaValue>;
        } else {
          for (var value in (elem['values'] as Map<String, String>).entries) {
            values.add(FormulaValue(value.key, value.value));
          }
        }
        var _actual = FormulaParser().parse(elem['formula'] as String, values);
        expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
      });
    }
  });

  group("FormulaParser.parse - String functions:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'formula' : 'bww(ABCD)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '10', 'state': 'ok'}]}},
      {'formula' : 'bww(AB,CD)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '10', 'state': 'ok'}]}},
      {'formula' : 'bww(123)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '6', 'state': 'ok'}]}},
      {'formula' : 'bww(AB)C)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'error', 'output': [{'result': 'bww(AB)C)', 'state': 'error'}]}},
      {'formula' : 'bww(1-3#2,7)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '13', 'state': 'ok'}]}},
      {'formula' : 'bww(A)', 'values': [FormulaValue('A', 'ABC', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '6', 'state': 'ok'}]}},
      {'formula' : 'bww(A) + bww(A)', 'values': [FormulaValue('A', 'ABC', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '12', 'state': 'ok'}]}},
      {'formula' : '1+ BWW(A) + cs(12) + bww(A) * 2', 'values': [FormulaValue('A', 'ABC', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '22', 'state': 'ok'}]}},
      {'formula' : 'bWw(c)', 'values': [
          FormulaValue('A', '1-3', type: FormulaValueType.FIXED),
          FormulaValue('B', '1-3', type: FormulaValueType.INTERPOLATED),
          FormulaValue('C', '1-3', type: FormulaValueType.TEXT),
        ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '4', 'state': 'ok', 'variables': {'B': '1'}}]}
      },

      // ABCD incl. variable A = ABC; so ABCD will be converted to ABCBCD
      {'formula' : '1+ bww(A) + cs(12) + bww(ABCD) * 2', 'values': [FormulaValue('A', 'ABC', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '40', 'state': 'ok'}]}},

      {'formula' : 'len(ABC)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'len(ABC)', 'values': [FormulaValue('A', 'ABC', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '5', 'state': 'ok'}]}},
      {'formula' : 'len(A,B,C)', 'values': [FormulaValue('A', 'ABC', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '7', 'state': 'ok'}]}},

      {'formula' : 'len(ABC) * bww(55)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '30', 'state': 'ok'}]}},
      {'formula' : 'cs(bww(ABCDE)) * len(55)', 'values': <FormulaValue>[], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '12', 'state': 'ok'}]}},

      {'formula' : 'bww(A)', 'values': [FormulaValue('A', '', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'error', 'output': [{'result': 'bww()', 'state': 'error'}]}},
      {'formula' : 'bww(AB)', 'values': [FormulaValue('A', '', type: FormulaValueType.TEXT), FormulaValue('B', 'C', type: FormulaValueType.TEXT),], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '3', 'state': 'ok'}]}},
      {'formula' : 'len(A)', 'values': [FormulaValue('A', '', type: FormulaValueType.TEXT)], 'expectedOutput' : {'state': 'error', 'output': [{'result': 'len()', 'state': 'error'}]}},
      {'formula' : 'len(AB)', 'values': [FormulaValue('A', '', type: FormulaValueType.TEXT), FormulaValue('B', 'C', type: FormulaValueType.TEXT),], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok'}]}},
    ];

    for (var elem in _inputsToExpected) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        var _actual = FormulaParser().parse(elem['formula'] as String, elem['values'] as List<FormulaValue>);
        expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
      });
    }
  });

  group("FormulaParser.parse - Expanded functions:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'formula' : 'A', 'values': [FormulaValue('A', '1', type: FormulaValueType.INTERPOLATED)], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '1', 'state': 'ok', 'variables': {'A': '1'}}]}},
      {'formula' : 'A', 'values': [FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED)], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': '1', 'variables': {'A': '1'}, 'state': 'ok'},
        {'result': '2', 'variables': {'A': '2'}, 'state': 'ok'},
        {'result': '3', 'variables': {'A': '3'}, 'state': 'ok'}
      ]}},
      {'formula' : 'A', 'values': [FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED)], 'expandValues': false, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '-2', 'state': 'ok'}]}},

      {'formula' : 'AB', 'values': [
        FormulaValue('A', '1', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '11', 'state': 'ok', 'variables': {'A': '1'}}]}},

      {'formula' : 'AB', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': '11', 'variables': {'A': '1'}, 'state': 'ok'},
        {'result': '21', 'variables': {'A': '2'}, 'state': 'ok'},
        {'result': '31', 'variables': {'A': '3'}, 'state': 'ok'}
      ]}},

      {'formula' : 'A+B', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.FIXED),
      ], 'expandValues': false, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '-1', 'state': 'ok'}]}},

      {'formula' : 'AB', 'values': [
        FormulaValue('A', '1', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.INTERPOLATED),
      ], 'expectedOutput' : {'state': 'ok', 'output': [{'result': '11', 'state': 'ok', 'variables': {'A': '1', 'B': '1'}}]}},

      {'formula' : 'AB', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.INTERPOLATED),
      ], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': '11', 'variables': {'A': '1', 'B': '1'}, 'state': 'ok'},
        {'result': '21', 'variables': {'A': '2', 'B': '1'}, 'state': 'ok'},
        {'result': '31', 'variables': {'A': '3', 'B': '1'}, 'state': 'ok'}
      ]}},

      {'formula' : 'A+B', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.INTERPOLATED),
      ], 'expandValues': false, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '-1', 'state': 'ok'}]}},

      {'formula' : 'AB', 'values': [
        FormulaValue('A', '1', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1,4-8#2', type: FormulaValueType.INTERPOLATED),
      ], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': '11', 'variables': {'A': '1', 'B': '1'}, 'state': 'ok'},
        {'result': '14', 'variables': {'A': '1', 'B': '4'}, 'state': 'ok'},
        {'result': '16', 'variables': {'A': '1', 'B': '6'}, 'state': 'ok'},
        {'result': '18', 'variables': {'A': '1', 'B': '8'}, 'state': 'ok'},
      ]}},

      {'formula' : 'AB', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1,4-8#2', type: FormulaValueType.INTERPOLATED),
      ], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': '11', 'variables': {'A': '1', 'B': '1'}, 'state': 'ok'},
        {'result': '14', 'variables': {'A': '1', 'B': '4'}, 'state': 'ok'},
        {'result': '16', 'variables': {'A': '1', 'B': '6'}, 'state': 'ok'},
        {'result': '18', 'variables': {'A': '1', 'B': '8'}, 'state': 'ok'},
        {'result': '21', 'variables': {'A': '2', 'B': '1'}, 'state': 'ok'},
        {'result': '24', 'variables': {'A': '2', 'B': '4'}, 'state': 'ok'},
        {'result': '26', 'variables': {'A': '2', 'B': '6'}, 'state': 'ok'},
        {'result': '28', 'variables': {'A': '2', 'B': '8'}, 'state': 'ok'},
        {'result': '31', 'variables': {'A': '3', 'B': '1'}, 'state': 'ok'},
        {'result': '34', 'variables': {'A': '3', 'B': '4'}, 'state': 'ok'},
        {'result': '36', 'variables': {'A': '3', 'B': '6'}, 'state': 'ok'},
        {'result': '38', 'variables': {'A': '3', 'B': '8'}, 'state': 'ok'}
      ]}},

      {'formula' : 'A+B', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1,4-8#2', type: FormulaValueType.INTERPOLATED),
      ], 'expandValues': false, 'expectedOutput' : {'state': 'error', 'output': [{'result': '1-3+1,4-8#2', 'state': 'error'}]}},

      {'formula' : 'A+B', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '4-8', type: FormulaValueType.INTERPOLATED),
      ], 'expandValues': false, 'expectedOutput' : {'state': 'ok', 'output': [{'result': '-6', 'state': 'ok'}]}},

      {'formula' : 'N 52 [QR].[S+T*U*2] [R] [S] [R+S] [T] [U]', 'values': [
        FormulaValue('Q', '1', type: FormulaValueType.FIXED),
        FormulaValue('R', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('S', '2,6', type: FormulaValueType.INTERPOLATED),
        FormulaValue('T', 'S+R', type: FormulaValueType.FIXED),
        FormulaValue('U', 'T+1', type: FormulaValueType.FIXED),
        FormulaValue('N', '7', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': 'N 52 11.26 1 2 3 3 4', 'variables': {'R': '1', 'S': '2'}, 'state': 'ok'},
        {'result': 'N 52 11.118 1 6 7 7 8', 'variables': {'R': '1', 'S': '6'}, 'state': 'ok'},
        {'result': 'N 52 12.42 2 2 4 4 5', 'variables': {'R': '2', 'S': '2'}, 'state': 'ok'},
        {'result': 'N 52 12.150 2 6 8 8 9', 'variables': {'R': '2', 'S': '6'}, 'state': 'ok'},
        {'result': 'N 52 13.62 3 2 5 5 6', 'variables': {'R': '3', 'S': '2'}, 'state': 'ok'},
        {'result': 'N 52 13.186 3 6 9 9 10', 'variables': {'R': '3', 'S': '6'}, 'state': 'ok'}
      ]}},

      {'formula' : 'N 52 [QR].[S+T*U*2] [R] [S] [R+S] [T] [U]', 'values': [
        FormulaValue('R', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('S', '2,6', type: FormulaValueType.INTERPOLATED),
        FormulaValue('T', 'S+R', type: FormulaValueType.FIXED),
        FormulaValue('U', 'T+1', type: FormulaValueType.FIXED),
        FormulaValue('N', '7', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'expanded_error', 'output': [
        {'result': 'N 52 [Q1].26 1 2 3 3 4', 'variables': {'R': '1', 'S': '2'}, 'state': 'error'},
        {'result': 'N 52 [Q1].118 1 6 7 7 8', 'variables': {'R': '1', 'S': '6'}, 'state': 'error'},
        {'result': 'N 52 [Q2].42 2 2 4 4 5', 'variables': {'R': '2', 'S': '2'}, 'state': 'error'},
        {'result': 'N 52 [Q2].150 2 6 8 8 9', 'variables': {'R': '2', 'S': '6'}, 'state': 'error'},
        {'result': 'N 52 [Q3].62 3 2 5 5 6', 'variables': {'R': '3', 'S': '2'}, 'state': 'error'},
        {'result': 'N 52 [Q3].186 3 6 9 9 10', 'variables': {'R': '3', 'S': '6'}, 'state': 'error'}
      ]}},

      {'formula' : 'N 52 [QR].[S+T×U*2] [R] [S] [R+S] [T] [U]', 'values': [
        FormulaValue('R', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('S', '2,6', type: FormulaValueType.INTERPOLATED),
        FormulaValue('T', 'S+R', type: FormulaValueType.FIXED),
        FormulaValue('U', 'T+1', type: FormulaValueType.FIXED),
        FormulaValue('N', '7', type: FormulaValueType.FIXED),
      ], 'expectedOutput' : {'state': 'expanded_error', 'output': [
        {'result': 'N 52 [Q1].26 1 2 3 3 4', 'variables': {'R': '1', 'S': '2'}, 'state': 'error'},
        {'result': 'N 52 [Q1].118 1 6 7 7 8', 'variables': {'R': '1', 'S': '6'}, 'state': 'error'},
        {'result': 'N 52 [Q2].42 2 2 4 4 5', 'variables': {'R': '2', 'S': '2'}, 'state': 'error'},
        {'result': 'N 52 [Q2].150 2 6 8 8 9', 'variables': {'R': '2', 'S': '6'}, 'state': 'error'},
        {'result': 'N 52 [Q3].62 3 2 5 5 6', 'variables': {'R': '3', 'S': '2'}, 'state': 'error'},
        {'result': 'N 52 [Q3].186 3 6 9 9 10', 'variables': {'R': '3', 'S': '6'}, 'state': 'error'}
      ]}},

      {'formula' : 'N 51.[C]20 E 11.423', 'values': [
        FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '1', type: FormulaValueType.INTERPOLATED),
      ], 'expectedOutput' : {'state': 'error', 'output': [
        {'result': 'N 51.[C]20 E 11.423', 'state': 'error', 'variables': {'A': '1', 'B': '1'}},
      ]}},

      // no duplicates
      {'formula' : '[A + B]', 'values': [
        FormulaValue('A', '1,3,5', type: FormulaValueType.INTERPOLATED),
        FormulaValue('B', '2-8#2', type: FormulaValueType.INTERPOLATED),
        FormulaValue('C', '10-12', type: FormulaValueType.INTERPOLATED),
      ], 'expectedOutput' : {'state': 'expanded_ok', 'output': [
        {'result': '3', 'state': 'ok', 'variables': {'A': '1', 'B': '2', 'C': '10'}},
        {'result': '5', 'state': 'ok', 'variables': {'A': '1', 'B': '4', 'C': '10'}},
        {'result': '7', 'state': 'ok', 'variables': {'A': '1', 'B': '6', 'C': '10'}},
        {'result': '9', 'state': 'ok', 'variables': {'A': '1', 'B': '8', 'C': '10'}},
        {'result': '11', 'state': 'ok', 'variables': {'A': '3', 'B': '8', 'C': '10'}},
        {'result': '13', 'state': 'ok', 'variables': {'A': '5', 'B': '8', 'C': '10'}}
      ]}},
    ];

    for (var elem in _inputsToExpected) {
      test('formula: ${elem['formula']}, values: ${elem['values']}, expandValues: ${elem['expandValues']}', () {
        FormulaSolverOutput _actual;
        if (elem['expandValues'] == null) {
          _actual = FormulaParser().parse(elem['formula'] as String, elem['values'] as List<FormulaValue>);
        } else {
          _actual = FormulaParser().parse(elem['formula'] as String, elem['values'] as List<FormulaValue>, expandValues: elem['expandValues'] as bool);
        }
        expect(_formulaSolverOutputToMap(_actual), elem['expectedOutput']);
      });
    }
  });
}