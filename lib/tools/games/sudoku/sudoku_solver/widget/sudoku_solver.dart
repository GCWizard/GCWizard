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
  const SudokuSolver({Key? key}) : super(key: key);

  @override
  SudokuSolverState createState() => SudokuSolverState();
}

class SudokuSolverState extends State<SudokuSolver> {
  late SudokuBoard _currentBoard;
  int _currentSolution = 0;

  final int _MAX_SOLUTIONS = 1000;

  @override
  void initState() {
    super.initState();

    _currentBoard = SudokuBoard();
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
              });
            },
          ),
        ),
        Container(
            height: 8 * DOUBLE_DEFAULT_MARGIN
        ),
        if (_currentBoard.solutions != null && _currentBoard.solutions!.length > 1)
          Row(
            children: [
              GCWIconButton(
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  setState(() {
                    _currentSolution = (_currentSolution - 1 + _currentBoard.solutions!.length) % _currentBoard.solutions!.length;
                    _showSolution();
                  });
                },
              ),
              Expanded(
                child: GCWText(
                  align: Alignment.center,
                  text: '${_currentSolution + 1}/${_currentBoard.solutions!.length}' +
                      (_currentBoard.solutions!.length >= _MAX_SOLUTIONS ? ' *' : ''),
                ),
              ),
              GCWIconButton(
                icon: Icons.arrow_forward_ios,
                onPressed: () {
                  setState(() {
                    _currentSolution = (_currentSolution + 1) % _currentBoard.solutions!.length;
                    _showSolution();
                  });
                },
              ),
            ],
          ),
        if (_currentBoard.solutions != null && _currentBoard.solutions!.length >= _MAX_SOLUTIONS)
          Container(
            padding: const EdgeInsets.only(top: DOUBLE_DEFAULT_MARGIN),
            child: GCWText(text: '*) ' + i18n(context, 'sudokusolver_maximumsolutions')),
          ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: GCWButton(
                  text: i18n(context, 'sudokusolver_solve'),
                  onPressed: () {
                    setState(() {
                      _currentBoard.solveSudoku(_MAX_SOLUTIONS);
                      if (_currentBoard.solutions == null) {
                        showToast(i18n(context, 'sudokusolver_error'));
                      } else {
                        _currentSolution = 0;
                        _showSolution();
                      }
                    });
                  },
                ),
              ),
            ),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                  child: GCWButton(
                    text: i18n(context, 'sudokusolver_clearcalculated'),
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < 9; i++) {
                          for (int j = 0; j < 9; j++) {
                            if (_currentBoard.getFillType(i, j) == SudokuFillType.CALCULATED) {
                              _currentBoard.setValue(i, j, null);
                            }
                          }
                        }
                        _currentBoard.solutions = null;
                      });
                    },
                  ),
                )),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
                  child: GCWButton(
                    text: i18n(context, 'sudokusolver_clearall'),
                    onPressed: () {
                      showDeleteAlertDialog(
                        context,
                        i18n(context, 'sudokusolver_clearall_board'),
                            () {
                          setState(() {
                            _currentBoard = SudokuBoard();
                          });
                        },
                      );
                    },
                  ),
                ))
          ],
        )
      ],
    );
  }

  void _showSolution() {
    if (_currentBoard.solutions == null || _currentSolution >= _currentBoard.solutions!.length) return;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_currentBoard.getFillType(i, j) == SudokuFillType.USER_FILLED) continue;
        _currentBoard.setValue(i, j, _currentBoard.solutions![_currentSolution].getValue(i, j),
            type: SudokuFillType.CALCULATED);
      }
    }
  }
}
