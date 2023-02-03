import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class FormulaPainter {
  static final _operators = {'+', '-', '*', '/', '^', '%'};
  static final _bracket = {'[': ']', '(': ')', '{': '}'};
  static final numberRegEx = r'(\s*(\d+.\d*|\d*\.\d|\d+)\s*)';
  static final _allCharacters = allCharacters();
  Map<String, String> _values;
  var _variables = <String>[];
  var _functions = <String>[];
  var _constants = <String>[];
  int _formulaId;
  bool _operatorBevor;
  String _parentFunctionName;
  String formula;

  String _operatorsRegEx;
  String _functionsRegEx;
  String _constantsRegEx;
  String _variablesRegEx;

  FormulaPainter() {
    _functions = _toUpperCaseAndSort(FormulaParser.availableParserFunctions());
    _constants = _toUpperCaseAndSort(FormulaParser.CONSTANTS.keys.toList());

    _operatorsRegEx = _operators.map((op) => r'\' + op).join();
    _functionsRegEx = _functions.map((function) => function).join('|');
    _constantsRegEx = _constants.map((constant) => constant).join('|');
  }

  String paintFormula(String formula, Map<String, String> values, int formulaIndex, bool coloredFormulas) {
    if (formula == null) return null;

    var result = _buildResultString('t', formula.length);
    if (!coloredFormulas) return result;

    var subResult = '';
    this._formulaId = formulaIndex;

    if (values != null) {
      _variables = values.keys.map((variable) {
        return ((variable == null) || (variable.length == 0)) ? null : variable;
      }).toList();
    } else
      _variables.clear();

    _values = values;
    _variables = _toUpperCaseAndSort(_variables);
    _variablesRegEx = _variables.map((variable) => variable).join('|');

    formula = normalizeCharacters(formula);
    formula = FormulaParser.normalizeMathematicalSymbols(formula);
    formula = formula.toUpperCase();
    this.formula = formula;

    RegExp regExp = RegExp(r'(\[)(.+?|\s*)(\])');
    var matches = regExp.allMatches(formula);
    if (matches.isNotEmpty) {
      // formel references
      result = _paintOutsideFormulaReferences(formula, result, matches);

      matches.forEach((match) {
        var _parserResult = [formula.substring(0, match.start), match.group(1), match.group(2), match.group(3)];
        var literal = _parserResult[2];
        var emptyLiteral = literal.trim().isEmpty;
        result = _coloredContent(result, _parserResult, emptyLiteral);

        _operatorBevor = true;
        subResult = _paintSubFormula(literal, 0);
        result = _replaceRange(result, _calcOffset(_parserResult, count: 2), null, subResult);
      });
    } else {
      _operatorBevor = true;
      result = _paintSubFormula(formula, 0);
    }

    return _replaceSpaces(result);
  }

  String _paintOutsideFormulaReferences(String formula, String result, Iterable<RegExpMatch> bracketMatches) {
    var offset = 0;
    for (var i = 0; i < bracketMatches.length; i++) {
      if (i == 0) {
        offset = 0;
        _operatorBevor = true;
        var subResult = _paintSubFormula(formula.substring(offset, bracketMatches.elementAt(i).start), 0,
            onlyFormulaReference: true);
        result = _replaceRange(result, 0, null, subResult);
      } else {
        offset = bracketMatches.elementAt(i - 1).end;
        _operatorBevor = true;
        var subResult = _paintSubFormula(formula.substring(offset, bracketMatches.elementAt(i).start), 0,
            onlyFormulaReference: true);
        result = _replaceRange(result, offset, null, subResult);
      }

      if (i == bracketMatches.length - 1) {
        offset = bracketMatches.elementAt(i).end;
        _operatorBevor = true;
        var subResult = _paintSubFormula(formula.substring(offset), 0, onlyFormulaReference: true);
        result = _replaceRange(result, offset, null, subResult);
      }
    }

    return result;
  }

  String _paintSubFormula(String formula, int literalOffset, {bool onlyFormulaReference = false}) {
    var offset = 0;
    var result = _buildResultString('t', formula.length);
    var isOperator = false;
    String subResult;
    List<String> _parserResult;

    if (formula.length > 0) {
      // reference
      if (offset == 0) {
        _parserResult = _isFormulaReference(formula);
        if (_parserResult != null) {
          result = _coloredFormulaReference(result, _parserResult);
          offset = _calcOffset(_parserResult);
        } else if (onlyFormulaReference) offset = 1;
      }
      // function
      if (offset == 0) {
        _parserResult = _isFunction(formula);
        if (_parserResult != null) {
          var hasError = _parserResult[2].trim().isEmpty || !_operatorBevor;
          result = _coloredFunction(result, _parserResult, hasError);
          // literal
          offset = _calcOffset(_parserResult, count: 2);
          subResult = formula.substring(offset, _calcOffset(_parserResult, count: 3));

          var _parserSubResult = _isSpecialFunctionsLiteral(subResult, _parserResult);
          subResult = _coloredSpecialFunctionsLiteral(subResult, _parserSubResult);
          result = _replaceRange(result, offset, null, subResult);

          offset = _calcOffset(_parserResult);
        }
      }
      // literal
      if (offset == 0) {
        _parserResult = _isLiteral(formula);
        if (_parserResult != null) {
          offset = _calcOffset(_parserResult, count: 1);
          var literal = formula.substring(offset, _calcOffset(_parserResult, count: 2));
          var emptyLiteral = literal.trim().isEmpty;
          var hasError = emptyLiteral || !_operatorBevor;

          result = _coloredLiteral(result, _parserResult, hasError);
          // literal
          if (!emptyLiteral) {
            _operatorBevor = true;
            subResult = _paintSubFormula(literal, literalOffset + offset);
            if (hasError) subResult = subResult.toUpperCase();
            result = _replaceRange(result, offset, null, subResult);
          }
          offset = _calcOffset(_parserResult);
        }
      }
      // constant
      if (offset == 0) {
        _parserResult = _isConstant(formula);
        if (_parserResult != null) {
          result = _coloredConstant(result, _parserResult, false);
          offset = _calcOffset(_parserResult);
        }
      }
      // variable
      if (offset == 0) {
        _parserResult = _isVariable(formula);
        if (_parserResult != null) {
          result = _coloredVariable(result, _parserResult, _isEmptyVariable(formula));
          offset = _calcOffset(_parserResult);
        }
      }
      // invalid variable
      if (offset == 0) {
        _parserResult = _isInvalidVariable(formula);
        if (_parserResult != null) {
          result = _coloredVariable(result, _parserResult, true);
          offset = _calcOffset(_parserResult);
        }
      }
      // number with point
      if (offset == 0) {
        _parserResult = _isNumberWithPoint(formula);
        if (_parserResult != null) {
          result = _coloredNumber(result, _parserResult, false);
          offset = _calcOffset(_parserResult);
        }
      }
      // number
      if (offset == 0) {
        _parserResult = _isNumber(formula);
        if (_parserResult != null) {
          result = _coloredNumber(result, _parserResult, false);
          offset = _calcOffset(_parserResult);
        }
      }
      // operator
      if (offset == 0) {
        _parserResult = _isOperator(formula, literalOffset);
        if (_parserResult != null) {
          result = _coloredOperator(result, _parserResult, false);
          offset = _calcOffset(_parserResult);
          isOperator = true;
        }
      }
      // invalid operator
      if (offset == 0) {
        _parserResult = _isInvalidOperator(formula);
        if (_parserResult != null) {
          result = _coloredOperator(result, _parserResult, true);
          offset = _calcOffset(_parserResult);
          isOperator = true;
        }
      }
      // faculty
      if (offset == 0) {
        _parserResult = _isFaculty(formula);
        if (_parserResult != null) {
          result = _coloredOperator(result, _parserResult, false);
          offset = _calcOffset(_parserResult);
          isOperator = true;
        }
      }
      // new line
      if (offset == 0) {
        _parserResult = _isNewLine(formula);
        if (_parserResult != null) {
          result = _coloredSpaces(result, _parserResult);
          offset = _calcOffset(_parserResult);
          isOperator = true;
        }
      }

      // spaces
      if (offset == 0) {
        _parserResult = _isSpaces(formula);
        if (_parserResult != null) {
          result = _coloredSpaces(result, _parserResult);
          offset = _calcOffset(_parserResult);
          isOperator = _operatorBevor;
        }
      }

      // undefnied ?
      if (offset == 0) {
        subResult = 'R';
        if (_bracket.containsKey(formula[0])) subResult = 'B';
        if (_bracket.containsValue(formula[0])) subResult = 'B';
        if (formula[0] == ',') subResult = 'B';
        result = _replaceRange(result, offset, subResult.length, subResult);
        offset = subResult.length;
        isOperator = _operatorBevor;
      }

      // analyse rest recursive
      if (offset < formula.length) {
        _operatorBevor = isOperator;
        subResult = formula.substring(offset);
        subResult = _paintSubFormula(subResult, literalOffset + offset, onlyFormulaReference: onlyFormulaReference);
        result = _replaceRange(result, offset, null, subResult);
      }
    }

    return result;
  }

  List<String> _isSpaces(String formula) {
    RegExp regex = RegExp(r'^(\s*)');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)];
  }

  List<String> _isNewLine(String formula) {
    RegExp regex = RegExp(r'^([\r\n])');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)];
  }

  String _coloredSpaces(String result, List<String> parts) {
    return _replaceRange(result, 0, parts[0].length, 'S');
  }

  List<String> _isFormulaReference(String formula) {
    RegExp regex = RegExp(r'^({)([1-9][0-9]*)(})');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(1), match.group(2), match.group(3)];
  }

  String _coloredFormulaReference(String result, List<String> parts) {
    result = _replaceRange(result, 0, parts[0].length, 'b');
    if (int.tryParse(parts[1]) < _formulaId)
      result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, 'b');
    else
      result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, 'B');
    result = _replaceRange(result, _calcOffset(parts, count: 2), parts[2].length, 'b');

    return result;
  }

  List<String> _isFunction(String formula) {
    RegExp regex = RegExp(r'^\b(' + _functionsRegEx + r')\b(\s*)(\()');
    var match = regex.firstMatch(formula);

    if (match == null) return null;
    var functionName = _combineGroups([match.group(1), match.group(2)]);
    var offset = functionName.length;
    var result = _separateLiteral(formula.substring(offset), '(', ')');

    if (result == null) return null;

    return [
      _combineGroups([functionName, result[0]]),
      result[1],
      result[2],
      result[3]
    ];
  }

  String _coloredFunction(String result, List<String> parts, bool hasError) {
    result = _replaceRange(result, 0, parts[0].length, hasError ? 'B' : 'b');
    result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, hasError ? 'B' : 'b');
    result = _replaceRange(result, _calcOffset(parts, count: 3), parts[3].length, hasError ? 'B' : 'b');

    return result;
  }

  List<String> _isSpecialFunctionsLiteral(String formula, List<String> parts) {
    var functionName = parts[0].trim();

    var result = <String>[];
    var arguments = _separateArguments(formula);
    var maxCommaCount;
    var minCommaCount = 0;
    switch (functionName) {
      case 'LOG':
        minCommaCount = 1;
        maxCommaCount = minCommaCount;
        break;
      case 'NTH':
        minCommaCount = 0;
        maxCommaCount = 2;
        break;
      case 'ROUND':
        minCommaCount = 0;
        maxCommaCount = 1;
        break;
      case 'NRT':
        maxCommaCount == minCommaCount;
        break;
      case 'MIN':
      case 'MAX':
      case 'CS':
      case 'CSI':
        break;
      case 'BWW':
      case 'AV':
      case 'LEN':
        maxCommaCount == minCommaCount;
        break;
      default:
        maxCommaCount = minCommaCount;
    }
    minCommaCount = minCommaCount * 2 + 1; // ${number commas} * 2 + 1
    maxCommaCount = maxCommaCount == null ? null : maxCommaCount * 2 + 1;
    if (arguments.length < minCommaCount) return null;

    _parentFunctionName = functionName;
    for (var i = 0; i < arguments.length; i++) {
      if (maxCommaCount != null && i >= maxCommaCount) {
        var subresult = _paintSubFormula(arguments[i], 0);
        result.add(subresult.toUpperCase());
      } else if (arguments[i] == ',')
        result.add(_wordFunction(functionName) ? 'g' : 'b');
      else {
        _operatorBevor = true;
        var subresult = _paintSubFormula(arguments[i], 0);
        if (_wordFunction(functionName) && _emptyValues()) subresult = subresult.replaceAll('R', 'g');
        result.add(subresult);
      }
    }
    _parentFunctionName = null;

    return result;
  }

  bool _wordFunction(String functionName) {
    switch (functionName) {
      case 'BWW':
      case 'AV':
      case 'LEN':
        return true;
      default:
        return false;
    }
  }

  bool _numberFunction(String functionName) {
    switch (functionName) {
      case 'MIN':
      case 'MAX':
      case 'CS':
      case 'CSI':
        return true;
      default:
        return false;
    }
  }

  String _coloredSpecialFunctionsLiteral(String result, List<String> parts) {
    if (parts != null) {
      for (var i = 0; i < parts.length; i++)
        result = _replaceRange(result, _calcOffset(parts, count: i), null, parts[i]);
    } else
      result = _buildResultString('R', result.length);

    return result;
  }

  List<String> _isFaculty(String formula) {
    RegExp regex = RegExp(r'^(\s*)(!)(\s*)');

    var match = regex.firstMatch(formula);
    if (match == null) return null;

    regex = RegExp(r'(\d)');
    var matchNumber = regex.firstMatch(this.formula);
    regex = RegExp(r'(' + _variablesRegEx + ')');
    var matchVariable = regex.firstMatch(this.formula);

    return (matchNumber == null && matchVariable == null) ? null : [match.group(0)];
  }

  List<String> _isLiteral(String formula) {
    RegExp regex = RegExp(r'^([\(\{])');
    var match = regex.firstMatch(formula);

    if (match == null) return null;
    var result = _separateLiteral(formula.substring(match.start), match.group(1), _bracket[match.group(1)]);

    if (result == null) return null;
    return [result[1], result[2], result[3]];
  }

  String _coloredLiteral(String result, List<String> parts, bool hasError) {
    result = _replaceRange(result, 0, parts[0].length, hasError ? 'B' : 'b');
    result = _replaceRange(result, _calcOffset(parts, count: 2), parts[2].length, hasError ? 'B' : 'b');
    if (hasError) result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, 'B');

    return result;
  }

  String _coloredContent(String result, List<String> parts, bool hasError) {
    result = _replaceRange(result, parts[0].length, parts[1].length, hasError ? 'B' : 'b');
    result = _replaceRange(result, _calcOffset(parts, count: 3), parts[3].length, hasError ? 'B' : 'b');
    if (hasError) result = _replaceRange(result, _calcOffset(parts, count: 2), parts[2].length, 'B');

    return result;
  }

  List<String> _isConstant(String formula) {
    //extract all non-ascii chars, like Pi or Phi
    var specialChars = _constantsRegEx.replaceAll(RegExp(r'[A-Za-z0-9\|_]'), '');
    //add special chars to allowed character (next to \w == ASCII chars)
    var wordChars = r'[\w' + specialChars + r']';
    // \b does not allow non-ASCII chars
    //https://stackoverflow.com/a/61754724/3984221
    // so, \b must be manipulated. Following expressing equals the internal representation of \b, which is now enhanced
    // to use the specialChars as well
    //https://stackoverflow.com/a/12712840/3984221
    var wordBoundary = '(?:(?<!$wordChars)(?=$wordChars)|(?<=$wordChars)(?!$wordChars))';
    RegExp regex = RegExp('^$wordBoundary(' + _constantsRegEx + ')$wordBoundary');

    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)];
  }

  String _coloredConstant(String result, List<String> parts, bool hasError) {
    return _replaceRange(result, 0, parts[0].length, hasError ? 'G' : 'g');
  }

  List<String> _isVariable(String formula) {
    var match = _variableMatch(formula);

    return (match == null) ? null : [match.group(0)];
  }

  bool _isEmptyVariable(String formula) {
    var match = _variableMatch(formula);
    if (match == null) return true;

    var variableValue = _variableValue(match.group(1));
    return variableValue == null || variableValue.isEmpty;
  }

  String _variableValue(String variable) {
    if ((_values == null) || !_values.containsKey(variable)) return null;
    return _values[variable];
  }

  /// return VariableName (group(1))
  RegExpMatch _variableMatch(String formula) {
    if (_variablesRegEx.isEmpty) return null;
    RegExp regex = RegExp(r'^(' + _variablesRegEx + ')');
    return regex.firstMatch(formula);
  }

  bool _emptyValues() {
    return (_values == null) || (_values.isEmpty);
  }

  List<String> _isInvalidVariable(String formula) {
    RegExp regex = RegExp(r'^(\S)');
    var match = regex.firstMatch(formula);

    if ((match != null) && (_allCharacters.contains(match.group(1))))
      return [match.group(0)];
    else
      return null;
  }

  String _coloredVariable(String result, List<String> parts, bool hasError) {
    var char = hasError ? 'R' : 'r';
    if (hasError && _wordFunction(_parentFunctionName))
      char = _coloredWordFunctionVariable(parts[0]);
    else if (_numberFunction(_parentFunctionName)) char = _coloredNumberFunctionVariable(parts[0]);

    return _replaceRange(result, 0, parts[0].length, char);
  }

  String _coloredWordFunctionVariable(String variable) {
    return (_isVariable(variable) == null || !_isEmptyVariable(variable)) ? 'g' : 'R';
  }

  String _coloredNumberFunctionVariable(String variable) {
    var variableValue = _variableValue(variable);
    if ((variableValue == null) || variableValue.isEmpty) return 'R';
    if (_isNumberWithPoint(variableValue) == null) return 'R';

    return 'r';
  }

  List<String> _isNumberWithPoint(String formula) {
    RegExp regex = RegExp('^$numberRegEx');
    var match = regex.firstMatch(formula);
    if (match == null) return null;

    var value = double.tryParse(match.group(0));
    return (value == null) ? null : [match.group(0)];
  }

  List<String> _isNumber(String formula) {
    RegExp regex = RegExp(r'^(\d)+');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)];
  }

  String _coloredNumber(String result, List<String> parts, bool hasError) {
    hasError |= !_operatorBevor;
    return _replaceRange(result, 0, parts[0].length, hasError ? 'G' : 'g');
  }

  List<String> _isOperator(String formula, var offset) {
    var regex = RegExp(r'^([' + _operatorsRegEx + r'])(\s*)(\-)*(\s*)([^' + _operatorsRegEx + '])');
    var match = regex.firstMatch(formula);

    if ((match != null) && (offset == 0) && (match.group(0)[0] != '-')) return null;
    return (match == null)
        ? null
        : [
            _combineGroups([match.group(1), match.group(2), match.group(3), match.group(4)])
          ];
  }

  List<String> _isInvalidOperator(String formula) {
    var regex = RegExp(r'^([' + _operatorsRegEx + ']+)');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)];
  }

  String _coloredOperator(String result, List<String> parts, bool hasError) {
    return _replaceRange(result, 0, parts[0].length, hasError ? 'B' : 'b');
  }

  String _replaceRange(String string, int start, int length, String replacement) {
    if (length == null)
      return string.replaceRange(start, start + replacement.length, replacement);
    else
      return string.replaceRange(start, start + length, replacement * length);
  }

  int _calcOffset(List<String> list, {int count = -1}) {
    var length = 0;
    for (var i = 0; i < list.length; i++) {
      if ((count >= 0) && (i >= count)) break;
      length += list[i].length;
    }
    return length;
  }

  List<String> _toUpperCaseAndSort(List<String> list) {
    list = list.map((entry) {
      return entry.toUpperCase();
    }).toList();
    list.sort((a, b) => b.length.compareTo(a.length));
    return list;
  }

  String _buildResultString(String s, int count) {
    return s * count;
  }

  List<String> _separateLiteral(String formula, String openBracket, String closeBracket) {
    var bracketCounter = 0;
    var bracketPosition = -1;

    for (var i = 0; i < formula.length; i++) {
      if (formula[i] == openBracket) {
        bracketCounter++;
        if (bracketPosition < 0) bracketPosition = i;
      } else if ((formula[i] == closeBracket) && (bracketCounter > 0)) {
        bracketCounter--;
        if (bracketCounter == 0)
          return [
            formula.substring(0, bracketPosition),
            formula[bracketPosition],
            formula.substring(bracketPosition + 1, i),
            formula[i]
          ];
      }
    }

    return null;
  }

  List<String> _separateArguments(String formula) {
    const String separator = ',';
    var arguments = <String>[];
    var startIndex = 0;

    for (int i = 0; i < formula.length; i++) {
      if (formula[i] == separator) {
        //if (arguments.isNotEmpty) arguments.add(separator);
        arguments.add(formula.substring(startIndex, i));
        startIndex = i + 1;
        arguments.add(separator);
        // empty argument ?
        if (startIndex == formula.length) {
          arguments.add("");
        }
      } else if (_bracket.containsKey(formula[i])) {
        var literal = _separateLiteral(formula.substring(i), formula[i], _bracket[formula[i]]);

        if (literal != null) {
          var literalString = _combineGroups(literal);
          i += literalString.length - 1;
        }
      }
    }
    if ((formula.length - startIndex > 0) || (arguments.length == 0)) arguments.add(formula.substring(startIndex));

    return arguments;
  }

  String _combineGroups(List<String> list) {
    return list.map((e) {
      return e == null ? '' : e;
    }).join();
  }

  String _replaceSpaces(String result) {
    for (var i = 1; i < result.length; i++) if (result[i] == 'S') result = _replaceRange(result, i, 1, result[i - 1]);

    for (var i = result.length - 2; i > 0; i--)
      if (result[i] == 'S') result = _replaceRange(result, i, 1, result[i + 1]);

    return result;
  }
}
