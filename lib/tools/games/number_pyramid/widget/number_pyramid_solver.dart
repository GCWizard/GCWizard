import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/number_pyramid/logic/number_pyramid_solver.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/games/number_pyramid/widget/number_pyramid_board.dart';

class NumberPyramidSolver extends StatefulWidget {
  const NumberPyramidSolver({Key? key}) : super(key: key);

  @override
  NumberPyramidSolverState createState() => NumberPyramidSolverState();
}

class NumberPyramidSolverState extends State<NumberPyramidSolver> {
  late NumberPyramid _currentBoard;
  int _currentSolution = 0;

  final int _MAX_SOLUTIONS = 10;
  var _rowCount = 3;
  double _scale = 1;

  @override
  void initState() {
    super.initState();

    _currentBoard = NumberPyramid(_rowCount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'common_row_count'),
          value: _rowCount,
          min: 1,
          onChanged: (value) {
            setState(() {
              _rowCount = value;
              _scale = min((maxScreenWidth(context) - 2 * DEFAULT_DESCRIPTION_MARGIN) / (100.0 * _rowCount), 1.0);
              _currentBoard = NumberPyramid(_rowCount, pyramid: _currentBoard);
            });
          },
        ),
        Container(height: 10),
        GCWPainterContainer(
          scale: _scale,
          onChanged: (value) {
            _scale = value;
          },
          child: NumberPyramidBoard(
            board: _currentBoard,
            onChanged: (newBoard) {
              setState(() {
                _currentBoard = newBoard;
                _hideInputTextBox();
              });
            },
          ),
        ),
        if (_currentBoard.solutions != null && _currentBoard.solutions!.length > 1)
          Container(
            margin: const EdgeInsets.only(top: 5 * DOUBLE_DEFAULT_MARGIN),
            child: Row(
              children: [
                GCWIconButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () {
                    setState(() {
                      _currentSolution =
                          (_currentSolution - 1 + _currentBoard.solutions!.length) % _currentBoard.solutions!.length;
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
                      _hideInputTextBox();
                      _currentBoard.solvePyramid(_MAX_SOLUTIONS);
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
                        _hideInputTextBox();
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
                      setState(() {
                        _hideInputTextBox();
                        _currentBoard = NumberPyramid(_rowCount);
                      });
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
