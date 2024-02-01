import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

class FormulaPainter {
  static const String _Text = 't'; //text
  static const String _Space = 'S'; //space
  static const String Number = 'g'; // or character in word function or ' "
  static const String NumberError = 'G'; //or character in word function error
  static const String Variable = 'r'; //variable
  static const String VariableError = 'R'; //variable error
  static const String OFRB = 'b'; //operator, function, reference, bracket
  static const String OFRBError = 'B'; //operator, function, reference, bracket error
  static const _operators = {'+', '-', '*', '/', '^', '%'};
  static const _bracket = {'[': ']', '(': ')', '{': '}'};
  static const _numberRegEx = r'(\s*(\d+.\d*|\d*\.\d|\d+)\s*)';
  static const _STRING_MARKER_APOSTROPHE = "'";
  static const _STRING_MARKER_QUOTE = '"';

  static final _allCharacters = allCharacters();
  var _variables = <FormulaValue>[];
  var _functions = <String>[];
  var _constants = <String>[];
  late int _formulaId;
  late bool _operatorBevor;
  var _stringBevor = false;
  String? _parentFunctionName;
  late String formula;

  late String _operatorsRegEx;
  late String _functionsRegEx;
  late String _constantsRegEx;
  late String _variablesRegEx;

  FormulaPainter() {
    _functions = _toUpperCaseAndSort(FormulaParser.availableParserFunctions());
    _constants = _toUpperCaseAndSort(FormulaParser.CONSTANTS.keys.toList());

    _operatorsRegEx = _operators.map((op) => r'\' + op).join();
    _functionsRegEx = _functions.map((function) => function).join('|');
    _constantsRegEx = _constants.map((constant) => constant).join('|');
  }

  String paintFormula(String formula, List<FormulaValue> values, int formulaIndex, bool coloredFormulas) {
    var result = _buildResultString(_Text, formula.length);
    if (!coloredFormulas) return result;

    var subResult = '';
    _formulaId = formulaIndex;

    _variables = values.map((value) => FormulaValue(value.key.toUpperCase(), value.value, type: value.type)).toList();

    _variables = _variablesSort(_variables);
    _variablesRegEx = _variables.map((variable) => variable.key).join('|');

    formula = normalizeCharacters(formula);
    formula = FormulaParser.normalizeMathematicalSymbols(formula);
    formula = formula.toUpperCase();
    this.formula = formula;

    RegExp regExp = RegExp(r'(\[)(.+?|\s*)(\])');
    var matches = regExp.allMatches(formula);
    if (matches.isNotEmpty) {
      // formel references
      result = _paintOutsideFormulaReferences(formula, result, matches);

      for (var match in matches) {
        var _parserResult = [formula.substring(0, match.start), match.group(1), match.group(2), match.group(3)];
        var literal = _parserResult[2];
        var emptyLiteral = (literal ?? '').trim().isEmpty;
        result = _coloredContent(result, _parserResult, emptyLiteral);

        _operatorBevor = true;
        subResult = _paintSubFormula(literal ?? '', 0);
        result = _replaceRange(result, _calcOffset(_parserResult, count: 2), null, subResult);
      }
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
    if (formula.isEmpty) return '';
    var result = _buildResultString(_Text, formula.length);
    var isOperator = false;
    var isString = false;
    String subResult;
    List<String>? _parserResult;

    // reference
    if (offset == 0) {
      _parserResult = _isFormulaReference(formula);
      if (_parserResult != null) {
        result = _coloredFormulaReference(result, _parserResult);
        offset = _calcOffset(_parserResult);
      } else if (onlyFormulaReference) {
        offset = 1;
      }
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
        result = _coloredNumber(result, _parserResult, _wordFunction(_parentFunctionName), false);
        offset = _calcOffset(_parserResult);
      }
    }
    // number
    if (offset == 0) {
      _parserResult = _isNumber(formula);
      if (_parserResult != null) {
        result = _coloredNumber(result, _parserResult, _wordFunction(_parentFunctionName), false);
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
    // string
    if (offset == 0) {
      _parserResult = _isString(formula);
      if (_parserResult != null) {
        result = _coloredNumber(
            result, _parserResult, _parentFunctionName != null && !_wordFunction(_parentFunctionName), true);
        offset = _calcOffset(_parserResult);
        isString = true;
      }
    }
    // invalid string
    if (offset == 0) {
      _parserResult = _isInvalidString(formula);
      if (_parserResult != null) {
        result = _coloredNumber(result, _parserResult, true, false);
        offset = _calcOffset(_parserResult);
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
        isString = _stringBevor;
      }
    }

    // undefnied ?
    if (offset == 0) {
      subResult = VariableError;
      if (_bracket.containsKey(formula[0])) subResult = OFRBError;
      if (_bracket.containsValue(formula[0])) subResult = OFRBError;
      if (formula[0] == ',') subResult = OFRBError;
      result = _replaceRange(result, offset, subResult.length, subResult);
      offset = subResult.length;
      isOperator = _operatorBevor;
      isString = _stringBevor;
    }

    // analyse rest recursive
    if (offset < formula.length) {
      _operatorBevor = isOperator;
      _stringBevor = isString;
      subResult = formula.substring(offset);
      subResult = _paintSubFormula(subResult, literalOffset + offset, onlyFormulaReference: onlyFormulaReference);
      result = _replaceRange(result, offset, null, subResult);
    }

    return result;
  }

  List<String>? _isSpaces(String formula) {
    RegExp regex = RegExp(r'^(\s*)');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)!];
  }

  List<String>? _isNewLine(String formula) {
    RegExp regex = RegExp(r'^([\r\n])');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)!];
  }

  String _coloredSpaces(String result, List<String> parts) {
    return _replaceRange(result, 0, parts[0].length, _Space);
  }

  List<String>? _isFormulaReference(String formula) {
    RegExp regex = RegExp(r'^({)([1-9]\d*)(})');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(1)!, match.group(2)!, match.group(3)!];
  }

  String _coloredFormulaReference(String result, List<String> parts) {
    result = _replaceRange(result, 0, parts[0].length, OFRB);
    if ((int.tryParse(parts[1]) ?? 9999999) < _formulaId) {
      result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, OFRB);
    } else {
      result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, OFRBError);
    }
    result = _replaceRange(result, _calcOffset(parts, count: 2), parts[2].length, OFRB);

    return result;
  }

  List<String>? _isFunction(String formula) {
    RegExp regex = RegExp(r'^\b(' + _functionsRegEx + r')\b(\s*)(\()');
    var match = regex.firstMatch(formula);

    if (match == null) return null;
    var functionName = _combineGroups([match.group(1)!, match.group(2)!]);
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
    result = _replaceRange(result, 0, parts[0].length, hasError ? OFRBError : OFRB);
    result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, hasError ? OFRBError : OFRB);
    result = _replaceRange(result, _calcOffset(parts, count: 3), parts[3].length, hasError ? OFRBError : OFRB);

    return result;
  }

  List<String>? _isSpecialFunctionsLiteral(String formula, List<String> parts) {
    var functionName = parts[0].trim();

    var result = <String>[];
    var arguments = _separateArguments(formula);
    int? maxCommaCount;
    int minCommaCount = 0;
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
        maxCommaCount = null;
        break;
      case 'MIN':
      case 'MAX':
      case 'CS':
      case 'CSI':
        break;
      case 'AV':
      case 'LEN':
        maxCommaCount = null;
        break;
      default:
        maxCommaCount = minCommaCount;
    }
    minCommaCount = minCommaCount * 2 + 1;
    maxCommaCount = maxCommaCount == null ? null : maxCommaCount * 2 + 1;
    if (arguments.length < minCommaCount) return null;

    _parentFunctionName = functionName;
    for (var i = 0; i < arguments.length; i++) {
      if (maxCommaCount != null && i >= maxCommaCount) {
        var subresult = _paintSubFormula(arguments[i], 0);
        result.add(subresult.toUpperCase());
      } else if (arguments[i] == ',') {
        result.add(_wordFunction(functionName) ? Number : OFRB);
      } else {
        _operatorBevor = true;
        var subresult = _paintSubFormula(arguments[i], 0);
        result.add(subresult);
      }
    }
    _parentFunctionName = null;

    return result;
  }

  bool _wordFunction(String? functionName) {
    switch (functionName) {
      case 'BWW':
      case 'AV':
      case 'LEN':
        return true;
      default:
        return false;
    }
  }

  bool _numberFunction(String? functionName) {
    switch (functionName) {
      case 'MIN':
      case 'MAX':
      case 'CS':
      case 'CSI':
      case 'NTH':
        return true;
      default:
        return false;
    }
  }

  String _coloredSpecialFunctionsLiteral(String result, List<String>? parts) {
    if (parts != null) {
      for (var i = 0; i < parts.length; i++) {
        result = _replaceRange(result, _calcOffset(parts, count: i), null, parts[i]);
      }
    } else {
      result = _buildResultString(VariableError, result.length);
    }

    return result;
  }

  List<String>? _isFaculty(String formula) {
    RegExp regex = RegExp(r'^(\s*)(!)(\s*)');

    var match = regex.firstMatch(formula);
    if (match == null) return null;

    regex = RegExp(r'(\d)');
    var matchNumber = regex.firstMatch(this.formula);
    regex = RegExp(r'(' + _variablesRegEx + ')');
    var matchVariable = regex.firstMatch(this.formula);

    return (matchNumber == null || matchVariable == null) ? null : [match.group(0)!];
  }

  List<String>? _isLiteral(String formula) {
    RegExp regex = RegExp(r'^([({])');
    var match = regex.firstMatch(formula);

    if (match == null) return null;
    var result = _separateLiteral(formula.substring(match.start), match.group(1)!, _bracket[match.group(1)]!);

    if (result == null) return null;
    return [result[1], result[2], result[3]];
  }

  List<String>? _isString(String formula) {
    RegExp regex = RegExp('^([' + _STRING_MARKER_APOSTROPHE + _STRING_MARKER_QUOTE + '])(?:(?=(\\\\?))\\2.)*?\\1');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)!];
  }

  List<String>? _isInvalidString(String formula) {
    if (formula.startsWith(_STRING_MARKER_APOSTROPHE) || formula.startsWith(_STRING_MARKER_QUOTE)) return [formula];
    return null;
  }

  String _coloredLiteral(String result, List<String> parts, bool hasError) {
    result = _replaceRange(result, 0, parts[0].length, hasError ? OFRBError : OFRB);
    result = _replaceRange(result, _calcOffset(parts, count: 2), parts[2].length, hasError ? OFRBError : OFRB);
    if (hasError) result = _replaceRange(result, _calcOffset(parts, count: 1), parts[1].length, OFRBError);

    return result;
  }

  String _coloredContent(String result, List<String?> parts, bool hasError) {
    result = _replaceRange(result, (parts[0] ?? '').length, (parts[1] ?? '').length, hasError ? OFRBError : OFRB);
    result = _replaceRange(result, _calcOffset(parts, count: 3), (parts[3] ?? '').length, hasError ? OFRBError : OFRB);
    if (hasError) result = _replaceRange(result, _calcOffset(parts, count: 2), (parts[2] ?? '').length, OFRBError);

    return result;
  }

  List<String>? _isConstant(String formula) {
    //extract all non-ascii chars, like Pi or Phi
    var specialChars = _constantsRegEx.replaceAll(RegExp(r'[A-Za-z0-9|_]'), '');
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

    return (match == null) ? null : [match.group(0)!];
  }

  String _coloredConstant(String result, List<String?> parts, bool hasError) {
    return _replaceRange(result, 0, parts[0]?.length, hasError ? NumberError : Number);
  }

  List<String>? _isVariable(String formula) {
    var match = _variableMatch(formula);

    return (match == null) ? null : [match.group(0)!];
  }

  bool _isEmptyVariable(String formula) {
    var match = _variableMatch(formula);
    if (match == null) return true;

    var variableValue = _variableValue(match.group(1)!);
    var result = variableValue == null || variableValue.isEmpty;
    if (result) return result;
    var stringResult = _isString(variableValue);
    return stringResult != null && stringResult.first.length <= 2;
  }

  bool _isStringVariable(String variable) {
    var match = _variableMatch(variable);
    if (match == null) return true;

    var variableValue = _variableValue(match.group(1)!);
    if (variableValue == null) return false;
    var result = _isString(variableValue);
    return (result != null && result[0].length == variableValue.length);
  }

  bool _isNumberVariable(String variable) {
    var match = _variableMatch(variable);
    if (match == null) return true;

    var variableValue = _variableValue(match.group(1)!);
    if (variableValue != null &&
        variableValue.isNotEmpty &&
        _variableType(match.group(1)!) == FormulaValueType.INTERPOLATED) {
      var expanded = VariableStringExpander('x', {'x': variableValue}, orderAndUnique: false)
          .run()
          .map((e) => e.text)
          .whereType<String>()
          .toList();
      return (expanded.isNotEmpty) && expanded.first != 'x';
    }
    return (variableValue != null &&
        ((_isNumberWithPoint(variableValue) != null) ||
            _isFunction(variableValue.trim()) != null)); // !_isStringVariable(variable);
  }

  FormulaValueType? _variableType(String variable) {
    for (var _variable in _variables) {
      if (_variable.key == variable) return _variable.type;
    }
    return null;
  }

  String? _variableValue(String variable) {
    for (var _variable in _variables) {
      if (_variable.key == variable) return _variable.value.toUpperCase();
    }
    return null;
  }

  /// return VariableName (group(1))
  RegExpMatch? _variableMatch(String formula) {
    if (_variablesRegEx.isEmpty) return null;
    RegExp regex = RegExp(r'^(' + _variablesRegEx + ')');
    return regex.firstMatch(formula);
  }

  List<String>? _isInvalidVariable(String formula) {
    RegExp regex = RegExp(r'^(\S)');
    var match = regex.firstMatch(formula);

    if ((match != null) && (_allCharacters.contains(match.group(1)))) {
      return [match.group(0)!];
    } else {
      return null;
    }
  }

  String _coloredVariable(String result, List<String> parts, bool hasError) {
    var char = hasError ? VariableError : Variable;
    if (_wordFunction(_parentFunctionName) || _stringBevor) {
      char = _coloredWordFunctionVariable(parts[0]);
      _operatorBevor = true;
    } else if (_numberFunction(_parentFunctionName)) {
      char = _coloredNumberFunctionVariable(parts[0]);
    }
    return _replaceRange(result, 0, parts[0].length, char);
  }

  String _coloredWordFunctionVariable(String variable) {
    if (_isVariable(variable) == null) return NumberError;
    return (_isStringVariable(variable)) ? Variable : VariableError;
  }

  String _coloredNumberFunctionVariable(String variable) {
    var variableValue = _variableValue(variable);
    if ((variableValue == null) || variableValue.isEmpty) return VariableError;
    return (_isNumberVariable(variable)) ? Variable : VariableError;
  }

  List<String>? _isNumberWithPoint(String formula) {
    RegExp regex = RegExp('^$_numberRegEx');
    var match = regex.firstMatch(formula);
    if (match == null) return null;

    var value = double.tryParse(match.group(0)!);
    return (value == null) ? null : [match.group(0)!];
  }

  List<String>? _isNumber(String formula) {
    RegExp regex = RegExp(r'^(\d)+');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)!];
  }

  String _coloredNumber(String result, List<String> parts, bool hasError, bool stringValue) {
    hasError |= (!_operatorBevor && !_wordFunction(_parentFunctionName) && !stringValue); // ||
    //(stringValue && _parentFunctionName == null && !_isString(formula)); //
    return _replaceRange(result, 0, parts[0].length, hasError ? NumberError : Number);
  }

  List<String>? _isOperator(String formula, int offset) {
    var regex = RegExp(r'^([' + _operatorsRegEx + r'])(\s*)(\-)*(\s*)([^' + _operatorsRegEx + '])');
    var match = regex.firstMatch(formula);

    if ((match != null) && (offset == 0) && (match.group(0)![0] != '-')) return null;
    return (match == null)
        ? null
        : [
            _combineGroups([match.group(1), match.group(2), match.group(3), match.group(4)])
          ];
  }

  List<String>? _isInvalidOperator(String formula) {
    var regex = RegExp(r'^([' + _operatorsRegEx + ']+)');
    var match = regex.firstMatch(formula);

    return (match == null) ? null : [match.group(0)!];
  }

  String _coloredOperator(String result, List<String> parts, bool hasError) {
    return _replaceRange(result, 0, parts[0].length, hasError ? OFRBError : OFRB);
  }

  String _replaceRange(String string, int start, int? length, String replacement) {
    try {
      if (length == null) {
        return string.replaceRange(start, start + replacement.length, replacement);
      } else {
        return string.replaceRange(start, start + length, replacement * length);
      }
    } catch (e) {
      return string;
    }
  }

  int _calcOffset(List<String?> list, {int count = -1}) {
    var length = 0;
    for (var i = 0; i < list.length; i++) {
      if ((count >= 0) && (i >= count)) break;
      length += list[i]?.length ?? 0;
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

  List<FormulaValue> _variablesSort(List<FormulaValue> list) {
    list.sort((a, b) => b.key.length.compareTo(a.key.length));
    return list;
  }

  String _buildResultString(String s, int count) {
    return s * count;
  }

  List<String>? _separateLiteral(String formula, String openBracket, String closeBracket) {
    var bracketCounter = 0;
    var bracketPosition = -1;

    for (var i = 0; i < formula.length; i++) {
      if (formula[i] == openBracket) {
        bracketCounter++;
        if (bracketPosition < 0) bracketPosition = i;
      } else if ((formula[i] == closeBracket) && (bracketCounter > 0)) {
        bracketCounter--;
        if (bracketCounter == 0) {
          return [
            formula.substring(0, bracketPosition),
            formula[bracketPosition],
            formula.substring(bracketPosition + 1, i),
            formula[i]
          ];
        }
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
          arguments.add('');
        }
      } else if (_bracket.containsKey(formula[i])) {
        var literal = _separateLiteral(formula.substring(i), formula[i], _bracket[formula[i]]!);

        if (literal != null) {
          var literalString = _combineGroups(literal);
          i += literalString.length - 1;
        }
      }
    }
    if ((formula.length - startIndex > 0) || (arguments.isEmpty)) arguments.add(formula.substring(startIndex));

    return arguments;
  }

  String _combineGroups(List<String?> list) {
    var result = '';
    for (String? char in list) {
      if (char != null) result += char;
    }
    return result;
  }

  String _replaceSpaces(String result) {
    for (var i = 1; i < result.length; i++) {
      if (result[i] == _Space) result = _replaceRange(result, i, 1, result[i - 1]);
    }

    for (var i = result.length - 2; i > 0; i--) {
      if (result[i] == _Space) result = _replaceRange(result, i, 1, result[i + 1]);
    }

    return result;
  }
}
