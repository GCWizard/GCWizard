import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:image/image.dart' as Image;
import 'package:gc_wizard/tools/games/nonogram/logic/strategy.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/image_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';

enum PuzzleState {
  Ok, // no data errors
  Finished, // has errors
  Solved,
  InvalidContentData, // data errors (no row or column hints)
  InvalidHintData // hint data errors
}

class Puzzle {
  var rowHints = <List<int>>[];
  var columnHints = <List<int>>[];
  int height = 0;
  int width = 0;
  var rows = <List<int>>[];
  PuzzleState state = PuzzleState.Ok;
  var invalidHintDataInfo = "";

  Puzzle(this.rowHints, this.columnHints, {List<int>? content}) {
    height = rowHints.length;
    width = columnHints.length;
    if (content != null) {
      _import(content);
    }
  }

  void solve() {
    var maxRecursionLevel = 0;
    Strategy().solve(this, maxRecursionLevel);
    if (!isSolved) {
      // Increasing the recursion depth value may dramatically slow down or speed up the solution process, depending on the puzzle.
      // It has no effect on puzzles that don't require trial and error
      maxRecursionLevel = 3;
      Strategy().solve(this, maxRecursionLevel);
    }
    var stateTmp = state;
    _checkConsistency(this);
    if (state == PuzzleState.Ok) {
      state = stateTmp;
    }
  }

   static Puzzle generate(int height, int width) {
     var puzzle = Puzzle(List<List<int>>.generate(height, (index) => []),
                   List<List<int>>.generate(width, (index) => []));
     mapData(puzzle);
     return puzzle;
  }

  static List<List<int>> generateRows(Puzzle data) {
    return List<List<int>>.generate(data.height, (index) => List<int>.filled(data.width, 0));
  }

  static void mapData(Puzzle data) {
    data.rowHints = _cleanClone(data.rowHints);
    data.columnHints = _cleanClone(data.columnHints);
    data.height = data.rowHints.length;
    data.width = data.columnHints.length;
    if (data.height == 0 || data.width == 0) {
      data.height = 10;
      data.width = 10;
    }
    data.rows = generateRows(data);

    _checkConsistency(data);
  }

  static List<List<int>> _cleanClone(List<List<int>> hints) {
    return hints.map((h) {
      if (h.length == 1 && h[0] == 0) {
        return <int>[];
      }
      return h;
    }).toList();
  }

  static List<int> cleanHints(List<int> hints, int size) {
    hints.removeWhere((element) => element <= 0);
    return hints.sublist(0, min(size, hints.length));
  }

  void clearHints() {
    for (var hints in rowHints) { hints.clear(); }
    for (var hints in columnHints) { hints.clear(); }
  }

  List<List<int>> get columns {
    var _columns = List<List<int>>.generate(width, (index) => List<int>.filled(height, 0));
    for(var x = 0; x < width; x++) {
      for(var y = 0; y < height; y++) {
        _columns[x][y] = rows[y][x];
      }
    }
    return _columns;
  }

  set columns (List<List<int>> newColumns) {
    for(var x = 0; x < width; x++) {
      for(var y = 0; y < height; y++) {
        rows[y][x] = newColumns[x][y];
      }
    }
  }

  bool get isFinished {
    for (var row in rows) {
      if (row.any((item) => item == 0)) return false;
    }
    return true;
  }

  bool get isSolved {
    if (!isFinished) return false;
    var ok = true;
    rows.forEachIndexed((i, column) => ok = _isOk(column, rowHints[i]));
    if (!ok) return false;
    columns.forEachIndexed((i, column) => ok = ok && _isOk(column, columnHints[i]));

    return ok;
  }

  bool _isOk(List<int> line, List<int> hints) {
    var actual = line.join('').split(RegExp(r'(?:-1)+')).map((x) => x.length).where((x) => x > 0);
    if (actual.length == hints.length) {
      var ok = true;
      actual.forEachIndexed((i, x) => ok = ok && x == hints[i]);
      return ok;
    }
    return false;
  }

  List<int> get snapshot {
    var state = <int>[];

    for (var row in rows) {
      state.addAll(row);
    }
    return state;
  }

  bool _import(List<int> snapshot) {
    if (snapshot.length != width * height) return false;
    rows.clear();
    for (int i = 0; i < height; i++) {
      rows.add(snapshot.sublist(i * width, (i + 1) * width));
    }
    return true;
  }

  void importHints(Puzzle puzzle) {
    for (var y = 0; y < min(puzzle.height, height); y++) {
      rowHints[y] = puzzle.rowHints[y];
    }
    for (var x = 0; x < min(puzzle.width, width); x++) {
      columnHints[x] = puzzle.columnHints[x];
    }
  }

  Puzzle calcHints() {
    var clone = Puzzle(List<List<int>>.generate(rowHints.length, (index) => []),
        List<List<int>>.generate(columnHints.length, (index) => []), content: snapshot);
    var counter = 0;
    clone.rows.forEachIndexed((index, row) {
      counter = 0;
      for (var cell in row) {
        if (cell == 1) {
          counter++;
        } else if (counter > 0) {
          clone.rowHints[index].add(counter);
          counter = 0;
        }
      }
      if (counter > 0) {
        clone.rowHints[index].add(counter);
      }
    });
    clone.columns.forEachIndexed((index, column) {
      counter = 0;
      for (var cell in column) {
        if (cell == 1) {
          counter++;
        } else if (counter > 0) {
          clone.columnHints[index].add(counter);
          counter = 0;
        }
      }
      if (counter > 0) {
        clone.columnHints[index].add(counter);
      }
    });
    return clone;
  }

