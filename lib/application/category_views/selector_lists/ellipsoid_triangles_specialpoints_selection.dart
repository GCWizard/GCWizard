import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/centerofgravity/widget/ellipsoidtriangle_centerofgravity.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/gergonne/widget/ellipsoidtriangle_gergonne.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/napoleon/widget/ellipsoidtriangle_napoleon.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/orthocenter/widget/ellipsoidtriangle_orthocenter.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class EllipsoidTrianglePointsSpecialPointsSelection extends GCWSelection {
  const EllipsoidTrianglePointsSpecialPointsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const EllipsoidTriangleCenterOfGravity()),
        className(const EllipsoidTriangleOrthocenter()),
        className(const EllipsoidTriangleNapoleonPoints()),
        className(const EllipsoidTriangleGergonnePoint()),
      ].contains(className(element.tool));
    }).toList();
    _toolList.sort((a, b) => sortToolList(a, b));

    return GCWToolList(toolList: _toolList);
  }
}
