import 'dart:ui';

import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

String colorToHexString(Color color) {
  return HexCode.fromRGB(RGB(color.red as double, color.green as double, color.blue as double)).toString();
}

Color hexStringToColor(String hex) {
  RGB rgb = HexCode(hex).toRGB();
  return Color.fromARGB(255, rgb.red.floor(), rgb.green.floor(), rgb.blue.floor());
}

int colorValue (Color color) {
  return _floatToInt8(color.alpha as double) << 24 |
  _floatToInt8(color.red as double) << 16 |
  _floatToInt8(color.green as double) << 8 |
  _floatToInt8(color.blue as double) << 0;
}

int _floatToInt8(double x) {
  return (x * 255.0).round() & 0xff;
}