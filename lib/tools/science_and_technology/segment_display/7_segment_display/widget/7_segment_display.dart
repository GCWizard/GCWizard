import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a': false,
  'b': false,
  'c': false,
  'd': false,
  'e': false,
  'f': false,
  'g': false,
  'dp': false
};

class SevenSegmentDisplay extends NSegmentDisplay {
  SevenSegmentDisplay(
      {super.key,
      required super.segments,
      SegmentDisplayType? type,
      super.readOnly,
      super.onChanged})
      : super(
            initialSegments: _INITIAL_SEGMENTS,
            type: (Variants7Segment.contains(type) ? type : null) ?? SegmentDisplayType.SEVEN);
}
