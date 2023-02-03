import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Power extends Unit {
  Function toWatt;
  Function fromWatt;

  Power({String name, String symbol, bool isReference: false, double inWatt})
      : super(name, symbol, isReference, (e) => e * inWatt, (e) => e / inWatt) {
    toWatt = this.toReference;
    fromWatt = this.fromReference;
  }
}

final POWER_WATT = Power(
  name: 'common_unit_power_w_name',
  symbol: 'W',
  isReference: true,
);

final POWER_HORSEPOWER = Power(name: 'common_unit_power_hp_name', symbol: 'hp', inWatt: 745.699871515585);

final POWER_METRICHORSEPOWER = Power(name: 'common_unit_power_ps_name', symbol: 'PS', inWatt: 735.49875);

//According to Randall Munroe, What If? ISBN 978-1-84854-958-6
final POWER_YODA = Power(name: 'common_unit_power_yoda_name', symbol: null, inWatt: 19200);

// https://webmadness.net/blog/?post=knuth
final POWER_WHATMEWORRIES = Power(name: 'common_unit_power_whatmeworries_name', symbol: 'WMW', inWatt: 1.0 / 3.499651);

final List<Unit> powers = [
  POWER_WATT,
  POWER_HORSEPOWER,
  POWER_METRICHORSEPOWER,
  POWER_YODA,
  POWER_WHATMEWORRIES,
];
