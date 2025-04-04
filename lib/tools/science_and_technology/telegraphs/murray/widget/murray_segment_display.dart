part of 'package:gc_wizard/tools/science_and_technology/telegraphs/murray/widget/murray.dart';

const _INITIAL_SEGMENTS = <String, bool>{'1': false, '4': false, '2': false, '5': false, '3': false, '6': false};

const _MURRAY_RELATIVE_DISPLAY_WIDTH = 50;
const _MURRAY_RELATIVE_DISPLAY_HEIGHT = 110;
const _MURRAY_RADIUS = 10.0;

class _MurraySegmentDisplay extends NSegmentDisplay {
  _MurraySegmentDisplay({
      required super.segments,
      super.readOnly,
      super.onChanged})
      : super(
            initialSegments: _INITIAL_SEGMENTS,
            type: SegmentDisplayType.CUSTOM,
            customPaint: (GCWTouchCanvas canvas, Size size, Map<String, bool> currentSegments, Function setSegmentState,
                Color segment_color_on, Color segment_color_off) {
              var paint = defaultSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;

              const shutters = {
                '1': [5, 20],
                '2': [25, 20],
                '3': [5, 50],
                '4': [25, 50],
                '5': [5, 80],
                '6': [25, 80]
              };
              var pointSize = size.height / _MURRAY_RELATIVE_DISPLAY_HEIGHT * _MURRAY_RADIUS;

              paint.color = Colors.black;
              shutters.forEach((key, value) {
                canvas.touchCanvas.drawRect(
                    Offset(size.width / _MURRAY_RELATIVE_DISPLAY_WIDTH * (value[0] - 1),
                            size.height / _MURRAY_RELATIVE_DISPLAY_HEIGHT * (value[1]) - 1) &
                        Size(pointSize * 3 + 2, pointSize * 2 + 2),
                    paint);

                if (size.height < NSegmentDisplay.MIN_HEIGHT) return;
              });

              shutters.forEach((key, value) {
                paint.color = segmentActive(currentSegments, key) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
                canvas.touchCanvas.drawRect(
                    Offset(size.width / _MURRAY_RELATIVE_DISPLAY_WIDTH * value[0],
                            size.height / _MURRAY_RELATIVE_DISPLAY_HEIGHT * value[1]) &
                        Size(pointSize * 3, pointSize * 2),
                    paint, onTapDown: (tapDetail) {
                  setSegmentState(key, !segmentActive(currentSegments, key));
                });

                if (size.height < NSegmentDisplay.MIN_HEIGHT) return;
              });
            });
}
