import 'dart:collection';
import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';
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
const _SAFED_FUNCTION_MARKER = '\x01';
const _SAFED_RECURSIVE_FORMULA_MARKER = '\x02';
const _SAFED_TEXTS_MARKER = '\x03';
const _STRING_MARKER_APOSTROPHE = "'";
const _STRING_MARKER_QUOTE = '"';

const _PHI = 1.6180339887498948482045868343656381177;
const _SQRT3 = 1.73205080756887729352744634150587236;
const _SQRT5 = 2.23606797749978969640917366873127623;

var _SUPPORTED_OPERATION_CHARACTERS = RegExp(r'[+\-*!^%/]');

class FormulaParser {
  final ContextModel _context = ContextModel();
  Parser parser = Parser();

  bool unlimitedExpanded = false;
  Map<String, String> safedFormulasMap = {};
  Map<String, String> safedFormulaReplacementMap = {};
  Map<String, String> safedTextsMap = {};

  static const Map<String, double> CONSTANTS = {
    'ln10': ln10,
    'ln2': ln2,
    // 'log2e': log2e,    // not supported due to a problem by the math expression lib: https://github.com/fkleon/math-expressions/issues/35
    // 'log10e': log10e,  // not supported due to a problem by the math expression lib: https://github.com/fkleon/math-expressions/issues/35
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
    // 'sqrt1_2': sqrt1_2, // not supported due to a problem by the math expression lib: https://github.com/fkleon/math-expressions/issues/35
    'sqrt2': sqrt2,
    'sqrt3': _SQRT3,
    'sqrt5': _SQRT5,
  };

