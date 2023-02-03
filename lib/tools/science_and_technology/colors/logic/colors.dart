import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_cmyk.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_hue.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_yuv.dart';

const keyColorSpaceRGB = 'colors_rgb';
const keyColorSpaceHex = 'colors_hex';
const keyColorSpaceHSV = 'colors_hsv';
const keyColorSpaceHSL = 'colors_hsl';
const keyColorSpaceHSI = 'colors_hsi';
const keyColorSpaceCMYK = 'colors_cmyk';
const keyColorSpaceCMY = 'colors_cmy';
const keyColorSpaceYUV = 'colors_yuv';
const keyColorSpaceYPbPr = 'colors_ypbpr';
const keyColorSpaceYCbCr = 'colors_ycbcr';
const keyColorSpaceYIQ = 'colors_yiq';

class ColorSpace {
  final key;
  String name;

  ColorSpace(this.key, this.name);
}

final String defaultColorSpace = keyColorSpaceRGB;
final RGB defaultColor = RGB(255.0, 155.0, 0.0);
final int COLOR_DOUBLE_PRECISION = 5;

final List<ColorSpace> allColorSpaces = [
  ColorSpace(keyColorSpaceRGB, 'colors_colorspace_rgb_title'),
  ColorSpace(keyColorSpaceHex, 'colors_colorspace_hex_title'),
  ColorSpace(keyColorSpaceHSV, 'colors_colorspace_hsv_title'),
  ColorSpace(keyColorSpaceHSL, 'colors_colorspace_hsl_title'),
  ColorSpace(keyColorSpaceHSI, 'colors_colorspace_hsi_title'),
  ColorSpace(keyColorSpaceCMYK, 'colors_colorspace_cmyk_title'),
  ColorSpace(keyColorSpaceCMY, 'colors_colorspace_cmy_title'),
  ColorSpace(keyColorSpaceYUV, 'colors_colorspace_yuv_title'),
  ColorSpace(keyColorSpaceYPbPr, 'colors_colorspace_ypbpr_title'),
  ColorSpace(keyColorSpaceYCbCr, 'colors_colorspace_ycbcr_title'),
  ColorSpace(keyColorSpaceYIQ, 'colors_colorspace_yiq_title'),
];

ColorSpace getColorSpaceByKey(String key) {
  return allColorSpaces.firstWhere((colorSpace) => colorSpace.key == key);
}

convertColorSpace(dynamic color, String oldColorSpace, String newColorSpace) {
  if (newColorSpace == oldColorSpace) {
    return color;
  }

  if (oldColorSpace != keyColorSpaceRGB) {
    color = color.toRGB();
  }

  switch (newColorSpace) {
    case keyColorSpaceRGB:
      return color;
    case keyColorSpaceHex:
      return HexCode.fromRGB(color);
    case keyColorSpaceHSV:
      return HSV.fromRGB(color);
    case keyColorSpaceHSL:
      return HSL.fromRGB(color);
    case keyColorSpaceHSI:
      return HSI.fromRGB(color);
    case keyColorSpaceCMYK:
      return CMYK.fromRGB(color);
    case keyColorSpaceCMY:
      return CMY.fromRGB(color);
    case keyColorSpaceYUV:
      return YUV.fromRGB(color);
    case keyColorSpaceYPbPr:
      return YPbPr.fromRGB(color);
    case keyColorSpaceYCbCr:
      return YCbCr.fromRGB(color);
    case keyColorSpaceYIQ:
      return YIQ.fromRGB(color);
  }
}
