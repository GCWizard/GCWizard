import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/game_of_life/logic/game_of_life.dart';
import 'package:gc_wizard/tools/games/game_of_life/widget/game_of_life_board.dart';

class GameOfLife extends StatefulWidget {
  const GameOfLife({Key? key}) : super(key: key);

  @override
  _GameOfLifeState createState() => _GameOfLifeState();
}

const _KEY_CUSTOM_RULES = 'gameoflife_custom';

class _GameOfLifeState extends State<GameOfLife> {
  late List<List<List<bool>>> _boards;
  List<List<bool>> _currentBoard = [];
  var _currentStep = 0;

  var _currentSize = 12;
  var _currentWrapWorld = false;
  var _currentRules = 'gameoflife_conway';
  late Map<String, GameOfLifeRules?> _allRules;
  var _currentCustomSurvive = '';
  late TextEditingController _currentCustomSurviveController;
  var _currentCustomBirth = '';
  late TextEditingController _currentCustomBirthController;
  var _currentCustomInverse = false;

  final _maskInputFormatter = GCWMaskTextInputFormatter(mask: '*********', filter: {"*": RegExp(r'[012345678]')});

  @override
  void initState() {
    super.initState();

    _currentCustomSurviveController = TextEditingController(text: _currentCustomSurvive);
    _currentCustomBirthController = TextEditingController(text: _currentCustomBirth);

    _generateBoard();

    _allRules = Map<String, GameOfLifeRules?>.from(DEFAULT_GAME_OF_LIFE_RULES);
    _allRules.removeWhere((key, value) => value == null);
    _allRules.putIfAbsent(_KEY_CUSTOM_RULES, () => null);
  }

  @override
  void dispose() {
    _currentCustomSurviveController.dispose();
    _currentCustomBirthController.dispose();

    super.dispose();
  }

  void _generateBoard() {
    var _newBoard =
        List<List<bool>>.generate(_currentSize, (index) => List<bool>.generate(_currentSize, (index) => false));

    if (_currentBoard.isEmpty) {
      var limit = min(_currentSize, _currentBoard.length);

      for (int i = 0; i < limit; i++) {
        for (int j = 0; j < limit; j++) {
          _newBoard[i][j] = _currentBoard[i][j];
        }
      }
    }

    _boards = <List<List<bool>>>[];
    _boards.add(_newBoard);

    _currentBoard = List.from(_newBoard);
    _currentStep = 0;
  }

