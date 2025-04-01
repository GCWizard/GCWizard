import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';

class GCWSymbolTableTool extends GCWTool {
  final String symbolKey;
  final List<String> symbolSearchStrings;


  GCWSymbolTableTool({
    super.key,
    required this.symbolKey,
    required this.symbolSearchStrings,
    super.licenses,
  }) : super(
            tool: SymbolTable(symbolKey: symbolKey),
            id: 'symboltables_' + symbolKey,
            autoScroll: false,
            iconPath: SYMBOLTABLES_ASSETPATH + symbolKey + '/logo.png',
            helpSearchString: 'symboltables_selection_title',
            searchKeys: ['symbol'] + symbolSearchStrings);
}
