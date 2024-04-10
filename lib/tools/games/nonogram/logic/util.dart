import 'package:collection/collection.dart';
import 'package:utility/utility.dart';

int hintSum(List<int> hints) {
  if (hints.isEmpty) return 0;
  return hints.reduceIndexed((i, x, y) => x + y + (i != 0 ? 1 : 0));
}

ShiftResult trimLine(List<int> line, List<int> hints) {

  var minIndex = line.indexOf(0);
  if (minIndex == -1) {
    throw const FormatException('Cannot trim solved line');
  }
  if (minIndex > 0 && line[minIndex - 1] == 1) {
    minIndex--;
  }
  var clonedHints = hints.sublist(0);
  for (var i = 0; i < minIndex; i++) {
    if (line[i] == 1) {
      var start = i;
      while (i < minIndex && line[i] == 1) {
        i++;
      }
      if (i == minIndex) { // on the rim
        clonedHints[0] -= i - start;
        if (clonedHints[0] == 0) {
          clonedHints[0] = 1;
          minIndex -= 1;
          break;
        }
      } else {
        clonedHints.removeFirst();
      }
    }
  }
  var maxIndex = line.lastIndexOf(0);
  if (maxIndex < (line.length - 1) && line[maxIndex + 1] == 1) {
    maxIndex++;
  }
  for (var i = line.length - 1; i > maxIndex; i--) {
    if (line[i] == 1) {
      var start = i;
      while (i > maxIndex && line[i] == 1) {
        i--;
      }
      if (i == maxIndex) { // on the rim
        clonedHints[clonedHints.length - 1] -= start - i;
        if (clonedHints[clonedHints.length - 1] == 0) {
          clonedHints[clonedHints.length - 1] = 1;
          maxIndex += 1;
          break;
        }
      } else {
        clonedHints.removeLast();
      }
    }
  }
  if (clonedHints.any((x) => x < 0)) {
    throw FormatException('Impossible line $line, $hints');
  }

  return ShiftResult(line.sublist(minIndex, maxIndex + 1), clonedHints,
      TrimInfo( line.sublist(0, minIndex), line.sublist(maxIndex + 1)));
}

List<int> restoreLine(List<int> line, TrimInfo trimInfo) {
  var _line = List<int>.from(trimInfo.left);
  _line.addAll(line);
  _line.addAll(trimInfo.right);
  return _line;
}

class ShiftResult {
  List<int>? trimmedLine;
  List<int>? trimmedHints;
  TrimInfo? trimInfo;

  ShiftResult(this.trimmedLine, this.trimmedHints, this.trimInfo);
}

class TrimInfo {
  List<int> left;
  List<int> right;

  TrimInfo(this.left, this.right);
}

class LineMetaData {
  var index = 0;
  var zeros = 0;
  var estimate = 0;
  List<int> line = [];

  LineMetaData(this.line, this.index, this.zeros);
}
