import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/puzzle.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/strategy.dart';
import 'package:utility/utility.dart';

int _getNextIndex(List<int> zeroIndexes, bool randomize) {
  if (zeroIndexes.isEmpty) return 0;
  if (randomize) {
    var random = (Random().nextDouble() * zeroIndexes.length).floor();
    return zeroIndexes.removeAt(random);
  }
  return zeroIndexes.removeFirst()!;
}

Puzzle? _recurse(
    Strategy strategy, int currentRecursionLevel, int maxRecursionLevel, List<int> snapshot, int index, Puzzle trial) {
  if (currentRecursionLevel >= maxRecursionLevel) {
    // reset and just try the next index
    snapshot[index] = 0;
    return null;
  }
  // try recursion
  var anotherTry = Puzzle(trial.rowHints, trial.columnHints, content: snapshot);
  var result =
      guessAndConquer(strategy, anotherTry, maxRecursionLevel, currentRecursionLevel: currentRecursionLevel + 1);

  return result;
}

/**
 * Run trial and error iteration
 * @param {Strategy} strategy The strategy to use
 * @param {Puzzle} puzzle The puzzle to solve
 * @param {number} currentRecursionLevel (internal) keep track of recursion depth
 */
Puzzle? guessAndConquer(Strategy strategy, Puzzle puzzle, int maxRecursionLevel, {int currentRecursionLevel = 0}) {
  const int maxGuessCount = 20;
  if (puzzle.isFinished) {
    return puzzle.isSolved ? puzzle : null;
  }
  var snapshot = puzzle.snapshot;
  var zeroIndexes = <int>[];

  // find unsolved cells
  snapshot.forEachIndexed((i, x) {
    if (x == 0) {
      zeroIndexes.add(i);
    }
  });

  if (zeroIndexes.isEmpty) {
    throw const FormatException('Contradiction in trial and error');
  }

  for (var i = 0; i < min(maxGuessCount, zeroIndexes.length); i++) {
    var index = _getNextIndex(zeroIndexes, strategy.randomize);
    // try and set the 'index'th cell to 1, and create a new Puzzle from that
    snapshot[index] = 1;
    var trial = Puzzle(puzzle.rowHints.sublist(0), puzzle.columnHints.sublist(0), content: snapshot);

    // solve the trial puzzle
    try {
      strategy.solve(trial, maxRecursionLevel, withTrialAndError: false); // may throw an exception on contradiction
      if (trial.isFinished) {
        if (!trial.isSolved) {
          // This is a contradiction
          throw Exception('Not a solution');
        }
        // We found a solution by guessing.
        return trial;
      }
      // No progress
      var result = _recurse(strategy, currentRecursionLevel, maxRecursionLevel, snapshot, index, trial);
      if (result != null) {
        return result;
      }
      // reset and just try the next index
      snapshot[index] = 0;
    } catch (e) {
      // A contradiction has occurred, which means we can be sure that 'index'th cell is empty
      snapshot[index] = -1;
    }
  }
  return null;
}
