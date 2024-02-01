import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Power extends Unit {
  late double Function(double) toWatt;
  late double Function(double) fromWatt;

  Power({required String name, required String symbol, bool isReference = false, required double inWatt})
      : super(name, symbol, isReference, (e) => e * inWatt, (e) => e / inWatt) {
    toWatt = toReference;
    fromWatt = fromReference;
  }
}

final POWER_WATT = Power(
  name: 'common_unit_power_w_name',
  symbol: 'W',
  inWatt: 1.0,
  isReference: true,
);

final _POWER_HORSEPOWER = Power(name: 'common_unit_power_hp_name', symbol: 'hp', inWatt: 745.699871515585);

final POWER_METRICHORSEPOWER = Power(name: 'common_unit_power_ps_name', symbol: 'PS', inWatt: 735.49875);

//According to Randall Munroe, What If? ISBN 978-1-84854-958-6
final _POWER_YODA = Power(name: 'common_unit_power_yoda_name', symbol: '', inWatt: 19200);

// https://webmadness.net/blog/?post=knuth
final _POWER_WHATMEWORRIES = Power(name: 'common_unit_power_whatmeworries_name', symbol: 'WMW', inWatt: 1.0 / 3.499651);

final List<Power> powers = [
  POWER_WATT,
  _POWER_HORSEPOWER,
  POWER_METRICHORSEPOWER,
  _POWER_YODA,
  _POWER_WHATMEWORRIES,
];
