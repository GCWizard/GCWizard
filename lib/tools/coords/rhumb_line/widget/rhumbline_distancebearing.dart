import 'package:gc_wizard/tools/coords/_common/widget/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/rhumb_line/logic/rhumb_line.dart';

class DistanceBearingRhumbline extends DistanceBearing {
  const DistanceBearingRhumbline({super.key})
      : super(
          type: GCWMapLineType.RHUMB,
          calculate: distanceBearing,
        );
}
