import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/games/catan.dart';
import 'package:gc_wizard/logic/tools/games/symbol_arithmetic/parser.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_expandable.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_paste_button.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class SymbolArithmetic extends StatefulWidget {
  @override
  SymbolArithmeticState createState() => SymbolArithmeticState();
}

class SymbolArithmeticState extends State<SymbolArithmetic> {
  int _rowCount = 2;
  int _columnCount = 2;
  SymbolMatrix _currentMatrix = SymbolMatrix(2, 2);
  List<List<TextEditingController>> _textEditingControllerArray;
  bool _currentExpanded = true;
  String _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();

    _resizeMatrix();
  }

  @override
  void dispose() {
    if (_textEditingControllerArray != null) {
      for(var y = 0; y < _textEditingControllerArray.length; y++)
        for(var x = 0; x < _textEditingControllerArray[y].length; x++)
          if (_textEditingControllerArray[y][x] != null)
            _textEditingControllerArray[y][x].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWExpandableTextDivider(
          text: i18n(context, 'Row Count'),
          expanded: _currentExpanded,
          onChanged: (value) {
            setState(() {
              _currentExpanded = value;
            });
          },
          child: Column(
            children: <Widget>[
              GCWIntegerSpinner(
                title: 'Row Count',
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
                title: 'Column Count',
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
           trailing: Row(children: <Widget>[
              GCWPasteButton(
                  iconSize: IconButtonSize.SMALL,
                  onSelected: _parseClipboard,
                ),
              GCWIconButton(
                size: IconButtonSize.SMALL,
                icon: Icons.content_copy,
                onPressed: () {
                  var copyText = _currentMatrix.toJson();
                  if (copyText == null) return;
                  insertIntoGCWClipboard(context, copyText);
                },
              )
          ])
        ),

        SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            child: _buildTable(_rowCount, _columnCount),
          ),
        ),
        GCWIconButton(
          onPressed: () {
            var valid = _currentMatrix.isValidMatrix();
            print(valid.toString());
            if (valid) {
              for(var y = 0; y < _currentMatrix.getRowsCount()-2; y+=2){
                print(_currentMatrix.buildRow(y));
              }
              for(var x = 0; x < _currentMatrix.getColumnsCount()-2; x+=2){
                print(_currentMatrix.buildColumn(x));
              }
            }
          },
        ),
        // GCWTextField(
        //   onChanged: (text) {
        //     setState(() {
        //       _currentInput = text;
        //     });
        //   },
        // ),
        // GCWTwoOptionsSwitch(
        //   value: _currentMode,
        //   leftValue: i18n(context, 'catan_mode_basegame'),
        //   rightValue: i18n(context, 'catan_mode_expansion'),
        //   onChanged: (value) {
        //     setState(() {
        //       _currentMode = value;
        //     });
        //   },
        // ),
        GCWDefaultOutput(
            child: encodeCatan(
                _currentInput, _currentMode == GCWSwitchPosition.left ? CatanMode.BASE : CatanMode.EXPANSION)
                .join(' '))
      ],
    );
  }

  _parseClipboard(text) {
    setState(() {
      var matrix = SymbolMatrix.fromJson(text);
      if (matrix == null) {
        _currentMatrix = null;
        _rowCount = 2;
        _columnCount = 2;
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
    for (var i=0; i < _currentMatrix.getRowsCount(); i++)
      rows.add(_buildTableRow(rowCount, columnCount, i));

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
                  _currentMatrix.getValue(rowIndex, columnIndex)),
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
    var config = Map<int, TableColumnWidth>();
    for(var columnIndex = 0; columnIndex < _currentMatrix.getColumnsCount(); columnIndex++) {
      if (columnIndex % 2 == 0)
        config.addAll({columnIndex: FixedColumnWidth(100)}); //IntrinsicColumnWidth FlexColumnWidth()
      else
        config.addAll({columnIndex: FixedColumnWidth((columnIndex == _currentMatrix.getColumnsCount() - 2) ? 30 : 60)});
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
    var list = <GCWDropDownMenuItem>[];

    operatorList.forEach((key, value) {
      list.add(GCWDropDownMenuItem(
        value: key,
        child: key,
      ));
    });

    return GCWDropDownButton(
        value: _currentMatrix.getOperator(rowIndex, columnIndex),
        items: list,
        onChanged: (newValue) {
          setState(() {
            _currentMatrix.setValue(rowIndex, columnIndex, newValue);
          });
        }
    );
  }

  void _resizeMatrix() {
    _currentMatrix = SymbolMatrix(_rowCount, _columnCount, oldMatrix: _currentMatrix);
    _buildtextEditingControllerArray(_rowCount, _columnCount);
  }


  void _buildtextEditingControllerArray(int rowCount, int columnCount) {
    var matrix =<List<TextEditingController>>[];
    for(var y = 0; y < _currentMatrix.getRowsCount(); y++)
      matrix.add(List<TextEditingController>.filled(_currentMatrix.getColumnsCount(), null));

    if (_textEditingControllerArray != null) {
      for(var y = 0; y < min(matrix.length, _textEditingControllerArray.length); y++)
        for(var x = 0; x < min(matrix[y].length, _textEditingControllerArray[y].length); x++)
          matrix[y][x] = _textEditingControllerArray[y][x];

      for(var y = matrix.length; y < _textEditingControllerArray.length; y++)
        for(var x = matrix[0].length; x < _textEditingControllerArray[y].length; x++)
          if (_textEditingControllerArray[y][x] != null)
            _textEditingControllerArray[y][x].dispose();
    }

    _textEditingControllerArray = matrix;
  }

  TextEditingController _getTextEditingController(int rowIndex, int columnIndex, String text) {
    if (_textEditingControllerArray[rowIndex][columnIndex] == null)
      _textEditingControllerArray[rowIndex][columnIndex] = TextEditingController();

    _textEditingControllerArray[rowIndex][columnIndex].text = text;

    return _textEditingControllerArray[rowIndex][columnIndex];
  }
}