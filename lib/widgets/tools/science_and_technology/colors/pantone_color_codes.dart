import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors_cmyk.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors_rgb.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/pantone_color_codes.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/common/base/gcw_button.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/colors/base/gcw_colors.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/colors/color_tool.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';

class PantoneColorCodes extends StatefulWidget {
  @override
  PantoneColorCodesState createState() => PantoneColorCodesState();
}

class PantoneColorCodesState extends State<PantoneColorCodes> {
  var _currentValue;
  List<Map<String, String>> _colors;

  var _currentMode = GCWSwitchPosition.left;

  dynamic _currentInputColor = defaultColor;
  String _currentColorSpace = keyColorSpaceRGB;

  @override
  Widget build(BuildContext context) {
    if (_colors == null) {
      _colors = PANTONE_COLOR_CODES_WITH_NAMES.values.map((color) {
        var name = i18n(context, color['name']);
        if (color['prefix'] != null) name = i18n(context, color['prefix']) + ' ' + name;
        if (color['suffix'] != null) name = name + ' ' + color['suffix'];
        return {'name': name, 'colorcode': color['colorcode']};
      }).toList();

      _colors.sort((a, b) => a['name'].compareTo(b['name']));

      _colors.addAll(PANTONE_COLOR_CODES_ONLY_NUMBERS.values.toList());

      _currentValue = _colors[0];
    }

    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'pantonecolorcodes_mode_pmstocolor'),
          rightValue: i18n(context, 'pantonecolorcodes_mode_colortopms'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? Column(
                children: [
                  GCWDropDownButton(
                      value: _currentValue,
                      onChanged: (newValue) {
                        setState(() {
                          _currentValue = newValue;
                        });
                      },
                      items: _colors.map((color) {
                        return GCWDropDownMenuItem(value: color, child: color['name']);
                      }).toList()),
                  GCWDefaultOutput(child: _buildPantoneToColorOutput())
                ],
              )
            : Column(
                children: [
                  GCWColors(
                    color: _currentInputColor,
                    colorSpace: _currentColorSpace,
                    onChanged: (value) {
                      setState(() {
                        _currentColorSpace = value['colorSpace'];
                        _currentInputColor = value['color'];
                      });
                    },
                  ),
                  _buildColorToPantoneOutput()
                ],
              ),
      ],
    );
  }

  List<dynamic> _buildPantoneColorOutput(Map<String, String> pantone) {
    var rgb = HexCode(pantone['colorcode']).toRGB();

    return [
      Container(
        margin: EdgeInsets.only(right: 4 * DOUBLE_DEFAULT_MARGIN),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: themeColors().mainFont(), width: 2),
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(rgb.red.round(), rgb.green.round(), rgb.blue.round(), 1.0),
        ),
      ),
      pantone['colorcode'],
      pantone['name']
    ];
  }

  Widget _buildColorToPantoneOutput() {
    RGB rgb = convertColorSpace(_currentInputColor, _currentColorSpace, keyColorSpaceRGB);
    List<Map<String, String>> similarPantones = findSimilarPantoneColors(rgb, _colors);

    if (similarPantones == null || similarPantones.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'pantonecolorcodes_mode_colorstoral_nocolorfound'),
      );
    }

    return GCWOutput(
        title: similarPantones.length == 1
            ? i18n(context, 'common_output')
            : i18n(context, 'pantonecolorcodes_mode_colorstoral_similarcolorsfound'),
        child: GCWColumnedMultilineOutput(
                  data:  similarPantones.map((e) => _buildPantoneColorOutput(e)).toList(),
                  flexValues: [1, 1, 2],
                  copyColumn: 2
              ),
        );
  }

  Widget _buildPantoneToColorOutput() {
    var rgbColor = HexCode(_currentValue['colorcode']).toRGB();

    var name = _currentValue['name'];
    if (name == null || name.isEmpty) name = 'common_unknown';

    List<Widget> children = [GCWColumnedMultilineOutput(
                              data : [
                                      ['Name', i18n(context, name)],
                                      ['Hex Color Code', _currentValue['colorcode']],
                                      ['RGB', rgbColor.toRBGString()],
                                      ['CMYK', CMYK.fromRGB(rgbColor).toCMYKString()],
                                    ]
                              )];

    children.add(Container(
      margin: EdgeInsets.only(top: 10 * DEFAULT_MARGIN),
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

  _showElement(RGB color) {
    Navigator.of(context).push(NoAnimationMaterialPageRoute(
        builder: (context) => GCWTool(tool: ColorTool(color: color), i18nPrefix: 'colors')));
  }
}
