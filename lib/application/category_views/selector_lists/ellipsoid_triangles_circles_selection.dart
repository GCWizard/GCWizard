import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/excircles/widget/ellipsoidtriangle_excircles.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/incircle/widget/ellipsoidtriangle_incircle.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/circumcircle/widget/circumcircle.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class EllipsoidTrianglePointsCirclesSelection extends GCWSelection {
  const EllipsoidTrianglePointsCirclesSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const EllipsoidTriangleIncircle()),
        className(const EllipsoidTriangleCircumCircle()),
        className(const EllipsoidTriangleExcircles()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
