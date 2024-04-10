import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/gap_distributor.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/push_solver.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/util.dart';

const _cacheLimits = [2, 20];

class bruteForce extends Solver {
  final Map<String, _GapResult> _solveGapCache = {};

  _GapResult? _solveGap(List<int> gap, List<int> hints) {
    var zeros = List<int>.filled(gap.length, 0);
    var ones = List<int>.filled(gap.length, 0);
    if (hints.isEmpty) {
      if (gap.contains(1)) {
        return null;
      }
      zeros.fillRange(0, zeros.length, 1);
      return _GapResult(zeros, ones);
    }
    if (_cacheLimits[0] <= hints.length && hints.length <= _cacheLimits[1]) {
      var key = [gap, hints].toString();
      if (_solveGapCache.containsKey(key)) {
        return _solveGapCache[key];
      }
    }
    var hint = hints[0];
    var maxIndex = gap.indexOf(1);
    if (maxIndex == -1) {
      maxIndex = gap.length;
    }
    var _hintSum = hintSum(hints);
    maxIndex = min(maxIndex, gap.length - _hintSum);
    if (maxIndex > _hintSum && !gap.contains(1)) {
      zeros.fillRange(0, zeros.length, 1);
      ones.fillRange(0, ones.length, 1);
      return _GapResult(zeros, ones);
    }
    for (var hintStart = 0; hintStart <= maxIndex; hintStart++) {
      if (hintStart + hint < gap.length && gap[hintStart + hint] == 1) {
        continue;
      }
      var rest = _solveGap(hintStart + hint + 1 < gap.length ? gap.sublist(hintStart + hint + 1) : [], hints.sublist(1));
      if (rest == null) {
        continue;
      }
      for (var k = 0; k < gap.length; k++) {
        if (k < hintStart || k == hintStart + hint) {
          zeros[k] = 1;
        } else if (k < hintStart + hint) {
          ones[k] = 1;
        } else {
          zeros[k] = ((zeros[k] != 0) || (rest.zeros[k - (hintStart + hint + 1)]) != 0 ? 1 : 0);
          ones[k]  = ((ones[k] != 0) || (rest.ones[k - (hintStart + hint + 1)]) != 0 ? 1 : 0);
        }
      }
    }
    var result = _GapResult(zeros, ones);
    _solveGapCache.addAll({[gap, hints].toString() : result});
    return result;
  }

  List<int> _solveGapWithHintList(List<int> gap, List<List<int>> hintList) {
    if (gap.contains(-1)) {
      throw const FormatException('solveGapWithHintList called with a non-gap');
    }
    var zeros = List<int>.filled(gap.length, 0);
    var ones = List<int>.filled(gap.length, 0);
    for (var hints in hintList) {
      var item = _solveGap(gap, hints);
      zeros.forEachIndexed((i, zero) => zeros[i] = (zero != 0 || ((item?.zeros[i] ?? 0) != 0) ? 1 : 0));
      ones.forEachIndexed((i, one) => ones[i] = (one != 0 || ((item?.ones[i] ?? 0) != 0) ? 1 : 0));
    }
    var result = zeros.mapIndexed((i, zero) {
      var one = ones[i];
      if (zero != 0) {
        return one != 0 ? 0 : -1;
      }
      if (one != 0) {
        return 1;
      }
      throw FormatException('Cannot fill gap ($gap, $hintList)');
    }).toList();

    return result;
  }

  @override
  List<int>? solve(List<int> line, List<int> hints) {
    if (line.every((el) => el == 0)) {
      return pushSolver().solve(line, hints);
    }
    var gapResult = gapDistributor(line, hints);
    if (gapResult == null || gapResult.distributions.isEmpty) {
      throw FormatException('Contradiction in line $line | $hints');
    }

    var distributionsPerGap = gapResult.gaps.mapIndexed((i, gap) {
      Map<String, List<int>> set = {};
      for (var dist in gapResult.distributions) {
        var value = dist[i].toList();
        if (!set.containsKey(value.toString())) {
          set.addAll({value.toString() : value});
        }
      }
      return set.values.toList();
    }).toList();

    var result = line.sublist(0);
    Set<int> changed = {};
    gapResult.gaps.forEachIndexed((i, gap) {
      var gapResult = _solveGapWithHintList(line.sublist(gap[0], gap[1]), distributionsPerGap[i]);
      gapResult.forEachIndexed((i, item) {
        var before = result[gap[0] + i];
        if (before != item) {
          result[gap[0] + i] = item;
          changed.add(item);
        }
      });
    });
    if (changed.contains(0)) {
      throw FormatException('Contradiction in line $line | $hints');
    }

    if (changed.contains(-1)) {
      return solve(result, hints) ?? result;
    }
    return changed.contains(1) ? result : null;
  }

  @override
  bool get slowSolveSpeed {
    return true;
  }
}

class _GapResult {
  List<int> zeros = [];
  List<int> ones = [];

  _GapResult(this.zeros, this.ones);
}
