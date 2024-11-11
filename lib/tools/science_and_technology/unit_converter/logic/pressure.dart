import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Pressure extends Unit {
  late double Function(double) toPascal;
  late double Function(double) fromPascal;

  Pressure({required String key, required String symbol, bool isReference = false, required double inPascal})
      : super(key, symbol, isReference, (e) => e * inPascal, (e) => e / inPascal) {
    toPascal = toReference;
    fromPascal = fromReference;
  }
}

final PRESSURE_PASCAL = Pressure(
  key: 'common_unit_pressure_pa_name',
  symbol: 'Pa',
  inPascal: 1.0,
  isReference: true,
);

final PRESSURE_BAR = Pressure(key: 'common_unit_pressure_bar_name', symbol: 'bar', inPascal: 100000.0);

final _PRESSURE_POUNDSPERSQUAREINCH =
    Pressure(key: 'common_unit_pressure_psi_name', symbol: 'psi, lbf/in\u00B2', inPascal: 6894.75729);

final _PRESSURE_ATMOSPHERE = Pressure(key: 'common_unit_pressure_atm_name', symbol: 'atm', inPascal: 101325.0);

final _PRESSURE_TECHNICALATMOSPHERE = Pressure(key: 'common_unit_pressure_at_name', symbol: 'at', inPascal: 98066.5);

final _PRESSURE_MILLIMETEROFMERCURY =
    Pressure(key: 'common_unit_pressure_mmhg_name', symbol: 'mmHg', inPascal: 133.322387415);

final _PRESSURE_INCHOFMERCURY = Pressure(key: 'common_unit_pressure_inhg_name', symbol: 'inHg', inPascal: 3386.39);

final _PRESSURE_TORR = Pressure(key: 'common_unit_pressure_torr_name', symbol: 'Torr', inPascal: 101325.0 / 760.0);

final PRESSURE_MBAR = Pressure(key: 'common_unit_pressure_mbar_name', symbol: 'mBar', inPascal: 100.0);
final PRESSURE_HPASCAL = Pressure(key: 'common_unit_pressure_hpascal_name', symbol: 'hPa', inPascal: 100.0);

final List<Pressure> pressures = [
  PRESSURE_PASCAL,
  PRESSURE_BAR,
  _PRESSURE_POUNDSPERSQUAREINCH,
  _PRESSURE_ATMOSPHERE,
  _PRESSURE_TECHNICALATMOSPHERE,
  _PRESSURE_MILLIMETEROFMERCURY,
  _PRESSURE_INCHOFMERCURY,
  _PRESSURE_TORR
];

List<Unit> allPressures() {
  var additionalPressures = List<Unit>.from(pressures);
  var indexM = pressures.indexOf(_PRESSURE_TORR);
  additionalPressures.insert(indexM + 1, PRESSURE_MBAR);
  additionalPressures.insert(indexM + 2, PRESSURE_HPASCAL);

  return additionalPressures;
}
