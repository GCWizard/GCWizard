import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/Harshad/widget/Harshad_numbers.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceHarshadNumbersSelection extends GCWSelection {
  const NumberSequenceHarshadNumbersSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const NumberSequenceHarshadNumbersNthNumber()),
        className(const NumberSequenceHarshadNumbersRange()),
        className(const NumberSequenceHarshadNumbersDigits()),
        className(const NumberSequenceHarshadNumbersCheckNumber()),
        className(const NumberSequenceHarshadNumbersContainsDigits()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
