import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/category_views/selector_lists/easter_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_position/widget/moon_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_rise_set/widget/moon_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/right_ascension_to_degree/widget/right_ascension_to_degree.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/widget/seasons.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/shadow_length/widget/shadow_length.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/widget/sun_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_rise_set/widget/sun_rise_set.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class AstronomySelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(SunRiseSet()),
        className(SunPosition()),
        className(MoonRiseSet()),
        className(MoonPosition()),
        className(EasterSelection()),
        className(Seasons()),
        className(ShadowLength()),
        className(RightAscensionToDegree())
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
