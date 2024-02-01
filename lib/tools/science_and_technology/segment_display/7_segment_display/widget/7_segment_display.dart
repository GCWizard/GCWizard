import 'package:flutter/material.dart';
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
      {Key? key,
      required Map<String, bool> segments,
      SegmentDisplayType? type,
      bool readOnly = false,
      void Function(Map<String, bool>)? onChanged})
      : super(
            key: key,
            initialSegments: _INITIAL_SEGMENTS,
            segments: segments,
            readOnly: readOnly,
            onChanged: onChanged,
            type: (Variants7Segment.contains(type) ? type : null) ?? SegmentDisplayType.SEVEN);
}
