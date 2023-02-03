import 'dart:math';

import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

Map<String, String> solveQuadraticEquation(String currentA, String currentB, String currentC) {
  if (currentA == null || currentA == '' || currentB == null || currentB == '' || currentC == null || currentC == '')
    return {'': ''};

  currentA = currentA.replaceAll(',', '.');
  currentB = currentB.replaceAll(',', '.');
  currentC = currentC.replaceAll(',', '.');

  Map<String, String> result = new Map<String, String>();
  double a = 0.0;
  double b = 0.0;
  double c = 0.0;

  final parser = Parser();
  final _context = ContextModel();

  var evalResult = _parseExpression(currentA, parser, _context);
  if (evalResult is double)
    a = evalResult;
  else
    return {'': ''};

  evalResult = _parseExpression(currentB, parser, _context);
  if (evalResult is double)
    b = evalResult;
  else
    return {'': ''};

  evalResult = _parseExpression(currentC, parser, _context);
  if (evalResult is double)
    c = evalResult;
  else
    return {'': ''};

  if (a == 0) {
    result['quadratic_equation_hint_caution'] = 'quadratic_equation_hint_a_null';
    if (b == 0) {
      result['quadratic_equation_hint_caution'] = 'quadratic_equation_hint_a_b_null';
      result['x'] = '0.0';
    } else {
      if (-c / b == 0.0)
        result['x'] = '0.0';
      else
        result['x'] = NumberFormat('0.0' + '#' * 7).format(-c / b);
    }
    return result;
  }

  if (b * b - 4 * a * c < 0) {
    result['quadratic_equation_hint_caution'] = 'quadratic_equation_hint_complex';
    result['x1'] = NumberFormat('0.0' + '#' * 7).format(-b / 2 / a) +
        ' + i * ' +
        NumberFormat('0.0' + '#' * 7).format(sqrt(4 * a * c - b * b) / 2 / a);
    result['x2'] = NumberFormat('0.0' + '#' * 7).format(-b / 2 / a) +
        ' - i * ' +
        NumberFormat('0.0' + '#' * 7).format(sqrt(4 * a * c - b * b) / 2 / a);
  } else {
    result['x1'] = NumberFormat('0.0' + '#' * 7).format((-b + sqrt(b * b - 4 * a * c)) / 2 / a);
    result['x2'] = NumberFormat('0.0' + '#' * 7).format((-b - sqrt(b * b - 4 * a * c)) / 2 / a);
  }
  return result;
}

dynamic _parseExpression(String value, Parser parser, ContextModel context) {
  try {
    Expression expression = parser.parse(value);
    return expression.evaluate(EvaluationType.REAL, context);
  } catch (e) {}
  return null;
}
