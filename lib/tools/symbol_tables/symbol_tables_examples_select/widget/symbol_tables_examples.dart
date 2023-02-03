import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_text_to_symbols.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_tool.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_zoom_buttons.dart';
import 'package:prefs/prefs.dart';

class SymbolTableExamples extends StatefulWidget {
  final List<String> symbolKeys;

  const SymbolTableExamples({Key key, this.symbolKeys}) : super(key: key);

  @override
  SymbolTableExamplesState createState() => SymbolTableExamplesState();
}

class SymbolTableExamplesState extends State<SymbolTableExamples> {
  var _controller;
  String _currentInput = 'ABC123';

  var symbolKeys = <String>[];

  Map<String, SymbolTableData> data = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);

    _initialize();
  }

  Future _initialize() async {
    if (widget.symbolKeys == null || widget.symbolKeys.isEmpty) {
      return;
    }

    symbolKeys = List.from(widget.symbolKeys);

    for (String symbolKey in symbolKeys) {
      var symbolTableData = SymbolTableData(context, symbolKey);
      await symbolTableData.initialize();
      data.putIfAbsent(symbolKey, () => symbolTableData);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
        ? Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, 'symboltablesexamples_exampletext'),
          suppressTopSpace: true,
        ),
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextDivider(
            text: i18n(context, 'common_output'),
            suppressTopSpace: true,
            trailing: GCWSymbolTableZoomButtons(
              countColumns: countColumns,
              mediaQueryData: mediaQueryData,
              onChanged: () {
                setState(() {});
              },
            )),
        Expanded(
          child: _createSymbols(countColumns),
        )
      ],
    );
  }

  _createSymbols(int countColumns) {
    if (data == null || data.isEmpty) return Container();

    var symbols = symbolKeys.map<Widget>((symbolKey) {
      var tableOutput = GCWSymbolTableTextToSymbols(
          text: _currentInput,
          ignoreUnknown: true,
          countColumns: countColumns,
          data: data[symbolKey],
          showExportButton: false,
          specialEncryption: false,
          fixed: true);

      return Column(
        children: [
          GCWTextDivider(
              text: i18n(context, 'symboltables_${symbolKey}_title'),
              trailing: GCWIconButton(
                icon: Icons.open_in_new,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => GCWSymbolTableTool(
                                symbolKey: symbolKey,
                              )));
                },
              )),
          tableOutput
        ],
      );
    }).toList();

    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        primary: true,
        child: Column(
            children: symbols
        )
    );
  }
}
