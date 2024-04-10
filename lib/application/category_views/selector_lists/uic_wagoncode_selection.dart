import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_uic_selection.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_countrycodes.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_freight_classifications.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_passenger_lettercodes.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_vkm.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class UICWagonCodeSelection extends GCWSelection {
  const UICWagonCodeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const UICWagonCode()),
        className(const CheckDigitsUICSelection()),
        className(const UICWagonCodeCountryCodes()),
        className(const UICWagonCodeFreightClassifications()),
        className(const UICWagonCodePassengerLettercodes()),
        className(const UICWagonCodeVKM()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
