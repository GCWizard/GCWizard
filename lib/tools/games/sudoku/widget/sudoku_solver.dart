import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_page_spinner.dart';
import 'package:gc_wizard/tools/games/sudoku/logic/sudoku_solver.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/games/sudoku/widget/sudoku_board.dart';

class SudokuSolver extends StatefulWidget {
  const SudokuSolver({super.key});

  @override
  _SudokuSolverState createState() => _SudokuSolverState();
}

class _SudokuSolverState extends State<SudokuSolver> {
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
        GCWPainterContainer(
          child: _SudokuBoard(
            board: _currentBoard,
            onChanged: (newBoard) {
              setState(() {
                _currentBoard = newBoard;
              });
            },
          ),
        ),
        Container(height: 8 * DOUBLE_DEFAULT_MARGIN),
        if (_currentBoard.solutions != null && _currentBoard.solutions!.length > 1)
          GCWPageSpinner(
            textExtension:  (_currentBoard.solutions!.length >= _MAX_SOLUTIONS ? ' *' : ''),
            max: _currentBoard.solutions!.length,
            index: _currentSolution + 1,
            onChanged: (index) {
              setState(() {
                _currentSolution = index - 1;
                _showSolution();
              });
            },
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
                        showSnackBar(i18n(context, 'sudokusolver_error'), context);
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
                    _currentBoard.removeCalculated();
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
    _currentBoard.mergeSolution(_currentSolution);
  }
}
