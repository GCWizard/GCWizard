import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_calling_codes/widget/countries_calling_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_embassycodes_ger/widget/countries_embassycodes_ger.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_ioc_codes/widget/countries_ioc_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_iso_codes/widget/countries_iso_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_vehicle_codes/widget/countries_vehicle_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/country_flags/widget/country_flags.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class CountriesSelection extends GCWSelection {
  const CountriesSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(CountriesCallingCodes()),
        className(CountriesIOCCodes()),
        className(CountriesISOCodes()),
        className(CountriesVehicleCodes()),
        className(const CountriesFlags()),
        className(CountriesEmbassyCodesGER()),
      ].contains(className(element.tool));
    }).toList();

    _toolList.sort((a, b) => sortToolList(a, b));

    return GCWToolList(toolList: _toolList);
  }
}
