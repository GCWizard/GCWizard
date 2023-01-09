import 'dart:math';

import 'package:gc_wizard/logic/common/parser/variable_string_expander.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/alphabet_values.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/persistence/formula_solver/model.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/utils/crosstotals.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

enum FormulaState {
  STATE_SINGLE_OK,
  STATE_EXPANDED_OK,
  STATE_EXPANDED_ERROR,
  STATE_SINGLE_ERROR,
  STATE_EXPANDED_ERROR_EXCEEDEDRANGE
}

const _MAX_EXPANDED = 100;

const RECURSIVE_FORMULA_REPLACEMENT_START = '{\u0000';
const RECURSIVE_FORMULA_REPLACEMENT_END = '\u0000}';
const SAFED_FUNCTION_MARKER = '\x01';
const SAFED_RECURSIVE_FORMULA_MARKER = '\x02';

const _PHI = 1.6180339887498948482045868343656381177;

class FormulaParser {
  ContextModel _context;
  Parser parser;

  bool unlimitedExpanded = false;
  Map<String, String> safedFormulasMap = {};
  Map<String, String> safedFormulaReplacementMap = {};

  static final Map<String, double> CONSTANTS = {
    'ln10': ln10,
    'ln2': ln2,
    'log2e': log2e,
    'log10e': log10e,
    'pi': pi,
    '\u03A0': pi,
    '\u03C0': pi,
    '\u220F': pi,
    '\u1D28': pi,
    'phi': _PHI,
    '\u03A6': _PHI,
    '\u03C6': _PHI,
    '\u03d5': _PHI,
    '\u0278': _PHI,
    'sqrt1_2': sqrt1_2,
    'sqrt2': sqrt2,
  };

  static final List<String> _BUILTIN_FUNCTIONS = [
    'sqrt',
    'nrt',
    'arcsin',
    'arccos',
    'arctan',
    'sin',
    'cos',
    'tan',
    'log',
    'ln',
    'abs',
    'floor',
    'sgn',
    'e',
    'ceil'
  ];

  static final Map<String, Function> _CUSTOM_FUNCTIONS = {
    'cs': (List<double> numbers) => sumCrossSum(numbers.map((number) => number.toInt()).toList()).toDouble(),
    'csi': (List<double> numbers) => sumCrossSumIterated(numbers.map((number) => number.toInt()).toList()).toDouble(),
    'min': (List<double> numbers) => numbers.reduce(min),
    'max': (List<double> numbers) => numbers.reduce(max),
    'round': (List<double> numbers) {
      var precision = 0;
      if (numbers.length > 1) precision = numbers[1].toInt();

      return round(numbers.first, precision: precision);
    },
    'sindeg': (List<double> numbers) => sin(degreesToRadian(numbers.first)),
    'cosdeg': (List<double> numbers) => cos(degreesToRadian(numbers.first)),
    'tandeg': (List<double> numbers) => tan(degreesToRadian(numbers.first)),
    'arcsindeg': (List<double> numbers) => asin(degreesToRadian(numbers.first)),
    'arccosdeg': (List<double> numbers) => acos(degreesToRadian(numbers.first)),
    'arctandeg': (List<double> numbers) => atan(degreesToRadian(numbers.first)),
    'nth': (List<double> numbers) {
      if (numbers.length == 1) return numbers.first;

      String numStr;
      if (numbers.first == numbers.first.toInt()) {
        numStr = numbers.first.toInt().toString();
      } else {
        numStr = numbers.first.toString();
      }

      var subNumStart = max(min(numbers[1].toInt() - 1, numStr.length - 1), 0);
      var subNumEnd =
          (numbers.length > 2 && numbers[2] > numbers[1]) ? min(numbers[2].toInt(), numStr.length) : subNumStart + 1;

      numStr = numStr.substring(subNumStart, subNumEnd);

      if (numStr.startsWith('.')) numStr = '0' + numStr;

      if (numStr.endsWith('.')) numStr = numStr.substring(0, numStr.length - 1);

      return double.parse(numStr);
    },
  };

