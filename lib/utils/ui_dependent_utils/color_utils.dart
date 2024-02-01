import 'dart:ui';

import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

String colorToHexString(Color color) {
  return HexCode.fromRGB(RGB(color.red.toDouble(), color.green.toDouble(), color.blue.toDouble())).toString();
}

Color hexStringToColor(String hex) {
  RGB rgb = HexCode(hex).toRGB();
  return Color.fromARGB(255, rgb.red.floor(), rgb.green.floor(), rgb.blue.floor());
}
