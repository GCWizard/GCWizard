import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_address/widget/ip_address.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_address/widget/ip_address_minimumsubnet.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class IPAddressSelection extends GCWSelection {
  const IPAddressSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const IPAddress()),
        className(const IPAddressMinimumSubnet()),
       ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
