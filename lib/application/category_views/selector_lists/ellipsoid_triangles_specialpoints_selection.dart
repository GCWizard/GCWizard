import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/gergonne/widget/gergonne.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/napoleon/widget/napoleon.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/orthocenter/widget/orthocenter.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class EllipsoidTrianglePointsSpecialPointsSelection extends GCWSelection {
  const EllipsoidTrianglePointsSpecialPointsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const TriangleOrthocenter()),
        className(const TriangleNapoleonPoints()),
        className(const TriangleGergonnePoint()),
      ].contains(className(element.tool));
    }).toList();
    _toolList.sort((a, b) => sortToolList(a, b));

    return GCWToolList(toolList: _toolList);
  }
}
