// final _UNITPREFIX_QUETTA = UnitPrefix('common_unit_prefix_quetta', 'Q', 1.0e30);
// final _UNITPREFIX_RONNA = UnitPrefix('common_unit_prefix_ronna', 'R', 1.0e27);
// final _UNITPREFIX_YOTTA = UnitPrefix('common_unit_prefix_yotta', 'Y', 1.0e24);
// final _UNITPREFIX_ZETTA = UnitPrefix('common_unit_prefix_zetta', 'Z', 1.0e21);
final _UNITPREFIX_EXA = UnitPrefix('common_unit_prefix_exa', 'E', 1.0e18);
final _UNITPREFIX_PETA = UnitPrefix('common_unit_prefix_peta', 'P', 1.0e15);
final _UNITPREFIX_TERA = UnitPrefix('common_unit_prefix_tera', 'T', 1.0e12);
final _UNITPREFIX_GIGA = UnitPrefix('common_unit_prefix_giga', 'G', 1.0e9);
final _UNITPREFIX_MEGA = UnitPrefix('common_unit_prefix_mega', 'M', 1.0e6);
final UNITPREFIX_KILO = UnitPrefix('common_unit_prefix_kilo', 'k', 1.0e3);
final _UNITPREFIX_HECTO = UnitPrefix('common_unit_prefix_hecto', 'h', 1.0e2);
final _UNITPREFIX_DECA = UnitPrefix('common_unit_prefix_deca', 'da', 1.0e1);
final UNITPREFIX_NONE = UnitPrefix('', '', 1.0);
final _UNITPREFIX_DECI = UnitPrefix('common_unit_prefix_deci', 'd', 1.0e-1);
final UNITPREFIX_CENTI = UnitPrefix('common_unit_prefix_centi', 'c', 1.0e-2);
final UNITPREFIX_MILLI = UnitPrefix('common_unit_prefix_milli', 'm', 1.0e-3);
final _UNITPREFIX_MICRO = UnitPrefix('common_unit_prefix_micro', '\u00B5', 1.0e-6);
final _UNITPREFIX_NANO = UnitPrefix('common_unit_prefix_nano', 'n', 1.0e-9);
final _UNITPREFIX_PICO = UnitPrefix('common_unit_prefix_pico', 'p', 1.0e-12);
final _UNITPREFIX_FEMTO = UnitPrefix('common_unit_prefix_femto', 'f', 1.0e-15);
final _UNITPREFIX_ATTO = UnitPrefix('common_unit_prefix_atto', 'a', 1.0e-18);
// final _UNITPREFIX_ZEPTO = UnitPrefix('common_unit_prefix_zepto', 'z', 1.0e-21);
// final _UNITPREFIX_YOCTO = UnitPrefix('common_unit_prefix_yocto', 'y', 1.0e-24);
// final _UNITPREFIX_RONTO = UnitPrefix('common_unit_prefix_ronto', 'r', 1.0e-27);
// final _UNITPREFIX_QUECTO = UnitPrefix('common_unit_prefix_quecto', 'q', 1.0e-30);

final unitPrefixes = [
  // UNITPREFIX_QUETTA,
  // UNITPREFIX_RONNA,
  // UNITPREFIX_YOTTA,
  // UNITPREFIX_ZETTA,
  _UNITPREFIX_EXA,
  _UNITPREFIX_PETA,
  _UNITPREFIX_TERA,
  _UNITPREFIX_GIGA,
  _UNITPREFIX_MEGA,
  UNITPREFIX_KILO,
  _UNITPREFIX_HECTO,
  _UNITPREFIX_DECA,
  UNITPREFIX_NONE,
  _UNITPREFIX_DECI,
  UNITPREFIX_CENTI,
  UNITPREFIX_MILLI,
  _UNITPREFIX_MICRO,
  _UNITPREFIX_NANO,
  _UNITPREFIX_PICO,
  _UNITPREFIX_FEMTO,
  _UNITPREFIX_ATTO,
  // UNITPREFIX_ZEPTO,
  // UNITPREFIX_YOCTO,
  // UNITPREFIX_RONTO,
  // UNITPREFIX_QUECTO,
];

class UnitPrefix {
  String key;
  String symbol;
  double value;

  UnitPrefix(this.key, this.symbol, this.value);
}
