import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/nonogram/logic/puzzle.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/games/nonogram/widget/nonogram_board.dart';

class NonogramSolver extends StatefulWidget {
  const NonogramSolver({Key? key}) : super(key: key);

  @override
  NonogramSolverState createState() => NonogramSolverState();
}

enum _DecryptWizardStep {
  FILE_OR_MANUAL,
  LOAD_JSON,
  SHOW_RESULT_FILE,
  DEFINE_SIZE,
  SET_ROW_VALUES,
  SET_COLUMN_VALUES,
  SHOW_RESULT_MANUAL
}

enum _EncryptWizardStep {
  FILE_OR_MANUAL,
  LOAD_JSON,
  DRAW_LOADED_JSON,
  DEFINE_SIZE_IMAGE,
  LOAD_IMAGE,
  DRAW_LOADED_IMAGE,
  DEFINE_SIZE,
  DRAW_MANUALLY
}

class NonogramSolverState extends State<NonogramSolver> {
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  late PuzzleWidgetValues _decryptPuzzle;
  late PuzzleWidgetValues _encryptPuzzle;

  _DecryptWizardStep _currentDecryptStep = _DecryptWizardStep.FILE_OR_MANUAL;
  _EncryptWizardStep _currentEncryptStep = _EncryptWizardStep.FILE_OR_MANUAL;

  @override
  void initState() {
    super.initState();

    _decryptPuzzle = PuzzleWidgetValues();
    _encryptPuzzle = PuzzleWidgetValues(encryptVersion: true);
  }

