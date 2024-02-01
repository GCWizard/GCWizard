import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/variablestring_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/alphametics/logic/alphametics.dart';
import 'package:gc_wizard/tools/games/catan/logic/catan.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';


class Alphametics extends StatefulWidget {
  const Alphametics({Key? key}) : super(key: key);

  @override
  AlphameticsState createState() => AlphameticsState();
}

class AlphameticsState extends State<Alphametics> {
  late TextEditingController _inputController;
  late TextEditingController _maskController;

  var _currentInput = '';
  var _currentOutput = '';
  var _currentMask = '';
  var _currentFromInput = '';
  var _currentToInput = '';

  var _currentIdCount = 0;
  final List<KeyValueBase> _currentSubstitutions = [];

  int _rowCount = 2;
  int _columnCount = 2;
  SymbolMatrix _currentMatrix = SymbolMatrix(2, 2);
  List<List<TextEditingController?>> _textEditingControllerArray = [];
  bool _currentExpanded = true;
  bool _currentValuesExpanded = true;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _maskController = TextEditingController(text: _currentMask);

    _resizeMatrix();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _maskController.dispose();

    for(var y = 0; y < _textEditingControllerArray.length; y++) {
      for (var x = 0; x < _textEditingControllerArray[y].length; x++) {
        if (_textEditingControllerArray[y][x] != null) {
          _textEditingControllerArray[y][x]?.dispose();
        }
      }
    }

