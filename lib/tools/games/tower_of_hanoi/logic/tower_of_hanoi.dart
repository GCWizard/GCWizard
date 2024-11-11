import 'dart:core';
import 'dart:math';
import 'package:stack/stack.dart';

const MAXDISCCOUNT = 100;
const MAXDISCVIEWCOUNT = 9;

BigInt moveCount(int discCount) {
  if (discCount <= 0) return BigInt.zero;
  return BigInt.from(2).pow(discCount) - BigInt.one;
}

List<(String, int, int, int)> moves(int discCount) {
  var t = _towerOfHanoi(discCount);
  return t.towersOutput;
}

class _towerOfHanoi {
  final towersOutput = <(String, int, int, int)>[];
  final _towers = <Stack<int>> [ Stack<int>(), Stack<int>(), Stack<int>() ];
  final int _numdiscs;

  _towerOfHanoi(this._numdiscs) {
    if (moveCount(_numdiscs) <= BigInt.zero || _numdiscs > MAXDISCVIEWCOUNT) return;

    for (int i = _numdiscs; i > 0; i--) {
      _towers[0].push(i);
    }
    _movetower(_numdiscs, 1, 3, 2);
  }

  void _movetower(int n, int from, int to, int other) {
    if (n > 0) {
      _movetower(n - 1, from, other, to);
      _towers[to - 1].push(_towers[from - 1].pop());
      _addTowersOutput(n, from, to);
      _movetower(n - 1, other, to, from);
    }
  }

  void _addTowersOutput(int n, int from, int to) {
    var output = '';
    int offset;
    var rowCount = max(_towers[0].length, max(_towers[1].length, _towers[2].length));
    rowCount = max(2, rowCount);

    for (int row = 0; row < rowCount; row++) {
      for (var tower = 0; tower < _towers.length; tower++) {
        offset = rowCount - _towers[tower].length;
        List<int> stack = [];
        // 2024/10 MAL: TODO Das ist ja wohl mal richtig beschissen!!! Build own Stack class which can reference elements and supports toList()!
        var _tower = _towers[tower];
        while (_tower.isNotEmpty) {
          stack.add(_tower.pop());
        }
        stack = stack.reversed.toList();
        for (var i = 0; i < stack.length; i++) {
          _tower.push(stack[i]);
        }
        output += (row >= offset ? stack[_towers[tower].length - 1 - (row - offset)].toString() : "|").padLeft(tower == 0 ? 3 : 6);
      }
      output += "\n";
    }
    towersOutput.add((output.trimRight(), n, from, to));
  }
}