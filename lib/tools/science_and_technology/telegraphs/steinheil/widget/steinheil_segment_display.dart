part of 'package:gc_wizard/tools/science_and_technology/telegraphs/steinheil/widget/steinheil.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a': false,
  'b': false,
  'c': false,
  'd': false,
  'e': false,
  'f': false,
  'g': false,
  'h': false
};

const _STEINHEIL_RELATIVE_DISPLAY_WIDTH = 100;
const _STEINHEIL_RELATIVE_DISPLAY_HEIGHT = 100;
const _STEINHEIL_RADIUS = 10;


class _SteinheilSegmentDisplay extends NSegmentDisplay {

  _SteinheilSegmentDisplay({
    Key? key,
    required Map<String, bool> segments,
    bool readOnly = false,
    void Function(Map<String, bool>)? onChanged})
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

        var circles = {
          'a': [15, 20],
          'b': [40, 20],
          'c': [65, 20],
          'd': [90, 20],
          'e': [15, 60],
          'f': [40, 60],
          'g': [65, 60],
          'h': [90, 60]
        };

        circles.forEach((key, value) {
          paint.color = segmentActive(currentSegments, key) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;

          canvas.touchCanvas.drawCircle(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * value[0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * value[1]),
              size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * _STEINHEIL_RADIUS,
              paint, onTapDown: (tapDetail) {
            setSegmentState(key, !segmentActive(currentSegments, key));
          });

          if (currentSegments['a']! && currentSegments['b']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['a']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['a']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['b']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['b']![1]),
              paint,
            );
          }
          if (currentSegments['a']! && currentSegments['f']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['a']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['a']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['f']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['f']![1]),
              paint,
            );
          }
          if (currentSegments['c']! && currentSegments['b']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['c']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['c']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['b']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['b']![1]),
              paint,
            );
          }
          if (currentSegments['g']! && currentSegments['b']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['g']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['g']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['b']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['b']![1]),
              paint,
            );
          }
          if (currentSegments['c']! && currentSegments['d']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['c']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['c']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['d']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['d']![1]),
              paint,
            );
          }
          if (currentSegments['c']! && currentSegments['h']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['c']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['c']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['h']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['h']![1]),
              paint,
            );
          }
          if (currentSegments['e']! && currentSegments['b']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
                Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['e']![0],
                    size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['e']![1]),
                Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['b']![0],
                    size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['b']![1]),
                paint,
            );
          }
          if (currentSegments['e']! && currentSegments['f']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['e']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['e']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['f']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['f']![1]),
              paint,
            );
          }
          if (currentSegments['f']! && currentSegments['c']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['f']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['f']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['c']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['c']![1]),
              paint,
            );
          }
          if (currentSegments['f']! && currentSegments['g']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['f']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['f']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['g']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['g']![1]),
              paint,
            );
          }
          if (currentSegments['g']! && currentSegments['d']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['g']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['g']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['d']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['d']![1]),
              paint,
            );
          }
          if (currentSegments['g']! && currentSegments['h']!) {
            paint.color = SEGMENTS_COLOR_ON;
            paint.strokeWidth = 2.0;
            canvas.touchCanvas.drawLine(
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['g']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['g']![1]),
              Offset(size.width / _STEINHEIL_RELATIVE_DISPLAY_WIDTH * circles['h']![0],
                  size.height / _STEINHEIL_RELATIVE_DISPLAY_HEIGHT * circles['h']![1]),
              paint,
            );
          }
          if (size.height < 50) return;

        });
      });
}
