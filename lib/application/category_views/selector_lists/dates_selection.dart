import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/category_views/selector_lists/maya_calendar_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/widget/calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/widget/day_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_of_the_year/widget/day_of_the_year.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/time_calculator/widget/time_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/weekday/widget/weekday.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class DatesSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(DayCalculator()),
        className(TimeCalculator()),
        className(Weekday()),
        className(DayOfTheYear()),
        className(Calendar()),
        className(MayaCalendarSelection()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
