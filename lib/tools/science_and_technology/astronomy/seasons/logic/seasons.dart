import 'dart:math';

import 'package:gc_wizard/utils/datetime_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/external_libs/jgiesen_de.season2/aphelion_perihelion.dart';
part 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/external_libs/jgiesen_de.season2/seasons.dart';

Map<String, DateTime> seasons(int year) {
  return _computeSeasons(year);
}

Map<String, dynamic> perihelion(int year) {
  return _perihelion(year);
}

Map<String, dynamic> aphelion(int year) {
  return _aphelion(year);
}
