import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/selector_lists/ellipsoid_triangles_circles_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/ellipsoid_triangles_specialpoints_selection.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/coords/triangles/area/widget/ellipsoidtriangle_area.dart';
import 'package:gc_wizard/tools/coords/triangles/medians/widget/ellipsoidtriangle_medians.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class EllipsoidTrianglePointsSelection extends GCWSelection {
  const EllipsoidTrianglePointsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const EllipsoidTrianglePointsCirclesSelection()),
        className(const EllipsoidTriangleArea()),
        className(const EllipsoidTriangleMedians()),
        className(const EllipsoidTrianglePointsSpecialPointsSelection()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
