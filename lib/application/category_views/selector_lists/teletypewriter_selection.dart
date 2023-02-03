import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ancient_teletypewriter/widget/ancient_teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt_teletypewriter/widget/ccitt_teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/other_teletypewriter/widget/other_teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/widget/punchtape.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class TeletypewriterSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      if (className(element.tool) == className(SymbolTable())) if ((element.tool as SymbolTable).symbolKey ==
              'baudot_1888' ||
          (element.tool as SymbolTable).symbolKey == 'baudot_54123' ||
          (element.tool as SymbolTable).symbolKey == 'murraybaudot' ||
          (element.tool as SymbolTable).symbolKey == 'siemens' ||
          (element.tool as SymbolTable).symbolKey == 'westernunion' ||
          (element.tool as SymbolTable).symbolKey == 'ita1_1926' ||
          (element.tool as SymbolTable).symbolKey == 'ita1_1929' ||
          (element.tool as SymbolTable).symbolKey == 'ita2_1929' ||
          (element.tool as SymbolTable).symbolKey == 'ita3_1931') return true;

      return [
        className(AncientTeletypewriter()),
        className(OtherTeletypewriter()),
        className(CCITTTeletypewriter()),
        className(TeletypewriterPunchTape()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
