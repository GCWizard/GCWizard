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
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/wordoku/logic/wordoku_solver.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/games/wordoku/widget/wordoku_board.dart';

class WordokuSolver extends StatefulWidget {
  const WordokuSolver({super.key});

  @override
  _WordokuSolverState createState() => _WordokuSolverState();
}

class _WordokuSolverState extends State<WordokuSolver> {
  late WordokuBoard _currentBoard;
  late TextEditingController _charController;
  int _currentSolution = 0;

  final int _MAX_SOLUTIONS = 1000;

  @override
  void initState() {
    super.initState();

    _currentBoard = WordokuBoard();
    _charController = TextEditingController(text: _currentBoard.mapLetters);
  }

  @override
  void dispose() {
    _charController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          maxLength: 9,
          title: i18n(context, 'common_letters'),
          controller: _charController,
          onChanged: (value) {
            setState(() {
              _currentBoard.mapLetters = value;
            });
          }
        ),
        GCWPainterContainer(
          child: _WordokuBoard(
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
                      _currentBoard.solveWordoku(_MAX_SOLUTIONS);
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
                        _currentBoard = WordokuBoard();
                        _charController.text = _currentBoard.mapLetters;
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