    super.dispose();
  }

  void _addEntry(KeyValueBase entry) {
    if (entry.key.isEmpty) return;
    _currentIdCount++;
    if (_currentSubstitutions.firstWhereOrNull((_entry) => _entry.id == _currentIdCount) == null) {
      entry.id = _currentIdCount;
      return _currentSubstitutions.add(entry);
    }
    //_calculateOutput();
  }


  void _updateEntry(KeyValueBase entry) {
    //_calculateOutput();
  }

  void _updateNewEntry(KeyValueBase entry) {
    _currentFromInput = entry.key;
    _currentToInput = entry.value;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWExpandableTextDivider(
          text: i18n(context, 'common_row_count'),
          expanded: _currentExpanded,
          onChanged: (value) {
            setState(() {
              _currentExpanded = value;
            });
          },
          child: Column(
            children: <Widget>[
              GCWIntegerSpinner(
                title: i18n(context, 'common_row_count'),
                value: _rowCount,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    _rowCount = value;
                    _resizeMatrix();
                  });
                },
              ),
              GCWIntegerSpinner(
                title: i18n(context, 'common_column_count'),
                value: _columnCount,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    _columnCount = value;
                    _resizeMatrix();
                  });
                },
              ),
          ]),
        ),

        GCWTextDivider(
          text : '',
           trailing: Row(children: <Widget>[
              GCWPasteButton(
                  iconSize: IconButtonSize.SMALL,
                  onSelected: _parseClipboard,
                ),
              GCWIconButton(
                size: IconButtonSize.SMALL,
                icon: Icons.content_copy,
                onPressed: () {
                  _currentMatrix.substitutions = _getSubstitutions();
                  var copyText = _currentMatrix.toJson();
                  if (copyText.isEmpty) return;
                  insertIntoGCWClipboard(context, copyText);
                },
              )
          ])
        ),

        GCWPainterContainer(
          child: _buildTable(_rowCount, _columnCount),
        ),
        _buildVariablesEditor(),
        _buildSubmitButton(),
        GCWIconButton(
          onPressed: () {
            var valid = _currentMatrix.isValidMatrix();
            print(valid.toString());
            if (valid) {
              for(var y = 0; y < _currentMatrix.getRowsCount()-2; y+=2){
                print(_currentMatrix.buildRowFormula(y));
              }
              for(var x = 0; x < _currentMatrix.getColumnsCount()-2; x+=2){
                print(_currentMatrix.buildColumnFormula(x));
              }
            }
          },
        ),
        GCWDefaultOutput(
            child: encodeCatan(
                _currentInput, _currentMode == GCWSwitchPosition.left ? CatanMode.BASE : CatanMode.EXPANSION)
                .join(' '))
      ],
    );
  }

  Widget _buildVariablesEditor() {
    return Column(
      children: <Widget>[
        GCWExpandableTextDivider(
          text: i18n(context, 'coords_variablecoordinate_variables'),
          expanded: _currentValuesExpanded,
          onChanged: (value) {
            setState(() {
              _currentValuesExpanded = value;
            });
          },
          child: GCWKeyValueEditor(
              keyHintText: i18n(context, 'coords_variablecoordinate_variable'),
              valueHintText: i18n(context, 'coords_variablecoordinate_possiblevalues'),
              addValueInputFormatters: [VariableStringTextInputFormatter()],
              valueFlex: 4,
              onNewEntryChanged: (entry) => _updateNewEntry(entry),
              onAddEntry: (entry) => _addEntry(entry),
              entries: _currentSubstitutions,
              onUpdateEntry: (entry) => _updateEntry(entry),
          )
        )
    ]);
  }

  void _onDoCalculation() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 150,
            child: GCWAsyncExecuter<SymbolArithmeticOutput>(
              isolatedFunction: solveAlphameticsAsync,
              parameter: _buildJobData,
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return GCWSubmitButton(
      onPressed: () async {
        _onDoCalculation();
      },
    );
  }

  void _parseClipboard(String text) {
    setState(() {
      var matrix = SymbolMatrix.fromJson(text);
      if (matrix == null) {
        _rowCount = 2;
        _columnCount = 2;
        _currentMatrix = SymbolMatrix(_rowCount, _columnCount);
      } else {
        _currentMatrix = matrix;
        _rowCount = matrix.rowCount;
        _columnCount = matrix.columnCount;
      }
      _resizeMatrix();
    });
  }

  Widget _buildTable(int rowCount, int columnCount) {
    var rows = <TableRow>[];
    for (var i=0; i < _currentMatrix.getRowsCount(); i++) {
      rows.add(_buildTableRow(rowCount, columnCount, i));
    }

    return Table(
        border: TableBorder.all(),
        columnWidths: _columnWidthConfiguration(columnCount),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows
    );
  }

  TableRow _buildTableRow(int rowCount, int columnCount, int rowIndex) {
    var cells = <Widget>[];

    for(var columnIndex = 0; columnIndex < _currentMatrix.getColumnsCount(); columnIndex++) {
      if (rowIndex % 2 == 0) {
        if (columnIndex % 2 == 0) {
          cells.add(
            GCWTextField(
              controller: _getTextEditingController(rowIndex, columnIndex,
                  _currentMatrix.getValue(rowIndex, columnIndex) ?? ''),
              onChanged: (text) {
                _currentMatrix.setValue(rowIndex, columnIndex, text);
              }
            )
          );
        } else if (columnIndex == _currentMatrix.getColumnsCount() - 2) {
          cells.add(
            _equalText(rowIndex, columnIndex)
          );
        } else {
          cells.add(
            (rowIndex == _currentMatrix.getRowsCount() - 1)
            ? Container() // last row
            : _operatorDropDown(rowIndex, columnIndex)
          );
        }
      } else if (columnIndex % 2 == 0 && columnIndex < _currentMatrix.getColumnsCount() - 1) {
        cells.add(
          (rowIndex == _currentMatrix.getRowsCount() - 2)
          ? _equalText(rowIndex, columnIndex) // pre last row
          : _operatorDropDown(rowIndex, columnIndex)
        );
      } else {
        cells.add(
          Container()
        );
      }
    }

    return TableRow(
      children: cells,
    );
  }

  Map<int, TableColumnWidth> _columnWidthConfiguration(int columnCount) {
    var config = <int, TableColumnWidth>{};
    for(var columnIndex = 0; columnIndex < _currentMatrix.getColumnsCount(); columnIndex++) {
      if (columnIndex % 2 == 0) {
        config.addAll({columnIndex: const FixedColumnWidth(100)}); //IntrinsicColumnWidth FlexColumnWidth()
      } else {
        config.addAll({columnIndex: FixedColumnWidth((columnIndex == _currentMatrix.getColumnsCount() - 2) ? 30 : 60)});
      }
    }
    return config;
  }

  Widget _equalText(int rowIndex, int columnIndex) {
    _currentMatrix.setValue(rowIndex, columnIndex, '=');
    return Text('=',
      style: gcwTextStyle(),
      textAlign: TextAlign.center,
    );
  }

  Widget _operatorDropDown(int rowIndex, int columnIndex) {
    //List<GCWDropDownMenuItem>
    var list = <GCWDropDownMenuItem<String>>[];

    operatorList.forEach((key, value) {
      list.add(GCWDropDownMenuItem(
        value: key,
        child: key,
      ));
    });

    return GCWDropDown<String?>(
        value: _currentMatrix.getOperator(rowIndex, columnIndex),
        items: list,
        onChanged: (newValue) {
          setState(() {
            _currentMatrix.setValue(rowIndex, columnIndex, newValue ?? '');
          });
        }
    );
  }

  void _resizeMatrix() {
    _currentMatrix = SymbolMatrix(_rowCount, _columnCount, oldMatrix: _currentMatrix);
    _buildtextEditingControllerArray(_rowCount, _columnCount);
  }

  Map<String, String> _getSubstitutions() {
    var _substitutions = <String, String>{};
    for (var entry in _currentSubstitutions) {
      _substitutions.putIfAbsent(entry.key, () => entry.value);
    }

    if (_currentFromInput.isNotEmpty &&
        _currentToInput.isNotEmpty) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    return _substitutions;
  }

  List<String>? _getFormulas() {
    if (!_currentMatrix.isValidMatrix()) return null;
    var formulas = <String>[];
    for(var y = 0; y < _currentMatrix.getRowsCount()-2; y+=2) {
      formulas.add(_currentMatrix.buildRowFormula(y));
    }

    for(var x = 0; x < _currentMatrix.getColumnsCount()-2; x+=2) {
      formulas.add(_currentMatrix.buildColumnFormula(x));
    }
    return formulas;
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    _currentOutput = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    var _substitutions = _getSubstitutions();
    var _formulas = _getFormulas();
    if (_formulas == null) return null;

    return GCWAsyncExecuterParameters(SymbolArithmeticJobData(
        formulas: _formulas,
        substitutions: _substitutions));
  }

  void _showOutput(SymbolArithmeticOutput output) {
    if (output.error) {
      _currentOutput = i18n(context, 'hashes_hashbreaker_solutionnotfound');
    } else {
      _currentOutput = output.formulas.toString();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }


  void _buildtextEditingControllerArray(int rowCount, int columnCount) {
    var matrix =<List<TextEditingController?>>[];
    for(var y = 0; y < _currentMatrix.getRowsCount(); y++) {
      matrix.add(List<TextEditingController>.filled(_currentMatrix.getColumnsCount(), TextEditingController()));
    }

    for(var y = 0; y < min(matrix.length, _textEditingControllerArray.length); y++) {
      for (var x = 0; x < min(matrix[y].length, _textEditingControllerArray[y].length); x++) {
        matrix[y][x] = _textEditingControllerArray[y][x];
      }

      for(var y = matrix.length; y < _textEditingControllerArray.length; y++) {
        for (var x = matrix[0].length; x < _textEditingControllerArray[y].length; x++) {
          if (_textEditingControllerArray[y][x] != null) {
            _textEditingControllerArray[y][x]?.dispose();
          }
        }
      }
    }

    _textEditingControllerArray = matrix;
  }

  TextEditingController? _getTextEditingController(int rowIndex, int columnIndex, String text) {
    if (_textEditingControllerArray[rowIndex][columnIndex] == null) {
      _textEditingControllerArray[rowIndex][columnIndex] = TextEditingController();
    }

    _textEditingControllerArray[rowIndex][columnIndex]!.text = text;

    return _textEditingControllerArray[rowIndex][columnIndex];
  }
}