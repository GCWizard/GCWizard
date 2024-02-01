//ported from https://github.com/dennistreysa/Py-Ramid

/*
 GNU GENERAL PUBLIC LICENSE
 Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
*/

/* Checks if a given pyramid is solved
			Keyword arguments:
			pyramid -- The pyramid to be checked
*/
import 'dart:math';

const _MAX_SOLUTIONS_DEFAULT = 10;
var _max_solutions = _MAX_SOLUTIONS_DEFAULT;
const _timeOut = 10000;
var _start_time = DateTime.now();
var _globalMaxValue = 1000;
List<List<List<int?>>> _solutions = [];

/* Asserts that a given pyramid is valid
			Keyword arguments:
			pyramid -- The pyramid to be checked
*/
bool _assertValidPyramid(List<List<int?>> pyramid) {
  for (var layer = 0; layer < pyramid.length - 1; layer++) {
    if (pyramid[layer].isEmpty) return false;
    if (pyramid[layer].length != layer + 1) return false;
  }
  return true;
}

bool _isSolved(List<List<int?>> pyramid) {
  for (var layer = 0; layer < pyramid.length - 1; layer++) {
    for (var brick = 0; brick < pyramid[layer].length; brick++) {
      var brickValue = pyramid[layer][brick];
      var leftChild = pyramid[layer + 1][brick];
      var rightChild = pyramid[layer + 1][brick + 1];

      if ((brickValue == null) || (leftChild == null) || (rightChild == null)) {
        return false;
      }

      if (brickValue != (leftChild + rightChild)) {
        return false;
      }
    }
  }
  return true;
}

/* Checks if a given pyramid is solveable by the data already given
			Keyword arguments:
			pyramid -- The pyramid to be checked
*/
bool _isSolveable(List<List<int?>> pyramid) {
  for (var layer = 0; layer < pyramid.length - 1; layer++) {
    for (var brick = 0; brick < pyramid[layer].length; brick++) {
      var brickValue = pyramid[layer][brick];
      if (brickValue != null) {
        // left child
        var leftChild = pyramid[layer + 1][brick];
        if (leftChild != null && leftChild > brickValue) {
          return false;
        }

        // right child
        var rightChild = pyramid[layer + 1][brick + 1];
        if (rightChild != null && rightChild > brickValue) {
          return false;
        }
      }
    }
  }
  return true;
}

/* Tries to find the maximum possible value for a specific brick
			Keyword arguments:
			pyramid -- The pyramid
			layer/brick -- The location of the brick to get the max value for
*/
int? _getMaxValue(List<List<int?>> pyramid, int layer, int brick) {
  // if brick already has a value, this is the maximum
  if (pyramid[layer][brick] != null) {
    return pyramid[layer][brick];
  }

  // recursively search for parent value
  var left = (layer > 0 && brick > 0) ? _getMaxValue(pyramid, layer - 1, brick - 1) : _globalMaxValue;
  var right = (layer > 0 && brick < layer) ? _getMaxValue(pyramid, layer - 1, brick) : _globalMaxValue;

  if ((left == null) || (right == null)) return null;
  return min(left, right);
}

/* Tries to find a solution for a given pyramid and brick by guessing values
			Keyword arguments:
			pyramid -- The pyramid
			brick -- Index of the brick (always bottom layer!)
*/
void _solveGuess(List<List<int?>> pyramid, int brick) {
  if (_solutions.length >= _max_solutions || DateTime.now().difference(_start_time).inMilliseconds > _timeOut) {
    return;
  }

  var lastLayer = pyramid.length - 1;
  var brickValue = pyramid[lastLayer][brick];
  var startValue = (brickValue != null) ? brickValue : 0;
  var endValue = (brickValue != null) ? brickValue + 1 : _getMaxValue(pyramid, lastLayer, brick);

  for (var currentValue = startValue; currentValue <= (endValue ?? 0); currentValue++) {
    pyramid[lastLayer][brick] = currentValue;

    // is the pyramid solveable with these values
    if (_isSolveable(pyramid)) {
      // try to repair
      var repairedPyramid = _solveRepair(_copyPyramid(pyramid));
      if (!_isSolved(repairedPyramid)) {
        if ((brick + 1) < pyramid.length) {
          _solveGuess(repairedPyramid, brick + 1);
        }
      } else if (_solutions.length < _max_solutions) {
        _solutions.add(repairedPyramid);
      }
    }
  }
}

List<List<int?>> _copyPyramid(List<List<int?>> pyramid) {
  var copy = <List<int?>>[];
  for (var layer in pyramid) {
    copy.add(List<int?>.from(layer));
  }
  return copy;
}

/* Tries to find a solution for a given pyramid by repairing it
			Keyword arguments:
			pyramid -- The pyramid
*/
List<List<int?>> _solveRepair(List<List<int?>> pyramid) {
  var repairedSomething = true;

  while (repairedSomething) {
    repairedSomething = false;
    for (var layer = 0; layer < pyramid.length - 1; layer++) {
      for (var brick = 0; brick < pyramid[layer].length; brick++) {
        var top = pyramid[layer][brick];
        var left = pyramid[layer + 1][brick];
        var right = pyramid[layer + 1][brick + 1];
        // bottom-right is missing
        if (top != null && left != null && right == null) {
          if ((top - left) >= 0) {
            pyramid[layer + 1][brick + 1] = top - left;
            repairedSomething = true;
          }
          // bottom-left is missing
        } else if (top != null && left == null && right != null) {
          if ((top - right) >= 0) {
            pyramid[layer + 1][brick] = top - right;
            repairedSomething = true;
          }
          // top is missing
        } else if (top == null && right != null && left != null) {
          pyramid[layer][brick] = left + right;
          repairedSomething = true;
        }
      }
    }
  }
  return pyramid;
}

/* Tries to the solution(s) for a given pyramid

	Keyword arguments:
	pyramid -- The pyramid
*/
List<List<List<int?>>>? solve(List<List<int?>> pyramid, {int? maxSolutions = _MAX_SOLUTIONS_DEFAULT}) {
  if (maxSolutions != null && maxSolutions > 0) _max_solutions = maxSolutions;

  if (!_assertValidPyramid(pyramid)) return null;

  _start_time = DateTime.now();
  _solutions = [];

  pyramid = _solveRepair(pyramid);
  if (!_isSolved(pyramid)) {
    _solveGuess(pyramid, 0);
  } else {
    _solutions.add(pyramid);
  }

  return _solutions.isEmpty ? null : _solutions;
}
