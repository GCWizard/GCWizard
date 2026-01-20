import 'package:gc_wizard/tools/coords/_common/widget/waypoint_projection.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';

class WaypointProjectionGeodetic extends WaypointProjection {
  const WaypointProjectionGeodetic({super.key})
      : super(type: GCWMapLineType.GEODETIC, calculate: projection, calculateReverse: reverseProjection);
}
