import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_cards.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_coin.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_color.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_coords.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_dice.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_double.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_integer.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_letter.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_password.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_rockpaperscissors.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class RandomizerSelection extends GCWSelection {
  const RandomizerSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const RandomizerCoin()),
        className(const RandomizerDice()),
        className(const RandomizerCards()),
        className(const RandomizerRockPaperScissors()),
        className(const RandomizerPassword()),
        className(const RandomizerInteger()),
        className(const RandomizerDouble()),
        className(const RandomizerLetter()),
        className(const RandomizerCoordinates()),
        className(const RandomizerColor()),
        className(const RandomizerLists()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
