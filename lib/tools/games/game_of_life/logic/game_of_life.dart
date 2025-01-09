import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';

part 'package:gc_wizard/tools/games/game_of_life/logic/game_of_life_rle.dart';

const KEY_CUSTOM_RULES = 'gameoflife_custom';
const MAX_SIZE = 2000;

class GameOfLifeData {
  late List<List<List<bool>>> boards;
  List<List<bool>> currentBoard = [];
  var step = 0;
  final Point<int> size;
  GameOfLifeRules rules;

  GameOfLifeData(this.size, this.rules, {List<List<bool>>? content}) {
    _generateBoard(content);
  }

  void _generateBoard(List<List<bool>>? content) {
    var _newBoard = List<List<bool>>.generate(size.y, (index) => List<bool>.generate(size.x, (index) => false));

    if (content != null && content.isNotEmpty) {
      for (int i = 0; i < min(size.y, content.length); i++) {
        for (int j = 0; j < min(size.x, content[i].length); j++) {
          _newBoard[i][j] = content[i][j];
        }
      }
    }

    boards = <List<List<bool>>>[];
    boards.add(_newBoard);

    currentBoard = List.from(_newBoard);
    step = 0;
  }

  void reset({List<List<bool>>? board}) {
    boards = <List<List<bool>>>[];
    boards.add(board ?? List.from(currentBoard));

    step = 0;
  }

  int _countNeighbors(List<List<bool>> board, int i, int j, {bool isOpenWorld = false}) {
    var counter = 0;

    for (int k = i - 1; k <= i + 1; k++) {
      if (!isOpenWorld && (k < 0 || k == size.y)) continue;

      for (int l = j - 1; l <= j + 1; l++) {
        if (!isOpenWorld && (l < 0 || l == size.x)) continue;

        if (k == i && l == j) continue;

        if (board[k % size.y][l % size.x]) {
          counter++;
        }
      }
    }

    return counter;
  }

  List<List<bool>> calculateStep(List<List<bool>> board, {bool isWrapWorld = false}) {
    var _newStepBoard = List<List<bool>>.generate(size.y, (index) => List<bool>.generate(size.x, (index) => false));

    var _rules = (rules.isInverse) ? rules.inverseRules() : rules;

    for (int i = 0; i < size.y; i++) {
      for (int j = 0; j < size.x; j++) {
        var countNeighbors = _countNeighbors(board, i, j, isOpenWorld: isWrapWorld);
        if (board[i][j] && _rules.survivals.contains(countNeighbors)) {
          _newStepBoard[i][j] = true;
        }
        if (!board[i][j] && _rules.births.contains(countNeighbors)) {
          _newStepBoard[i][j] = true;
        }
      }
    }

    return _newStepBoard;
  }

  int countCells() {
    var counter = 0;
    for (int i = 0; i < size.y; i++) {
      for (int j = 0; j < size.x; j++) {
        if (currentBoard[i][j]) counter++;
      }
    }
    return counter;
  }
}

class GameOfLifeRules {
  final Set<int> survivals;
  final Set<int> births;
  final bool isInverse;
  final String key;

  const GameOfLifeRules({this.survivals = const {}, this.births = const {}, this.isInverse = false,
    this.key = KEY_CUSTOM_RULES});

  GameOfLifeRules inverseRules() {
    var inverseSurvivals = <int>{};
    var inverseBirths = <int>{};

    var deaths = <int>{};

    for (int i = 0; i <= 8; i++) {
      if (survivals.contains(i)) continue;

      deaths.add(i);
    }

    var inverseDeaths = births.map((e) => 8 - e).toSet();
    inverseBirths = deaths.map((e) => 8 - e).toSet();

    for (int i = 0; i <= 8; i++) {
      if (inverseDeaths.contains(i)) continue;

      inverseSurvivals.add(i);
    }

    return GameOfLifeRules(survivals: inverseSurvivals, births: inverseBirths);
  }

  static Set<int> toSet(String input) {
    input = input.replaceAll(RegExp(r'[^0-8]'), '');
    return input.split('').map((e) => int.parse(e)).toSet();
  }
}

const List<GameOfLifeRules> DEFAULT_GAME_OF_LIFE_RULES = [
  GameOfLifeRules(survivals: {2, 3}, births: {3}, key: 'gameoflife_conway'),
  GameOfLifeRules(survivals: {1, 3, 5, 7}, births: {1, 3, 5, 7}, key: 'gameoflife_copy'),
  GameOfLifeRules(survivals: {3}, births: {3}, key: 'gameoflife_3_3'),
  GameOfLifeRules(survivals: {1, 3}, births: {3}, key: 'gameoflife_13_3'),
  GameOfLifeRules(survivals: {3, 4}, births: {3}, key: 'gameoflife_34_3'),
  GameOfLifeRules(survivals: {3, 5}, births: {3}, key: 'gameoflife_35_3'),
  GameOfLifeRules(survivals: {2}, births: {3}, key: 'gameoflife_2_3'),
  GameOfLifeRules(survivals: {2, 4}, births: {3}, key: 'gameoflife_24_3'),
  GameOfLifeRules(survivals: {2, 4, 5}, births: {3}, key: 'gameoflife_245_3'),
  GameOfLifeRules(survivals: {1, 2, 5}, births: {3, 6}, key: 'gameoflife_125_36'),
  GameOfLifeRules(survivals: {2, 3}, births: {3}, isInverse: true, key: 'gameoflife_inverseconway'),
  GameOfLifeRules(survivals: {1, 3, 5, 7}, births: {1, 3, 5, 7}, isInverse: true, key: 'gameoflife_inversecopy'),
];