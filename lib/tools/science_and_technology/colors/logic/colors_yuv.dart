import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/utils/math_utils.dart';

//source: https://en.wikipedia.org/wiki/YUV#Conversion_to/from_RGB
class YUV {
  double y; //luminance/luma;
  double u; //chrominance: blue projection
  double v; //chrominance: red projection

  //values for standard ITU-R BT.601; //TODO: standard BT.709
  static final double U_MAX = 0.436;
  static final double V_MAX = 0.615;

  static final double _W_R = 0.299;
  static final double _W_B = 0.114;
  static final double _W_G = 1.0 - _W_B - _W_R;

  YUV(double y, double u, double v) {
    this.y = min(1.0, max(0.0, y));
    this.u = min(U_MAX, max(-U_MAX, u));
    this.v = min(V_MAX, max(-V_MAX, v));
  }

  RGB toRGB() {
    double red = y + v * ((1.0 - _W_R) / V_MAX);
    double green = y - u * (_W_B * (1.0 - _W_B) / (U_MAX * _W_G)) - v * (_W_R * (1.0 - _W_R) / (V_MAX * _W_G));
    double blue = y + u * ((1.0 - _W_B) / U_MAX);

    return RGB(red * 255.0, green * 255.0, blue * 255.0);
  }

  static YUV fromRGB(RGB rgb) {
    double red = rgb.redPercentage;
    double green = rgb.greenPercentage;
    double blue = rgb.bluePercentage;

    double y = _W_R * red + _W_G * green + _W_B * blue;
    double u = U_MAX * ((blue - y) / (1.0 - _W_B));
    double v = V_MAX * ((red - y) / (1.0 - _W_R));

    return YUV(y, u, v);
  }

  @override
  String toString() {
    return 'YUV($y, $u, $v)';
  }
}

//source https://en.wikipedia.org/wiki/YCbCr#ITU-R_BT.601_conversion
class YPbPr {
  double y; //luminance/luma;
  double pb; //chrominance: blue projection
  double pr; //chrominance: red projection

  //values for standard ITU-R BT.601; //TODO: standard BT.709, BT.2020, SMPTE 240M, JPEG
  static final double _K_R = 0.299;
  static final double _K_B = 0.114;
  static final double _K_G = 1.0 - _K_R - _K_B;

  YPbPr(double y, double p_b, double p_r) {
    this.y = min(1.0, max(0.0, y));
    this.pb = min(0.5, max(-0.5, p_b));
    this.pr = min(0.5, max(-0.5, p_r));
  }

  RGB toRGB() {
    double red = y + pr * (2.0 - 2.0 * _K_R);
    double green = y - pb * (_K_B / _K_G * (2.0 - 2.0 * _K_B)) - pr * (_K_R / _K_G * (2.0 - 2.0 * _K_R));
    double blue = y + pb * (2.0 - 2.0 * _K_B);

    return RGB(red * 255.0, green * 255.0, blue * 255.0);
  }

  static YPbPr fromRGB(RGB rgb) {
    double red = rgb.redPercentage;
    double green = rgb.greenPercentage;
    double blue = rgb.bluePercentage;

    double y = _K_R * red + _K_G * green + _K_B * blue;
    double p_b = 0.5 * (blue - y) / (1.0 - _K_B);
    double p_r = 0.5 * (red - y) / (1.0 - _K_R);

    return YPbPr(y, p_b, p_r);
  }

  @override
  String toString() {
    return 'YPbPr($y, $pb, $pr)';
  }
}

//source https://en.wikipedia.org/wiki/YCbCr#ITU-R_BT.601_conversion
class YCbCr {
  double y; //luminance/luma;
  double cb; //chrominance: blue projection
  double cr; //chrominance: red projection

  YCbCr(double y, double p_b, double p_r) {
    this.y = min(235.0, max(16.0, y));
    this.cb = min(240.0, max(16.0, p_b));
    this.cr = min(240.0, max(16.0, p_r));
  }

  YPbPr toYPbPr() {
    double y_pbpr = (y - 16.0) / 219.0;
    double p_b = (cb - 128.0) / 224.0;
    double p_r = (cr - 128.0) / 224.0;

    return YPbPr(y_pbpr, p_b, p_r);
  }

  RGB toRGB() {
    return toYPbPr().toRGB();
  }

  static YCbCr fromYPbPr(YPbPr yPbPr) {
    double y = 16.0 + 219.0 * yPbPr.y;
    double c_b = 128.0 + 224.0 * yPbPr.pb;
    double c_r = 128.0 + 224.0 * yPbPr.pr;

    return YCbCr(y, c_b, c_r);
  }

  static YCbCr fromRGB(RGB rgb) {
    return fromYPbPr(YPbPr.fromRGB(rgb));
  }

  @override
  String toString() {
    return 'YCbCr($y, $cb, $cr)';
  }
}

//source: https://de.wikipedia.org/wiki/YIQ-Farbmodell
class YIQ {
  double y; //luminance/luma;
  double i; //cyan orange balance
  double q; //magenta green balance

  static final double I_MAX = 0.5957;
  static final double Q_MAX = 0.5226;

  YIQ(double y, double i, double q) {
    this.y = min(1.0, max(0.0, y));
    this.i = min(I_MAX, max(-I_MAX, i));
    this.q = min(Q_MAX, max(-Q_MAX, q));
  }

  YUV toYUV() {
    double yuv_y = y;
    double u = -i * sin(degreesToRadian(33.0)) + q * cos(degreesToRadian(33.0));
    double v = i * cos(degreesToRadian(33.0)) + q * sin(degreesToRadian(33.0));

    return YUV(yuv_y, u, v);
  }

  RGB toRGB() {
    return toYUV().toRGB();
  }

  static YIQ fromYUV(YUV yuv) {
    double y = yuv.y;
    double i = -yuv.u * sin(degreesToRadian(33.0)) + yuv.v * cos(degreesToRadian(33.0));
    double q = yuv.u * cos(degreesToRadian(33.0)) + yuv.v * sin(degreesToRadian(33.0));

    return YIQ(y, i, q);
  }

  static YIQ fromRGB(RGB rgb) {
    return fromYUV(YUV.fromRGB(rgb));
  }

  @override
  String toString() {
    return 'YIQ($y, $i, $q)';
  }
}
