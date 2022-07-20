import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/common/gcw_tool/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/common/gcw_toollist/widget/gcw_toollist.dart';
import 'package:gc_wizard/widgets/registry.dart';
import 'package:gc_wizard/widgets/selector_lists/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/atomic_numbers_to_text/widget/atomic_numbers_to_text.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table/widget/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

class PeriodicTableSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(PeriodicTable()),
        className(PeriodicTableDataView()),
        className(AtomicNumbersToText()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
