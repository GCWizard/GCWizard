import 'dart:math';

import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/external_libs/jgiesen_de.season2/aphelion_perihelion.dart';
part 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/external_libs/jgiesen_de.season2/seasons.dart';

_computeSeasons seasons(int year) {
  return _computeSeasons(year);
}

DateTimeDouble perihelion(int year) {
  return _perihelion(year);
}

DateTimeDouble aphelion(int year) {
  return _aphelion(year);
}
