import 'package:flutter/material.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/common/gcw_toollist.dart';
import 'package:gc_wizard/widgets/registry.dart';
import 'package:gc_wizard/widgets/selector_lists/gcw_selection.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/combinatorics/combination.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/combinatorics/combination_permutation.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/combinatorics/permutation.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class CombinatoricsSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = Registry.toolList.where((element) {
      return [
        className(Combination()),
        className(Permutation()),
        className(CombinationPermutation()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
