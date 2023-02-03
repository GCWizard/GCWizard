import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt1/widget/ccitt1.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt2/widget/ccitt2.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt3/widget/ccitt3.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt4/widget/ccitt4.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt5/widget/ccitt5.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt_ccir476/widget/ccitt_ccir476.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/widget/punchtape.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class CCITTSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      if (className(element.tool) == className(SymbolTable())) if ((element.tool as SymbolTable).symbolKey ==
              'ita1_1926' ||
          (element.tool as SymbolTable).symbolKey == 'ita1_1929' ||
          (element.tool as SymbolTable).symbolKey == 'ita2_1929' ||
          (element.tool as SymbolTable).symbolKey == 'ita3_1931') return true;

      return [
        className(CCITT1()),
        className(CCITT2()),
        className(CCITT3()),
        className(CCITT4()),
        className(CCITT5()),
        className(CCIR476()),
        className(TeletypewriterPunchTape()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
