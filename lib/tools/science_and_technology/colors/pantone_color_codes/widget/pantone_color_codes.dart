import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
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
import 'package:gc_wizard/tools/science_and_technology/colors/pantone_color_codes/logic/pantone_color_codes.dart';

class PantoneColorCodes extends StatefulWidget {
  const PantoneColorCodes({Key? key}) : super(key: key);

  @override
  PantoneColorCodesState createState() => PantoneColorCodesState();
}

class PantoneColorCodesState extends State<PantoneColorCodes> {
  late PantoneColor _currentValue;
  List<PantoneColor> _colors = [];

  var _currentMode = GCWSwitchPosition.left;

  var _currentColor = GCWColorValue(ColorSpaceKey.RGB, defaultColor);

  @override
  void initState() {
    super.initState();

    _colors = PANTONE_COLOR_CODES_WITH_NAMES.values.map((color) {
      var name = i18n(context, color.name);
      if (color.prefix != null) name = i18n(context, color.prefix!) + ' ' + name;
      if (color.suffix != null) name = name + ' ' + color.suffix!;
      return PantoneColor(name: name, colorcode: color.colorcode);
    }).toList();

    _colors.sort((a, b) => a.name.compareTo(b.name));

    _colors.addAll(PANTONE_COLOR_CODES_ONLY_NUMBERS.values.toList());

    _currentValue = _colors[0];
  }

  @override
  Widget build(BuildContext context) {

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
                  GCWDropDown<PantoneColor>(
                      value: _currentValue,
                      onChanged: (newValue) {
                        setState(() {
                          _currentValue = newValue;
                        });
                      },
                      items: _colors.map((color) {
                        return GCWDropDownMenuItem(value: color, child: color.name);
                      }).toList()),
                  GCWDefaultOutput(child: _buildPantoneToColorOutput())
                ],
              )
            : Column(
                children: [
                  GCWColors(
                    colorsValue: _currentColor,
                    onChanged: (value) {
                      setState(() {
                        _currentColor = value;
                      });
                    },
                  ),
                  _buildColorToPantoneOutput()
                ],
              ),
      ],
    );
  }

  List<Object> _buildPantoneColorOutput(PantoneColor pantone) {
    var rgb = HexCode(pantone.colorcode).toRGB();

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
      pantone.colorcode,
      pantone.name
    ];
  }

  Widget _buildColorToPantoneOutput() {
    var rgb = convertColorSpace(_currentColor, ColorSpaceKey.RGB);
    var similarPantones = findSimilarPantoneColors(rgb, _colors);

    if (similarPantones.isEmpty) {
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
                  flexValues: const [1, 1, 2],
                  copyColumn: 2
              ),
        );
  }

  Widget _buildPantoneToColorOutput() {
    var rgbColor = HexCode(_currentValue.colorcode).toRGB();

    var name = _currentValue.name;
    if (name.isEmpty) name = 'common_unknown';

    List<Widget> children = [GCWColumnedMultilineOutput(
                              data : [
                                      ['Name', i18n(context, name)],
                                      ['Hex Color Code', _currentValue.colorcode],
                                      ['RGB', rgbColor.toRBGString()],
                                      ['CMYK', CMYK.fromRGB(rgbColor).toCMYKString()],
                                    ]
                              )];

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
