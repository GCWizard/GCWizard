import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:gc_wizard/utils/json_utils.dart';
import 'package:math_expressions/math_expressions.dart';

class VerbalArithmeticJobData {
  final List<String> equations;
  final Map<String, String> substitutions;

  VerbalArithmeticJobData({
    required this.equations,
    required this.substitutions,
  });
}

class VerbalArithmeticOutput {
  final List<Equation> equations;
  final HashMap<String, int>? solutions;
  final String error;

  VerbalArithmeticOutput({
    required this.equations,
    required this.solutions,
    required this.error,
  });
}

const Map<String, String> operatorList = {
  '+':'+',
  '-':'-',
  '*':'*',
  '÷':'/'
};


final parser = Parser();

class Equation {
  late String equation;
  late String formatedEquation;
  late Expression exp;
  late List<Token> token;
  bool onlyAddition = false;
  bool singleLetter = false;
  bool validFormula = true;
  Set<String> usedMembers = <String>{};
  Set<String> leadingLetters = <String>{};

  Equation(this.equation, {this.singleLetter = false}) {
    equation = equation.toUpperCase();
    formatedEquation = equation.replaceAll(' ', '').replaceAll('==', '=');

    if (singleLetter) {
      // Extract all letters and determine the leading letters
      for (var token in formatedEquation.split(RegExp(r'[^A-Z]'))) {
        if (token.isNotEmpty) {
          usedMembers.addAll(token.split(''));
          leadingLetters.add(token[0]);
        }
      }
    } else {
      if (formatedEquation.contains('=')) {
        var members = formatedEquation.split('=');
        formatedEquation = members[0] + '-(' + members[1]+ ')';
        validFormula &= !(members.length > 2);
      }
      token = parser.lex.tokenize(formatedEquation);
      exp = parser.parse(formatedEquation);

      usedMembers = token.where((t) => t.type == TokenType.VAR).map((t) => t.text).toSet();
    }
  }

  Iterable<int> get Values {
    return token.where((t) => t.type == TokenType.VAL).map((t) => int.parse(t.text));
  }

  String getOutput(HashMap<String, int> result) {
    return replaceValues(equation, result);
  }

  static String replaceValues(String equation, Map<String, int> mapping) {
    for (var key in mapping.keys) {
      equation = equation.replaceAll(key, mapping[key].toString());
    }
    return equation;
  }
}

class SymbolMatrixString {
  static List<String> buildEquations(String input) {
    if (input.trim().isEmpty) return [];
    var formulas = const LineSplitter().convert(input);
    formulas.removeWhere((formula) => formula.trim().isEmpty);
    formulas = formulas.map((formula) => formula.trim()).toList();
    return formulas;
  }
}

class SymbolMatrixGrid {
  List<List<String>> matrix = [];
  Map<String, String> substitutions = {};
  late int columnCount;
  late int rowCount;

  SymbolMatrixGrid (this.rowCount, this.columnCount, {SymbolMatrixGrid? oldMatrix}) {
    matrix = <List<String>>[];
    for(var y = 0; y < getRowsCount(); y++) {
      matrix.add(List<String>.filled(getColumnsCount(), ''));
    }

    if (oldMatrix != null) {
      for(var y = 0; y < min(matrix.length, oldMatrix.matrix.length); y++) {
        for (var x = 0; x < min(matrix[y].length, oldMatrix.matrix[y].length); x++) {
          matrix[y][x] = oldMatrix.matrix[y][x];
        }
      }
    }
  }

  int getColumnsCount() {
    return columnCount * 2 + 1;
  }
  int getRowsCount() {
    return rowCount * 2 + 1;
  }

    String? getOperator(int y, int x) {
    if  (!_validPosition(y, x)) {
      return null;
    }
    var value = matrix[y][x];
    if (!operatorList.containsKey(value)) {
      value = operatorList.keys.first;
      setValue(y, x, value);
    }
    return value;
  }

  String? getValue(int y, int x) {
    if (!_validPosition(y, x)) {
      return null;
    }
    return matrix[y][x];
  }

    void setValue(int y, int x, String text) {
    if (!_validPosition(y, x)) {
      return;
    }
    matrix[y][x] = text;
  }

  bool _validPosition(int y, int x) {
    return !(y >= matrix.length || matrix[y].isEmpty || x >= matrix[y].length);
  }

  bool isValidMatrix() {
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (y % 2 == 0) {
          if (x % 2 == 0) {
            if (matrix[y][x].isEmpty) {
              return false;
            }
          } else if (x < getColumnsCount() - 2 && y < getRowsCount() - 2) {
            if (!operatorList.keys.contains(matrix[y][x])) {
              return false;
            }
          }
        } else {
          if (x % 2 == 0 && x < getColumnsCount() - 1) {
            if ((y < getRowsCount() - 2) && (!operatorList.keys.contains(matrix[y][x]))) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  String buildRowEquation(int y) {
    var formula = '';
    for (var x = 0; x < matrix[y].length; x++) {
      if (x % 2 == 0) {
        formula += matrix[y][x];
      } else if (x < getColumnsCount() - 2) {
        formula += operatorList[matrix[y][x]]!;
      } else {
        formula += '-('; //=
      }
    }
    return formula + ')';
  }

  String buildColumnEquation(int x) {
    var formula = '';
    for (var y = 0; y < matrix.length; y++) {
      if (y % 2 == 0) {
        formula += matrix[y][x];
      } else if (y < getRowsCount() - 2) {
        formula += operatorList[matrix[y][x]]!;
      }else {
        formula += '-('; //=
      }
    }
    return formula + ')';
  }

  List<String> buildEquations() {
    var equations = <String>[];

    if (!isValidMatrix()) return equations;
    for(var y = 0; y < getRowsCount()-2; y += 2){
      equations.add(buildRowEquation(y));
    }
    for(var x = 0; x < getColumnsCount()-2; x += 2){
      equations.add(buildColumnEquation(x));
    }
    return equations;
  }

  String toJson() {
    var list = <String>[];
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x].isNotEmpty) {
          list.add(({'x': x, 'y': y, 'v': matrix[y][x]}).toString());
        }
      }
    }

    return (jsonEncode({'columns': columnCount, 'rows': rowCount,
      'values': list.toString(), 'substitutions': _toJsonSubstitutions(substitutions)}).toString());
  }

  static String? _toJsonSubstitutions(Map<String, String>? substitutions) {
    if (substitutions == null) return null;
    var list = <String>[];
    substitutions.forEach((key, value) {
      list.add(jsonEncode({'key': key, 'value': value}));
    });

    if (list.isEmpty) return null;

    return jsonEncode(list);
  }


  static SymbolMatrixGrid? fromJson(String text) {
    if (text.isEmpty) return null;
    var json = asJsonMap(jsonDecode(text));

    SymbolMatrixGrid matrix;
    // var rowCount = toIntOrNull(json['rows']);
    // var columnCount = toIntOrNull(json['columns']);
    // var values = asJsonMap(json['values']);
    // if (rowCount == null || columnCount == null) return null;
    //
    // matrix = SymbolMatrix(rowCount, columnCount);
    // if (values.isNotEmpty) {
    //   values.forEach((key, value) {
    //     var element = asJsonMap(jsonDecode(value));
    //     var x = toIntOrNull(element['x']);
    //     var y = toIntOrNull(element['y']);
    //     var value = toStringOrNull(element['v']);
    //     if (x != null && y != null && value != null) {
    //       matrix.setValue(y, x, value);
    //     }
    //   }
    // }
    // matrix.substitutions = _fromJsonSubstitutions(jsonDecode(json)['substitutions']);
    // return matrix;
  }
}