  @override
  void dispose() {
    _decryptPuzzle.dispose();
    _encryptPuzzle.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      _currentMode == GCWSwitchPosition.left
          ? GCWTextDivider(
              text: i18n(context, 'nonogramsolver_setup_generator'),
              trailing: GCWIconButton(
                iconColor: _currentEncryptStep == _EncryptWizardStep.FILE_OR_MANUAL ? themeColors().inActive() : null,
                size: IconButtonSize.SMALL,
                icon: Icons.undo,
                onPressed: () {
                  if (_currentEncryptStep == _EncryptWizardStep.FILE_OR_MANUAL) {
                    return;
                  }

                  setState(() {
                    switch (_currentEncryptStep) {
                      case _EncryptWizardStep.LOAD_JSON:
                        _currentEncryptStep = _EncryptWizardStep.FILE_OR_MANUAL;
                        break;
                      case _EncryptWizardStep.DRAW_LOADED_JSON:
                        _currentEncryptStep = _EncryptWizardStep.LOAD_JSON;
                        break;
                      case _EncryptWizardStep.DEFINE_SIZE_IMAGE:
                        _currentEncryptStep = _EncryptWizardStep.FILE_OR_MANUAL;
                        break;
                      case _EncryptWizardStep.LOAD_IMAGE:
                        _currentEncryptStep = _EncryptWizardStep.DEFINE_SIZE_IMAGE;
                        break;
                      case _EncryptWizardStep.DRAW_LOADED_IMAGE:
                        _currentEncryptStep = _EncryptWizardStep.LOAD_IMAGE;
                        break;
                      case _EncryptWizardStep.DEFINE_SIZE:
                        _currentEncryptStep = _EncryptWizardStep.FILE_OR_MANUAL;
                        break;
                      case _EncryptWizardStep.DRAW_MANUALLY:
                        _currentEncryptStep = _EncryptWizardStep.DEFINE_SIZE;
                        break;
                      default:
                        _currentEncryptStep = _EncryptWizardStep.FILE_OR_MANUAL;
                        break;
                    }

                    _encryptPuzzle.resetCalculation();
                  });
                },
              ))
          : GCWTextDivider(
              text: i18n(context, 'nonogramsolver_setup_solver'),
              trailing: _buildDecryptTrailingButtons(_decryptPuzzle)),
      _currentMode == GCWSwitchPosition.right ? _puzzleWidget(_decryptPuzzle) : _puzzleWidget(_encryptPuzzle)
    ]);
  }

  Widget _puzzleWidget(PuzzleWidgetValues puzzle) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? Column(
                children: [
                  if (_currentEncryptStep == _EncryptWizardStep.FILE_OR_MANUAL)
                    Column(
                      children: [
                        GCWText(text: i18n(context, 'nonogramsolver_generator_loadfrom_hint')),
                        Container(height: DOUBLE_DEFAULT_MARGIN),
                        Row(
                          children: [
                            Expanded(
                                child: GCWButton(
                                    text: i18n(context, 'nonogramsolver_loadfromimage'),
                                    onPressed: () {
                                      setState(() {
                                        _currentEncryptStep = _EncryptWizardStep.DEFINE_SIZE_IMAGE;
                                      });
                                    })),
                            Container(width: DOUBLE_DEFAULT_MARGIN),
                            Expanded(
                                child: GCWButton(
                                    text: i18n(context, 'nonogramsolver_loadfromjson'),
                                    onPressed: () {
                                      setState(() {
                                        _currentEncryptStep = _EncryptWizardStep.LOAD_JSON;
                                      });
                                    })),
                            Container(width: DOUBLE_DEFAULT_MARGIN),
                            Expanded(
                                child: GCWButton(
                                    text: i18n(context, 'nonogramsolver_drawmanually'),
                                    onPressed: () {
                                      setState(() {
                                        _currentEncryptStep = _EncryptWizardStep.DEFINE_SIZE;
                                      });
                                    })),
                          ],
                        ),
                      ],
                    ),
                  if (_currentEncryptStep == _EncryptWizardStep.LOAD_JSON)
                    _openFileButtonEncrypt(puzzle, _currentEncryptStep),
                  if (_currentEncryptStep == _EncryptWizardStep.LOAD_IMAGE)
                    _openFileButtonEncrypt(puzzle, _currentEncryptStep),
                  if (_currentEncryptStep == _EncryptWizardStep.DEFINE_SIZE ||
                      _currentEncryptStep == _EncryptWizardStep.DEFINE_SIZE_IMAGE)
                    _buildSizeSelection(puzzle),
                  if ([
                        _EncryptWizardStep.DRAW_LOADED_JSON,
                        _EncryptWizardStep.DRAW_LOADED_IMAGE,
                        _EncryptWizardStep.DRAW_MANUALLY
                      ].contains(_currentEncryptStep) &&
                      [PuzzleState.Ok, PuzzleState.Solved].contains(puzzle.board.state))
                    Column(
                      children: [
                        _drawNonogramm(puzzle),
                        _controlButtons(puzzle),
                        _encryptPreview(puzzle),
                        _exportButtons(puzzle),
                      ],
                    ),
                  if ([
                        _EncryptWizardStep.DRAW_LOADED_JSON,
                        _EncryptWizardStep.DRAW_LOADED_IMAGE,
                        _EncryptWizardStep.DRAW_MANUALLY
                      ].contains(_currentEncryptStep) &&
                      ![PuzzleState.Ok, PuzzleState.Solved].contains(puzzle.board.state))
                    Column(children: [
                      GCWDefaultOutput(
                        child: _dataErrorText(puzzle.board),
                      )
                    ])
                ],
              )
            : Column(
                children: [
                  if (_currentDecryptStep == _DecryptWizardStep.FILE_OR_MANUAL)
                    Column(
                      children: [
                        GCWText(text: i18n(context, 'nonogramsolver_solver_loadfrom_hint')),
                        Container(height: DOUBLE_DEFAULT_MARGIN),
                        Row(
                          children: [
                            Expanded(
                                child: GCWButton(
                                    text: i18n(context, 'nonogramsolver_loadfromjson'),
                                    onPressed: () {
                                      setState(() {
                                        _currentDecryptStep = _DecryptWizardStep.LOAD_JSON;
                                      });
                                    })),
                            Container(width: DOUBLE_DEFAULT_MARGIN),
                            Expanded(
                                child: GCWButton(
                                    text: i18n(context, 'nonogramsolver_createmanually'),
                                    onPressed: () {
                                      setState(() {
                                        _currentDecryptStep = _DecryptWizardStep.DEFINE_SIZE;
                                      });
                                    })),
                          ],
                        ),
                      ],
                    ),
                  if (_currentDecryptStep == _DecryptWizardStep.LOAD_JSON) _openFileButtonDecrypt(puzzle),
                  if (_currentDecryptStep == _DecryptWizardStep.DEFINE_SIZE) _buildSizeSelection(puzzle),
                  if (_currentDecryptStep == _DecryptWizardStep.SET_ROW_VALUES) _buildRowHints(puzzle),
                  if (_currentDecryptStep == _DecryptWizardStep.SET_COLUMN_VALUES) _buildColumnHints(puzzle),
                  if ([_DecryptWizardStep.SHOW_RESULT_MANUAL, _DecryptWizardStep.SHOW_RESULT_FILE]
                          .contains(_currentDecryptStep) &&
                      [PuzzleState.Ok, PuzzleState.Solved].contains(puzzle.board.state))
                    Column(
                      children: [
                        _drawNonogramm(puzzle),
                        _controlButtons(puzzle),
                        _exportButtons(puzzle),
                      ],
                    ),
                  if ([_DecryptWizardStep.SHOW_RESULT_MANUAL, _DecryptWizardStep.SHOW_RESULT_FILE]
                          .contains(_currentDecryptStep) &&
                      ![PuzzleState.Ok, PuzzleState.Solved].contains(puzzle.board.state))
                    GCWDefaultOutput(
                      child: _dataErrorText(puzzle.board),
                    )
                ],
              )
      ],
    );
  }

  Widget _drawNonogramm(PuzzleWidgetValues puzzle) {
    return GCWPainterContainer(
      scale: puzzle.scale,
      suppressTopSpace: true,
      suppressBottomSpace: true,
      onChanged: (value) {
        puzzle.scale = value;
      },
      child: NonogramBoard(
        board: puzzle.board,
        onChanged: (newBoard) {
          setState(() {
            puzzle.board = newBoard;
          });
        },
        onTapped: (row, column) {
          puzzle.encryptVersion
              ? setState(() {
                  puzzle.onTapped(row, column);
                })
              : null;
        },
      ),
    );
  }

  Widget _openFileButtonEncrypt(PuzzleWidgetValues puzzle, _EncryptWizardStep type) {
    var fileTypes = <FileType>[];
    var title = '';

    switch (type) {
      case _EncryptWizardStep.LOAD_JSON:
        fileTypes = [FileType.TXT, FileType.JSON];
        title = 'JSON/TXT';
        break;
      case _EncryptWizardStep.LOAD_IMAGE:
        fileTypes = SUPPORTED_IMAGE_TYPES;
        title = i18n(context, 'common_image');
        break;
      default:
        fileTypes = [FileType.TXT, FileType.JSON];
        break;
    }

    return GCWOpenFile(
        title: title,
        supportedFileTypes: fileTypes,
        onLoaded: (GCWFile? value) {
          if (value == null) {
            showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
            return;
          } else if (isImage(value.bytes)) {
            puzzle.board.importImage(value.bytes);
            _currentEncryptStep = _EncryptWizardStep.DRAW_LOADED_IMAGE;
          } else {
            _importJsonFile(value.bytes, puzzle);
            _currentEncryptStep = _EncryptWizardStep.DRAW_LOADED_JSON;
          }
          setState(() {});
        });
  }

  Widget _openFileButtonDecrypt(PuzzleWidgetValues puzzle) {
    return GCWOpenFile(
      title: 'JSON/TXT',
      supportedFileTypes: const [FileType.TXT, FileType.JSON],
      onLoaded: (GCWFile? value) {
        if (value == null) {
          showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
          return;
        }
        _importJsonFile(value.bytes, puzzle);
        setState(() {
          _currentDecryptStep = _DecryptWizardStep.SHOW_RESULT_FILE;
        });
      },
    );
  }

  Widget _buildSizeSelection(PuzzleWidgetValues puzzle) {
    return Column(children: <Widget>[
      GCWIntegerSpinner(
          title: i18n(context, 'common_row_count'),
          controller: puzzle.rowCountController,
          flexValues: const [1, 1],
          value: puzzle.rowCount,
          min: 1,
          onChanged: (value) {
            setState(() {
              puzzle.rowCount = value;
            });
          }),
      GCWIntegerSpinner(
          title: i18n(context, 'common_column_count'),
          controller: puzzle.columnCountController,
          flexValues: const [1, 1],
          value: puzzle.columnCount,
          min: 1,
          onChanged: (value) {
            setState(() {
              puzzle.columnCount = value;
            });
          }),
      GCWButton(
          text: i18n(context, 'common_next'),
          onPressed: () {
            setState(() {
              puzzle.scale = 1.0;
              var tmpPuzzle = puzzle.board;
              puzzle.board = Puzzle.generate(puzzle.rowCount, puzzle.columnCount);
              puzzle.board.importHints(tmpPuzzle);

              if (puzzle.encryptVersion) {
                _currentEncryptStep = _currentEncryptStep == _EncryptWizardStep.DEFINE_SIZE_IMAGE
                    ? _EncryptWizardStep.LOAD_IMAGE
                    : _EncryptWizardStep.DRAW_MANUALLY;
              } else {
                puzzle.clearRowHints();
                puzzle.clearColumnHints();
                _currentDecryptStep = _DecryptWizardStep.SET_ROW_VALUES;
              }
            });
          }),
    ]);
  }

  Widget _buildRowHints(PuzzleWidgetValues puzzle) {
    var list = <Widget>[];

    for (var i = 0; i < puzzle.rowCount; i++) {
      var controller = puzzle.getRowController(i);
      var row = Row(children: <Widget>[
        Expanded(flex: 2, child: GCWText(text: i18n(context, 'common_row') + ' ' + (i + 1).toString())),
        Expanded(flex: 3, child: GCWTextField(controller: controller, onChanged: (text) {}))
      ]);
      list.add(row);
    }

    list.add(GCWButton(
        text: i18n(context, 'common_next'),
        onPressed: () {
          setState(() {
            setState(() {
              for (var i = 0; i < puzzle.rowCount; i++) {
                var _encryptList = textToIntList(puzzle.getRowController(i).text, allowNegativeValues: true);
                var dataBackup = _encryptList.sublist(0);
                var data = Puzzle.cleanHints(_encryptList, puzzle.board.width);
                if (!listEquals(data, dataBackup)) {
                  showSnackBar(i18n(context, 'nonogramsolver_hinterror'), context);
                } else {
                  puzzle.board.rowHints[i] = data;
                  _currentDecryptStep = _DecryptWizardStep.SET_COLUMN_VALUES;
                }
              }
            });
          });
        }));

    return Column(
      children: list,
    );
  }

  Widget _buildColumnHints(PuzzleWidgetValues puzzle) {
    var list = <Widget>[];

    for (var i = 0; i < puzzle.columnCount; i++) {
      var controller = puzzle.getColumnController(i);
      var row = Row(children: <Widget>[
        Expanded(
          flex: 2,
          child: GCWText(text: i18n(context, 'common_column') + ' ' + (i + 1).toString()),
        ),
        Expanded(
          flex: 3,
          child: GCWTextField(controller: controller, onChanged: (text) {}),
        )
      ]);
      list.add(row);
    }

    list.add(GCWButton(
        text: i18n(context, 'common_done'),
        onPressed: () {
          setState(() {
            setState(() {
              for (var i = 0; i < puzzle.columnCount; i++) {
                var _encryptList = textToIntList(puzzle.getColumnController(i).text, allowNegativeValues: true);
                var dataBackup = _encryptList.sublist(0);
                var data = Puzzle.cleanHints(_encryptList, puzzle.board.width);
                if (!listEquals(data, dataBackup)) {
                  showSnackBar(i18n(context, 'nonogramsolver_hinterror'), context);
                } else {
                  puzzle.board.columnHints[i] = data;
                  Puzzle.checkConsistency(puzzle.board);
                  _currentDecryptStep = _DecryptWizardStep.SHOW_RESULT_MANUAL;
                }
              }
            });
          });
        }));

    return Column(
      children: list,
    );
  }

  Row _buildDecryptTrailingButtons(PuzzleWidgetValues puzzle) {
    var row = Row(
      children: <Widget>[
        GCWIconButton(
          iconColor: _currentDecryptStep == _DecryptWizardStep.FILE_OR_MANUAL ? themeColors().inActive() : null,
          size: IconButtonSize.SMALL,
          icon: Icons.undo,
          onPressed: () {
            if (_currentDecryptStep == _DecryptWizardStep.FILE_OR_MANUAL) {
              return;
            }
            setState(() {
              switch (_currentDecryptStep) {
                case _DecryptWizardStep.LOAD_JSON:
                  _currentDecryptStep = _DecryptWizardStep.FILE_OR_MANUAL;
                  break;
                case _DecryptWizardStep.SHOW_RESULT_FILE:
                  _currentDecryptStep = _DecryptWizardStep.LOAD_JSON;
                  break;
                case _DecryptWizardStep.DEFINE_SIZE:
                  _currentDecryptStep = _DecryptWizardStep.FILE_OR_MANUAL;
                  break;
                case _DecryptWizardStep.SET_ROW_VALUES:
                  _currentDecryptStep = _DecryptWizardStep.DEFINE_SIZE;
                  break;
                case _DecryptWizardStep.SET_COLUMN_VALUES:
                  _currentDecryptStep = _DecryptWizardStep.SET_ROW_VALUES;
                  break;
                case _DecryptWizardStep.SHOW_RESULT_MANUAL:
                  _currentDecryptStep = _DecryptWizardStep.SET_COLUMN_VALUES;
                  break;
                default:
                  _currentDecryptStep = _DecryptWizardStep.FILE_OR_MANUAL;
                  break;
              }

              _decryptPuzzle.resetCalculation();
            });
          },
        )
      ],
    );

    if (_currentDecryptStep == _DecryptWizardStep.SET_ROW_VALUES) {
      row.children.insertAll(0, _buildCopyPasteTrailingButtons(puzzle.rowController));
    } else if (_currentDecryptStep == _DecryptWizardStep.SET_COLUMN_VALUES) {
      row.children.insertAll(0, _buildCopyPasteTrailingButtons(puzzle.columnController));
    }
    return row;
  }

  List<Widget> _buildCopyPasteTrailingButtons(List<TextEditingController> controller) {
    return <Widget>[
      GCWPasteButton(
        iconSize: IconButtonSize.SMALL,
        onSelected: (text) {
          var lines = const LineSplitter().convert(text);
          for (var i = 0; i < min(controller.length, lines.length); i++) {
            controller[i].text = lines[i];
          }
        },
      ),
      GCWIconButton(
        size: IconButtonSize.SMALL,
        icon: Icons.content_copy,
        onPressed: () {
          var copyText = controller.map((item) {
            return item.text;
          }).join('\n');
          insertIntoGCWClipboard(context, copyText);
        },
      ),
      Container(width: 10)
    ];
  }

  Widget _controlButtons(PuzzleWidgetValues puzzle) {
    return Row(
      children: <Widget>[
        puzzle.encryptVersion
            ? Container()
            : Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                  child: GCWButton(
                    text: i18n(context, 'sudokusolver_solve'),
                    onPressed: () {
                      setState(() {
                        puzzle.board.solve();
                      });
                    },
                  ),
                ),
              ),
        puzzle.encryptVersion
            ? Container()
            : Expanded(
                child: Container(
                padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                child: GCWButton(
                  text: i18n(context, 'sudokusolver_clearcalculated'),
                  onPressed: () {
                    setState(() {
                      puzzle.board.removeCalculated();
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
              showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text(i18n(context, 'nonogramsolver_title')),
                        titleTextStyle:
                            const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                        content: Text(i18n(context, 'nonogramsolver_clear_all_data')),
                        contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
                        backgroundColor: themeColors().dialog(),
                        actions: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (puzzle.encryptVersion && _currentEncryptStep == _EncryptWizardStep.DRAW_MANUALLY) {
                                    puzzle.board = Puzzle.generate(puzzle.rowCount, puzzle.columnCount);
                                  } else {
                                    puzzle.resetCalculation();
                                    puzzle.clearRowHints();
                                    puzzle.clearColumnHints();
                                  }
                                  _currentDecryptStep = _DecryptWizardStep.FILE_OR_MANUAL;
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(i18n(context, 'common_yes'))),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(i18n(context, 'common_no')))
                        ],
                      ));
            },
          ),
        ))
      ],
    );
  }

  Widget _encryptPreview(PuzzleWidgetValues puzzle) {
    if (!puzzle.encryptVersion) return Container();
    return Column(children: <Widget>[NonogramBoard(board: puzzle.board.calcHints(), onChanged: (newBoard) => {})]);
  }

  Widget _exportButtons(PuzzleWidgetValues puzzle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
            child: GCWButton(
              text: i18n(context, 'common_exportfile_saveoutput') + ' (' + i18n(context, 'common_image') + ')',
              onPressed: () {
                _renderedImage(puzzle.board, puzzle.encryptVersion).then((image) async {
                  image.toByteData(format: ui.ImageByteFormat.png).then((data) {
                    _exportFile(context, data?.buffer.asUint8List(), puzzle);
                  });
                });
              },
            ),
          ),
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
          child: GCWButton(
            text: i18n(context, 'common_exportfile_saveoutput') + ' (JSON)',
            onPressed: () {
              setState(() {
                _exportJsonFile(context, puzzle.board.toJson(encryptVersion: puzzle.encryptVersion), puzzle);
              });
            },
          ),
        )),
      ],
    );
  }

  void _importJsonFile(Uint8List bytes, PuzzleWidgetValues puzzle) {
    puzzle.board = Puzzle.parseJson(convertBytesToString(bytes));
    if (puzzle.board.state != PuzzleState.Ok) {
      if (!_showSnackBarDataError(puzzle.board)) {
        showSnackBar(i18n(context, 'nonogramsolver_dataerror'), context);
      }
    }

    puzzle.setControllerData();
    if (puzzle.encryptVersion) {
      puzzle.board.solve();
      puzzle.board.clearHints();
    }
  }

  String _dataErrorText(Puzzle board) {
    switch (board.state) {
      case PuzzleState.InvalidHintData:
        var errorhint = i18n(context, 'nonogramsolver_hinterror');

        var extendedInfo = board.invalidHintDataInfoCode;
        if (extendedInfo != null && extendedInfo.isNotEmpty) {
          errorhint += '\n';

          var params = board.invalidHintDataInfoData;
          if (params != null && params.isNotEmpty) {
            errorhint += i18n(context, 'nonogramsolver_error_invalidhint_' + extendedInfo,
                parameters: [board.invalidHintDataInfoData]);
          } else {
            errorhint += i18n(context, 'nonogramsolver_error_invalidhint_' + extendedInfo);
          }
        }
        return errorhint;
      case PuzzleState.Finished:
        return i18n(context, 'sudokusolver_error');
      default:
        return '';
    }
  }

  bool _showSnackBarDataError(Puzzle board) {
    if (board.state == PuzzleState.InvalidHintData) {
      showSnackBar(_dataErrorText(board), context);
      return true;
    }
    return false;
  }

  Future<void> _exportFile(BuildContext context, Uint8List? data, PuzzleWidgetValues puzzle) async {
    if (data == null) return;

    if (puzzle.encryptVersion) {
      showGCWDialog(context, i18n(context, 'nonogramsolver_title'),
          SizedBox(width: 300, height: 130, child: Text(i18n(context, 'nonogramsolver_createhint'))), [
        GCWDialogButton(
          text: i18n(context, 'common_ok'),
          onPressed: () {
            setState(() {
              __exportFile(context, data, puzzle);
            });
          },
        )
      ]);
    } else {
      __exportFile(context, data, puzzle);
    }
  }

  Future<void> __exportFile(BuildContext context, Uint8List data, PuzzleWidgetValues puzzle) async {
    await saveByteDataToFile(context, data, buildFileNameWithDate('img_', FileType.PNG)).then((value) {
      if (value) showExportedFileDialog(context, contentWidget: imageContent(context, data));
    });
  }

  Future<void> _exportJsonFile(BuildContext context, String? data, PuzzleWidgetValues puzzle) async {
    if (data == null) return;
    if (puzzle.encryptVersion) {
      showGCWDialog(context, i18n(context, 'nonogramsolver_title'),
          SizedBox(width: 300, height: 130, child: Text(i18n(context, 'nonogramsolver_createhint'))), [
        GCWDialogButton(
          text: i18n(context, 'common_ok'),
          onPressed: () {
            setState(() {
              __exportJson(context, data, puzzle);
            });
          },
        )
      ]);
    } else {
      __exportJson(context, data, puzzle);
    }
  }

  Future<void> __exportJson(BuildContext context, String data, PuzzleWidgetValues puzzle) async {
    saveStringToFile(context, data, buildFileNameWithDate('nonogram_', FileType.JSON));
  }

  Future<ui.Image> _renderedImage(Puzzle puzzle, bool encryptVersion) async {
    const cellSize = 70.0;
    final recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    if (encryptVersion) {
      var clone = puzzle.calcHints();
      clone.removeCalculated();

      puzzle = clone;
    }

    final size = Size((puzzle.columns.length + _maxRowHintsCount(puzzle)) * cellSize,
        (puzzle.rows.length + _maxColumnHintsCount(puzzle)) * cellSize);

    final painter = NonogramBoardPainter(context, puzzle, () => {},
        line_color: Colors.black,
        hint_line_color: Colors.grey,
        full_color: Colors.black,
        background_color: Colors.white,
        font_color: Colors.black);

    var paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.save();
    painter.paint(canvas, size);
    return recorder.endRecording().toImage(size.width.floor(), size.height.floor());
  }
}

