import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

String formatCoordOutput(LatLng _coords, CoordinateFormat _outputFormat, [Ellipsoid? ells]) {
  int? precision;
  switch (_outputFormat.type) {
    case CoordinateFormatKey.DMM:
      precision = Prefs.getInt(PREFERENCE_COORD_PRECISION_DMM);
      break;
    default:
      break;
  }

  return buildCoordinate(_outputFormat, _coords, ells).toString(precision);
}
