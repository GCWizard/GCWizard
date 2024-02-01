import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Time extends Unit {
  late double Function(double) toSeconds;
  late double Function(double) fromSeconds;

  Time({required String name, required String symbol, bool isReference = false, required double inSeconds})
      : super(name, symbol, isReference, (e) => e * inSeconds, (e) => e / inSeconds) {
    toSeconds = toReference;
    fromSeconds = fromReference;
  }
}

final _TIME_WEEK = Time(name: 'common_unit_time_w_name', symbol: 'w', inSeconds: 7.0 * 24.0 * 60.0 * 60.0);

final _TIME_DAY = Time(name: 'common_unit_time_d_name', symbol: 'd', inSeconds: 24.0 * 60.0 * 60.0);

final TIME_HOUR = Time(name: 'common_unit_time_h_name', symbol: 'h', inSeconds: 60.0 * 60.0);

final TIME_MINUTE = Time(name: 'common_unit_time_min_name', symbol: 'min', inSeconds: 60.0);

final TIME_SECOND = Time(name: 'common_unit_time_s_name', symbol: 's', inSeconds: 1.0, isReference: true);

// https://webmadness.net/blog/?post=knuth
final _TIME_WOLVERTON = Time(name: 'common_unit_time_wolverton_name', symbol: 'wl', inSeconds: 0.864);

final _TIME_KOVAC = Time(name: 'common_unit_time_kovac_name', symbol: 'kv', inSeconds: 0.864);

final _TIME_MARTIN = Time(name: 'common_unit_time_martin_name', symbol: 'mn', inSeconds: 86.4);

final _TIME_WOOD = Time(name: 'common_unit_time_wood_name', symbol: 'wd', inSeconds: 8640.0);

final _TIME_CLARKE = Time(name: 'common_unit_time_clarke_name', symbol: 'cl', inSeconds: 86400.0);

final _TIME_MINGO = Time(name: 'common_unit_time_mingo_name', symbol: 'mi', inSeconds: 864000.0);

final _TIME_COWZNOFSKI = Time(name: 'common_unit_time_cowznofski_name', symbol: 'cow', inSeconds: 8640000.0);

final List<Time> times = [
  _TIME_WEEK,
  _TIME_DAY,
  TIME_HOUR,
  TIME_MINUTE,
  TIME_SECOND,
  _TIME_WOLVERTON,
  _TIME_KOVAC,
  _TIME_MARTIN,
  _TIME_WOOD,
  _TIME_CLARKE,
  _TIME_MINGO,
  _TIME_COWZNOFSKI,
];
