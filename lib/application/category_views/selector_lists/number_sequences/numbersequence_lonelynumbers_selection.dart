import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lonely_numbers/widget/lonely_numbers.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceLonelyNumbersSelection extends GCWSelection {
  const NumberSequenceLonelyNumbersSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const NumberSequenceLonelyNumbersNthNumber()),
        className(const NumberSequenceLonelyNumbersRange()),
        className(const NumberSequenceLonelyNumbersDigits()),
        className(const NumberSequenceLonelyNumbersCheckNumber()),
        className(const NumberSequenceLonelyNumbersContainsDigits()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
