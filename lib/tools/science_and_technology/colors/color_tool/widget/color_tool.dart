import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_cmyk.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_hue.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_yuv.dart';
import 'package:intl/intl.dart';

class ColorTool extends StatefulWidget {
  final RGB? color;

  const ColorTool({Key? key, this.color}) : super(key: key);

  @override
  ColorToolState createState() => ColorToolState();
}

class ColorToolState extends State<ColorTool> {
  late GCWColorValue _currentColor;
  var _currentOutputColorSpace = ColorSpaceKey.HEXCODE;

  final NumberFormat _numberFormat = NumberFormat('0.' + '#' * COLOR_DOUBLE_PRECISION);

  @override
  void initState() {
    super.initState();

    _currentColor = GCWColorValue(ColorSpaceKey.RGB, widget.color ?? defaultColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWColors(
          colorsValue: _currentColor,
          onChanged: (value) {
            setState(() {
              _currentColor = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'colors_outputcolorspace')),
        GCWDropDown<ColorSpaceKey>(
          value: _currentOutputColorSpace,
          items: allColorSpaces.map((colorSpace) {
            return GCWDropDownMenuItem(value: colorSpace.key, child: i18n(context, colorSpace.name));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentOutputColorSpace = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    List<List<String>> colorSpaceOutputs;

    switch (_currentOutputColorSpace) {
      case ColorSpaceKey.RGB:
        var rgb = convertColorSpace(_currentColor, ColorSpaceKey.RGB) as RGB;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_rgb_red'), _numberFormat.format(rgb.red)],
          [i18n(context, 'colors_colorspace_rgb_green'), _numberFormat.format(rgb.green)],
          [i18n(context, 'colors_colorspace_rgb_blue'), _numberFormat.format(rgb.blue)]
        ];
        break;
      case ColorSpaceKey.HEXCODE:
        var hex = convertColorSpace(_currentColor, ColorSpaceKey.HEXCODE) as HexCode;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_hex_hexcode'), hex.toString()],
          [i18n(context, 'colors_colorspace_hex_shorthexcode'), (hex.isShortHex ? hex.shortHexCode.toString() : '-')]
        ];
        break;
      case ColorSpaceKey.HSV:
        var hsv = convertColorSpace(_currentColor, ColorSpaceKey.HSV) as HSV;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_hsv_hue'), _numberFormat.format(hsv.hue)],
          [i18n(context, 'colors_colorspace_hsv_saturation'), _numberFormat.format(hsv.saturation * 100.0)],
          [i18n(context, 'colors_colorspace_hsv_value'), _numberFormat.format(hsv.value * 100.0)]
        ];
        break;
      case ColorSpaceKey.HSL:
        var hsl = convertColorSpace(_currentColor, ColorSpaceKey.HSL) as HSL;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_hsl_hue'), _numberFormat.format(hsl.hue)],
          [i18n(context, 'colors_colorspace_hsl_saturation'), _numberFormat.format(hsl.saturation * 100.0)],
          [i18n(context, 'colors_colorspace_hsl_lightness'), _numberFormat.format(hsl.lightness * 100.0)]
        ];
        break;
      case ColorSpaceKey.HSI:
        var hsi = convertColorSpace(_currentColor, ColorSpaceKey.HSI) as HSI;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_hsi_hue'), _numberFormat.format(hsi.hue)],
          [i18n(context, 'colors_colorspace_hsi_saturation'), _numberFormat.format(hsi.saturation * 100.0)],
          [i18n(context, 'colors_colorspace_hsi_intensity'), _numberFormat.format(hsi.intensity * 100.0)]
        ];
        break;
      case ColorSpaceKey.CMYK:
        var cmyk = convertColorSpace(_currentColor, ColorSpaceKey.CMYK) as CMYK;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_cmyk_cyan'), _numberFormat.format(cmyk.cyan * 100.0)],
          [i18n(context, 'colors_colorspace_cmyk_magenta'), _numberFormat.format(cmyk.magenta * 100.0)],
          [i18n(context, 'colors_colorspace_cmyk_yellow'), _numberFormat.format(cmyk.yellow * 100.0)],
          [i18n(context, 'colors_colorspace_cmyk_key'), _numberFormat.format(cmyk.key * 100.0)]
        ];
        break;
      case ColorSpaceKey.CMY:
        var cmy = convertColorSpace(_currentColor, ColorSpaceKey.CMY) as CMY;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_cmy_cyan'), _numberFormat.format(cmy.cyan * 100.0)],
          [i18n(context, 'colors_colorspace_cmy_magenta'), _numberFormat.format(cmy.magenta * 100.0)],
          [i18n(context, 'colors_colorspace_cmy_yellow'), _numberFormat.format(cmy.yellow * 100.0)]
        ];
        break;
      case ColorSpaceKey.YUV:
        var yuv = convertColorSpace(_currentColor, ColorSpaceKey.YUV) as YUV;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_yuv_y'), _numberFormat.format(yuv.y * 100.0)],
          [i18n(context, 'colors_colorspace_yuv_u'), _numberFormat.format(yuv.u * 100.0)],
          [i18n(context, 'colors_colorspace_yuv_v'), _numberFormat.format(yuv.v * 100.0)]
        ];
        break;
      case ColorSpaceKey.YPBPR:
        var yPbPr = convertColorSpace(_currentColor, ColorSpaceKey.YPBPR) as YPbPr;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_ypbpr_y'), _numberFormat.format(yPbPr.y * 100.0)],
          [i18n(context, 'colors_colorspace_ypbpr_pb'), _numberFormat.format(yPbPr.pb * 100.0)],
          [i18n(context, 'colors_colorspace_ypbpr_pr'), _numberFormat.format(yPbPr.pr * 100.0)]
        ];
        break;
      case ColorSpaceKey.YCBCR:
        var yCbCr = convertColorSpace(_currentColor, ColorSpaceKey.YCBCR) as YCbCr;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_ycbcr_y'), _numberFormat.format(yCbCr.y)],
          [i18n(context, 'colors_colorspace_ycbcr_cb'), _numberFormat.format(yCbCr.cb)],
          [i18n(context, 'colors_colorspace_ycbcr_cr'), _numberFormat.format(yCbCr.cr)]
        ];
        break;
      case ColorSpaceKey.YIQ:
        var yiq = convertColorSpace(_currentColor, ColorSpaceKey.YIQ) as YIQ;
        colorSpaceOutputs = [
          [i18n(context, 'colors_colorspace_yiq_y'), _numberFormat.format(yiq.y * 100.0)],
          [i18n(context, 'colors_colorspace_yiq_i'), _numberFormat.format(yiq.i * 100.0)],
          [i18n(context, 'colors_colorspace_yiq_q'), _numberFormat.format(yiq.q * 100.0)]
        ];
        break;
    }

    return GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
        data: colorSpaceOutputs
    );
  }
}
