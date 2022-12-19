import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/logic/common/parser/variable_string_expander.dart';

class SymbolMatrix {
  List<List<String>> matrix;
  var columnCount;
  var rowCount;

  SymbolMatrix (int rowCount, int columnCount, {SymbolMatrix oldMatrix}) {
    this.columnCount = columnCount;
    this.rowCount = rowCount;

    matrix =<List<String>>[];
    for(var y = 0; y < getRowsCount(); y++)
      matrix.add(List<String>.filled(getColumnsCount(), null));

    if (oldMatrix != null) {
      for(var y = 0; y < min(matrix.length, oldMatrix.matrix.length); y++)
        for(var x = 0; x < min(matrix[y].length, oldMatrix.matrix[y].length); x++)
          matrix[y][x] = oldMatrix.matrix[y][x];
    }
  }

  int getColumnsCount() {
    return columnCount * 2 + 1;
  }
  int getRowsCount() {
    return rowCount * 2 + 1;
  }

  String getOperator(int y, int x) {
    if  (!_validPosition(y, x))
      return null;
    var value = matrix[y][x];
    if (!operatorList.containsKey(value)) {
      value = operatorList.keys.first;
      setValue(y, x, value);
    }
    return value;
  }

  String getValue(int y, int x) {
    if (!_validPosition(y, x))
      return null;
    return matrix[y][x];
  }
  void setValue(int y, int x, String text) {
    if (!_validPosition(y, x))
      return;
    matrix[y][x] = text;
  }

  bool _validPosition(int y, int x) {
    return !(matrix == null || y >= matrix.length || matrix[y] == null || x >= matrix[y].length);
  }

  bool isValidMatrix() {
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (y % 2 == 0) {
          if (x % 2 == 0) {
            if (matrix[y][x] == null || matrix[y][x].length == 0)
              return false;
          } else if (x < getColumnsCount() - 2 && y < getRowsCount() - 2) {
            if (!operatorList.keys.contains(matrix[y][x]))
              return false;
          }
        } else {
          if (x % 2 == 0 && x < getColumnsCount() - 1) {
            if (y < getRowsCount() - 2)
              if (!operatorList.keys.contains(matrix[y][x]))
                return false;
          }
        }
      }
    }
    return true;
  }

  String buildRow(int y) {
    var formula = '';
    for (var x = 0; x < matrix[y].length; x++) {
      if (x % 2 == 0)
        formula += matrix[y][x];
      else if (x < getColumnsCount() - 2)
        formula += operatorList[matrix[y][x]];
      else
        formula += '=';
    }
    return formula;
  }

  String buildColumn(int x) {
    var formula = '';
    for (var y = 0; y < matrix.length; y++) {
      if (y % 2 == 0)
        formula += matrix[y][x];
      else if (y < getRowsCount() - 2)
        formula += operatorList[matrix[y][x]];
      else
        formula += '=';
    }
    return formula;
  }

  String toJson() {
    var list = <String>[];
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x] != null && matrix[y][x].isNotEmpty) {
          list.add(({'x': x, 'y': y, 'v': matrix[y][x]}).toString());
        }
      }
    }

    return (jsonEncode({'columns': columnCount, 'rows': rowCount, 'values': list.toString()}).toString());
  }


  static SymbolMatrix fromJson(String text) {
    if (text == null) return null;
    var json = jsonDecode(text);
    if (json == null) return null;

    SymbolMatrix matrix;
    var rowCount = jsonDecode(json)['rows'];
    var columnCount = jsonDecode(json)['columns'];
    var values = jsonDecode(json)['values'];
    if (rowCount == null || columnCount == null) return null;

    matrix = SymbolMatrix(rowCount, columnCount);
    if (values != null) {
      for (var jsonElement in values) {
        var element = jsonDecode(jsonElement);
        var x = element['x'];
        var y = element['y'];
        var value = element['v'];
        if (x != null && y != null && value != null)
          matrix.setValue(y, x, value);
      }
    }
    return matrix;
  }
}


class ArrayEntry {
  final int x;
  final int y;
  final String value;
  final bool userDefinied;

  ArrayEntry(this.x, this.y, this.value, this.userDefinied);

  ArrayEntry.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        value = json['v'],
        userDefinied = json['ud']
  ;

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'v': value,
    'ud': userDefinied,
  };
}
// class ArrayEntry {
//   int x;
//   int y;
//   ArrayEntry(int x, int y) {
//     this.x = x;
//     this.y = y;
//   }
//   toJson ()= jsonEncode
//
// }


final Map<String, String> operatorList = {
  '+':'+',
  '-':'-',
  '*':'*',
  '÷':'/'
};


class HashBreakerJobData {
  final String input;
  final String searchMask;
  final Map<String, String> substitutions;
  final Function hashFunction;

  HashBreakerJobData({
    this.input = '',
    this.searchMask = '',
    this.substitutions,
    this.hashFunction,
  });
}

Future<Map<String, dynamic>> breakHashAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = breakHash(jobData.parameters.input, jobData.parameters.searchMask, jobData.parameters.substitutions,
      jobData.parameters.hashFunction,
      sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Map<String, dynamic> breakHash(
    String input, String searchMask, Map<String, String> substitutions, Function hashFunction,
    {SendPort sendAsyncPort}) {
  if (input == null ||
      input.length == 0 ||
      searchMask == null ||
      searchMask.length == 0 ||
      substitutions == null ||
      hashFunction == null) return null;

  input = input.toLowerCase();
  var expander = VariableStringExpander(searchMask, substitutions, onAfterExpandedText: (expandedText) {
    var withoutBrackets = expandedText.replaceAll(RegExp(r'[\[\]]'), '');
    var hashValue = hashFunction(withoutBrackets).toLowerCase();

    if (hashValue == input)
      return withoutBrackets;
    else
      return null;
  }, breakCondition: VariableStringExpanderBreakCondition.BREAK_ON_FIRST_FOUND, sendAsyncPort: sendAsyncPort);

  var results = expander.run();

  if (results == null || results.length == 0) return {'state': 'not_found'};

  return {'state': 'ok', 'text': results[0]['text']};
}
