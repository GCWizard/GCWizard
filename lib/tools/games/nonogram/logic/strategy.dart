//ported from https://github.com/ThomasR/nonogram-solver
//json import with nonogram.org format

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/bruteforce_solver.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/guess_and_conquer.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/push_solver.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/puzzle.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/util.dart';

/**
 * Strategy for solving a puzzle by applying line solvers repeatedly
 */
class Strategy {
  late _VisitedG _visited;
  bool randomize = true;

  /**
   * @param {Array} solvers List of line solvers sorted by speed
   * @param {boolean} randomize 'false' to run trial and error in order. Defaults to 'true'.
   *     In practice, using random guessing mostly yields faster results.
   */
  Strategy({this.randomize = true});

  /**
   * Solve the puzzle.
   * @param {Puzzle} puzzle The puzzle to solve
   * @param {boolean} withTrialAndError 'false' to stop without trial and error. Defaults to 'true'.
   */
  Puzzle solve(Puzzle puzzle, int maxRecursionLevel, {bool withTrialAndError = true}) {
    try {
      Puzzle.generateRows(puzzle);

      var solvers = [pushSolver(), bruteForce()];
      // keep tracks of visited lines
      _visited = _VisitedG(
          rows: List<Uint8List>.generate(puzzle.height, (index) => Uint8List(solvers.length)),
          columns: List<Uint8List>.generate(puzzle.width, (index) => Uint8List(solvers.length)));

      // repeatedly run all solvers on puzzle
      bool progress = false;
      do {
        var snapshot = puzzle.snapshot;
        progress = false;

        solvers.forEachIndexed((i, solver) {
          if (progress) {
            return;
          }

          // run one line solver on the whole puzzle
          _solveOnce(puzzle, solver, i);
          progress = !listEquals(snapshot, puzzle.snapshot);
        });
      } while (progress);

      // no solution found… trial and error now
      if (withTrialAndError && !puzzle.isFinished) {
        var deepResult = guessAndConquer(this, puzzle, maxRecursionLevel);
        if (deepResult != null) {
          puzzle.rows = deepResult.rows;
        }
      }
    } on FormatException {}

    puzzle.state = puzzle.isSolved ? PuzzleState.Solved : PuzzleState.Finished;
    return puzzle;
  }

  /**
   * @private
   * Run one solver on the puzzle
   * @param {Puzzle} puzzle The puzzle to solve
   * @param {Solver} solver The solver to use
   * @param {number} solverIndex The solver's index in 'solvers'
   */
  void _solveOnce(Puzzle puzzle, Solver solver, int solverIndex) {
    // If we're dealing with a slow solver, we want to skip as soon as one line is partially solved
    var skipEarly = solver.slowSolveSpeed;
    var skip = false;

    // run on rows
    skip = _run(puzzle.rows, puzzle.rowHints, true, solver, solverIndex, skip, skipEarly);
    if (skip) {
      return;
    }
    // …and then on columns
    var lines = puzzle.columns;
    skip = _run(lines, puzzle.columnHints, false, solver, solverIndex, skip, skipEarly);
    puzzle.columns = lines;
  }

  // the actual execution
  bool _run(List<List<int>> lines, List<List<int>> hints, bool onRow, Solver solver, int solverIndex, bool skip,
      bool skipEarly) {
    var visited = onRow
        ? _VisitedL(current: _visited.rows, other: _visited.columns)
        : _VisitedL(current: _visited.columns, other: _visited.rows);
    var rearrangedLines = _optimizeOrder(lines, hints, skipEarly);

    for (var line in rearrangedLines) {
      //estimate
      if (skip || visited.current[line.index][solverIndex] != 0) {
        continue;
      }

      visited.current[line.index][solverIndex] = 1;
      // First, trim unnecessary information from the line
      var trimresult = trimLine(line.line, hints[line.index]);

      // solver run
      var newLine = solver.solve(trimresult.trimmedLine!, trimresult.trimmedHints!);

      // now, restore the trimmed line and analyze the result
      var hasChanged = false;
      if (newLine != null) {
        // the solver may return null to indicate no progress
        newLine = restoreLine(newLine, trimresult.trimInfo!);
        line.line.forEachIndexed((i, el) {
          // What has changed?
          if (el != newLine![i]) {
            line.line[i] = newLine[i];
            // These perpendicular lines must be revisited
            visited.other[i].fillRange(0, visited.other[i].length, 0);
            hasChanged = true;
          }
        });
        skip = hasChanged && skipEarly;
      }
    }
    return skip;
  }

  // Optimize iteration order
  List<LineMetaData> _optimizeOrder(List<List<int>> lines, List<List<int>> hints, bool skipEarly) {
    // remove already solved lines
    var unsolvedLines = lines.mapIndexed((index, line) {
      var zeros = line.fold(0, (count, x) => count + (x == 0 ? 1 : 0));
      if (zeros == 0) {
        return null;
      }
      return LineMetaData(line, index, zeros);
    }).whereNotNull();

    // sort by estimated computation effort
    if (skipEarly) {
      unsolvedLines = unsolvedLines.map((lineMeta) {
        var _hintSum = hintSum(hints[lineMeta.index]);
        var estimate =
            (lineMeta.zeros < _hintSum) ? 0 : pow(lineMeta.zeros - _hintSum, hints[lineMeta.index].length).toInt();
        lineMeta.estimate = estimate;
        return lineMeta;
      });
      unsolvedLines = unsolvedLines.sorted((left, right) => left.estimate - right.estimate);
    }
    return unsolvedLines.toList();
  }
}

class _VisitedG {
  List<Uint8List> rows = [];
  List<Uint8List> columns = [];

  _VisitedG({required this.rows, required this.columns});
}

class _VisitedL {
  List<Uint8List> current = [];
  List<Uint8List> other = [];

  _VisitedL({required this.current, required this.other});
}
