import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:touchable/touchable.dart';

class NSegmentDisplay extends StatefulWidget {
  final Map<String, bool> initialSegments;
  final double aspectRatio;
  final SegmentDisplayType type;

  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;

  final Function customPaint;
  NSegmentDisplayState nSegmentDisplayState;

  NSegmentDisplay(
      {Key key,
      this.initialSegments,
      this.type,
      this.segments,
      this.readOnly: false,
      this.onChanged,
      this.customPaint,
      this.aspectRatio: SEGMENTS_RELATIVE_DISPLAY_WIDTH / SEGMENTS_RELATIVE_DISPLAY_HEIGHT})
      : super(key: key);

  @override
  NSegmentDisplayState createState() => NSegmentDisplayState();

  Future<ui.Image> get renderedImage async {
    return nSegmentDisplayState.renderedImage;
  }
}

class NSegmentDisplayState extends State<NSegmentDisplay> {
  Map<String, bool> _segments;

  @override
  Widget build(BuildContext context) {
    widget.nSegmentDisplayState = this;

    if (widget.segments != null) {
      _segments = Map.from(widget.segments);

      widget.initialSegments.keys.forEach((segmentID) {
        _segments.putIfAbsent(segmentID, () => widget.initialSegments[segmentID]);
      });
    } else {
      _segments = Map.from(widget.initialSegments);
    }

    return Row(
      children: <Widget>[
        Expanded(
            child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: CanvasTouchDetector(
                    gesturesToOverride: [GestureType.onTapDown],
                    builder: (context) {
                      return CustomPaint(
                          painter: SegmentDisplayPainter(context, widget.type, _segments, (key, value) {
                        if (widget.readOnly) return;

                        setState(() {
                          _segments[key] = value;
                          widget.onChanged(_segments);
                        });
                      }, customPaint: widget.customPaint));
                    })))
      ],
    );
  }

  Future<ui.Image> get renderedImage async {
    if (widget.segments != null) {
      _segments = Map.from(widget.segments);

      widget.initialSegments.keys.forEach((segmentID) {
        _segments.putIfAbsent(segmentID, () => widget.initialSegments[segmentID]);
      });
    } else {
      _segments = Map.from(widget.initialSegments);
    }

    final recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    final size = context.size;
    final painter = SegmentDisplayPainter(context, widget.type, _segments, (key, value) {},
        customPaint: widget.customPaint, segment_color_on: Colors.black, segment_color_off: Colors.white);

    canvas.save();
    painter.paint(canvas, size);
    final data = recorder.endRecording().toImage(size.width.floor(), size.height.floor());
    return data;
  }
}
