import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a1': false,
  'a2': false,
  'b': false,
  'c': false,
  'd1': false,
  'd2': false,
  'e': false,
  'f': false,
  'g1': false,
  'g2': false,
  'h': false,
  'i': false,
  'j': false,
  'k': false,
  'l': false,
  'm': false,
  'dp': false
};

class SixteenSegmentDisplay extends NSegmentDisplay {
  SixteenSegmentDisplay(
      {super.key,
      required super.segments,
      SegmentDisplayType? type,
      super.readOnly,
      super.onChanged})
      : super(
            initialSegments: _INITIAL_SEGMENTS,
            type: (Variants16Segment.contains(type) ? type : null) ?? SegmentDisplayType.SIXTEEN);
}
