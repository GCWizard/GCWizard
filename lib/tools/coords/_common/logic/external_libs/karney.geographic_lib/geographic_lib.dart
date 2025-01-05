// imports
import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:latlong2/latlong.dart';

// parts
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/aux_angle.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/aux_latitude.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/azimuthal_equidistant.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/d_aux_latitude.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/ellipsoid.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/elliptic_function.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geo_math.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geodesic.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geodesic_data.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geodesic_line.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geodesic_mask.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/intersect.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/lambert_conformal_conic.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/math.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/pair.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/rhumb.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/transverse_mercator.dart';

GeodesicData geodeticInverse(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  return _Geodesic(ellipsoid.a, ellipsoid.f).inverse(coords1.latitude, coords1.longitude, coords2.latitude, coords2.longitude);
}

GeodesicData geodeticDirect(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  return _Geodesic(ellipsoid.a, ellipsoid.f).direct(coord.latitude, coord.longitude, bearing, distance);
}

LatLng intersectGeodesics(LatLng coord1, double azimuth1, LatLng coord2, double azimuth2, Ellipsoid ellipsoid) {
  var intersect = _Intersect(ellipsoid.a, ellipsoid.f);
  var distances = intersect.closest(coord1.latitude, coord1.longitude, azimuth1, coord2.latitude, coord2.longitude, azimuth2);

  var geodesic = _Geodesic(ellipsoid.a, ellipsoid.f);
  var projected1 = geodesic.direct(coord1.latitude, coord1.longitude, azimuth1, distances.first);
  var projected2 = geodesic.direct(coord2.latitude, coord2.longitude, azimuth2, distances.second);

  return LatLng((projected1.lat2 + projected2.lat2) / 2, (projected1.lon2 + projected2.lon2) / 2);
}

LatLng azimuthalEquidistantReverse(LatLng projectionCenter, Point<double> point, Ellipsoid ellipsoid) {
  var aeReturn = _AzimuthalEquidistant.reverse(projectionCenter.latitude, projectionCenter.longitude, point.x, point.y, ellipsoid);
  return LatLng(aeReturn.yOrLat, aeReturn.xOrLon);
}

Point<double> azimuthalEquidistantForward(LatLng projectionCenter, LatLng coord, Ellipsoid ellipsoid) {
  var aeReturn = _AzimuthalEquidistant.forward(projectionCenter.latitude, projectionCenter.longitude, coord.latitude, coord.longitude, ellipsoid);
  return Point(aeReturn.xOrLon, aeReturn.yOrLat);
}

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class Rhumb {
  late final _Rhumb rhumb;

  Rhumb(double a, double f) {
    rhumb = _Rhumb(a, f, true);
  }

  RhumbInverseReturn inverse(double lat1, double lon1, double lat2, double lon2) {
    return rhumb._Inverse(lat1, lon1, lat2, lon2);
  }

  RhumbDirectReturn direct(double lat1, double lon1, double azi12, double s12) {
    return rhumb._Direct(lat1, lon1, azi12, s12);
  }
}

