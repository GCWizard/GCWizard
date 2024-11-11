import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/widget/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/widget/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/widget/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/wet_bulb_temperature/widget/wet_bulb_temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/widget/windchill.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class ApparentTemperatureSelection extends GCWSelection {
  const ApparentTemperatureSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const HeatIndex()),
        className(const Humidex()),
        className(const SummerSimmerIndex()),
        className(const Windchill()),
        className(const WetBulbTemperature()),
       ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
