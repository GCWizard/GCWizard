import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Length extends Unit {
  late double Function(double) toMeter;
  late double Function(double) fromMeter;

  Length({
    required String name,
    required String symbol,
    bool isReference = false,
    required double inMeters,
  }) : super(name, symbol, isReference, (e) => e * inMeters, (e) => e / inMeters) {
    toMeter = toReference;
    fromMeter = fromReference;
  }
}

final LENGTH_METER = Length(name: 'common_unit_length_m_name', symbol: 'm', inMeters: 1.0, isReference: true);

final _LENGTH_STATUTEMILE = Length(name: 'common_unit_length_mi_name', symbol: 'mi', inMeters: 1609.344);

final _LENGTH_NAUTICALMILE = Length(name: 'common_unit_length_nm_name', symbol: 'nm', inMeters: 1852.0);

final _LENGTH_INCH = Length(name: 'common_unit_length_in_name', symbol: 'in', inMeters: 0.3048 / 12.0);

final LENGTH_FOOT = Length(name: 'common_unit_length_ft_name', symbol: 'ft', inMeters: 0.3048);

final _LENGTH_YARD = Length(name: 'common_unit_length_yd_name', symbol: 'yd', inMeters: 3 * 0.3048);

final _LENGTH_USSURVEYFOOT =
    Length(name: 'common_unit_length_ussurveyft_name', symbol: 'ft', inMeters: 1200.0 / 3937.0);

final _LENGTH_LIGHTYEAR = Length(name: 'common_unit_length_ly_name', symbol: 'ly', inMeters: 9460730472580800.0);

final _LENGTH_ASTRONOMICALUNIT = Length(name: 'common_unit_length_au_name', symbol: 'AU', inMeters: 149597870700.0);

final _LENGTH_PARSEC = Length(name: 'common_unit_length_pc_name', symbol: 'pc', inMeters: 96939420213600000.0 / pi);

final _LENGTH_LAR = Length(name: 'common_unit_length_lar_name', symbol: 'lar', inMeters: 4827);

final _LENGTH_RANGAR = Length(name: 'common_unit_length_rangar_name', symbol: 'rangar', inMeters: 4827 / 5000);

final _LENGTH_CABLELENGTH_IMP =
    Length(name: 'common_unit_length_cablelength_imp_name', symbol: 'kbl', inMeters: 182.88);

final _LENGTH_CABLELENGTH_US = Length(name: 'common_unit_length_cablelength_us_name', symbol: 'kbl', inMeters: 219.456);

final _LENGTH_CABLELENGTH_GB =
    Length(name: 'common_unit_length_cablelength_gb_name', symbol: 'kbl', inMeters: 185.3184);

final _LENGTH_FATHOM = Length(name: 'common_unit_length_fathom_name', symbol: 'fm', inMeters: 1.8288);

final _LENGTH_KLAFTER = Length(name: 'common_unit_length_klafter_name', symbol: 'klafter', inMeters: 1.8288);

final _LENGTH_FURLONG = Length(name: 'common_unit_length_furlong_name', symbol: 'fur', inMeters: 201.168);

final _LENGTH_CHAIN = Length(name: 'common_unit_length_chain_name', symbol: 'ch', inMeters: 20.1168);

final _LENGTH_ROD = Length(name: 'common_unit_length_rod_name', symbol: 'rd', inMeters: 5.0292);

final _LENGTH_LINK = Length(name: 'common_unit_length_link_name', symbol: 'li', inMeters: 0.201168);

// https://webmadness.net/blog/?post=knuth: 1 potrzebie = 2.263348517438173216473 mm
final _LENGTH_POTRZEBIE =
    Length(name: 'common_unit_length_potrzebie_name', symbol: 'p', inMeters: 0.002263348517438173216473);

final _LENGTH_FARP = Length(
    name: 'common_unit_length_farshimmelt_name',
    symbol: 'fp',
    inMeters: 0.002263348517438173216473 * 0.000001); // 0.000001 p = 1 farshimmelt potrzebie

final _LENGTH_FURP = Length(
    name: 'common_unit_length_furshlugginer_name',
    symbol: 'Fp',
    inMeters: 0.002263348517438173216473 * 1000 * 1000); // 1000 Kp = 1 furshlugginer potrzebie

// https://en.wikipedia.org/wiki/Smoot
final _LENGTH_SMOOT = Length(
    name: 'common_unit_length_smoot_name', symbol: 'smoot', inMeters: 5 * 0.3048 + 7 * 0.3048 / 12.0); // 5 ft 7 in

final List<Length> baseLengths = [
  LENGTH_METER,
  _LENGTH_STATUTEMILE,
  _LENGTH_INCH,
  LENGTH_FOOT,
  _LENGTH_YARD,
  _LENGTH_FATHOM,
  _LENGTH_FURLONG,
  _LENGTH_CHAIN,
  _LENGTH_ROD,
  _LENGTH_LINK,
  _LENGTH_CABLELENGTH_IMP,
  _LENGTH_CABLELENGTH_US,
  _LENGTH_CABLELENGTH_GB,
  _LENGTH_KLAFTER,
  _LENGTH_USSURVEYFOOT,
  _LENGTH_NAUTICALMILE,
  _LENGTH_LIGHTYEAR,
  _LENGTH_ASTRONOMICALUNIT,
  _LENGTH_PARSEC,
  _LENGTH_LAR,
  _LENGTH_RANGAR,
  _LENGTH_POTRZEBIE,
  _LENGTH_FARP,
  _LENGTH_FURP,
  _LENGTH_SMOOT
];

final LENGTH_KM = Length(name: 'common_unit_length_km_name', symbol: 'km', inMeters: 1000.0);
final LENGTH_CM = Length(name: 'common_unit_length_cm_name', symbol: 'cm', inMeters: 0.01);

List<Length> allLengths() {
  var lengths = List<Length>.from(baseLengths);
  var indexM = baseLengths.indexOf(LENGTH_METER);
  lengths.insert(indexM + 1, LENGTH_KM);
  lengths.insert(indexM + 2, LENGTH_CM);

  return lengths;
}
