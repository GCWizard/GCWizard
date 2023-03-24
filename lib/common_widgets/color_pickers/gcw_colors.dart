import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/color_pickers/gcw_colorpicker.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_cmyk.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_hue.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_yuv.dart';

part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_cmy.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_cmyk.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_hex.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_hsi.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_hsl.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_hsv.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_rgb.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_ycbcr.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_yiq.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_ypbpr.dart';
part 'package:gc_wizard/common_widgets/color_pickers/color_spaces/gcw_color_yuv.dart';
part 'package:gc_wizard/common_widgets/color_pickers/gcw_color_values_picker.dart';

class GCWColors extends StatefulWidget {
  final void Function(GCWColorValue) onChanged;
  final GCWColorValue colorsValue;

  const GCWColors({Key? key, required this.onChanged, required this.colorsValue}) : super(key: key);

  @override
  GCWColorsState createState() => GCWColorsState();
}

class GCWColorsState extends State<GCWColors> {
  late HSVColor _currentColorPickerColor;
  late GCWColorValue _currentColorsValue;

  @override
  void initState() {
    super.initState();

    _currentColorsValue = widget.colorsValue;

    _setColorPickerColor(_currentColorsValue);
  }

  void _setColorPickerColor(GCWColorValue color) {
    var rgb = convertColorSpace(color, ColorSpaceKey.RGB) as RGB;
    var sysColor = Color.fromARGB(255, rgb.red.round(), rgb.green.round(), rgb.blue.round());
    _currentColorPickerColor = HSVColor.fromColor(sysColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GCWColorPicker(
            hsvColor: _currentColorPickerColor,
            onChanged: (color) {
              setState(() {
                _currentColorPickerColor = color;

                var hsv = GCWColorValue(ColorSpaceKey.HSV, HSV(color.hue, color.saturation, color.value));
                var newColor = convertColorSpace(hsv, _currentColorsValue.colorSpace);
                _currentColorsValue = GCWColorValue(_currentColorsValue.colorSpace, newColor);

                _setCurrentValueAndEmitOnChange();
              });
            },
          ),
        ),
        _GCWColorValuesPicker(
          colorsValue: _currentColorsValue,
          onChanged: (GCWColorValue result) {
            setState(() {
              _currentColorsValue = result;
              var colorPickerColor = convertColorSpace(_currentColorsValue, ColorSpaceKey.HSV) as HSV;
              _currentColorPickerColor =
                  HSVColor.fromAHSV(1.0, colorPickerColor.hue, colorPickerColor.saturation, colorPickerColor.value);

              _setCurrentValueAndEmitOnChange();
            });
          },
        )
      ],
    );
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(_currentColorsValue);
  }
}
