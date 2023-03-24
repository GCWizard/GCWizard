import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/maya_calendar/widget/maya_calendar.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class MayaCalendarSelection extends GCWSelection {
  const MayaCalendarSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      if (className(element.tool) == className(const SymbolTable()) &&
          (element.tool as SymbolTable).symbolKey == 'maya_calendar_longcount') return true;
      if (className(element.tool) == className(const SymbolTable()) &&
          (element.tool as SymbolTable).symbolKey == 'maya_calendar_haab_codices') return true;
      if (className(element.tool) == className(const SymbolTable()) &&
          (element.tool as SymbolTable).symbolKey == 'maya_calendar_haab_inscripts') return true;
      if (className(element.tool) == className(const SymbolTable()) &&
          (element.tool as SymbolTable).symbolKey == 'maya_calendar_tzolkin_codices') return true;
      if (className(element.tool) == className(const SymbolTable()) &&
          (element.tool as SymbolTable).symbolKey == 'maya_calendar_tzolkin_inscripts') return true;

      return [
        className(const MayaCalendar()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
