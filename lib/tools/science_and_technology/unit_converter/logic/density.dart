import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Density extends Unit {
  late double Function (double) toGramPerCubicMeter;
  late double Function (double) fromGramPerCubicMeter;

  Density({
    required String name,
    required String symbol,
    bool isReference = false,
    double inGramPerCubicMeter = 1.0,
  }) : super(name, symbol, isReference, (e) => e * inGramPerCubicMeter, (e) => e / inGramPerCubicMeter) {
    toGramPerCubicMeter = toReference;
    fromGramPerCubicMeter = fromReference;
  }
}

final DENSITY_GRAMPERCUBICMETER = Density(name: 'common_unit_density_gm3_name', symbol: 'g/m\u00B3', isReference: true);

final DENSITY_KILOGRAMPERCUBICMETER =
    Density(name: 'common_unit_density_kgm3_name', symbol: 'kg/m\u00B3', inGramPerCubicMeter: 1000.0);

final DENSITY_GRAMPERCUBICCENTIMETER =
    Density(name: 'common_unit_density_gcm3_name', symbol: 'g/cm\u00B3', inGramPerCubicMeter: 1000.0 * 1000.0);

final DENSITY_GRAMPERMILLILITER =
    Density(name: 'common_unit_density_gml_name', symbol: 'g/ml', inGramPerCubicMeter: 1000.0 * 1000.0);

final DENSITY_MILLIGRAMPERLITER =
    Density(name: 'common_unit_density_mgl_name', symbol: 'mg/l', inGramPerCubicMeter: 1.0);

final DENSITY_GRAMPERLITER = Density(name: 'common_unit_density_gl_name', symbol: 'g/l', inGramPerCubicMeter: 1000.0);

final DENSITY_KILOGRAMPERLITER =
    Density(name: 'common_unit_density_kgl_name', symbol: 'kg/l', inGramPerCubicMeter: 1000.0 * 1000.0);

final DENSITY_POUNDPERCUBICFOOT = Density(
    name: 'common_unit_density_lbcuft_name',
    symbol: 'lb/cu ft',
    inGramPerCubicMeter: 453.59237 / (0.3048 * 0.3048 * 0.3048));

final DENSITY_POUNDPERCUBICYARD = Density(
    name: 'common_unit_density_lbcuyd_name',
    symbol: 'lb/cu yd',
    inGramPerCubicMeter: 453.59237 / (0.3048 * 0.3048 * 0.3048 * 27.0));

final DENSITY_POUNDPERUSLIQUIDGALLON = Density(
    name: 'common_unit_density_lbusliqgal_name',
    symbol: 'lb/US.liq.gal',
    inGramPerCubicMeter: 453.59237 / (0.001 * 3.785411784));

final DENSITY_OUNCEPERUSLIQUIDGALLON = Density(
    name: 'common_unit_density_ozusliqgal_name',
    symbol: 'lb/US.liq.gal',
    inGramPerCubicMeter: 453.59237 / 16.0 / (0.001 * 3.785411784));

final DENSITY_POUNDPERUSBUSHEL = Density(
    name: 'common_unit_density_lbusbu_name',
    symbol: 'lb/US.bu',
    inGramPerCubicMeter: 453.59237 / (0.001 * 4.40488377086 * 8));

final List<Density> densities = [
  DENSITY_KILOGRAMPERCUBICMETER,
  DENSITY_GRAMPERCUBICCENTIMETER,
  DENSITY_GRAMPERCUBICMETER,
  DENSITY_GRAMPERMILLILITER,
  DENSITY_MILLIGRAMPERLITER,
  DENSITY_GRAMPERLITER,
  DENSITY_KILOGRAMPERLITER,
  DENSITY_POUNDPERCUBICFOOT,
  DENSITY_POUNDPERCUBICYARD,
  DENSITY_POUNDPERUSLIQUIDGALLON,
  DENSITY_OUNCEPERUSLIQUIDGALLON,
  DENSITY_POUNDPERUSBUSHEL
];
