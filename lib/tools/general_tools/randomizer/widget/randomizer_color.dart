import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/color_tool/widget/color_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_cmyk.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

class RandomizerColor extends StatefulWidget {
  const RandomizerColor({Key? key}) : super(key: key);

  @override
  _RandomizerColorState createState() => _RandomizerColorState();
}

class _RandomizerColorState extends State<RandomizerColor> {
  Widget _currentOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        _currentOutput
      ],
    );
  }

  void _calculateOutput() {
    var rgbColor = randomColor();

    List<Widget> children = [
      GCWColumnedMultilineOutput(data: [
        ['Hex Color Code', HexCode.fromRGB(rgbColor)],
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

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: children,
      ),
    );
  }

  void _showElement(RGB color) {
    Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
        builder: (context) => GCWTool(tool: ColorTool(color: color), id: 'colors')));
  }
}
