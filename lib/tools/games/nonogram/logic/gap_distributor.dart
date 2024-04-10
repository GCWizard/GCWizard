import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/push_solver.dart';

List<List<int>> _findGaps(List<int> line) {
  var result = <List<int>>[];
  line.forEachIndexed((i, el) {
    if (el > -1) {
      if (i > 0 && line[i - 1] > -1) {
        result[result.length - 1][1]++;
      } else {
        result.add([i, i + 1]);
      }
    }
  });
  return result;
}

_GapInfo? _allWithOneGap(List<int> line, List<List<int>> gaps, List<int> hints) {
  var left = gaps[0][0];
  var right = gaps[0][1];
  if (pushSolver.pushLeft(line.sublist(left, right), hints) != null) {
    return _GapInfo(gaps, [[hints]]);
  }
  return null;
}

_GapInfo? gapDistributor(List<int> line, List<int> hints) {
  var gaps = _findGaps(line);
  if (gaps.length == 1) {
    return _allWithOneGap(line, gaps, hints);
  }
  var distributions = <List<List<int>>>[];
  var gap = gaps[0];
  for (var hintCount = 0; hintCount <= hints.length; hintCount++) {
    var first = _allWithOneGap(line, [gap], hints.sublist(0, hintCount));
    if (first == null) {
      continue;
    }
    var second = gapDistributor(line.sublist(gap[1]), hints.sublist(hintCount));
    if (second == null) {
      continue;
    }
    for (var x in first.distributions) {
      for (var e in x) {
        for (var y in second.distributions) {
          var item = y.sublist(0);
          item.insert(0, e);
          distributions.add(item);
        }
      }
    }
  }
  return _GapInfo(gaps, distributions);
}

class _GapInfo {
  List<List<int>> gaps;
  List<List<List<int>>> distributions;

  _GapInfo(this.gaps, this.distributions);
}
