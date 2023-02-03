import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/chappe/widget/chappe.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/edelcrantz/widget/edelcrantz.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/widget/gauss_weber_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/murray/widget/murray.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/ohlsen_telegraph/widget/ohlsen_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/pasley_telegraph/widget/pasley_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/popham_telegraph/widget/popham_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/prussia_telegraph/widget/prussia_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/schilling_canstatt_telegraph/widget/schilling_canstatt_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/semaphore/widget/semaphore.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wheatstone_cooke_5_needles/widget/wheatstone_cooke_5_needles.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wigwag/widget/wigwag.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class TelegraphSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(ChappeTelegraph()),
        className(EdelcrantzTelegraph()),
        className(MurrayTelegraph()),
        className(OhlsenTelegraph()),
        className(PasleyTelegraph()),
        className(PophamTelegraph()),
        className(PrussiaTelegraph()),
        className(SemaphoreTelegraph()),
        className(WigWagSemaphoreTelegraph()),
        className(GaussWeberTelegraph()),
        className(SchillingCanstattTelegraph()),
        className(WheatstoneCookeNeedleTelegraph()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
