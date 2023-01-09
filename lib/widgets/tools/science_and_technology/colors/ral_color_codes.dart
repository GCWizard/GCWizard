import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors_cmyk.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors_rgb.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/ral_color_codes.dart';
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

class RALColorCodes extends StatefulWidget {
  @override
  RALColorCodesState createState() => RALColorCodesState();
}

class RALColorCodesState extends State<RALColorCodes> {
  var _currentValue;
  List<Map<String, String>> _colors;

  var _currentMode = GCWSwitchPosition.left;

  dynamic _currentInputColor = RGB(50, 175, 187);
  String _currentColorSpace = keyColorSpaceRGB;

  @override
  void initState() {
    super.initState();

    _colors = RAL_COLOR_CODES
        .map((key, value) {
          var val = Map<String, String>.from(value);
          val.putIfAbsent('key', () => key);

          return MapEntry(key, val);
        })
        .values
        .toList();

    _colors.sort((a, b) => a['key'].compareTo(b['key']));
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
                  GCWDropDownButton(
                      value: _currentValue,
                      onChanged: (newValue) {
                        setState(() {
                          _currentValue = newValue;
                        });
                      },
                      items: _colors.map((color) {
                        return GCWDropDownMenuItem(value: color, child: color['key']);
                      }).toList()),
                  GCWDefaultOutput(child: _buildRALToColorOutput())
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
                  _buildColorToRALOutput()
                ],
              ),
      ],
    );
  }

  List<dynamic> _buildRALColorOutput(Map<String, String> ral) {
    var rgb = HexCode(ral['colorcode']).toRGB();

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
      ral['ralcode'],
      i18n(context, ral['name']) + '\n' + ral['colorcode']
    ];
  }

  _buildColorToRALOutput() {
    RGB rgb = convertColorSpace(_currentInputColor, _currentColorSpace, keyColorSpaceRGB);
    List<Map<String, String>> similarRALs = findSimilarRALColors(rgb);

    if (similarRALs == null || similarRALs.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'ralcolorcodes_mode_colorstoral_nocolorfound'),
      );
    }

    return GCWOutput(
        title: similarRALs.length == 1
            ? i18n(context, 'common_output')
            : i18n(context, 'ralcolorcodes_mode_colorstoral_similarcolorsfound'),
        child: GCWColumnedMultilineOutput(
                  data: similarRALs.map((e) => _buildRALColorOutput(e)).toList(),
                  flexValues: [1, 2, 2],
                  copyColumn: 1
              ),
        );
  }

  _buildRALToColorOutput() {
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
