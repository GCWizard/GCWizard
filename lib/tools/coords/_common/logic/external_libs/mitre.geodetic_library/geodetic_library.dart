import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/shape.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/constants.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/util.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/projections.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/llpoint.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/vincenty_algorithms.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/intersections.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/arc.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/sphere.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library/vector.dart';

List<LatLng> geodesicArcIntercept(LatLng start, double crs1, LatLng center, double radius, Ellipsoid ellipsoid) {
  var out = <LatLng>[];

  var result = _geoArcIntx(_LLPoint.fromLatLng(start), degToRadian(crs1), _LLPoint.fromLatLng(center), radius / _NMI_IN_METERS, _TOL, ellipsoid);
  for (_LLPoint pt in result) {
    out.add(pt.toLatLng());
  }

  return out;
}

List<LatLng> arcArcIntercept(LatLng center1, double radius1, LatLng center2, double radius2, Ellipsoid ellipsoid) {
  var out = <LatLng>[];

  var result = _arcIntx(_LLPoint.fromLatLng(center1), radius1 / _NMI_IN_METERS, _LLPoint.fromLatLng(center2), radius2 / _NMI_IN_METERS, _TOL, ellipsoid);
  for (_LLPoint pt in result) {
    out.add(pt.toLatLng());
  }

  return out;
}