class PuzzleWidgetValues {
  var rowCount = 10;
  var columnCount = 10;
  late Puzzle board;
  var currentSizeExpanded = false;
  var currentRowHintsExpanded = false;
  var currentColumnHintsExpanded = false;
  late TextEditingController rowCountController;
  late TextEditingController columnCountController;
  final rowController = <TextEditingController>[];
  final columnController = <TextEditingController>[];
  double scale = 1;
  bool encryptVersion = false;

  PuzzleWidgetValues({this.encryptVersion = false}) {
    board = Puzzle.generate(rowCount, columnCount);

    rowCountController = TextEditingController(text: rowCount.toString());
    columnCountController = TextEditingController(text: columnCount.toString());

    Puzzle.mapData(board);
  }

  void resetCalculation() {
    board.resetCalculation();
  }

  void clearRowHints() {
    for (var controller in rowController) {
      controller.text = '';
    }
  }

  void clearColumnHints() {
    for (var controller in columnController) {
      controller.text = '';
    }
  }

  void onTapped(int row, int column) {
    if (row < board.rows.length && column < board.rows[row].length) {
      if (board.rows[row][column] == 1) {
        board.rows[row][column] = -1;
      } else {
        board.rows[row][column] = 1;
      }
    }
  }

  void setControllerData() {
    rowCount = board.height;
    columnCount = board.width;
    rowCountController.text = rowCount.toString();
    columnCountController.text = columnCount.toString();

    for (var i = 0; i < board.rowHints.length; i++) {
      var controller = getRowController(i);
      controller.text = board.rowHints[i].toString().replaceFirst('[', '').replaceFirst(']', '');
    }
    for (var i = board.rowHints.length; i < rowController.length; i++) {
      var controller = getRowController(i);
      controller.text = '';
    }

    for (var i = 0; i < board.columnHints.length; i++) {
      var controller = getColumnController(i);
      controller.text = board.columnHints[i].toString().replaceFirst('[', '').replaceFirst(']', '');
    }
    for (var i = board.columnHints.length; i < columnController.length; i++) {
      var controller = getColumnController(i);
      controller.text = '';
    }
  }

  TextEditingController getRowController(int index) {
    while (index >= rowController.length) {
      rowController.add(TextEditingController());
    }
    return rowController[index];
  }

  TextEditingController getColumnController(int index) {
    while (index >= columnController.length) {
      columnController.add(TextEditingController());
    }
    return columnController[index];
  }

  void dispose() {
    rowCountController.dispose();
    columnCountController.dispose();
    for (var controller in rowController) {
      controller.dispose();
    }
    for (var controller in columnController) {
      controller.dispose();
    }
  }
}
