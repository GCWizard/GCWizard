import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/look_and_say/widget/look_and_say.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/look_and_say/widget/look_and_say_text.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceLookAndSaySelection extends GCWSelection {
  const NumberSequenceLookAndSaySelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const NumberSequenceLookAndSayNthNumber()),
        className(const NumberSequenceLookAndSayRange()),
        className(const NumberSequenceLookAndSayDigits()),
        className(const NumberSequenceLookAndSayCheckNumber()),
        className(const NumberSequenceLookAndSayContainsDigits()),
        className(const LookAndSayText()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