  static final Map<String, Function> _CUSTOM_TEXT_FUNCTIONS = {
    'bww': (String arg) => sum(AlphabetValues().textToValues(arg, keepNumbers: true)),
    'av': (String arg) => sum(AlphabetValues().textToValues(arg, keepNumbers: true)),
    'len': (String arg) => arg.length,
  };

  // different minus/hyphens/dashes
  static final Map<String, String> alternateOperators = {
    //'-': '—–˗−‒', // not required here, because normalized in common_utils.normalizeCharacters()
    '/': ':÷',
    '*': '×•',
  };

  FormulaParser({unlimitedExpanded: false}) {
    this.unlimitedExpanded = unlimitedExpanded;

    _context = ContextModel();

    CONSTANTS.entries.forEach((constant) {
      _context.bindVariableName(constant.key, Number(constant.value));
    });

    parser = Parser();
    _CUSTOM_FUNCTIONS.forEach((name, handler) {
      parser.addFunction(name, handler);
    });
  }

  static List<String> availableParserFunctions() {
    var result = List<String>.from(_BUILTIN_FUNCTIONS);
    _CUSTOM_FUNCTIONS.forEach((name, handler) {
      result.add(name);
    });
    _CUSTOM_TEXT_FUNCTIONS.forEach((name, handler) {
      result.add(name);
    });

    return result;
  }

  // If, for example, the sin() function is used, but there's a variable i, you have to avoid
  // replace the i from sin with the variable value
  String _safeFunctionsAndConstants(String formula) {
    var list = CONSTANTS.keys
        .where((constant) => constant != 'e') //special case: If you remove e, you could never use this as variable name
        .toList();

    list.addAll(availableParserFunctions().map((functionName) => functionName + '\\s*\\(').toList());
    for (int i = 0; i < list.length; i++) {
      var matches = RegExp(list[i], caseSensitive: false).allMatches(formula);
      for (Match m in matches) {
        safedFormulasMap.putIfAbsent(
            m.group(0), () => '$SAFED_FUNCTION_MARKER${safedFormulasMap.length}$SAFED_FUNCTION_MARKER');
      }
      formula = substitution(formula, safedFormulasMap);
    }

    return formula;
  }

  // If, for instance, {1} will be replaced by a not yet calculated formula like 'len(ABC)',
  // then it must be avoided, that 'ABC' will be furtherly replaced by variables A, B or C.
  // Because: When a former formula will be included, this one IS still ready calculated and does not need another calculation round
  String _safeFormulaReplacements(String formula) {
    var formulaReplacementPattern =
        RegExp(RECURSIVE_FORMULA_REPLACEMENT_START + '(.*?)' + RECURSIVE_FORMULA_REPLACEMENT_END);
    var matches = formulaReplacementPattern.allMatches(formula);

    for (Match m in matches) {
      safedFormulaReplacementMap.putIfAbsent(m.group(0),
          () => '$SAFED_RECURSIVE_FORMULA_MARKER${safedFormulaReplacementMap.length}$SAFED_RECURSIVE_FORMULA_MARKER');
      formula = substitution(formula, safedFormulaReplacementMap);
    }

    return formula;
  }

  static String normalizeMathematicalSymbols(String formula) {
    alternateOperators.forEach((key, value) {
      formula = formula.replaceAll(RegExp('[$value]'), key);
    });
    /**** exponents *****/
    formula = formula.replaceAllMapped(RegExp('[\u2070\u00B9\u00B2\u00B3\u2074\u2075\u2076\u2077\u2078\u2079]+'),
        (Match match) {
      var group = match.group(0);
      group = substitution(group, switchMapKeyValue(SUPERSCRIPT_CHARACTERS));
      return '^$group';
    });

    return formula;
  }



