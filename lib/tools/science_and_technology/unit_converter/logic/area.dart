import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Area extends Unit {
  late double Function(double) toSquareMeter;
  late double Function(double) fromSquareMeter;

  Area({
    required String name,
    required String symbol,
    bool isReference = false,
    required double inSquareMeters,
  }) : super(name, symbol, isReference, (e) => e * inSquareMeters, (e) => e / inSquareMeters) {
    toSquareMeter = toReference;
    fromSquareMeter = fromReference;
  }
}

final AREA_SQUAREMETER =
    Area(name: 'common_unit_area_m2_name', symbol: 'm\u00B2', inSquareMeters: 1.0, isReference: true);

final AREA_SQUAREKILOMETER =
    Area(name: 'common_unit_area_km2_name', symbol: 'km\u00B2', inSquareMeters: 1000.0 * 1000.0);

final _AREA_SQUAREDEZIMETER = Area(name: 'common_unit_area_dm2_name', symbol: 'dm\u00B2', inSquareMeters: 0.1 * 0.1);

final AREA_SQUARECENTIMETER = Area(name: 'common_unit_area_cm2_name', symbol: 'cm\u00B2', inSquareMeters: 0.01 * 0.01);

final AREA_SQUAREMILLIMETER =
    Area(name: 'common_unit_area_mm2_name', symbol: 'mm\u00B2', inSquareMeters: 0.001 * 0.001);

final _AREA_HECTARE = Area(name: 'common_unit_area_ha_name', symbol: 'ha', inSquareMeters: 10000.0);

final _AREA_DECARE = Area(name: 'common_unit_area_daa_name', symbol: 'daa', inSquareMeters: 1000.0);

final _AREA_ARE = Area(name: 'common_unit_area_a_name', symbol: 'a', inSquareMeters: 100.0);

final _AREA_DECIARE = Area(name: 'common_unit_area_da_name', symbol: 'da', inSquareMeters: 10.0);

final _AREA_CENTIARE = Area(name: 'common_unit_area_ca_name', symbol: 'ca', inSquareMeters: 1.0);

final _AREA_SQUAREFOOT = Area(name: 'common_unit_area_sqft_name', symbol: 'sq ft', inSquareMeters: 0.3048 * 0.3048);

final AREA_SQUAREINCH =
    Area(name: 'common_unit_area_sqin_name', symbol: 'sq in', inSquareMeters: 0.3048 * 0.3048 / 144.0);

final _AREA_SQUAREYARD = Area(name: 'common_unit_area_sqyd_name', symbol: 'sq yd', inSquareMeters: 0.3048 * 0.3048 * 9);

final _AREA_SQUAREMILE = Area(name: 'common_unit_area_sqmi_name', symbol: 'sq mi', inSquareMeters: 1609.344 * 1609.344);

final _AREA_ACRE = Area(name: 'common_unit_area_ac_name', symbol: 'ac', inSquareMeters: 43560.0 * 0.3048 * 0.3048);

final _AREA_SECTION = Area(name: 'common_unit_area_section_name', symbol: '', inSquareMeters: 1609.344 * 1609.344);

final _AREA_SOCCERFIELD = Area(name: 'common_unit_area_sofi_name', symbol: '', inSquareMeters: 68.0 * 105.0);

// https://de.wikipedia.org/wiki/Alte_Ma%C3%9Fe_und_Gewichte_(r%C3%B6mische_Antike)
// https://en.wikipedia.org/wiki/Ancient_Roman_units_of_measurement
double _area_actusquadratus = 0.296 * 0.296 * 14400;
final _AREA_ROMAN_PESQUADRATUS = Area(name: 'common_unit_area_roman_pesquadratus_name', symbol: 'pes quadratus', inSquareMeters: _area_actusquadratus / 14400);
final _AREA_ROMAN_SCRIPULUM = Area(name: 'common_unit_area_roman_scripulum_name', symbol: 'scripulum', inSquareMeters: _area_actusquadratus / 144);
final _AREA_ROMAN_ACNUA = Area(name: 'common_unit_area_roman_acnua_name', symbol: 'acnua', inSquareMeters: _area_actusquadratus / 120);
final _AREA_ROMAN_ACTUSMINIMUS = Area(name: 'common_unit_area_roman_actusminimus_name', symbol: 'actus minimus', inSquareMeters: _area_actusquadratus / 30);
final _AREA_ROMAN_CLIMA = Area(name: 'common_unit_area_roman_clima_name', symbol: 'clima', inSquareMeters: _area_actusquadratus / 4);
final _AREA_ROMAN_ACTUSQUADRATUS = Area(name: 'common_unit_area_roman_actusquadratus_name', symbol: 'actus quadratus', inSquareMeters: _area_actusquadratus);
final _AREA_ROMAN_IUGERUM = Area(name: 'common_unit_area_roman_iugerum_name', symbol: 'iugerum', inSquareMeters: _area_actusquadratus * 2);
final _AREA_ROMAN_HEREDIUM = Area(name: 'common_unit_area_roman_heredium_name', symbol: 'heredium', inSquareMeters: _area_actusquadratus * 4);
final _AREA_ROMAN_CENTURIA = Area(name: 'common_unit_area_roman_centuria_name', symbol: 'centuria', inSquareMeters: _area_actusquadratus * 400);
final _AREA_ROMAN_SALTUS = Area(name: 'common_unit_area_roman_saltus_name', symbol: 'saltus', inSquareMeters: _area_actusquadratus * 1600);

final List<Area> areas = [
  AREA_SQUAREMILLIMETER,
  AREA_SQUARECENTIMETER,
  _AREA_SQUAREDEZIMETER,
  AREA_SQUAREMETER,
  AREA_SQUAREKILOMETER,
  AREA_SQUAREINCH,
  _AREA_SQUAREFOOT,
  _AREA_SQUAREYARD,
  _AREA_SQUAREMILE,
  _AREA_HECTARE,
  _AREA_DECARE,
  _AREA_ARE,
  _AREA_DECIARE,
  _AREA_CENTIARE,
  _AREA_ACRE,
  _AREA_SECTION,
  _AREA_SOCCERFIELD,
  _AREA_ROMAN_PESQUADRATUS,
  _AREA_ROMAN_SCRIPULUM,
  _AREA_ROMAN_ACNUA,
  _AREA_ROMAN_ACTUSMINIMUS,
  _AREA_ROMAN_CLIMA,
  _AREA_ROMAN_ACTUSQUADRATUS,
  _AREA_ROMAN_IUGERUM,
  _AREA_ROMAN_HEREDIUM,
  _AREA_ROMAN_CENTURIA,
  _AREA_ROMAN_SALTUS,
];
