import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt2/widget/sqrt2.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class SQRT2Selection extends GCWSelection {
  const SQRT2Selection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const SQRT2NthDecimal()),
        className(const SQRT2DecimalRange()),
        className(const SQRT2Search()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
