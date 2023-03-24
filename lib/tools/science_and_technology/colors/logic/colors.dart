import 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_cmyk.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_hue.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_yuv.dart';

enum ColorSpaceKey {RGB, HEXCODE, HSV, HSL, HSI, CMYK, CMY, YUV, YPBPR, YCBCR, YIQ}

class ColorSpace {
  final ColorSpaceKey key;
  final String persistanceKey;
  final String name;

  const ColorSpace(this.key, this.persistanceKey, this.name);
}

abstract class GCWBaseColor {
  RGB toRGB();
}

const ColorSpaceKey defaultColorSpace = ColorSpaceKey.RGB;
final RGB defaultColor = RGB(255.0, 155.0, 0.0);
const int COLOR_DOUBLE_PRECISION = 5;

const List<ColorSpace> allColorSpaces = [
  ColorSpace(ColorSpaceKey.RGB, 'colors_rgb', 'colors_colorspace_rgb_title'),
  ColorSpace(ColorSpaceKey.HEXCODE, 'colors_hex', 'colors_colorspace_hex_title'),
  ColorSpace(ColorSpaceKey.HSV, 'colors_hsv', 'colors_colorspace_hsv_title'),
  ColorSpace(ColorSpaceKey.HSL, 'colors_hsl', 'colors_colorspace_hsl_title'),
  ColorSpace(ColorSpaceKey.HSI, 'colors_hsi', 'colors_colorspace_hsi_title'),
  ColorSpace(ColorSpaceKey.CMYK, 'colors_cmyk', 'colors_colorspace_cmyk_title'),
  ColorSpace(ColorSpaceKey.CMY, 'colors_cmy', 'colors_colorspace_cmy_title'),
  ColorSpace(ColorSpaceKey.YUV, 'colors_yuv', 'colors_colorspace_yuv_title'),
  ColorSpace(ColorSpaceKey.YPBPR, 'colors_ypbpr', 'colors_colorspace_ypbpr_title'),
  ColorSpace(ColorSpaceKey.YCBCR, 'colors_ycbcr', 'colors_colorspace_ycbcr_title'),
  ColorSpace(ColorSpaceKey.YIQ, 'colors_yiq', 'colors_colorspace_yiq_title'),
];

ColorSpace getColorSpaceByKey(ColorSpaceKey key) {
  return allColorSpaces.firstWhere((colorSpace) => colorSpace.key == key);
}

GCWBaseColor convertColorSpace(GCWColorValue color, ColorSpaceKey newColorSpace) {
  if (newColorSpace == color.colorSpace) {
    return color.color;
  }

  var rgb = color.color.toRGB();

  switch (newColorSpace) {
    case ColorSpaceKey.RGB:
      return rgb;
    case ColorSpaceKey.HEXCODE:
      return HexCode.fromRGB(rgb);
    case ColorSpaceKey.HSV:
      return HSV.fromRGB(rgb);
    case ColorSpaceKey.HSL:
      return HSL.fromRGB(rgb);
    case ColorSpaceKey.HSI:
      return HSI.fromRGB(rgb);
    case ColorSpaceKey.CMYK:
      return CMYK.fromRGB(rgb);
    case ColorSpaceKey.CMY:
      return CMY.fromRGB(rgb);
    case ColorSpaceKey.YUV:
      return YUV.fromRGB(rgb);
    case ColorSpaceKey.YPBPR:
      return YPbPr.fromRGB(rgb);
    case ColorSpaceKey.YCBCR:
      return YCbCr.fromRGB(rgb);
    case ColorSpaceKey.YIQ:
      return YIQ.fromRGB(rgb);
  }
}
