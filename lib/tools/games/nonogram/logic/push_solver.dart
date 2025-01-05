import 'package:collection/collection.dart';

class pushSolver extends Solver {
  static bool _shouldSkip(List<int> line, int hint, int i) {
    var allZeros = i > 0 && line[i - 1] == 0;
    var collision = (i + hint) < line.length && line[i + hint] == 1;
    for (var x = i; x < i + hint; x++) {
      if (x >= line.length || line[x] == -1) {
        collision = true;
        break;
      }
      if (x < line.length && line[x] != 0) {
        allZeros = false;
      }
    }
    return allZeros || collision;
  }

  static List<int>? pushLeft(List<int> line, List<int> hints) {
    if (hints.isEmpty) {
      return line.contains(1) ? null : line;
    }
    var hint = hints[0];
    var maxIndex = line.indexOf(1);
    if (maxIndex == -1) {
      maxIndex = line.length - hint;
    }
    for (var i = 0; i <= maxIndex; i++) {
      if (_shouldSkip(line, hint, i)) {
        continue;
      }
      var _line = (line.length >= i + hint + 1) ? line.sublist(i + hint + 1) : <int>[];
      var _hints = hints.isNotEmpty ? hints.sublist(1) : <int>[];
      var rest = pushLeft(_line, _hints);
      if (rest != null) {
        line = line.isNotEmpty ? line.sublist(0) : <int>[];
        for (var x = i; x < i + hint; x++) {
          line[x] = 1;
        }
        for (var x = 0; x < rest.length; x++) {
          line[x + i + hint + 1] = rest[x];
        }
        return line;
      }
    }
    return null;
  }

  void _enumerate(List<int> array) {
    if (array.isEmpty) return;
    for (var i = 0, j = array[0] % 2; i < array.length; i++) {
      if (array[i] == -1) {
        array[i] = 0;
      }
      if (array[i] % 2 != j % 2) {
        j++;
      }
      array[i] = j;
    }
  }

  @override
  List<int>? solve(List<int> line, List<int> hints) {
    var leftmost = pushLeft(line, hints);
    if (leftmost == null) {
      return null;
    }

    var reverseLine = line.sublist(0).reversed.toList();
    var reverseHints = hints.sublist(0).reversed.toList();
    var rightmost = pushLeft(reverseLine, reverseHints)?.reversed.toList() ?? [];

    _enumerate(leftmost);
    _enumerate(rightmost);

    return leftmost.mapIndexed((i, el) {
      if ((i < rightmost.length) && (el == rightmost[i])) {
        return (el % 2 != 0) ? 1 : -1;
      }
      return line[i];
    }).toList();
  }

  @override
  bool get slowSolveSpeed {
    return false;
  }
}

abstract class Solver {
  List<int>? solve(List<int> line, List<int> hints);
  bool get slowSolveSpeed;
}
