import 'package:flutter/material.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_decryption.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_encryption.dart';
import 'package:prefs/prefs.dart';

class SymbolTable extends StatefulWidget {
  final String symbolKey;
  final String Function(String)? onDecrypt;
  final String Function(String)? onEncrypt;
  final bool alwaysIgnoreUnknown;

  const SymbolTable({Key? key, this.symbolKey = '', this.onDecrypt, this.onEncrypt, this.alwaysIgnoreUnknown = false})
      : super(key: key);

  @override
  _SymbolTableState createState() => _SymbolTableState();
}

class _SymbolTableState extends State<SymbolTable> {
  var _currentMode = GCWSwitchPosition.right;
  late SymbolTableData _data;

  @override
  void initState() {
    super.initState();

    _data = defaultSymbolTableData(context);
    _initialize();
  }

  Future<void> _initialize() async {
    var symbolTableData = SymbolTableData(context, widget.symbolKey);
    symbolTableData.initialize().then((value) {
      setState(() {
        _data = symbolTableData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
        ? Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

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
