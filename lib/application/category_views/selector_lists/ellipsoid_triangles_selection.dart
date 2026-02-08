import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/coords/triangles/centerofgravity/widget/centerofgravity.dart';
import 'package:gc_wizard/tools/coords/triangles/circumcircle/widget/circumcircle.dart';
import 'package:gc_wizard/tools/coords/triangles/excircles/widget/excircles.dart';
import 'package:gc_wizard/tools/coords/triangles/gergonne/widget/gergonne.dart';
import 'package:gc_wizard/tools/coords/triangles/incircle/widget/incircle.dart';
import 'package:gc_wizard/tools/coords/triangles/napoleon/widget/napoleon.dart';
import 'package:gc_wizard/tools/coords/triangles/orthocenter/widget/orthocenter.dart';
import 'package:gc_wizard/tools/coords/triangles/sidesmidpoint/widget/sidesmidpoint.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class EllipsoidTrianglePointsSelection extends GCWSelection {
  const EllipsoidTrianglePointsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const TriangleNapoleonPoints()),
        className(const TriangleSideMidPoints()),
        className(const TriangleCenterOfGravity()),
        className(const TriangleIncircle()),
        className(const TriangleCircumCircle()),
        className(const TriangleOrthocenter()),
        className(const TriangleExcircles()),
        className(const TriangleGergonnePoint()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
