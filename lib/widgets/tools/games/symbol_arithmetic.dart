import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/games/catan.dart';
import 'package:gc_wizard/logic/tools/games/symbol_arithmetic/parser.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_expandable.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';

class SymbolArithmetic extends StatefulWidget {
  @override
  SymbolArithmeticState createState() => SymbolArithmeticState();
}

class SymbolArithmeticState extends State<SymbolArithmetic> {
  int _rowCount = 2;
  int _columnCount = 2;
  SymbolMatrix _currentMatrix = SymbolMatrix(2, 2);
  bool _currentExpanded = true;
  String _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

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
                onChanged: (value) {
                  setState(() {
                    _rowCount = value;
                  });
                },
              ),
              GCWIntegerSpinner(
                title: 'Column Count',
                value: _columnCount,
                min: 1,
                onChanged: (value) {
                  setState(() {
                    _columnCount = value;
                  });
                },
              ),
          ]),
        ),
        _buildTable(_rowCount, _columnCount),
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'catan_mode_basegame'),
          rightValue: i18n(context, 'catan_mode_expansion'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(
            child: encodeCatan(
                _currentInput, _currentMode == GCWSwitchPosition.left ? CatanMode.BASE : CatanMode.EXPANSION)
                .join(' '))
      ],
    );
  }

  Widget _buildTable(int rows, int columns) {
    return Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(64),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Container(
                //height: 32,
                color: Colors.green,
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  //height: 32,
                  //width: 32,
                  color: Colors.red,
                ),
              ),
              Container(
                //height: 64,
                color: Colors.blue,
              ),
            ],
          ),
        ]
    );
  }

  Widget _operatorDropDown(int x, int y) {
    //List<GCWDropDownMenuItem>
    var list = <GCWDropDownMenuItem>[];

    operatorList.forEach((key, value) {
      list.add(GCWDropDownMenuItem(
        value: key,
        child: key,
      ));
    });

    GCWDropDownButton(
        value: _currentMatrix.getOperator(x, y),
        items: list,
        onChanged: (newValue) {
          setState(() {});
        });
  }
}