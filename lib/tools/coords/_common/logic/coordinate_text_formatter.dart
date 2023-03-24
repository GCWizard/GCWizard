import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

String formatCoordOutput(LatLng _coords, CoordinateFormat _outputFormat, Ellipsoid ells) {
  return buildCoordinatesByFormat(_outputFormat, _coords, ells).toString();
}