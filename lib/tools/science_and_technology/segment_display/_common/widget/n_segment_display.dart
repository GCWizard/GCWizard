import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:touchable/touchable.dart';

class NSegmentDisplay extends StatefulWidget {
  final Map<String, bool> initialSegments;
  final double aspectRatio;
  final SegmentDisplayType type;

  final Map<String, bool> segments;
  final bool readOnly;
  final void Function(Map<String, bool>)? onChanged;

  final void Function(GCWTouchCanvas, Size, Map<String, bool>, void Function(String, bool), Color, Color)? customPaint;
  late _NSegmentDisplayState nSegmentDisplayState;

  NSegmentDisplay(
      {Key? key,
      required this.initialSegments,
      required this.type,
      required this.segments,
      this.readOnly = false,
      required this.onChanged,
      this.customPaint,
      this.aspectRatio = SEGMENTS_RELATIVE_DISPLAY_WIDTH / SEGMENTS_RELATIVE_DISPLAY_HEIGHT})
      : super(key: key);

  @override
  _NSegmentDisplayState createState() => _NSegmentDisplayState();

  Future<ui.Image> get renderedImage async {
    return nSegmentDisplayState.renderedImage;
  }
}

class _NSegmentDisplayState extends State<NSegmentDisplay> {
  late Map<String, bool> _segments;

  @override
  Widget build(BuildContext context) {
    widget.nSegmentDisplayState = this;

    if (widget.segments.isNotEmpty) {
      _segments = Map.from(widget.segments);

      for (var segmentID in widget.initialSegments.keys) {
        _segments.putIfAbsent(segmentID, () => widget.initialSegments[segmentID]!);
      }
    } else {
      _segments = Map.from(widget.initialSegments);
    }

    return Row(
      children: <Widget>[
        Expanded(
            child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: CanvasTouchDetector(
                    gesturesToOverride: const [GestureType.onTapDown],
                    builder: (context) {
                      return CustomPaint(
                          painter: SegmentDisplayPainter(context, widget.type, _segments, (key, value) {
                        if (widget.readOnly) return;

                        setState(() {
                          _segments[key] = value;
                          if (widget.onChanged != null) widget.onChanged!(_segments);
                        });
                      }, customPaint: widget.customPaint));
                    })))
      ],
    );
  }

  Future<ui.Image> get renderedImage async {
    _segments = Map.from(widget.segments);

    for (var segmentID in widget.initialSegments.keys) {
      _segments.putIfAbsent(segmentID, () => widget.initialSegments[segmentID]!);
    }

    final recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    final size = context.size ?? const Size(100, 100);

    final painter = SegmentDisplayPainter(context, widget.type, _segments, (key, value) {},
        customPaint: widget.customPaint, segment_color_on: Colors.black, segment_color_off: Colors.white);

    canvas.save();
    painter.paint(canvas, size);
    final data = recorder.endRecording().toImage(size.width.floor(), size.height.floor());
    return data;
  }
}

Map<String, bool> buildSegmentMap(Segments segments) {
  Map<String, bool> segmentMap;
  if (segments.displays.isNotEmpty) {
    segmentMap = {for (var e in segments.displays.last) e.toString(): true};
  } else {
    segmentMap = {};
  }

  return segmentMap;
}
