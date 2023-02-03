import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Area extends Unit {
  Function toSquareMeter;
  Function fromSquareMeter;

  Area({
    String name,
    String symbol,
    bool isReference: false,
    double inSquareMeters: 1.0,
  }) : super(name, symbol, isReference, (e) => e * inSquareMeters, (e) => e / inSquareMeters) {
    toSquareMeter = this.toReference;
    fromSquareMeter = this.fromReference;
  }
}

final AREA_SQUAREMETER = Area(name: 'common_unit_area_m2_name', symbol: 'm\u00B2', isReference: true);

final AREA_SQUAREKILOMETER =
    Area(name: 'common_unit_area_km2_name', symbol: 'km\u00B2', inSquareMeters: 1000.0 * 1000.0);

final AREA_SQUAREDEZIMETER = Area(name: 'common_unit_area_dm2_name', symbol: 'dm\u00B2', inSquareMeters: 0.1 * 0.1);

final AREA_SQUARECENTIMETER = Area(name: 'common_unit_area_cm2_name', symbol: 'cm\u00B2', inSquareMeters: 0.01 * 0.01);

final AREA_SQUAREMILLIMETER =
    Area(name: 'common_unit_area_mm2_name', symbol: 'mm\u00B2', inSquareMeters: 0.001 * 0.001);

final AREA_HECTARE = Area(name: 'common_unit_area_ha_name', symbol: 'ha', inSquareMeters: 10000.0);

final AREA_DECARE = Area(name: 'common_unit_area_daa_name', symbol: 'daa', inSquareMeters: 1000.0);

final AREA_ARE = Area(name: 'common_unit_area_a_name', symbol: 'a', inSquareMeters: 100.0);

final AREA_DECIARE = Area(name: 'common_unit_area_da_name', symbol: 'da', inSquareMeters: 10.0);

final AREA_CENTIARE = Area(name: 'common_unit_area_ca_name', symbol: 'ca', inSquareMeters: 1.0);

final AREA_SQUAREFOOT = Area(name: 'common_unit_area_sqft_name', symbol: 'sq ft', inSquareMeters: 0.3048 * 0.3048);

final AREA_SQUAREINCH =
    Area(name: 'common_unit_area_sqin_name', symbol: 'sq in', inSquareMeters: 0.3048 * 0.3048 / 144.0);

final AREA_SQUAREYARD = Area(name: 'common_unit_area_sqyd_name', symbol: 'sq yd', inSquareMeters: 0.3048 * 0.3048 * 9);

final AREA_SQUAREMILE = Area(name: 'common_unit_area_sqmi_name', symbol: 'sq mi', inSquareMeters: 1609.344 * 1609.344);

final AREA_ACRE = Area(name: 'common_unit_area_ac_name', symbol: 'ac', inSquareMeters: 43560.0 * 0.3048 * 0.3048);

final AREA_SECTION = Area(name: 'common_unit_area_section_name', symbol: null, inSquareMeters: 1609.344 * 1609.344);

final AREA_SOCCERFIELD = Area(name: 'common_unit_area_sofi_name', symbol: null, inSquareMeters: 68.0 * 105.0);

final List<Unit> areas = [
  AREA_SQUAREMILLIMETER,
  AREA_SQUARECENTIMETER,
  AREA_SQUAREDEZIMETER,
  AREA_SQUAREMETER,
  AREA_SQUAREKILOMETER,
  AREA_SQUAREINCH,
  AREA_SQUAREFOOT,
  AREA_SQUAREYARD,
  AREA_SQUAREMILE,
  AREA_HECTARE,
  AREA_DECARE,
  AREA_ARE,
  AREA_DECIARE,
  AREA_CENTIARE,
  AREA_ACRE,
  AREA_SECTION,
  AREA_SOCCERFIELD
];
