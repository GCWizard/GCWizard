import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Mass extends Unit {
  late double Function(double) toGram;
  late double Function(double) fromGram;

  Mass({
    required String name,
    required String symbol,
    bool isReference = false,
    required double inGram,
  }) : super(name, symbol, isReference, (e) => e * inGram, (e) => e / inGram) {
    toGram = toReference;
    fromGram = fromReference;
  }
}

final MASS_GRAM = Mass(name: 'common_unit_mass_g_name', symbol: 'g', inGram: 1.0, isReference: true);

final _MASS_TON = Mass(name: 'common_unit_mass_t_name', symbol: 't', inGram: 1000.0 * 1000.0);

final _MASS_TROYOUNCE = Mass(name: 'common_unit_mass_ozt_name', symbol: 'oz.tr', inGram: 31.1034768);

final _MASS_GRAIN = Mass(name: 'common_unit_mass_gr_name', symbol: 'gr', inGram: 453.59237 / 7000.0);

final _MASS_DRAM = Mass(name: 'common_unit_mass_dr_name', symbol: 'dr', inGram: 453.59237 / 256.0);

final _MASS_OUNCE = Mass(name: 'common_unit_mass_oz_name', symbol: 'oz', inGram: 453.59237 / 16.0);

final MASS_POUND = Mass(name: 'common_unit_mass_lb_name', symbol: 'lb', inGram: 453.59237);

final _MASS_IMPERIALQUARTER = Mass(name: 'common_unit_mass_impqr_name', symbol: 'qr', inGram: 453.59237 * 28.0);

final _MASS_IMPERIALHUNDREDWEIGHT =
    Mass(name: 'common_unit_mass_impcwt_name', symbol: 'cwt', inGram: 453.59237 * 112.0);

final _MASS_IMPERIALLONGTON = Mass(name: 'common_unit_mass_impt_name', symbol: 't', inGram: 453.59237 * 2240.0);

final _MASS_USQUARTER = Mass(name: 'common_unit_mass_usqr_name', symbol: 'qr', inGram: 453.59237 * 25.0);

final _MASS_USHUNDREDWEIGHT = Mass(name: 'common_unit_mass_uscwt_name', symbol: 'cwt', inGram: 453.59237 * 100.0);

final _MASS_USSHORTTON = Mass(name: 'common_unit_mass_uston_name', symbol: 't', inGram: 453.59237 * 2000.0);

final _MASS_PFUND = Mass(name: 'common_unit_mass_pfd_name', symbol: 'Pfd', inGram: 500.0);

final _MASS_CARAT = Mass(name: 'common_unit_mass_ct_name', symbol: 'ct', inGram: 0.2);

final _MASS_ZENTNER = Mass(name: 'common_unit_mass_ztr_name', symbol: 'Ztr', inGram: 50.0 * 1000.0);

final _MASS_STONE = Mass(name: 'common_unit_mass_st_name', symbol: 'st', inGram: 6350.29317888);

final _MASS_ELEPHANT = Mass(name: 'common_unit_mass_elephant_name', symbol: 'el', inGram: 5000000.0);

// https://webmadness.net/blog/?post=knuth
final _MASS_BLINTZ = Mass(name: 'common_unit_mass_blintz_name', symbol: 'b', inGram: 36.42538631);

final _MASS_FARBLINTZ = Mass(name: 'common_unit_mass_farb_name', symbol: 'fb', inGram: 0.000001 * 36.42538631);

final _MASS_FURBLINTZ = Mass(name: 'common_unit_mass_furb_name', symbol: 'Fb', inGram: 1000 * 1000 * 36.42538631);

// https://de.wikipedia.org/wiki/Alte_Ma%C3%9Fe_und_Gewichte_(r%C3%B6mische_Antike)
// https://en.wikipedia.org/wiki/Ancient_Roman_units_of_measurement
double _granum = 0.04704;
final _MASS_ROMAN_GRANUM = Mass(name: 'common_unit_mass_roman_granum_name', symbol: 'granum', inGram: _granum);
final _MASS_ROMAN_CHALCUS = Mass(name: 'common_unit_mass_roman_chalcus_name', symbol: 'chalcus', inGram: _granum * 1.5);
final _MASS_ROMAN_SILIQUA = Mass(name: 'common_unit_mass_roman_siliqua_name', symbol: 'siliqua', inGram: _granum * 4);
final _MASS_ROMAN_OBULUS = Mass(name: 'common_unit_mass_roman_obulus_name', symbol: 'obulus', inGram: _granum * 12);
final _MASS_ROMAN_SCRUPULUM = Mass(name: 'common_unit_mass_roman_scrupulum_name', symbol: 'scrupulum', inGram: _granum * 24);
final _MASS_ROMAN_DRACHMA = Mass(name: 'common_unit_mass_roman_drachma_name', symbol: 'drachma', inGram: _granum * 72);
final _MASS_ROMAN_SICILIUS = Mass(name: 'common_unit_mass_roman_sicilius_name', symbol: 'sicilius', inGram: _granum * 144);
final _MASS_ROMAN_UNCIA = Mass(name: 'common_unit_mass_roman_uncia_name', symbol: 'uncia', inGram: _granum * 576);
final _MASS_ROMAN_LIBRA = Mass(name: 'common_unit_mass_roman_libra_name', symbol: 'libra', inGram: _granum * 6912);
final _MASS_ROMAN_MINA = Mass(name: 'common_unit_mass_roman_mina_name', symbol: 'mina', inGram: _granum * 9216);

final List<Mass> baseMasses = [
  MASS_GRAM,
  _MASS_TON,
  _MASS_GRAIN,
  _MASS_DRAM,
  _MASS_OUNCE,
  MASS_POUND,
  _MASS_IMPERIALQUARTER,
  _MASS_IMPERIALHUNDREDWEIGHT,
  _MASS_IMPERIALLONGTON,
  _MASS_USQUARTER,
  _MASS_USHUNDREDWEIGHT,
  _MASS_USSHORTTON,
  _MASS_TROYOUNCE,
  _MASS_CARAT,
  _MASS_PFUND,
  _MASS_ZENTNER,
  _MASS_STONE,
  _MASS_ELEPHANT,
  _MASS_BLINTZ,
  _MASS_FARBLINTZ,
  _MASS_FURBLINTZ,
  _MASS_ROMAN_GRANUM,
  _MASS_ROMAN_CHALCUS,
  _MASS_ROMAN_SILIQUA,
  _MASS_ROMAN_OBULUS,
  _MASS_ROMAN_SCRUPULUM,
  _MASS_ROMAN_DRACHMA,
  _MASS_ROMAN_SICILIUS,
  _MASS_ROMAN_UNCIA,
  _MASS_ROMAN_LIBRA,
  _MASS_ROMAN_MINA,
];

final MASS_KILOGRAM = Mass(name: 'common_unit_mass_kg_name', symbol: 'kg', inGram: 1000.0);

List<Mass> allMasses() {
  var masses = List<Mass>.from(baseMasses);
  var indexKG = baseMasses.indexOf(MASS_GRAM);
  masses.insert(indexKG + 1, MASS_KILOGRAM);

  return masses;
}
