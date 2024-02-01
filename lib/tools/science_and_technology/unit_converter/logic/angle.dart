import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Angle extends Unit {
  late double Function(double) toDegree;
  late double Function(double) fromDegree;

  Angle({required String name, required String symbol, bool isReference = false, required double inDegree})
      : super(name, symbol, isReference, (e) => e * inDegree, (e) => e / inDegree) {
    toDegree = toReference;
    fromDegree = fromReference;
  }
}

final ANGLE_DEGREE = Angle(
  name: 'common_unit_angle_deg_name',
  symbol: '°',
  inDegree: 1.0,
  isReference: true,
);

final ANGLE_RADIAN = Angle(name: 'common_unit_angle_rad_name', symbol: 'rad', inDegree: 180.0 / pi);

final _ANGLE_GON = Angle(name: 'common_unit_angle_gon_name', symbol: 'gon', inDegree: 360.0 / 400.0);

final _ANGLE_MIL = Angle(name: 'common_unit_angle_mil_name', symbol: '\u00AF', inDegree: 360.0 / 6400.0);

final _ANGLE_NAUTICALLINE = Angle(name: 'common_unit_angle_nauticalline_name', symbol: '"', inDegree: 360.0 / 32.0);

// https://webmadness.net/blog/?post=knuth
final _ANGLE_ZYGO = Angle(name: 'common_unit_angle_zygo_name', symbol: '§', inDegree: 3.6);

final _ANGLE_ZORCH = Angle(name: 'common_unit_angle_zorch_name', symbol: "'''", inDegree: 0.036);

final _ANGLE_QUIRCITS = Angle(name: 'common_unit_angle_quircits_name', symbol: '""', inDegree: 0.0036);

final List<Angle> angles = [
  ANGLE_DEGREE,
  ANGLE_RADIAN,
  _ANGLE_GON,
  _ANGLE_NAUTICALLINE,
  _ANGLE_MIL,
  _ANGLE_ZYGO,
  _ANGLE_ZORCH,
  _ANGLE_QUIRCITS,
];
