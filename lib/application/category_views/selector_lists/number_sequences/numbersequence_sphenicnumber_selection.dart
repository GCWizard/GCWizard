import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sphenic_numbers/widget/spenic_numbers.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceSphenicNumbersSelection extends GCWSelection {
  const NumberSequenceSphenicNumbersSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const NumberSequenceSphenicNumbersNthNumber()),
        className(const NumberSequenceSphenicNumbersRange()),
        className(const NumberSequenceSphenicNumbersDigits()),
        className(const NumberSequenceSphenicNumbersCheckNumber()),
        className(const NumberSequenceSphenicNumbersContainsDigits()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
