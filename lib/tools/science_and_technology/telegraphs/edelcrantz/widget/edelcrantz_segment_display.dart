part of 'package:gc_wizard/tools/science_and_technology/telegraphs/edelcrantz/widget/edelcrantz.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  't0': false,
  'a1': false,
  'a2': false,
  'a3': false,
  'b1': false,
  'b2': false,
  'b3': false,
  'c1': false,
  'c2': false,
  'c3': false
};

const _EDELCRANTZ_RELATIVE_DISPLAY_WIDTH = 150;
const _EDELCRANTZ_RELATIVE_DISPLAY_HEIGHT = 150;
const _EDELCRANTZ_RADIUS = 10.0;

class _EdelcrantzSegmentDisplay extends NSegmentDisplay {
  _EdelcrantzSegmentDisplay(
      {Key? key,
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

              const shutterSegments = {
                '0': 't0',
                '1': 'a1',
                '2': 'a2',
                '3': 'a3',
                '4': 'b1',
                '5': 'b2',
                '6': 'b3',
                '7': 'c1',
                '8': 'c2',
                '9': 'c3',
              };
              const shutters = {
                '0': [30, 10],
                '1': [10, 40],
                '2': [10, 70],
                '3': [10, 100],
                '4': [50, 40],
                '5': [50, 70],
                '6': [50, 100],
                '7': [90, 40],
                '8': [90, 70],
                '9': [90, 100],
              };
              var pointSize = size.height / _EDELCRANTZ_RELATIVE_DISPLAY_HEIGHT * _EDELCRANTZ_RADIUS;

              paint.color = Colors.black;
              shutters.forEach((key, value) {
                canvas.touchCanvas.drawRect(
                    Offset(size.width / _EDELCRANTZ_RELATIVE_DISPLAY_WIDTH * (value[0] - 1),
                            size.height / _EDELCRANTZ_RELATIVE_DISPLAY_HEIGHT * (value[1]) - 1) &
                        Size(pointSize * 3 + 1, pointSize * 2 + 2),
                    paint);

                if (size.height < 50) return;
              });

              shutters.forEach((key, value) {
                paint.color =
                    segmentActive(currentSegments, shutterSegments[key]!) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
                canvas.touchCanvas.drawRect(
                    Offset(size.width / _EDELCRANTZ_RELATIVE_DISPLAY_WIDTH * value[0],
                            size.height / _EDELCRANTZ_RELATIVE_DISPLAY_HEIGHT * value[1]) &
                        Size(pointSize * 3, pointSize * 2),
                    paint, onTapDown: (tapDetail) {
                  setSegmentState(shutterSegments[key], !segmentActive(currentSegments, shutterSegments[key]!));
                });

                if (size.height < 50) return;
              });
            });
}