  void removeCalculated() {
    rows = generateRows(this);
    state = PuzzleState.Ok;
  }

  static const String _jsonRows = 'rows';
  static const String _jsonColumns = 'columns';
  static const String _jsonContent = 'content'; //optional

  /// nonogram.org format (with 'rows' for row hints and 'columns' for column hints)
  static Puzzle parseJson(String jsonString) {
    var puzzle = Puzzle.generate(0, 0);
    var jsonMap = asJsonMap(json.decode(jsonString));

    var data = asJsonArrayOrNull(jsonMap[_jsonRows]);
    if (data != null) {
      puzzle.rowHints = _jsonArrayToArrayList(data);
    }

    data = asJsonArrayOrNull(jsonMap[_jsonColumns]);
    if (data != null) {
      puzzle.columnHints = _jsonArrayToArrayList(data);
    }
    Puzzle.mapData(puzzle);

    if (puzzle.state == PuzzleState.Ok) {
      data = asJsonArrayOrNull(jsonMap[_jsonContent]);
      if (data != null) {
        puzzle._import(_jsonArrayToList(data));
      }
    } else {

    }
    return puzzle;
  }

  static List<List<int>> _jsonArrayToArrayList(List<Object?> jsonList) {
    var list = <List<int>>[];
    for (var entrys in jsonList) {
      var subList = asJsonArrayOrNull(entrys);
      if (subList != null) {
        list.add(_jsonArrayToList(subList));
      }
    }
    return list;
  }

  static List<int> _jsonArrayToList(List<Object?> jsonList) {
    var list = <int>[];
    for (var entry in jsonList) {
       var value = toIntOrNull(entry);
      if (value != null) list.add(value);
    }
    return list;
  }

  String? toJson({bool withContent = false, bool encryptVersion = false}) {
    if (encryptVersion) {
      return _contentToJson();
    }
    if (columnHints.isEmpty && rowHints.isEmpty) return null;

    Map<String, Object> list = ({_jsonColumns: columnHints, _jsonRows: rowHints});
    if (withContent && rows.isNotEmpty) {
      list.addAll({_jsonContent: snapshot});
    }
    if (list.isEmpty) return null;

    return jsonEncode(list);
  }

  String? _contentToJson() {
    var clone = calcHints();

    return clone.toJson();
  }

  static void _checkConsistency(Puzzle data) {
    if (data.rowHints.isEmpty || data.columnHints.isEmpty ||
        data.height == 0 || data.width == 0) {
      data.state = PuzzleState.InvalidContentData;
      return;
    }

    var test = data.rowHints.firstWhereOrNull((row) => row.sum > data.width);
    if (test != null) {
       data.state = PuzzleState.InvalidHintData;
       data.invalidHintDataInfo = 'invalid row ' + (data.rowHints.indexOf(test) + 1).toString();
       return;
    }

    test = data.columnHints.firstWhereOrNull((column) => column.sum > data.height);
    if (test != null) {
      data.state = PuzzleState.InvalidHintData;
      data.invalidHintDataInfo = 'invalid column ' + (data.columnHints.indexOf(test) + 1).toString();
      return;
    }

    test = data.rowHints.firstWhereOrNull((row) => row.any((hint) => hint < 0));
    if (test != null) {
      data.state = PuzzleState.InvalidHintData;
      data.invalidHintDataInfo = 'invalid row ' + (data.rowHints.indexOf(test) + 1).toString();
      return;
    }

    test = data.columnHints.firstWhereOrNull((row) => row.any((hint) => hint < 0));
    if (test != null) {
      data.state = PuzzleState.InvalidHintData;
      data.invalidHintDataInfo = 'invalid column ' + (data.columnHints.indexOf(test) + 1).toString();
      return;
    }

    var rowSum = data.rowHints.map((l) => l.sum).sum;
    var columnSum = data.columnHints.map((l) => l.sum).sum;
    if ( (rowSum != columnSum)) {
     data.state = PuzzleState.InvalidHintData;
     if (rowSum > columnSum) {
       data.invalidHintDataInfo = 'more row as column points';
     } else {
       data.invalidHintDataInfo = 'more column as row points';
     }
     return;
   }

    data.state = PuzzleState.Ok;
  }

  void importImage(Uint8List data) {
    removeCalculated();
    var image = decodeImage4ChannelFormat(data);
    var rowOffset = 0;
    var columnOffset = 0;

    if (image == null) return;
    image = image.convert(numChannels: 1);
    if (width/ image.width > height/ image.height) {
      image = Image.copyResize(image, height: height, interpolation: Image.Interpolation.average);
    } else {
      image = Image.copyResize(image, width: width, interpolation: Image.Interpolation.average);
    }
    rowOffset = max((( height - image.height)/ 2).truncate(), 0);
    columnOffset = max(((width - image.width)/ 2).truncate(), 0);

    for (int row = 0; row < image.height; row++) {
      for (int column = 0; column < image.width; column++) {
        if ((row + rowOffset < rows.length) && (column + columnOffset < rows[row + rowOffset].length)) {
          rows[row + rowOffset][column + columnOffset] = image.getPixel(column, row).r < 128  ? 1 : -1;
        }
      }
    }
  }
}