  static const List<String> _BUILTIN_FUNCTIONS = [
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

  static RegExp _contentStringRegExp(String value) {
    var RegExpApostrophe =
        RegExp(r'^\s*\(?\s*\' + _STRING_MARKER_APOSTROPHE + r'(.*?)\' + _STRING_MARKER_APOSTROPHE + r'\)?\s*\s*');
    var RegExpQuote = RegExp(r'^\s*\(?\s*\' + _STRING_MARKER_QUOTE + r'(.*?)\' + _STRING_MARKER_QUOTE + r'\)?\s*\s*');

    var regexes = SplayTreeMap<int, RegExp>();

    if (RegExpApostrophe.hasMatch(value)) {
      regexes.addEntries({MapEntry(RegExpApostrophe.firstMatch(value)!.start, RegExpApostrophe)});
    }

    if (RegExpQuote.hasMatch(value)) {
      regexes.addEntries({MapEntry(RegExpQuote.firstMatch(value)!.start, RegExpQuote)});
    }

    try {
      return regexes.entries.first.value;
    } catch (e) {
      throw Exception();
    }
  }

  static String _contentFromString(String value) {
    var _value = value;
    var str = '';

    do {
      var regExp = _contentStringRegExp(_value);
      str += regExp.firstMatch(_value)!.group(1)!;
      _value = _value.replaceFirstMapped(regExp, (match) => '');
    } while (_value.isNotEmpty);

    return str;
  }

  static int _bww(String value) {
    return sum(AlphabetValues().textToValues(_contentFromString(value), keepNumbers: true).whereType<int>().toList())
        .toInt();
  }

  static final Map<String, int Function(String)> _CUSTOM_TEXT_FUNCTIONS = {
    'bww': (String arg) => _bww(arg),
    'av': (String arg) => _bww(arg),
    'len': (String arg) => _contentFromString(arg).length,
  };

  // different minus/hyphens/dashes
  static const Map<String, String> alternateOperators = {
    //'-': '—–˗−‒', // not required here, because normalized in normalizeCharacters()
    '/': ':÷⁄',
    '*': '×\u2022\u00B7\u16EB\u2981\u25CF\u2218\u25E6',
  };

  FormulaParser({this.unlimitedExpanded = false}) {
    for (var constant in CONSTANTS.entries) {
      _context.bindVariableName(constant.key, Number(constant.value));
    }

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

  String _safeTexts(String formula) {
    var safedTextsFormula = '';

    String? stringChar;
    String currentString = '';
    for (int i = 0; i < formula.length; i++) {
      var char = formula[i];
      if ([_STRING_MARKER_APOSTROPHE, _STRING_MARKER_QUOTE].contains(char)) {
        if (stringChar == null) {
          stringChar = char;
          currentString = '';
        } else {
          if (stringChar == char) {
            var marker = '$_SAFED_TEXTS_MARKER${safedTextsMap.length}$_SAFED_TEXTS_MARKER';
            safedTextsMap.putIfAbsent(marker, () => stringChar! + currentString + stringChar);
            safedTextsFormula += marker;

            currentString = '';
            stringChar = null;
            continue;
          } else {
            currentString += char;
          }
        }
      } else {
        if (stringChar != null) {
          currentString += char;
        } else {
          safedTextsFormula += char;
        }
      }
    }
    safedTextsFormula += (stringChar ?? '') + currentString;

    return safedTextsFormula;
  }

  // If, for example, the sin() function is used, but there's a variable i, you have to avoid
  // replacing the i from sin with the variable value
  String _safeFunctionsAndConstants(String formula) {
    var list = CONSTANTS.keys
        .where(
            (constant) => constant != 'e') //special case: If you removed e, you could never use this as variable name
        .toList();

    list.addAll(availableParserFunctions().map((functionName) => functionName + '\\s*\\(').toList());
    for (int i = 0; i < list.length; i++) {
      var matches = RegExp(list[i], caseSensitive: false).allMatches(formula);
      for (Match m in matches) {
        var group = m.group(0);
        if (group == null) continue;
        safedFormulasMap.putIfAbsent(
            group, () => '$_SAFED_FUNCTION_MARKER${safedFormulasMap.length}$_SAFED_FUNCTION_MARKER');
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
      var group = m.group(0);
      if (group == null) continue;
      safedFormulaReplacementMap.putIfAbsent(group,
          () => '$_SAFED_RECURSIVE_FORMULA_MARKER${safedFormulaReplacementMap.length}$_SAFED_RECURSIVE_FORMULA_MARKER');
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
      group = substitution(group!, switchMapKeyValue(SUPERSCRIPT_CHARACTERS));
      return '^$group';
    });

    return formula;
  }

  _FormulaSolverResult _parseFormula(String formula, List<FormulaValue> values, bool expandValues) {
    formula = normalizeCharacters(formula);
    formula = normalizeMathematicalSymbols(formula);
    safedFormulasMap = {};
    safedTextsMap = {};

    List<FormulaValue> preparedValues = _prepareValues(values);

    var fixedValues = <String, String>{};
    var interpolatedValues = <String, String>{};
    for (var value in preparedValues) {
      if (expandValues == false || value.type == null) {
        fixedValues.putIfAbsent(value.key, () => value.value);
        continue;
      }

      switch (value.type) {
        case FormulaValueType.FIXED:
          fixedValues.putIfAbsent(value.key, () => value.value);
          break;
        case FormulaValueType.INTERPOLATED:
          interpolatedValues.putIfAbsent(value.key, () => value.value);
          break;
        default:
          continue;
      }
    }

    var safedTexts = _safeTexts(formula);

    //replace formula replacements
    var safedFormulaReplacements = _safeFormulaReplacements(safedTexts);

    //replace constants and formula names
    var safedFormulaNames = _safeFunctionsAndConstants(safedFormulaReplacements);

    //replace fixed values recursively
    int i = pow(values.length, 2).toInt();
    var substitutedFormula = safedFormulaNames;
    var fullySubstituted = false;
    while (i > 0 && !fullySubstituted) {
      var tempSubstitutedFormula = substitution(substitutedFormula, fixedValues, caseSensitive: false);
      fullySubstituted = _isFullySubstituted(tempSubstitutedFormula, substitutedFormula);
      substitutedFormula = tempSubstitutedFormula;
      i--;
    }

    //expand formulas with interpolation values if exist
    // --> evaluate each interpolated result
    //if no interpolation: simply evaluate the formula directly
    List<VariableStringExpanderValue> expandedFormulas;
    if (expandValues && interpolatedValues.isNotEmpty) {
      var count = VariableStringExpander(substitutedFormula, interpolatedValues).run(onlyPrecheck: true).first.count;
      if (count == null) {
        return FormulaSolverSingleResult(FormulaState.STATE_SINGLE_ERROR, substitutedFormula);
      } else if (!unlimitedExpanded && count > _MAX_EXPANDED) {
        return FormulaSolverSingleResult(FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE, substitutedFormula);
      }

      try {
        expandedFormulas = VariableStringExpander(substitutedFormula, interpolatedValues).run();
      } catch (e) {
        return FormulaSolverSingleResult(FormulaState.STATE_SINGLE_ERROR, substitutedFormula);
      }

      var results = <FormulaSolverSingleResult>[];
      var hasError = false;
      for (var expandedFormula in expandedFormulas) {
        if (expandedFormula.text == null) continue;

        substitutedFormula = _reSubstituteSavings(expandedFormula.text!);

        try {
          var result = _evaluateFormula(substitutedFormula);
          results.add(
              FormulaSolverSingleResult(FormulaState.STATE_SINGLE_OK, result, variables: expandedFormula.variables));
        } catch (e) {
          results.add(FormulaSolverSingleResult(FormulaState.STATE_SINGLE_ERROR, substitutedFormula,
              variables: expandedFormula.variables));
          hasError = true;
        }
      }

      return FormulaSolverMultiResult(
          hasError ? FormulaState.STATE_EXPANDED_ERROR : FormulaState.STATE_EXPANDED_OK, results);
    } else {
      substitutedFormula = _reSubstituteSavings(substitutedFormula);

      try {
        String result;
        try {
          return FormulaSolverSingleResult(FormulaState.STATE_SINGLE_OK, _contentFromString(substitutedFormula));
        } catch (e) {
          result = _evaluateFormula(substitutedFormula);
          return FormulaSolverSingleResult(FormulaState.STATE_SINGLE_OK, result);
        }
      } catch (e) {
        return FormulaSolverSingleResult(FormulaState.STATE_SINGLE_ERROR, substitutedFormula);
      }
    }
  }

  bool _isString(String formula) {
    var _formula = formula.trim();
    if (_formula.startsWith('(') && _formula.endsWith(')')) {
      _formula = _formula.substring(1, _formula.length - 1).trim();
    }

    try {
      _contentFromString(_formula);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _reSubstituteSavings(String formula) {
    var substitutedFormula = substitution(formula, switchMapKeyValue(safedFormulasMap));
    substitutedFormula = substitution(substitutedFormula, switchMapKeyValue(safedFormulaReplacementMap));
    substitutedFormula = substitutedFormula
        .replaceAll(RECURSIVE_FORMULA_REPLACEMENT_START, '')
        .replaceAll(RECURSIVE_FORMULA_REPLACEMENT_END, '');
    substitutedFormula = substitution(substitutedFormula, safedTextsMap);

    return substitutedFormula;
  }

  bool _isFullySubstituted(String tempSubstitutedFormula, String substitutedFormula) {
    return double.tryParse(tempSubstitutedFormula.replaceAll(RegExp(r'[()]'), '')) != null ||
        substitutedFormula == tempSubstitutedFormula ||
        substitutedFormula == tempSubstitutedFormula.replaceAll(RegExp(r'[()]'), '');
  }

  String _evaluateTextFunctions(String formula) {
    var out = formula.toLowerCase();

    _CUSTOM_TEXT_FUNCTIONS.forEach((String name, int Function(String) function) {
      var regex = RegExp('(' + name + r'\s*\(\s*([^\(\)]+)\s*\))');
      var matches = regex.allMatches(out);

      for (var match in matches) {
        var foundFunction = match.group(1);
        if (foundFunction == null) continue;

        var argument = match.group(2);
        if (argument == null) continue;

        var result = function(argument);

        out = out.replaceFirst(foundFunction, result.toString());
      }
    });

    return out;
  }

  String tryGetOnlyStrings(String formula) {
    try {
      return _contentFromString(formula);
    } catch (e) {
      throw Exception();
    }
  }

  String _evaluateFormula(String formula) {
    // Remove Brackets; the formula evaluation only needs the internal content
    var hasBrackets = formula.startsWith('[') && formula.endsWith(']');
    formula = hasBrackets ? formula.substring(1, formula.length - 1) : formula;

    try {
      return tryGetOnlyStrings(formula);
    } catch (e) {}

    formula = _evaluateTextFunctions(formula);
    Expression expression = parser.parse(formula.toLowerCase());
    var result = expression.evaluate(EvaluationType.REAL, _context);
    if (result == null) throw Exception();

    return _formatOutput(result);
  }

  List<FormulaValue> _prepareValues(List<FormulaValue> values) {
    List<FormulaValue> val = [];
    for (var element in values) {
      var key = element.key.trim();
      var value = normalizeCharacters(element.value);

      if (value.isEmpty) {
        value = key;
      } else if (element.type == null || element.type == FormulaValueType.FIXED) {
        value = value.trim();
        if (value.contains(_SUPPORTED_OPERATION_CHARACTERS) && !_isString(value)) {
          value = '($value)';
        }
      }

      String safedTexts;
      String safedFormulas;
      if (element.type == null || element.type == FormulaValueType.FIXED) {
        safedTexts = _safeTexts(value);
        value = safedTexts;

        safedFormulas = _safeFunctionsAndConstants(value);
        value = safedFormulas;
      }

      val.add(FormulaValue(key, value, type: element.type ?? FormulaValueType.FIXED));
    }
    return val;
  }

  FormulaSolverOutput _simpleErrorOutput(String formula) {
    return FormulaSolverOutput(
        FormulaState.STATE_SINGLE_ERROR, [FormulaSolverSingleResult(FormulaState.STATE_SINGLE_ERROR, formula)]);
  }

  final String _MATCHED_VARIABLES_NO_KEY = '\x00';
  FormulaSolverOutput parse(String formula, List<FormulaValue> values, {bool expandValues = true}) {
    formula = formula.trim();

    if (formula.isEmpty) {
      return _simpleErrorOutput(formula);
    }

    RegExp regExp = RegExp(r'\[.+?\]');
    var matches = regExp.allMatches(formula);

    // if formula has no [ ], then match the whole string
    if (matches.isEmpty) {
      matches = RegExp(r'^.*$', multiLine: true).allMatches(formula);
    }

    Map<String, Map<String, FormulaSolverSingleResult>> matchedVariables = {};

    var overallState = FormulaState.STATE_SINGLE_OK;
    try {
      for (var match in matches) {
        var matchString = match.group(0);
        if (matchString == null) continue;

        ////////// MAGIC
        var result = _parseFormula(matchString, values, expandValues);
        //////////

        var state = result.state;

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
            var out = FormulaSolverSingleResult(state, _formatOutput((result as FormulaSolverSingleResult).result));
            if (matchedVariables.containsKey(_MATCHED_VARIABLES_NO_KEY)) {
              matchedVariables[_MATCHED_VARIABLES_NO_KEY]!.putIfAbsent(matchString, () => out);
            } else {
              matchedVariables.putIfAbsent(_MATCHED_VARIABLES_NO_KEY, () => {matchString: out});
            }
            break;
          case FormulaState.STATE_SINGLE_ERROR:
          case FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE:
            // restore brackets if formerly removed
            var out = FormulaSolverSingleResult(state, (result as FormulaSolverSingleResult).result);
            if (matchedVariables.containsKey(_MATCHED_VARIABLES_NO_KEY)) {
              matchedVariables[_MATCHED_VARIABLES_NO_KEY]!.putIfAbsent(matchString, () => out);
            } else {
              matchedVariables.putIfAbsent(_MATCHED_VARIABLES_NO_KEY, () => {matchString: out});
            }

            // overallState turns into error, if currently ok.
            // EXPANDED_ERROR cannot be overwritten
            if (overallState != FormulaState.STATE_EXPANDED_ERROR) overallState = state;
            break;
          case FormulaState.STATE_EXPANDED_OK:
          case FormulaState.STATE_EXPANDED_ERROR:
            for (var result in (result as FormulaSolverMultiResult).results) {
              String formatted;
              if (result.state == FormulaState.STATE_SINGLE_OK) {
                formatted = _formatOutput(result.result);
              } else {
                // restore brackets if formerly removed
                formatted = result.result;
              }

              var out = FormulaSolverSingleResult(result.state, formatted, variables: result.variables);

              var variables = result.variables.toString();
              if (matchedVariables.containsKey(variables)) {
                matchedVariables[variables]!.putIfAbsent(matchString, () => out);
              } else {
                matchedVariables.putIfAbsent(variables, () => {matchString: out});
              }

              // SINGLE_ERROR can be overwritten by EXPANDED_ERROR
              // SINGLE_OK can be overwritten by EXPANDED_OK
              // *_OK can overwritten by *_ERROR
              if (state == FormulaState.STATE_EXPANDED_OK) {
                if (overallState == FormulaState.STATE_SINGLE_ERROR) {
                  overallState = FormulaState.STATE_EXPANDED_ERROR;
                } else if (overallState != FormulaState.STATE_EXPANDED_ERROR) {
                  overallState = result.state == FormulaState.STATE_SINGLE_OK
                      ? FormulaState.STATE_EXPANDED_OK
                      : FormulaState.STATE_EXPANDED_ERROR;
                }
              } else {
                overallState = FormulaState.STATE_EXPANDED_ERROR;
              }
            }

            break;
        }
      }
    } catch (e) {}

    // Here the magic happens, which was decribed above
    // Variable sets with independent matchStrings will be substituted dependently here
    List<FormulaSolverSingleResult> output = [];
    for (var matchedResults in matchedVariables.values) {
      Map<String, String> substitutions = {};
      Map<String, String>? variables;
      var state = FormulaState.STATE_SINGLE_OK;
      matchedResults.forEach((String matchedString, FormulaSolverSingleResult result) {
        variables ??= result.variables;
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
        var out = FormulaSolverSingleResult(state, substitution(formula, substitutions), variables: variables);
        output.add(out);
      }
    }

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

abstract class _FormulaSolverResult {
  final FormulaState state;
  final Map<String, String>? variables;

  _FormulaSolverResult(this.state, {this.variables});
}

class FormulaSolverSingleResult extends _FormulaSolverResult {
  final String result;

  FormulaSolverSingleResult(FormulaState state, this.result, {Map<String, String>? variables})
      : super(state, variables: variables);

  @override
  String toString() {
    return "{'state': $state, 'result': $result, 'variables': $variables}";
  }
}

class FormulaSolverMultiResult extends _FormulaSolverResult {
  final List<FormulaSolverSingleResult> results;

  FormulaSolverMultiResult(FormulaState state, this.results, {Map<String, String>? variables})
      : super(state, variables: variables);

  @override
  String toString() {
    return "{'state': $state, 'results': $results, 'variables': $variables}";
  }
}

class FormulaSolverOutput {
  final FormulaState state;
  final List<FormulaSolverSingleResult> results;

  FormulaSolverOutput(this.state, this.results);

  @override
  String toString() {
    return "{'state': $state, 'results': $results}";
  }
}
