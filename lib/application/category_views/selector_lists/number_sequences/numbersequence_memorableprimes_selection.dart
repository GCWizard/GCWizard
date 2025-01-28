import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/memorable_primes/widget/memorable_primes.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceMemorablePrimesSelection extends GCWSelection {
  const NumberSequenceMemorablePrimesSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const NumberSequenceMemorablePrimesNthNumber()),
        className(const NumberSequenceMemorablePrimesRange()),
        className(const NumberSequenceMemorablePrimesDigits()),
        className(const NumberSequenceMemorablePrimesCheckNumber()),
        className(const NumberSequenceMemorablePrimesContainsDigits()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