  Map<String, dynamic> _parseFormula(String formula, List<FormulaValue> values, bool expandValues) {
    formula = normalizeCharacters(formula);
    formula = normalizeMathematicalSymbols(formula);
    safedFormulasMap = {};

    List<FormulaValue> preparedValues = _prepareValues(values);

    var fixedValues = <String, String>{};
    var textValues = <String, String>{};
    var interpolatedValues = <String, String>{};
    preparedValues.forEach((value) {
      if (expandValues == false || value.type == null) {
        fixedValues.putIfAbsent(value.key, () => value.value);
        return;
      }

      switch (value.type) {
        case FormulaValueType.FIXED:
          fixedValues.putIfAbsent(value.key, () => value.value);
          break;
        case FormulaValueType.INTERPOLATED:
          interpolatedValues.putIfAbsent(value.key, () => value.value);
          break;
        case FormulaValueType.TEXT:
          textValues.putIfAbsent(value.key, () => value.value);
          break;
      }
    });

    //replace formula replacements
    var safedFormulaReplacements = _safeFormulaReplacements(formula);

    //replace constants and formula names
    var safedFormulaNames = _safeFunctionsAndConstants(safedFormulaReplacements);

    //replace fixed values recursively
    int i = pow(values.length, 2);
    var substitutedFormula = safedFormulaNames;
    var fullySubstituted = false;
    while (i > 0 && !fullySubstituted) {
      var tempSubstitutedFormula = substitution(substitutedFormula, fixedValues, caseSensitive: false);
      fullySubstituted = _isFullySubstituted(tempSubstitutedFormula, substitutedFormula);

      substitutedFormula = tempSubstitutedFormula;
      i--;
    }
    // replace text values non-recursively afterwards
    // because C = FLOWER, the letters F,L,O,W,E,R should not be treated as new variables
    substitutedFormula = substitution(substitutedFormula, textValues, caseSensitive: false);

    //expand formulas with interpolation values if exist
    // --> evaluate each interpolated result
    //if no interpolation: simply evaluate the formula directly
    List<Map<String, dynamic>> expandedFormulas;
    if (expandValues && interpolatedValues.length > 0) {
      var count = VariableStringExpander(substitutedFormula, interpolatedValues).run(onlyPrecheck: true).first['count'];
      if (count == null) {
        return {'state': FormulaState.STATE_SINGLE_ERROR, 'result': substitutedFormula};
      } else if (!unlimitedExpanded && count > _MAX_EXPANDED) {
        return {'state': FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE, 'result': substitutedFormula};
      }

      try {
        expandedFormulas = VariableStringExpander(substitutedFormula, interpolatedValues).run();
      } catch (e) {
        return {'state': FormulaState.STATE_SINGLE_ERROR, 'result': substitutedFormula};
      }

      var results = <Map<String, dynamic>>[];
      var hasError = false;
      for (var expandedFormula in expandedFormulas) {
        substitutedFormula = _reSubstituteFormula(expandedFormula['text']);

        try {
          var result = _evaluateFormula(substitutedFormula);
          results.add(
              {'state': FormulaState.STATE_SINGLE_OK, 'result': result, 'variables': expandedFormula['variables']});
        } catch (e) {
          results.add({
            'state': FormulaState.STATE_SINGLE_ERROR,
            'result': substitutedFormula,
            'variables': expandedFormula['variables']
          });
          hasError = true;
        }
      }

      return {
        'state': hasError ? FormulaState.STATE_EXPANDED_ERROR : FormulaState.STATE_EXPANDED_OK,
        'result': results
      };
    } else {
      substitutedFormula = _reSubstituteFormula(substitutedFormula);

      try {
        var result = _evaluateFormula(substitutedFormula);
        return {'state': FormulaState.STATE_SINGLE_OK, 'result': result};
      } catch (e) {
        return {'state': FormulaState.STATE_SINGLE_ERROR, 'result': substitutedFormula};
      }
    }
  }

  String _reSubstituteFormula(String formula) {
    var substitutedFormula = substitution(formula, switchMapKeyValue(safedFormulasMap));
    substitutedFormula = substitution(substitutedFormula, switchMapKeyValue(safedFormulaReplacementMap));
    return substitutedFormula
        .replaceAll(RECURSIVE_FORMULA_REPLACEMENT_START, '')
        .replaceAll(RECURSIVE_FORMULA_REPLACEMENT_END, '');
  }

  bool _isFullySubstituted(String tempSubstitutedFormula, substitutedFormula) {
    return double.tryParse(tempSubstitutedFormula.replaceAll(RegExp(r'[\(\)]'), '')) != null ||
        substitutedFormula == tempSubstitutedFormula.replaceAll(RegExp(r'[\(\)]'), '');
  }

