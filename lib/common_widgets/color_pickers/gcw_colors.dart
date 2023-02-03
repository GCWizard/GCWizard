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
  final Function onChanged;
  final dynamic color;
  final String colorSpace;

  const GCWColors({Key key, this.onChanged, this.colorSpace, this.color}) : super(key: key);

  @override
  GCWColorsState createState() => GCWColorsState();
}

class GCWColorsState extends State<GCWColors> {
  dynamic _currentColor = defaultColor;
  HSVColor _currentColorPickerColor;
  String _currentColorSpace = keyColorSpaceRGB;

  @override
  void initState() {
    super.initState();

    _currentColorSpace = widget.colorSpace ?? defaultColorSpace;
    _currentColor = widget.color ?? defaultColor;

    _setColorPickerColor(_currentColor);
  }

  _setColorPickerColor(dynamic color) {
    var rgb = convertColorSpace(color, _currentColorSpace, keyColorSpaceRGB);
    var sysColor = Color.fromARGB(255, rgb.red.round(), rgb.green.round(), rgb.blue.round());
    _currentColorPickerColor = HSVColor.fromColor(sysColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: GCWColorPicker(
            hsvColor: _currentColorPickerColor,
            onChanged: (color) {
              setState(() {
                _currentColorPickerColor = color;

                HSV hsv = HSV(color.hue, color.saturation, color.value);
                _currentColor = convertColorSpace(hsv, keyColorSpaceHSV, _currentColorSpace);

                _setCurrentValueAndEmitOnChange();
              });
            },
          ),
          padding: EdgeInsets.only(bottom: 20.0),
        ),
        _GCWColorValuesPicker(
          color: _currentColor,
          colorSpace: _currentColorSpace,
          onChanged: (result) {
            setState(() {
              _currentColorSpace = result['colorSpace'];
              _currentColor = result['color'];

              HSV colorPickerColor = convertColorSpace(_currentColor, _currentColorSpace, keyColorSpaceHSV);
              _currentColorPickerColor =
                  HSVColor.fromAHSV(1.0, colorPickerColor.hue, colorPickerColor.saturation, colorPickerColor.value);

              _setCurrentValueAndEmitOnChange();
            });
          },
        )
      ],
    );
  }

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged({'colorSpace': _currentColorSpace, 'color': _currentColor});
  }
}
