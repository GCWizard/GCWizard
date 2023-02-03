import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Mass extends Unit {
  Function toGram;
  Function fromGram;

  Mass({
    String name,
    String symbol,
    bool isReference: false,
    double inGram: 1.0,
  }) : super(name, symbol, isReference, (e) => e * inGram, (e) => e / inGram) {
    toGram = this.toReference;
    fromGram = this.fromReference;
  }
}

final MASS_GRAM = Mass(name: 'common_unit_mass_g_name', symbol: 'g', isReference: true);

final MASS_TON = Mass(name: 'common_unit_mass_t_name', symbol: 't', inGram: 1000.0 * 1000.0);

final MASS_TROYOUNCE = Mass(name: 'common_unit_mass_ozt_name', symbol: 'oz.tr', inGram: 31.1034768);

final MASS_GRAIN = Mass(name: 'common_unit_mass_gr_name', symbol: 'gr', inGram: 453.59237 / 7000.0);

final MASS_DRAM = Mass(name: 'common_unit_mass_dr_name', symbol: 'dr', inGram: 453.59237 / 256.0);

final MASS_OUNCE = Mass(name: 'common_unit_mass_oz_name', symbol: 'oz', inGram: 453.59237 / 16.0);

final MASS_POUND = Mass(name: 'common_unit_mass_lb_name', symbol: 'lb', inGram: 453.59237);

final MASS_IMPERIALQUARTER = Mass(name: 'common_unit_mass_impqr_name', symbol: 'qr', inGram: 453.59237 * 28.0);

final MASS_IMPERIALHUNDREDWEIGHT = Mass(name: 'common_unit_mass_impcwt_name', symbol: 'cwt', inGram: 453.59237 * 112.0);

final MASS_IMPERIALLONGTON = Mass(name: 'common_unit_mass_impt_name', symbol: 't', inGram: 453.59237 * 2240.0);

final MASS_USQUARTER = Mass(name: 'common_unit_mass_usqr_name', symbol: 'qr', inGram: 453.59237 * 25.0);

final MASS_USHUNDREDWEIGHT = Mass(name: 'common_unit_mass_uscwt_name', symbol: 'cwt', inGram: 453.59237 * 100.0);

final MASS_USSHORTTON = Mass(name: 'common_unit_mass_uston_name', symbol: 't', inGram: 453.59237 * 2000.0);

final MASS_PFUND = Mass(name: 'common_unit_mass_pfd_name', symbol: 'Pfd', inGram: 500.0);

final MASS_CARAT = Mass(name: 'common_unit_mass_ct_name', symbol: 'ct', inGram: 0.2);

final MASS_ZENTNER = Mass(name: 'common_unit_mass_ztr_name', symbol: 'Ztr', inGram: 50.0 * 1000.0);

final MASS_STONE = Mass(name: 'common_unit_mass_st_name', symbol: 'st', inGram: 6350.29317888);

final MASS_ELEPHANT = Mass(name: 'common_unit_mass_elephant_name', symbol: 'el', inGram: 5000000.0);

// https://webmadness.net/blog/?post=knuth
final MASS_BLINTZ = Mass(name: 'common_unit_mass_blintz_name', symbol: 'b', inGram: 36.42538631);

final MASS_FARBLINTZ = Mass(name: 'common_unit_mass_farb_name', symbol: 'fb', inGram: 0.000001 * 36.42538631);

final MASS_FURBLINTZ = Mass(name: 'common_unit_mass_furb_name', symbol: 'Fb', inGram: 1000 * 1000 * 36.42538631);

final List<Unit> baseMasses = [
  MASS_GRAM,
  MASS_TON,
  MASS_GRAIN,
  MASS_DRAM,
  MASS_OUNCE,
  MASS_POUND,
  MASS_IMPERIALQUARTER,
  MASS_IMPERIALHUNDREDWEIGHT,
  MASS_IMPERIALLONGTON,
  MASS_USQUARTER,
  MASS_USHUNDREDWEIGHT,
  MASS_USSHORTTON,
  MASS_TROYOUNCE,
  MASS_CARAT,
  MASS_PFUND,
  MASS_ZENTNER,
  MASS_STONE,
  MASS_ELEPHANT,
  MASS_BLINTZ,
  MASS_FARBLINTZ,
  MASS_FURBLINTZ
];

final MASS_KILOGRAM = Mass(name: 'common_unit_mass_kg_name', symbol: 'kg', inGram: 1000.0);

List<Unit> allMasses() {
  var masses = List<Unit>.from(baseMasses);
  var indexKG = baseMasses.indexOf(MASS_GRAM);
  masses.insert(indexKG + 1, MASS_KILOGRAM);

  return masses;
}