  String _evaluateTextFunctions(String formula) {
    var out = formula.toLowerCase();

    _CUSTOM_TEXT_FUNCTIONS.forEach((name, function) {
      var regex = RegExp('(' + name + r'\s*\(\s*([^\(\)]+)\s*\))');
      var matches = regex.allMatches(out);

      matches.forEach((match) {
        var foundFunction = match.group(1);
        var argument = match.group(2);
        var result = function(argument);

        out = out.replaceFirst(foundFunction, result.toString());
      });
    });

    return out;
  }

  dynamic _evaluateFormula(String formula) {
    // Remove Brackets; the formula evaluation only needs the internal content
    var hasBrackets = formula.startsWith('[') && formula.endsWith(']');
    formula = hasBrackets ? formula.substring(1, formula.length - 1) : formula;

    formula = _evaluateTextFunctions(formula);

    Expression expression = parser.parse(formula.toLowerCase());
    var result = expression.evaluate(EvaluationType.REAL, _context);
    if (result == null) throw Exception();

    return result;
  }

  List<FormulaValue> _prepareValues(List<FormulaValue> values) {
    List<FormulaValue> val = [];
    values.forEach((element) {
      var key = element.key.trim();
      var value = element.value;

      if (value == null || value.length == 0) {
        if (element.type == FormulaValueType.TEXT) {
          value = '';
        } else {
          value = key;
        }
      } else if (element.type == FormulaValueType.FIXED && double.tryParse(value) == null) {
        value = '($value)';
      }

      var safedFormulas;
      if (element.type == FormulaValueType.FIXED) {
        safedFormulas = _safeFunctionsAndConstants(value);
        value = safedFormulas;
      }

      val.add(FormulaValue(key, value, type: element.type));
    });
    return val;
  }

  FormulaSolverOutput _simpleErrorOutput(String formula) {
    return FormulaSolverOutput(
        FormulaState.STATE_SINGLE_ERROR, [FormulaSolverResult(FormulaState.STATE_SINGLE_ERROR, formula)]);
  }

