import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a': false,
  'b': false,
  'c': false,
  'd': false,
  'e': false,
  'f': false,
  'g': false
};

class MayaNumbersSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  MayaNumbersSegmentDisplay({Key key, this.segments, this.readOnly: false, this.onChanged, this.tapeStyle: false})
      : super(
            key: key,
            initialSegments: _INITIAL_SEGMENTS,
            segments: segments,
            readOnly: readOnly,
            onChanged: onChanged,
            type: SegmentDisplayType.CUSTOM,
            customPaint: (GCWTouchCanvas canvas, Size size, Map<String, bool> currentSegments, Function setSegmentState,
                Color segment_color_on, Color segment_color_off) {
              var paint = defaultSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;

              paint.color = currentSegments['a'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA = Path();
              pathA.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 1,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 73);
              pathA.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 75,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 73);
              pathA.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 75,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 85);
              pathA.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 1,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 85);
              pathA.close();

              canvas.touchCanvas.drawPath(pathA, paint, onTapDown: (tapDetail) {
                setSegmentState('a', !currentSegments['a']);
              });

              paint.color = currentSegments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB = Path();
              pathB.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 1,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 53);
              pathB.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 75,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 53);
              pathB.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 75,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathB.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 1,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathB.close();

              canvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
                setSegmentState('b', !currentSegments['b']);
              });

              paint.color = currentSegments['c'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC = Path();
              pathC.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 1,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 33);
              pathC.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 75,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 33);
              pathC.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 75,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 45);
              pathC.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 1,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 45);
              pathC.close();

              canvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
                setSegmentState('c', !currentSegments['c']);
              });

              paint.color = currentSegments['d'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              canvas.touchCanvas.drawCircle(
                  Offset(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 10.5,
                      size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18.2),
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 6.8,
                  paint, onTapDown: (tapDetail) {
                setSegmentState('d', !currentSegments['d']);
              });

              paint.color = currentSegments['e'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              canvas.touchCanvas.drawCircle(
                  Offset(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 28.5,
                      size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18.2),
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 6.8,
                  paint, onTapDown: (tapDetail) {
                setSegmentState('e', !currentSegments['e']);
              });

              paint.color = currentSegments['f'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              canvas.touchCanvas.drawCircle(
                  Offset(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 46.5,
                      size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18.2),
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 6.8,
                  paint, onTapDown: (tapDetail) {
                setSegmentState('f', !currentSegments['f']);
              });

              paint.color = currentSegments['g'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              canvas.touchCanvas.drawCircle(
                  Offset(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 64.5,
                      size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18.2),
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 6.8,
                  paint, onTapDown: (tapDetail) {
                setSegmentState('g', !currentSegments['g']);
              });
            });
}
