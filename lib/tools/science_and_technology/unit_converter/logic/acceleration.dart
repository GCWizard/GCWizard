import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Acceleration extends Unit {
  late double Function(double) toMetersPerSquareSecond;
  late double Function(double) fromMetersPerSquareSecond;


  Acceleration({
    required String name,
    required String symbol,
    bool isReference = false,
    required double inMetersPerSquareSecond,
  }) : super(name, symbol, isReference, (e) => e * inMetersPerSquareSecond, (e) => e / inMetersPerSquareSecond) {
    toMetersPerSquareSecond = toReference;
    fromMetersPerSquareSecond = fromReference;
  }
}

final ACCELERATION_METERSPERSQUARESECONDS = Acceleration(
    name: 'common_unit_acceleration_ms2_name', symbol: 'm/s\u00B2', inMetersPerSquareSecond: 1.0, isReference: true);
final ACCELERATION_CENTIMETERSPERSQUARESECONDS =
    Acceleration(name: 'common_unit_acceleration_cms2_name', symbol: 'cm/s\u00B2', inMetersPerSquareSecond: 0.01);
final ACCELERATION_FEETPERSQUARESECOND =
    Acceleration(name: 'common_unit_acceleration_fts2_name', symbol: 'ft/s\u00B2', inMetersPerSquareSecond: 0.304800);
final ACCELERATION_STANDARDGRAVITY =
    Acceleration(name: 'common_unit_acceleration_g_name', symbol: 'g', inMetersPerSquareSecond: 9.80665);
final ACCELERATION_GAL =
    Acceleration(name: 'common_unit_acceleration_gal_name', symbol: 'Gal', inMetersPerSquareSecond: 0.01);

final List<Acceleration> accelerations = [
  ACCELERATION_METERSPERSQUARESECONDS,
  ACCELERATION_CENTIMETERSPERSQUARESECONDS,
  ACCELERATION_FEETPERSQUARESECOND,
  ACCELERATION_STANDARDGRAVITY,
  ACCELERATION_GAL
];

