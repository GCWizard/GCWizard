import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/color_tool/widget/color_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/pantone_color_codes/widget/pantone_color_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/ral_color_codes/widget/ral_color_codes.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class ColorsSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      if (className(element.tool) == className(SymbolTable()) &&
          (element.tool as SymbolTable).symbolKey.startsWith('color_code')) return true;

      return [className(ColorTool()), className(PantoneColorCodes()), className(RALColorCodes())]
          .contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
