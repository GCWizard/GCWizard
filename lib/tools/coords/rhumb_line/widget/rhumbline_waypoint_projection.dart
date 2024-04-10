import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/coords/_common/widget/waypoint_projection.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/rhumb_line/logic/rhumb_line.dart';

class WaypointProjectionRhumbline extends WaypointProjection {
  const WaypointProjectionRhumbline({Key? key}) : super(
    key: key,
    type: GCWMapLineType.RHUMB,
    calculate: projection,
    calculateReverse: reverseProjection
  );
}