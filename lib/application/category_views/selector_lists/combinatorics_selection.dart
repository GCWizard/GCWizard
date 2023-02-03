import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination/widget/combination.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination_permutation/widget/combination_permutation.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/permutation/widget/permutation.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class CombinatoricsSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(Combination()),
        className(Permutation()),
        className(CombinationPermutation()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
