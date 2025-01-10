import 'dart:ui';

import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

String colorToHexString(Color color) {
  return HexCode.fromRGB(RGB(color.r, color.g, color.b)).toString();
}

Color hexStringToColor(String hex) {
  RGB rgb = HexCode(hex).toRGB();
  return Color.fromARGB(255, rgb.r.floor(), rgb.g.floor(), rgb.b.floor());
}

int colorValue (Color color) {
  return _floatToInt8(color.a) << 24 |
  _floatToInt8(color.r) << 16 |
  _floatToInt8(color.g) << 8 |
  _floatToInt8(color.b) << 0;
}

int _floatToInt8(double x) {
  return (x * 255.0).round() & 0xff;
}