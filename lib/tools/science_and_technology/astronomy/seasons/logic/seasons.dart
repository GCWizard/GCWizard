import 'dart:math';

import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/external_libs/jgiesen_de.season2/aphelion_perihelion.dart';
part 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/external_libs/jgiesen_de.season2/seasons.dart';

class _Seasons {
  late DateTimeTZ spring;
  late DateTimeTZ summer;
  late DateTimeTZ autumn;
  late DateTimeTZ winter;

  _Seasons(int year, Duration timezone) {
    var seasons = _computeSeasons(year);

    spring = DateTimeTZ(dateTimeUtc: seasons.spring, timezone: timezone);
    summer = DateTimeTZ(dateTimeUtc: seasons.summer, timezone: timezone);
    autumn = DateTimeTZ(dateTimeUtc: seasons.autumn, timezone: timezone);
    winter = DateTimeTZ(dateTimeUtc: seasons.winter, timezone: timezone);
  }
}

_Seasons seasons(int year, Duration timezone) {
  return _Seasons(year, timezone);
}

class Helion {
  late DateTimeTZ dateTimeTZ;
  late double value;

  Helion({required DateTime dateTimeUtc, Duration timezone = const Duration(), required this.value}) {
    dateTimeTZ = DateTimeTZ(
      dateTimeUtc: dateTimeUtc,
      timezone: timezone,
    );
  }
}

Helion perihelion(int year, Duration timezone) {
  var peri = _perihelion(year);
  return Helion(
    dateTimeUtc: peri.$1,
    timezone: timezone,
    value: peri.$2
  );
}

Helion aphelion(int year, Duration timezone) {
  var aphel = _aphelion(year);
  return Helion(
      dateTimeUtc: aphel.$1,
      timezone: timezone,
      value: aphel.$2
  );
}
