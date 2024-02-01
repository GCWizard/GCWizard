import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

//https://de.wikipedia.org/wiki/Newtonskala

class Temperature extends Unit {
  late double Function(double) toKelvin;
  late double Function(double) fromKelvin;

  Temperature(
      {required String name,
      required String symbol,
      bool isReference = false,
      required this.toKelvin,
      required this.fromKelvin})
      : super(name, symbol, isReference, toKelvin, fromKelvin);
}

final TEMPERATURE_KELVIN = Temperature(
    name: 'common_unit_temperature_k_name', symbol: 'K', toKelvin: (e) => e, fromKelvin: (e) => e, isReference: true);

final TEMPERATURE_CELSIUS = Temperature(
    name: 'common_unit_temperature_degc_name',
    symbol: '\u00B0C',
    toKelvin: (e) => e + 273.15,
    fromKelvin: (e) => e - 273.15);

final TEMPERATURE_FAHRENHEIT = Temperature(
    name: 'common_unit_temperature_degf_name',
    symbol: '\u00B0F',
    toKelvin: (e) => (e + 459.67) * 5.0 / 9.0,
    fromKelvin: (e) => e * 9.0 / 5.0 - 459.67);

final _TEMPERATURE_REAUMUR = Temperature(
    name: 'common_unit_temperature_degr_name',
    symbol: '\u00B0R',
    toKelvin: (e) => e * 1.25 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 0.8);

final _TEMPERATURE_RANKINE = Temperature(
    name: 'common_unit_temperature_degra_name',
    symbol: '\u00B0Ra',
    toKelvin: (e) => e * 5.0 / 9.0,
    fromKelvin: (e) => e * 9.0 / 5.0);

final _TEMPERATURE_ROMER = Temperature(
    name: 'common_unit_temperature_degro_name',
    symbol: '\u00B0Rø',
    toKelvin: (e) => (e - 7.5) * 40.0 / 21.0 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 21.0 / 40.0 + 7.5);

final _TEMPERATURE_DELISLE = Temperature(
    name: 'common_unit_temperature_degde_name',
    symbol: '\u00B0De',
    toKelvin: (e) => 373.15 - e * 2.0 / 3.0,
    fromKelvin: (e) => (373.15 - e) * 1.5);

final _TEMPERATURE_NEWTON = Temperature(
    name: 'common_unit_temperature_degn_name',
    symbol: '\u00B0N',
    toKelvin: (e) => e * 100.0 / 33.0 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 0.33);

// https://webmadness.net/blog/?post=knuth
final _TEMPERATURE_SMURDLEY = Temperature(
    name: 'common_unit_temperature_smurdley_name',
    symbol: '\u00B0S',
    toKelvin: (e) => e / 0.27 + 273.15,
    fromKelvin: (e) => (e - 273.15) * 0.27);

final List<Temperature> temperatures = [
  TEMPERATURE_KELVIN,
  TEMPERATURE_CELSIUS,
  TEMPERATURE_FAHRENHEIT,
  _TEMPERATURE_REAUMUR,
  _TEMPERATURE_RANKINE,
  _TEMPERATURE_ROMER,
  _TEMPERATURE_DELISLE,
  _TEMPERATURE_NEWTON,
  _TEMPERATURE_SMURDLEY,
];
