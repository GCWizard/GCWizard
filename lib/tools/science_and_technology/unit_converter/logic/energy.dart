import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Energy extends Unit {
  Function toJoule;
  Function fromJoule;

  Energy({String name, String symbol, bool isReference: false, double inJoule})
      : super(name, symbol, isReference, (e) => e * inJoule, (e) => e / inJoule) {
    toJoule = this.toReference;
    fromJoule = this.fromReference;
  }
}

final ENERGY_JOULE = Energy(
  name: 'common_unit_energy_j_name',
  symbol: 'J',
  isReference: true,
);

final ENERGY_CALORIE = Energy(name: 'common_unit_energy_cal_name', symbol: 'cal', inJoule: 4.1868);

final ENERGY_BRITISHTHERMALUNIT = Energy(name: 'common_unit_energy_btu_name', symbol: 'BTU', inJoule: 1055.05585262);

final ENERGY_ERG = Energy(name: 'common_unit_energy_erg_name', symbol: 'erg', inJoule: 1e-7);

final ENERGY_FTLB = Energy(name: 'common_unit_energy_ftlb_name', symbol: 'ft-lb', inJoule: 1.35581795);

// https://webmadness.net/blog/?post=knuth
final ENERGY_VREEBLE = Energy(name: 'common_unit_energy_vreeble_name', symbol: 'v', inJoule: 34.33 * 4.1868);

final List<Unit> energies = [
  ENERGY_JOULE,
  ENERGY_CALORIE,
  ENERGY_BRITISHTHERMALUNIT,
  ENERGY_ERG,
  ENERGY_FTLB,
  ENERGY_VREEBLE,
];
