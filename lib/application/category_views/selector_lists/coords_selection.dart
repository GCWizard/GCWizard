import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';

class CoordsSelection extends GCWSelection {
  const CoordsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList =
        registeredTools.where((element) => element.categories.contains(ToolCategory.COORDINATES)).toList();

    return GCWToolList(toolList: _toolList);
  }
}
