import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/utils/math_utils.dart';

enum _HueType { HSV, HSL, HSI }

//source: https://www.vocal.com/video/rgb-and-hsvhsihsl-color-space-conversion/
//ToDo NullSafety remove Map result
Map<String, double> _fromRGB(RGB rgb, _HueType type) {
  var red = rgb.redPercentage;
  var green = rgb.greenPercentage;
  var blue = rgb.bluePercentage;

  var chroma_max = max(max(red, green), blue);
  var chroma_min = min(min(red, green), blue);
  var chroma = chroma_max - chroma_min;

  var hue = 0.0;
  if (chroma > 0.0) {
    if (chroma_max == red) {
      hue = 60.0 * (((green - blue) / chroma) % 6.0);
    } else if (chroma_max == green) {
      hue = 60.0 * ((blue - red) / chroma + 2.0);
    } else if (chroma_max == blue) {
      hue = 60.0 * ((red - green) / chroma + 4.0);
    }
  }

  var output = {'hue': hue};
  var saturation = 0.0;

  switch (type) {
    case _HueType.HSV:
      var value = chroma_max;
      saturation = chroma_max == 0.0 ? 0.0 : chroma / chroma_max;
      output.addAll({'value': value});
      break;
    case _HueType.HSL:
      var lightness = (chroma_max + chroma_min) / 2.0;
      saturation = chroma == 0.0 ? 0.0 : chroma / (1.0 - (2.0 * lightness - 1.0).abs());
      output.addAll({'lightness': lightness});
      break;
    case _HueType.HSI:
      var intensity = (red + green + blue) / 3.0;
      saturation = intensity == 0.0 ? 0.0 : 1 - (chroma_min / intensity);
      output.addAll({'intensity': intensity});
      break;
  }

  output.addAll({'saturation': saturation});

  return output;
}

// for HSV and HSL
RGB _toRGB(double hue, double saturation, double thirdComponent, _HueType type) {
  double c = 0.0;

  switch (type) {
    case _HueType.HSV:
      c = thirdComponent * saturation;
      break;
    case _HueType.HSL:
      c = (1.0 - (2.0 * thirdComponent - 1.0).abs()) * saturation;
      break;
    default:
      break;
  }

  double x = c * (1.0 - ((hue / 60.0) % 2.0 - 1.0).abs());

  double red = 0;
  double green = 0;
  double blue = 0;

  if (hue < 60.0) {
    red = c;
    green = x;
    blue = 0.0;
  } else if (hue < 120.0) {
    red = x;
    green = c;
    blue = 0.0;
  } else if (hue < 180.0) {
    red = 0.0;
    green = c;
    blue = x;
  } else if (hue < 240.0) {
    red = 0.0;
    green = x;
    blue = c;
  } else if (hue < 300.0) {
    red = x;
    green = 0.0;
    blue = c;
  } else if (hue <= 360.0) {
    red = c;
    green = 0.0;
    blue = x;
  }

  double m = 0.0;
  switch (type) {
    case _HueType.HSV:
      m = thirdComponent - c;
      break;
    case _HueType.HSL:
      m = thirdComponent - c / 2.0;
      break;
    default:
      break;
  }

  red = (red + m) * 255.0;
  green = (green + m) * 255.0;
  blue = (blue + m) * 255.0;

  return RGB(red, green, blue);
}

class HSV extends GCWBaseColor {
  late double hue;
  late double saturation;
  late double value;

  HSV(double hue, double saturation, double value) {
    this.hue = min(360.0, max(0.0, hue));
    this.saturation = min(1.0, max(0.0, saturation));
    this.value = min(1.0, max(0.0, value));
  }

  double get saturationPercentage {
    return saturation * 100.0;
  }

  double get valuePercentage {
    return value * 100.0;
  }

  @override
  RGB toRGB() {
    return _toRGB(hue, saturation, value, _HueType.HSV);
  }

  static HSV fromRGB(RGB rgb) {
    var values = _fromRGB(rgb, _HueType.HSV);
    return HSV(values['hue']!, values['saturation']!, values['value']!);
  }

  @override
  toString() {
    return 'HSV($hue, $saturation, $value)';
  }
}

class HSL extends GCWBaseColor {
  late double hue;
  late double saturation;
  late double lightness;

  HSL(double hue, double saturation, double lightness) {
    this.hue = min(360.0, max(0.0, hue));
    this.saturation = min(1.0, max(0.0, saturation));
    this.lightness = min(1.0, max(0.0, lightness));
  }

  @override
  RGB toRGB() {
    return _toRGB(hue, saturation, lightness, _HueType.HSL);
  }

  static HSL fromRGB(RGB rgb) {
    var values = _fromRGB(rgb, _HueType.HSL);
    return HSL(values['hue']!, values['saturation']!, values['lightness']!);
  }

  @override
  toString() {
    return 'HSL($hue, $saturation, $lightness)';
  }
}

class HSI extends GCWBaseColor {
  late double hue;
  late double saturation;
  late double intensity;

  HSI(double hue, double saturation, double intensity) {
    this.hue = min(360.0, max(0.0, hue));
    this.saturation = min(1.0, max(0.0, saturation));
    this.intensity = min(1.0, max(0.0, intensity));
  }

  //TODO: Although every source I found has the same formulas, the precision lacks a little bit; finding a better approach!
  //source: https://www.vocal.com/video/rgb-and-hsvhsihsl-color-space-conversion/
  @override
  RGB toRGB() {
    var red = 0.0;
    var green = 0.0;
    var blue = 0.0;

    if (hue < 120.0) {
      blue = intensity * (1.0 - saturation);
      red = intensity * (1 + (saturation * cos(degreesToRadian(hue)) / cos(degreesToRadian(60.0 - hue))));
      green = 3.0 * intensity - blue - red;
    } else if (hue < 240.0) {
      red = intensity * (1.0 - saturation);
      green = intensity * (1 + (saturation * cos(degreesToRadian(hue - 120.0)) / cos(degreesToRadian(180.0 - hue))));
      blue = 3.0 * intensity - red - green;
    } else if (hue <= 360.0) {
      green = intensity * (1.0 - saturation);
      blue = intensity * (1 + (saturation * cos(degreesToRadian(hue - 240.0)) / cos(degreesToRadian(300.0 - hue))));
      red = 3.0 * intensity - green - blue;
    }

    return RGB(red * 255.0, green * 255.0, blue * 255.0);
  }

  static HSI fromRGB(RGB rgb) {
    var values = _fromRGB(rgb, _HueType.HSI);
    return HSI(values['hue']!, values['saturation']!, values['intensity']!);
  }

  @override
  toString() {
    return 'HSI($hue, $saturation, $intensity)';
  }
}
