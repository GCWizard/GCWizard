import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

class CMYK {
  double cyan;
  double magenta;
  double yellow;
  double key; // black component

  CMYK(double cyan, double magenta, double yellow, double key) {
    this.cyan = min(1.0, max(0.0, cyan));
    this.magenta = min(1.0, max(0.0, magenta));
    this.yellow = min(1.0, max(0.0, yellow));
    this.key = min(1.0, max(0.0, key));
  }

  //source: https://github.com/GNOME/gimp/blob/mainline/libgimpcolor/gimpcolorspace.c
  RGB toRGB() {
    double c = 1.0;
    double m = 1.0;
    double y = 1.0;

    if (key < 1.0) {
      c = cyan * (1.0 - key) + key;
      m = magenta * (1.0 - key) + key;
      y = yellow * (1.0 - key) + key;
    }

    return RGB((1.0 - c) * 255.0, (1.0 - m) * 255.0, (1.0 - y) * 255.0);
  }

  //source: https://github.com/GNOME/gimp/blob/mainline/libgimpcolor/gimpcolorspace.c
  static CMYK fromRGB(RGB rgb, {double key: 1.0}) {
    double c = 1.0 - rgb.redPercentage;
    double m = 1.0 - rgb.greenPercentage;
    double y = 1.0 - rgb.bluePercentage;

    double k = 1.0;

    if (c < k) k = c;
    if (m < k) k = m;
    if (y < k) k = y;

    k *= key;

    double cyan = 0.0;
    double magenta = 0.0;
    double yellow = 0.0;
    if (k < 1.0) {
      cyan = (c - k) / (1.0 - k);
      magenta = (m - k) / (1.0 - k);
      yellow = (y - k) / (1.0 - k);
    }

    return CMYK(cyan, magenta, yellow, k);
  }

  String toCMYKString() {
    return '${(cyan * 100).round()}, ${(magenta * 100).round()}, ${(yellow * 100).round()}, ${(key * 100).round()}';
  }

  @override
  toString() {
    return 'CMYK($cyan, $magenta, $yellow, $key)';
  }
}

class CMY {
  double cyan;
  double magenta;
  double yellow;

  CMY(double cyan, double magenta, double yellow) {
    this.cyan = min(1.0, max(0.0, cyan));
    this.magenta = min(1.0, max(0.0, magenta));
    this.yellow = min(1.0, max(0.0, yellow));
  }

  RGB toRGB() {
    double red = (1.0 - cyan) * 255.0;
    double green = (1.0 - magenta) * 255.0;
    double blue = (1.0 - yellow) * 255.0;

    return RGB(red, green, blue);
  }

  static CMY fromRGB(RGB rgb) {
    double cyan = 1.0 - rgb.redPercentage;
    double magenta = 1.0 - rgb.greenPercentage;
    double yellow = 1.0 - rgb.bluePercentage;

    return CMY(cyan, magenta, yellow);
  }

  @override
  toString() {
    return 'CMY($cyan, $magenta, $yellow)';
  }
}
