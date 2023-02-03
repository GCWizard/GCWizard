import 'package:flutter/material.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_decryption.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_encryption.dart';
import 'package:prefs/prefs.dart';

class SymbolTable extends StatefulWidget {
  final String symbolKey;
  final Function onDecrypt;
  final Function onEncrypt;
  final bool alwaysIgnoreUnknown;

  const SymbolTable({Key key, this.symbolKey, this.onDecrypt, this.onEncrypt, this.alwaysIgnoreUnknown})
      : super(key: key);

  @override
  SymbolTableState createState() => SymbolTableState();
}

class SymbolTableState extends State<SymbolTable> {
  var _currentMode = GCWSwitchPosition.right;
  SymbolTableData _data;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future _initialize() async {
    var symbolTableData = SymbolTableData(context, widget.symbolKey);
    await symbolTableData.initialize();
    setState(() {
      _data = symbolTableData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
        ? Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: GCWTwoOptionsSwitch(
              value: _currentMode,
              onChanged: (value) {
                setState(() {
                  _currentMode = value;
                });
              },
            )),
            Container(
              width: 2 * 40.0,
            )
          ],
        ),
        _currentMode == GCWSwitchPosition.left
            ? Expanded(
                child: GCWSymbolTableEncryption(
                data: _data,
                countColumns: countColumns,
                mediaQueryData: mediaQueryData,
                symbolKey: widget.symbolKey,
                onBeforeEncrypt: widget.onEncrypt,
                alwaysIgnoreUnknown: widget.alwaysIgnoreUnknown,
                onChanged: () {
                  setState(() {});
                },
              ))
            : Expanded(
                child: GCWSymbolTableDecryption(
                data: _data,
                countColumns: countColumns,
                mediaQueryData: mediaQueryData,
                onAfterDecrypt: widget.onDecrypt,
                onChanged: () {
                  setState(() {});
                },
              ))
      ],
    );
  }
}
