import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/coords/_common/widget/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class DistanceBearingGeodetic extends DistanceBearing {
  const DistanceBearingGeodetic({Key? key})
      : super(
          key: key,
          type: GCWMapLineType.GEODETIC,
          calculate: distanceBearing,
        );
}
