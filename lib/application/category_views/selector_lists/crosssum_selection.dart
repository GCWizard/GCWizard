import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/cross_sum/widget/cross_sum.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/cross_sum_range/widget/cross_sum_range.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/cross_sum_range_frequency/widget/cross_sum_range_frequency.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/iterated_cross_sum_range/widget/iterated_cross_sum_range.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/iterated_cross_sum_range_frequency/widget/iterated_cross_sum_range_frequency.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class CrossSumSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(CrossSum()),
        className(CrossSumRange()),
        className(IteratedCrossSumRange()),
        className(CrossSumRangeFrequency()),
        className(IteratedCrossSumRangeFrequency()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
