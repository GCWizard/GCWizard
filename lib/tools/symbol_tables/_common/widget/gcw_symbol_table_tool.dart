import 'package:flutter/material.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_license_types.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';

class GCWSymbolTableTool extends GCWTool {
  final String symbolKey;
  final List<String> symbolSearchStrings;


  GCWSymbolTableTool({
    Key? key,
    required this.symbolKey,
    required this.symbolSearchStrings,
    List<ToolLicenseEntry>? licenses,
  }) : super(
            key: key,
            tool: SymbolTable(symbolKey: symbolKey),
            id: 'symboltables_' + symbolKey,
            autoScroll: false,
            iconPath: SYMBOLTABLES_ASSETPATH + symbolKey + '/logo.png',
            helpSearchString: 'symboltables_selection_title',
            searchKeys: ['symbol'] + symbolSearchStrings,
            licenses: licenses);
}
