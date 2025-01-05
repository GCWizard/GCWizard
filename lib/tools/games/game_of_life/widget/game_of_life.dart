import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/game_of_life/logic/game_of_life.dart';
import 'package:gc_wizard/tools/games/game_of_life/widget/game_of_life_board.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';

class GameOfLife extends StatefulWidget {
  const GameOfLife({Key? key}) : super(key: key);

  @override
  _GameOfLifeState createState() => _GameOfLifeState();
}

class _GameOfLifeState extends State<GameOfLife> {
  static var _currentSize = const Point<int>(12, 12);
  late GameOfLifeData _board;

  var _currentWrapWorld = false;
  late List<GameOfLifeRules> _allRules;
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

    _allRules = List<GameOfLifeRules>.from(DEFAULT_GAME_OF_LIFE_RULES);
    _allRules.add(const GameOfLifeRules(key: KEY_CUSTOM_RULES));

    _board = GameOfLifeData(_currentSize, _allRules.first);
  }

  @override
  void dispose() {
    _currentCustomSurviveController.dispose();
    _currentCustomBirthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWOpenFile(
          title: i18n(context, 'common_import') + ' RLE',
          onLoaded: (GCWFile? value) {
            if (value == null) {
              showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
            } else {
              var __board = importRLE(value);
              if (__board != null) {
                if (max(__board.size.x, __board.size.y) > MAX_SIZE) {
                  showSnackBar(i18n(context, 'gameoflife_size_too_large', parameters: [MAX_SIZE]), context);
                } else {
                  _board = __board;
                  _currentSize = _board.size;
                }
              } else {
                showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
              }
            }
            setState(() {});
        }),
        const SizedBox(height: 10),
        _buildSize(),
        _buildRules(),
        GCWPainterContainer(
          child: GameOfLifeBoard(
            state: _board.currentBoard,
            size: _currentSize,
            onChanged: (newBoard) {
              setState(() {
                _board.reset(board: newBoard);
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
                      i18n(context, 'gameoflife_step') + ': ' + _board.step.toString() + '\n' +
                          i18n(context, 'gameoflife_livingcells', parameters: [_board.countCells()])
              ),
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
          text: _board.rules.key == KEY_CUSTOM_RULES
              ? (_currentCustomInverse ? i18n(context, 'gameoflife_fillall') : i18n(context, 'gameoflife_clearall'))
              : (_board.rules.isInverse
                  ? i18n(context, 'gameoflife_fillall')
                  : i18n(context, 'gameoflife_clearall')),
          onPressed: () {
            setState(() {
              var isInverse = (_board.rules.key == KEY_CUSTOM_RULES && _currentCustomInverse) ||
                  (_board.rules.key != KEY_CUSTOM_RULES && _board.rules.isInverse);

              _board.currentBoard = List<List<bool>>.generate(
                  _board.size.y, (index) => List<bool>.generate(_board.size.x, (index) => isInverse));

              if (_board.rules.key == KEY_CUSTOM_RULES) {
                _setBoardCustomRules();
              }
              _board.reset();
            });
          },
        )
      ],
    );
  }

  Widget _buildSize() {
    var differentSize = _board.size.x != _board.size.y;

    return Column(
        children: <Widget>[
          GCWIntegerSpinner(
            title: i18n(context, 'gameoflife_size'),
            min: 2,
            max: MAX_SIZE,
            value: _currentSize.x,
            onChanged: (value) {
              setState(() {
                _currentSize = differentSize ? Point<int>(value, _currentSize.y) : Point<int>(value, value);
                _board = GameOfLifeData(_currentSize, _board.rules, content: _board.currentBoard);
                _board.reset();
              });
            },
        ),
        (differentSize)
        ? Row(
            children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 3,
                  child: GCWIntegerSpinner(
                    min: 2,
                    max: MAX_SIZE,
                    value: _currentSize.y,
                    onChanged: (value) {
                      setState(() {
                        _currentSize = differentSize ? Point<int>(_currentSize.x, value) : Point<int>(value, value);
                        _board = GameOfLifeData(_currentSize, _board.rules, content: _board.currentBoard);
                        _board.reset();
                      });
                    },
                  )
                )
            ]
        ) : Container()
      ]
    );
  }

  Widget _buildRules() {
    return Column(
        children: <Widget>[
          GCWDropDown<GameOfLifeRules>(
            title: i18n(context, 'gameoflife_rules'),
            value: _board.rules,
            items: _allRules.map((rules) {
              if (rules.key == KEY_CUSTOM_RULES) return GCWDropDownMenuItem(value: rules, child: i18n(context, rules.key));

              return GCWDropDownMenuItem(
                  value: rules,
                  child: i18n(context, rules.key),
                  subtitle:
                  '${i18n(context, 'gameoflife_survive')}: ${_getSurvive(rules)} / ${i18n(context,
                      'gameoflife_birth')}: ${_getBirth(rules)}');
            }).toList(),
            onChanged: (GameOfLifeRules value) {
              setState(() {
                _board.rules = value;
                if (_board.rules.key == KEY_CUSTOM_RULES) {
                  _currentWrapWorld = _currentCustomInverse;
                } else if (_board.rules.isInverse) {
                  _currentWrapWorld = true;
                }
                _board.reset();
              });
            },
          ),
          _board.rules.key == KEY_CUSTOM_RULES
              ? Column(
                children: [
                  GCWTextField(
                    title: i18n(context, 'gameoflife_survive'),
                    controller: _currentCustomSurviveController,
                    inputFormatters: [_maskInputFormatter],
                    onChanged: (text) {
                      setState(() {
                        _currentCustomSurvive = text;
                        _setBoardCustomRules();
                        _board.reset();
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
                        _setBoardCustomRules();
                        _board.reset();
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    title: i18n(context, 'gameoflife_inverse'),
                    value: _currentCustomInverse,
                    onChanged: (value) {
                      setState(() {
                        _currentCustomInverse = value;
                        _setBoardCustomRules();
                        _board.reset();
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
                _board.reset();
              });
            },
          ),
          ]
    );
  }

  void _forward() {
    _board.step++;

    _calculateStep();
  }

  void _backwards() {
    if (_board.step > 0) _board.step--;

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


  void _setBoardCustomRules() {
    if (_board.rules.key == KEY_CUSTOM_RULES) {
      _board.rules = GameOfLifeRules(
          survivals: GameOfLifeRules.toSet(_currentCustomSurvive),
          births: GameOfLifeRules.toSet(_currentCustomBirth),
          isInverse: _currentCustomInverse);
    }
  }

  void _calculateStep() {
    if (_board.step < _board.boards.length) {
      _board.currentBoard = List.from(_board.boards[_board.step]);
      return;
    }

    _board.boards.add(_board.calculateStep(_board.currentBoard, isWrapWorld: _currentWrapWorld));
    _board.currentBoard = List.from(_board.boards.last);
  }
}
