import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/toki_pona/widget/toki_pona.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class TokiPonaSelection extends GCWSelection {
  const TokiPonaSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      if (className(element.tool) == className(const SymbolTable()) &&
          ((element.tool as SymbolTable).symbolKey == 'toki_pona_letters_names' ||
          (element.tool as SymbolTable).symbolKey == 'toki_pona_letters_symbols' ||
          (element.tool as SymbolTable).symbolKey == 'toki_pona_numbers' ||
          (element.tool as SymbolTable).symbolKey == 'toki_pona_numbers_sitelen_pona' ||
          (element.tool as SymbolTable).symbolKey == 'toki_pona_numbers_sitelen_telo' ||
          (element.tool as SymbolTable).symbolKey == 'toki_pona_numbers_sitelen_sitelen')) {
        return true;
      }

      return [
        className(const TokiPona()),
      ].contains(className(element.tool));

    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
