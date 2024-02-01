import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/color_tool/widget/color_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_cmyk.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/ral_color_codes/logic/ral_color_codes.dart';

class RALColorCodes extends StatefulWidget {
  const RALColorCodes({Key? key}) : super(key: key);

  @override
  _RALColorCodesState createState() => _RALColorCodesState();
}

class _RALColorCodesState extends State<RALColorCodes> {
  late MapEntry<String, RalColor> _currentValue;
  List<MapEntry<String, RalColor>> _colors = [];

  var _currentMode = GCWSwitchPosition.left;

  var _currentInput = GCWColorValue(ColorSpaceKey.RGB, RGB(50, 175, 187));

  @override
  void initState() {
    super.initState();

    _colors = RAL_COLOR_CODES.entries.toList();

    _colors.sort((a, b) => a.key.compareTo(b.key));
    _currentValue = _colors[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'ralcolorcodes_mode_raltocolor'),
          rightValue: i18n(context, 'ralcolorcodes_mode_colortoral'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? Column(
                children: [
                  GCWDropDown<MapEntry<String, RalColor>>(
                      value: _currentValue,
                      onChanged: (newValue) {
                        setState(() {
                          _currentValue = newValue;
                        });
                      },
                      items: _colors.map((color) {
                        return GCWDropDownMenuItem(value: color, child: color.key);
                      }).toList()),
                  GCWDefaultOutput(child: _buildRALToColorOutput())
                ],
              )
            : Column(
                children: [
                  GCWColors(
                    colorsValue: _currentInput,
                    onChanged: (value) {
                      setState(() {
                        _currentInput = value;
                      });
                    },
                  ),
                  _buildColorToRALOutput()
                ],
              ),
      ],
    );
  }

  List<Object> _buildRALColorOutput(MapEntry<String, RalColor> ral) {
    var rgb = HexCode(ral.value.colorcode).toRGB();

    return [
      Container(
        margin: const EdgeInsets.only(right: 4 * DOUBLE_DEFAULT_MARGIN),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: themeColors().mainFont(), width: 2),
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(rgb.red.round(), rgb.green.round(), rgb.blue.round(), 1.0),
        ),
      ),
      ral.key,
      i18n(context, ral.value.name) + '\n' + ral.value.colorcode
    ];
  }

  Widget _buildColorToRALOutput() {
    var rgb = convertColorSpace(_currentInput, ColorSpaceKey.RGB);
    var similarRALs = findSimilarRALColors(rgb.toRGB());

    if (similarRALs.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'ralcolorcodes_mode_colorstoral_nocolorfound'),
      );
    }

    return GCWOutput(
      title: similarRALs.length == 1
          ? i18n(context, 'common_output')
          : i18n(context, 'ralcolorcodes_mode_colorstoral_similarcolorsfound'),
      child: GCWColumnedMultilineOutput(
          data: similarRALs.entries.map((e) => _buildRALColorOutput(e)).toList(),
          flexValues: const [1, 2, 2],
          copyColumn: 1),
    );
  }

  Widget _buildRALToColorOutput() {
    var rgbColor = HexCode(_currentValue.value.colorcode).toRGB();

    var name = _currentValue.value.name;
    if (name.isEmpty) name = 'common_unknown';

    List<Widget> children = [
      GCWColumnedMultilineOutput(data: [
        ['Name', i18n(context, name)],
        ['Hex Color Code', _currentValue.value.colorcode],
        ['RGB', rgbColor.toRBGString()],
        ['CMYK', CMYK.fromRGB(rgbColor).toCMYKString()],
      ])
    ];

    children.add(Container(
      margin: const EdgeInsets.only(top: 10 * DEFAULT_MARGIN),
      height: 200,
      width: 400,
      decoration: BoxDecoration(
        border: Border.all(color: themeColors().mainFont(), width: 2),
        shape: BoxShape.rectangle,
        color: Color.fromRGBO(rgbColor.red.round(), rgbColor.green.round(), rgbColor.blue.round(), 1.0),
      ),
    ));

    children.add(GCWButton(
      text: i18n(context, 'ralcolorcodes_showincolorpicker'),
      onPressed: () => _showElement(rgbColor),
    ));

    return Column(children: children);
  }

  void _showElement(RGB color) {
    Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
        builder: (context) => GCWTool(tool: ColorTool(color: color), id: 'colors')));
  }
}
