import 'package:flutter/material.dart';
import 'package:gc_wizard/configuration/abstract_tool_registration.dart';
import 'package:gc_wizard/tools/common/gcw_tool/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/ral_color_codes/widget/ral_color_codes.dart';

class RALColorCodesRegistration implements AbstractToolRegistration
{
  @override
  List<ToolCategory> ToolCategory.SCIENCE_AND_TECHNOLOGY = [
    ToolCategory.SCIENCE_AND_TECHNOLOGY
  ];

  @override
  String i18nPrefix = 'ralcolorcodes';

  @override
  List<String> searchKeys = [
    'color',
    'ralcolorcodes',
  ];

  @override
  Widget tool = RALColorCodes();
}