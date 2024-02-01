import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Velocity extends Unit {
  late double Function(double) toMS;
  late double Function(double) fromMS;

  Velocity({required String name, required String symbol, bool isReference = false, required double inMS})
      : super(name, symbol, isReference, (e) => e * inMS, (e) => e / inMS) {
    toMS = toReference;
    fromMS = fromReference;
  }
}

final VELOCITY_MS = Velocity(name: 'common_unit_velocity_ms_name', symbol: 'm/s', isReference: true, inMS: 1.0);

final VELOCITY_KMH = Velocity(name: 'common_unit_velocity_kmh_name', symbol: 'km/h', inMS: 1.0 / 3.6);

final _VELOCITY_MPH = Velocity(name: 'common_unit_velocity_mph_name', symbol: 'mph', inMS: 1.0 / 3.6 * 1.609344);

final _VELOCITY_MPMIN =
    Velocity(name: 'common_unit_velocity_mpmin_name', symbol: 'mpm', inMS: 1.0 / 3.6 * 1.609344 * 60.0);

final _VELOCITY_FTS = Velocity(name: 'common_unit_velocity_fts_name', symbol: 'fts', inMS: 0.3048);

final _VELOCITY_KN = Velocity(name: 'common_unit_velocity_kn_name', symbol: 'kn', inMS: 463.0 / 900.0);

final _VELOCITY_MMIN = Velocity(name: 'common_unit_velocity_mmin_name', symbol: 'm/min', inMS: 1.0 / 60.0);

final _VELOCITY_KMS = Velocity(name: 'common_unit_velocity_kms_name', symbol: 'km/s', inMS: 1000.0);

final _VELOCITY_KMMIN = Velocity(name: 'common_unit_velocity_kmmin_name', symbol: 'km/min', inMS: 100.0 / 6.0);

final _VELOCITY_FTMIN = Velocity(name: 'common_unit_velocity_ftmin_name', symbol: 'ft/min', inMS: 0.3048 / 60.0);

final _VELOCITY_YDS = Velocity(name: 'common_unit_velocity_yds_name', symbol: 'yd/s', inMS: 0.9144);

final _VELOCITY_YDMIN = Velocity(name: 'common_unit_velocity_ydmin_name', symbol: 'yd/min', inMS: 0.01524);

//Mach source: https://de.wikipedia.org/w/index.php?title=Schallgeschwindigkeit&oldid=211662455#Temperaturabh%C3%A4ngigkeit
final _VELOCITY_MACH0 = Velocity(name: 'common_unit_velocity_mach0_name', symbol: 'Ma', inMS: 343.46);

final _VELOCITY_MACHNEG50 = Velocity(name: 'common_unit_velocity_machneg50_name', symbol: 'Ma', inMS: 331.5);

final _VELOCITY_MACH20 = Velocity(name: 'common_unit_velocity_mach20_name', symbol: 'Ma', inMS: 299.63);

final List<Velocity> velocities = [
  VELOCITY_MS,
  _VELOCITY_MMIN,
  _VELOCITY_KMS,
  _VELOCITY_KMMIN,
  VELOCITY_KMH,
  _VELOCITY_MPMIN,
  _VELOCITY_MPH,
  _VELOCITY_KN,
  _VELOCITY_FTS,
  _VELOCITY_FTMIN,
  _VELOCITY_YDS,
  _VELOCITY_YDMIN,
  _VELOCITY_MACH20,
  _VELOCITY_MACH0,
  _VELOCITY_MACHNEG50
];