  FormulaSolverOutput parse(String formula, List<FormulaValue> values, {expandValues: true}) {
    if (formula == null) {
      return _simpleErrorOutput(formula);
    }

    formula = formula.trim();

    if (formula == '') {
      return _simpleErrorOutput(formula);
    }

    if (values == null) values = <FormulaValue>[];

    RegExp regExp = RegExp(r'\[.+?\]');
    var matches = regExp.allMatches(formula);

    // if formula has no [ ], then match the whole string
    if (matches.length == 0) {
      matches = RegExp(r'^.*$', multiLine: true).allMatches(formula);
    }

    Map<String, Map<String, FormulaSolverResult>> matchedVariables = {};

    var overallState = FormulaState.STATE_SINGLE_OK;
    try {
      matches.forEach((match) {
        var matchString = match.group(0);

        ////////// MAGIC
        var result = _parseFormula(matchString, values, expandValues);
        //////////

        var state = result['state'];

        // each match may return more than one result due to interpolation
        // final output map matches current match string to list of interpolation results
        //
        // if interpolation than several matches need clustering to same variables sets
        // Example: [A][A] for A = 1-2.
        // Two matches -> two iterations.
        // each iteration has two results. If simple adding results to final result set,
        // it would yield: 11, 12, 21, 22.
        // But this is obviously wrong result, because the user would not expect 12 and 21.
        // because A can not be two different values at once
        // So, results will be clustered by variables, A = 1 or A = 2, in that case
        // Then each match string will be in fitting variable set: {{A: 1}: [[1], [1]], {A:2}: [[2], [2]]}
        // Later the substitutions can be for each unique variable set dependently
        //
        // if no interpolation (only one or no result), variables key is NULL for simplicity
        switch (state) {
          case FormulaState.STATE_SINGLE_OK:
            var out = FormulaSolverResult(state, _formatOutput(result['result']));
            if (matchedVariables.containsKey(null)) {
              matchedVariables[null].putIfAbsent(matchString, () => out);
            } else {
              matchedVariables.putIfAbsent(null, () => {matchString: out});
            }
            break;
          case FormulaState.STATE_SINGLE_ERROR:
          case FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE:
            // restore brackets if formerly removed
            var out = FormulaSolverResult(state, result['result']);
            if (matchedVariables.containsKey(null)) {
              matchedVariables[null].putIfAbsent(matchString, () => out);
            } else {
              matchedVariables.putIfAbsent(null, () => {matchString: out});
            }

            // overallState turns into error, if currently ok.
            // EXPANDED_ERROR cannot be overwritten
            if (overallState != FormulaState.STATE_EXPANDED_ERROR) overallState = state;
            break;
          case FormulaState.STATE_EXPANDED_OK:
          case FormulaState.STATE_EXPANDED_ERROR:
            result['result'].forEach((result) {
              var formatted;
              if (result['state'] == FormulaState.STATE_SINGLE_OK) {
                formatted = _formatOutput(result['result']);
              } else {
                // restore brackets if formerly removed
                formatted = result['result'];
              }

              var out = FormulaSolverResult(result['state'], formatted, variables: result['variables']);

              var variables = result['variables'].toString();
              if (matchedVariables.containsKey(variables)) {
                matchedVariables[variables].putIfAbsent(matchString, () => out);
              } else {
                matchedVariables.putIfAbsent(variables, () => {matchString: out});
              }

              // SINGLE_ERROR can be overwritten by EXPANDED_ERROR
              // SINGLE_OK can be overwritten by EXPANDED_OK
              // *_OK can overwritten by *_ERROR
              if (state == FormulaState.STATE_EXPANDED_OK) {
                if (overallState == FormulaState.STATE_SINGLE_ERROR)
                  overallState = FormulaState.STATE_EXPANDED_ERROR;
                else if (overallState != FormulaState.STATE_EXPANDED_ERROR)
                  overallState = result['state'] == FormulaState.STATE_SINGLE_OK
                      ? FormulaState.STATE_EXPANDED_OK
                      : FormulaState.STATE_EXPANDED_ERROR;
              } else {
                overallState = FormulaState.STATE_EXPANDED_ERROR;
              }
            });

            break;
        }
      });
    } catch (e) {}

    // Here the magic happens, which was decribed above
    // Variable sets with independent matchStrings will be substituted dependently here
    List<FormulaSolverResult> output = [];
    matchedVariables.values.forEach((Map<String, FormulaSolverResult> matchedResults) {
      Map<String, String> substitutions = {};
      var variables;
      var state = FormulaState.STATE_SINGLE_OK;
      matchedResults.forEach((String matchedString, FormulaSolverResult result) {
        if (variables == null) variables = result.variables;
        if (result.state == FormulaState.STATE_SINGLE_ERROR) state = FormulaState.STATE_SINGLE_ERROR;
        substitutions.putIfAbsent(matchedString, () => result.result);
      });

      var backSubstituted = substitution(formula, substitutions);
      var exists = false;
      for (int i = 0; i < output.length; i++) {
        if (output[i].result == backSubstituted) {
          exists = true;
          break;
        }
      }

      if (!exists) {
        FormulaSolverResult out =
            FormulaSolverResult(state, substitution(formula, substitutions), variables: variables);
        output.add(out);
      }
    });

    // if EXPANDED state althought only one result -> make it to SINGLE state
    if (output.length <= 1) {
      if (overallState == FormulaState.STATE_EXPANDED_OK) overallState = FormulaState.STATE_SINGLE_OK;
      if (overallState == FormulaState.STATE_EXPANDED_ERROR) overallState = FormulaState.STATE_SINGLE_ERROR;
    }

    return FormulaSolverOutput(overallState, output);
  }

  String _formatOutput(dynamic value) {
    if (value is double) {
      return NumberFormat('0.############').format(value);
    } else {
      return value.toString();
    }
  }
}

class FormulaSolverResult {
  final FormulaState state;
  String result;
  final Map<String, String> variables;

  FormulaSolverResult(this.state, this.result, {this.variables});

  @override
  String toString() {
    return "{'state': $state, 'result': $result, 'variables': $variables}";
  }
}

class FormulaSolverOutput {
  final FormulaState state;
  final List<FormulaSolverResult> results;

  FormulaSolverOutput(this.state, this.results);

  @override
  String toString() {
    return "{'state': $state, 'results': $results}";
  }
}
