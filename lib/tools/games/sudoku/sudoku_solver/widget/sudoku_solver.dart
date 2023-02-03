import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/tools/games/sudoku/logic/sudoku_solver.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_board.dart';

class SudokuSolver extends StatefulWidget {
  @override
  SudokuSolverState createState() => SudokuSolverState();
}

class SudokuSolverState extends State<SudokuSolver> {
  List<List<Map<String, dynamic>>> _currentBoard;
  List<List<List<int>>> _currentSolutions;
  int _currentSolution = 0;

  final int _MAX_SOLUTIONS = 1000;

  @override
  void initState() {
    super.initState();

    _currentBoard = List<List<Map<String, dynamic>>>.generate(
        9, (index) => List<Map<String, dynamic>>.generate(9, (index) => null));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: min(500, MediaQuery.of(context).size.height * 0.8)),
          child: _SudokuBoard(
            board: _currentBoard,
            onChanged: (newBoard) {
              setState(() {
                _currentBoard = newBoard;
                _currentSolutions = null;
              });
            },
          ),
        ),
        Container(
          height: 8 * DOUBLE_DEFAULT_MARGIN
        ),
        if (_currentSolutions != null && _currentSolutions.length > 1)
          Row(
            children: [
              GCWIconButton(
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  setState(() {
                    _currentSolution = (_currentSolution - 1 + _currentSolutions.length) % _currentSolutions.length;
                    _showSolution();
                  });
                },
              ),
              Expanded(
                child: GCWText(
                  align: Alignment.center,
                  text: '${_currentSolution + 1}/${_currentSolutions.length}' +
                      (_currentSolutions.length >= _MAX_SOLUTIONS ? ' *' : ''),
                ),
              ),
              GCWIconButton(
                icon: Icons.arrow_forward_ios,
                onPressed: () {
                  setState(() {
                    _currentSolution = (_currentSolution + 1) % _currentSolutions.length;
                    _showSolution();
                  });
                },
              ),
            ],
          ),
        if (_currentSolutions != null && _currentSolutions.length >= _MAX_SOLUTIONS)
          Container(
            child: GCWText(text: '*) ' + i18n(context, 'sudokusolver_maximumsolutions')),
            padding: EdgeInsets.only(top: DOUBLE_DEFAULT_MARGIN),
          ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: GCWButton(
                  text: i18n(context, 'sudokusolver_solve'),
                  onPressed: () {
                    setState(() {
                      List<List<int>> solveableBoard = _currentBoard.map((column) {
                        return column
                            .map((row) =>
                                row != null && row['type'] == _SudokuFillType.USER_FILLED ? row['value'] as int : 0)
                            .toList();
                      }).toList();

                      _currentSolutions = solveSudoku(solveableBoard, _MAX_SOLUTIONS);
                      if (_currentSolutions == null) {
                        showToast(i18n(context, 'sudokusolver_error'));
                      } else {
                        _currentSolution = 0;
                        _showSolution();
                      }
                    });
                  },
                ),
                padding: EdgeInsets.only(right: DEFAULT_MARGIN),
              ),
            ),
            Expanded(
                child: Container(
              child: GCWButton(
                text: i18n(context, 'sudokusolver_clearcalculated'),
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < 9; i++) {
                      for (int j = 0; j < 9; j++) {
                        if (_currentBoard[i][j] != null && _currentBoard[i][j]['type'] == _SudokuFillType.CALCULATED)
                          _currentBoard[i][j] = null;
                      }
                    }
                    _currentSolutions = null;
                  });
                },
              ),
              padding: EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
            )),
            Expanded(
                child: Container(
              child: GCWButton(
                text: i18n(context, 'sudokusolver_clearall'),
                onPressed: () {
                  showDeleteAlertDialog(
                    context,
                    i18n(context, 'sudokusolver_clearall_board'),
                        () {
                        setState(() {
                          _currentBoard = List<List<Map<String, dynamic>>>.generate(
                              9, (index) => List<Map<String, dynamic>>.generate(9, (index) => null));

                          _currentSolutions = null;
                        });
                    },
                  );
                },
              ),
              padding: EdgeInsets.only(left: DEFAULT_MARGIN),
            ))
          ],
        )
      ],
    );
  }

  _showSolution() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_currentBoard[i][j] != null && _currentBoard[i][j]['type'] == _SudokuFillType.USER_FILLED) continue;

        _currentBoard[i][j] = {'value': _currentSolutions[_currentSolution][i][j], 'type': _SudokuFillType.CALCULATED};
      }
    }
  }
}
