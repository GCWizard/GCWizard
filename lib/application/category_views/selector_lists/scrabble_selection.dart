import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble/widget/scrabble.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble_overview/widget/scrabble_overview.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class ScrabbleSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [className(Scrabble()), className(ScrabbleOverview())].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
