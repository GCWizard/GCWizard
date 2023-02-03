import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

//https://de.wikipedia.org/wiki/Newtonskala

class Temperature extends Unit {
  final Function toKelvin;
  final Function fromKelvin;

  Temperature({String name, String symbol, bool isReference: false, this.toKelvin, this.fromKelvin})
      : super(name, symbol, isReference, toKelvin, fromKelvin);
}

final TEMPERATURE_KELVIN = Temperature(name: 'common_unit_temperature_k_name', symbol: 'K', isReference: true);

final TEMPERATURE_CELSIUS = Temperature(
    name: 'common_unit_temperature_degc_name',
    symbol: String.fromCharCode(176) + 'C',
    toKelvin: (e) => e + 273.15,
    fromKelvin: (e) => e - 273.15);

final TEMPERATURE_FAHRENHEIT = Temperature(
    name: 'common_unit_temperature_degf_name',
    symbol: String.fromCharCode(176) + 'F',
    toKelvin: (e) => (e + 459.67) * 5.0 / 9.0,
    fromKelvin: (e) => e * 9.0 / 5.0 - 459.67);

final TEMPERATURE_REAUMUR = Temperature(
    name: 'common_unit_temperature_degr_name',
    symbol: String.fromCharCode(176) + 'R',
    toKelvin: (e) => e * 1.25 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 0.8);

final TEMPERATURE_RANKINE = Temperature(
    name: 'common_unit_temperature_degra_name',
    symbol: String.fromCharCode(176) + 'Ra',
    toKelvin: (e) => e * 5.0 / 9.0,
    fromKelvin: (e) => e * 9.0 / 5.0);

final TEMPERATURE_ROMER = Temperature(
    name: 'common_unit_temperature_degro_name',
    symbol: String.fromCharCode(176) + 'Rø',
    toKelvin: (e) => (e - 7.5) * 40.0 / 21.0 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 21.0 / 40.0 + 7.5);

final TEMPERATURE_DELISLE = Temperature(
    name: 'common_unit_temperature_degde_name',
    symbol: String.fromCharCode(176) + 'De',
    toKelvin: (e) => 373.15 - e * 2.0 / 3.0,
    fromKelvin: (e) => (373.15 - e) * 1.5);

final TEMPERATURE_NEWTON = Temperature(
    name: 'common_unit_temperature_degn_name',
    symbol: String.fromCharCode(176) + 'N',
    toKelvin: (e) => e * 100.0 / 33.0 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 0.33);

// https://webmadness.net/blog/?post=knuth
final TEMPERATURE_SMURDLEY = Temperature(
    name: 'common_unit_temperature_smurdley_name',
    symbol: String.fromCharCode(176) + 'S',
    toKelvin: (e) => e / 0.27 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 0.27);

final List<Unit> temperatures = [
  TEMPERATURE_KELVIN,
  TEMPERATURE_CELSIUS,
  TEMPERATURE_FAHRENHEIT,
  TEMPERATURE_REAUMUR,
  TEMPERATURE_RANKINE,
  TEMPERATURE_ROMER,
  TEMPERATURE_DELISLE,
  TEMPERATURE_NEWTON,
  TEMPERATURE_SMURDLEY,
];