  void _reset({List<List<bool>>? board}) {
    _boards = <List<List<bool>>>[];
    _boards.add(board ?? List.from(_currentBoard));

    _currentStep = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'gameoflife_size'),
          min: 2,
          value: _currentSize,
          onChanged: (value) {
            setState(() {
              _currentSize = value;
              _generateBoard();
              _reset();
            });
          },
        ),
        GCWDropDown<String>(
          title: i18n(context, 'gameoflife_rules'),
          value: _currentRules,
          items: _allRules.keys.map((rules) {
            if (rules == _KEY_CUSTOM_RULES) return GCWDropDownMenuItem(value: rules, child: i18n(context, rules));

            return GCWDropDownMenuItem(
                value: rules,
                child: i18n(context, rules),
                subtitle:
                    '${i18n(context, 'gameoflife_survive')}: ${_getSurvive(_allRules[rules]!)} / ${i18n(context, 'gameoflife_birth')}: ${_getBirth(_allRules[rules]!)}');
          }).toList(),
          onChanged: (String value) {
            setState(() {
              _currentRules = value;
              if (_currentRules == _KEY_CUSTOM_RULES) {
                _currentWrapWorld = _currentCustomInverse;
              } else if (_allRules[_currentRules]!.isInverse) {
                _currentWrapWorld = true;
              }
              _reset();
            });
          },
        ),
        _currentRules == _KEY_CUSTOM_RULES
            ? Column(
                children: [
                  GCWTextField(
                    title: i18n(context, 'gameoflife_survive'),
                    controller: _currentCustomSurviveController,
                    inputFormatters: [_maskInputFormatter],
                    onChanged: (text) {
                      setState(() {
                        _currentCustomSurvive = text;
                        _reset();
                      });
                    },
                  ),
                  GCWTextField(
                    title: i18n(context, 'gameoflife_birth'),
                    controller: _currentCustomBirthController,
                    inputFormatters: [_maskInputFormatter],
                    onChanged: (text) {
                      setState(() {
                        _currentCustomBirth = text;
                        _reset();
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    title: i18n(context, 'gameoflife_inverse'),
                    value: _currentCustomInverse,
                    onChanged: (value) {
                      setState(() {
                        _currentCustomInverse = value;
                        _reset();
                      });
                    },
                  )
                ],
              )
            : Container(),
        GCWOnOffSwitch(
          title: i18n(context, 'gameoflife_wrapworld'),
          value: _currentWrapWorld,
          onChanged: (value) {
            setState(() {
              _currentWrapWorld = value;
              _reset();
            });
          },
        ),
        GCWPainterContainer(
          child: GameOfLifeBoard(
            state: _currentBoard,
            size: _currentSize,
            onChanged: (newBoard) {
              setState(() {
                _reset(board: newBoard);
              });
            },
          ),
        ),
        Row(
          children: [
            GCWIconButton(
              icon: Icons.double_arrow,
              rotateDegrees: 180.0,
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 10; i++) {
                    _backwards();
                  }
                });
              },
            ),
            GCWIconButton(
              icon: Icons.arrow_back_ios,
              onPressed: () {
                setState(() {
                  _backwards();
                });
              },
            ),
            Expanded(
              child: GCWText(
                  align: Alignment.center,
                  text:
                      '${i18n(context, 'gameoflife_step')}: $_currentStep\n${i18n(context, 'gameoflife_livingcells', parameters: [
                        _countCells()
                      ])}'),
            ),
            GCWIconButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                setState(() {
                  _forward();
                });
              },
            ),
            GCWIconButton(
              icon: Icons.double_arrow,
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 10; i++) {
                    _forward();
                  }
                });
              },
            ),
          ],
        ),
        GCWButton(
          text: _currentRules == _KEY_CUSTOM_RULES
              ? (_currentCustomInverse ? i18n(context, 'gameoflife_fillall') : i18n(context, 'gameoflife_clearall'))
              : (_allRules[_currentRules]!.isInverse
                  ? i18n(context, 'gameoflife_fillall')
                  : i18n(context, 'gameoflife_clearall')),
          onPressed: () {
            setState(() {
              var isInverse = (_currentRules == _KEY_CUSTOM_RULES && _currentCustomInverse) ||
                  (_currentRules != _KEY_CUSTOM_RULES && _allRules[_currentRules]!.isInverse);
              _currentBoard = List<List<bool>>.generate(
                  _currentSize, (index) => List<bool>.generate(_currentSize, (index) => isInverse));

              _reset();
            });
          },
        )
      ],
    );
  }

  void _forward() {
    _currentStep++;

    _calculateStep();
  }

  void _backwards() {
    if (_currentStep > 0) _currentStep--;

    _calculateStep();
  }

  String _getSurvive(GameOfLifeRules rules) {
    GameOfLifeRules _rules;
    if (rules.isInverse) {
      _rules = rules.inverseRules();
    } else {
      _rules = rules;
    }

    var survivals = _rules.survivals.toList();
    survivals.sort();

    var out = survivals.join(',');
    if (out.isEmpty) return '-';
    return out;
  }

  String _getBirth(GameOfLifeRules rules) {
    GameOfLifeRules _rules;
    if (rules.isInverse) {
      _rules = rules.inverseRules();
    } else {
      _rules = rules;
    }

    var births = _rules.births.toList();
    births.sort();

    var out = births.join(',');
    if (out.isEmpty) return '-';
    return out;
  }

  int _countCells() {
    var counter = 0;
    for (int i = 0; i < _currentSize; i++) {
      for (int j = 0; j < _currentSize; j++) {
        if (_currentBoard[i][j]) counter++;
      }
    }

    return counter;
  }

  Set<int> _toSet(String input) {
    input = input.replaceAll(RegExp(r'[^0-8]'), '');
    return input.split('').map((e) => int.parse(e)).toSet();
  }

  void _calculateStep() {
    if (_currentStep < _boards.length) {
      _currentBoard = List.from(_boards[_currentStep]);
      return;
    }

    GameOfLifeRules rules;
    if (_currentRules == _KEY_CUSTOM_RULES) {
      rules = GameOfLifeRules(
          survivals: _toSet(_currentCustomSurvive),
          births: _toSet(_currentCustomBirth),
          isInverse: _currentCustomInverse);
    } else {
      rules = _allRules[_currentRules] ?? const GameOfLifeRules();
    }

    _boards.add(calculateGameOfLifeStep(_currentBoard, rules, isWrapWorld: _currentWrapWorld));
    _currentBoard = List.from(_boards.last);
  }
}
