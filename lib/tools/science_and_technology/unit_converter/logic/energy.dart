import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Energy extends Unit {
  late double Function(double) toJoule;
  late double Function(double) fromJoule;

  Energy({required String name, required String symbol, bool isReference = false, required double inJoule})
      : super(name, symbol, isReference, (e) => e * inJoule, (e) => e / inJoule) {
    toJoule = toReference;
    fromJoule = fromReference;
  }
}

final ENERGY_JOULE = Energy(
  name: 'common_unit_energy_j_name',
  symbol: 'J',
  inJoule: 1.0,
  isReference: true,
);

final ENERGY_CALORIE = Energy(name: 'common_unit_energy_cal_name', symbol: 'cal', inJoule: 4.1868);

final _ENERGY_BRITISHTHERMALUNIT = Energy(name: 'common_unit_energy_btu_name', symbol: 'BTU', inJoule: 1055.05585262);

final _ENERGY_ERG = Energy(name: 'common_unit_energy_erg_name', symbol: 'erg', inJoule: 1e-7);

final _ENERGY_FTLB = Energy(name: 'common_unit_energy_ftlb_name', symbol: 'ft-lb', inJoule: 1.35581795);

// https://webmadness.net/blog/?post=knuth
final _ENERGY_VREEBLE = Energy(name: 'common_unit_energy_vreeble_name', symbol: 'v', inJoule: 34.33 * 4.1868);

final List<Energy> energies = [
  ENERGY_JOULE,
  ENERGY_CALORIE,
  _ENERGY_BRITISHTHERMALUNIT,
  _ENERGY_ERG,
  _ENERGY_FTLB,
  _ENERGY_VREEBLE,
];
