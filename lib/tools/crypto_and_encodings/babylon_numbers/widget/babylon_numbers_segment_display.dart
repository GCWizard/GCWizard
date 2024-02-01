part of 'package:gc_wizard/tools/crypto_and_encodings/babylon_numbers/widget/babylon_numbers.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a': false,
  'b': false,
  'c': false,
  'd': false,
  'e': false,
  'f': false,
  'g': false,
  'h': false,
  'i': false,
  'j': false,
  'k': false,
  'l': false,
  'm': false,
  'n': false,
};

const _BABYLON_RELATIVE_DISPLAY_WIDTH = 200;
const _BABYLON_RELATIVE_DISPLAY_HEIGHT = 100;

double _relativeX(Size size, double x) {
  return size.width / _BABYLON_RELATIVE_DISPLAY_WIDTH * x;
}

double _relativeY(Size size, double y) {
  return size.height / _BABYLON_RELATIVE_DISPLAY_HEIGHT * y;
}

const _TRANSPARENT_COLOR = Color.fromARGB(0, 0, 0, 0);

class _BabylonNumbersSegmentDisplay extends NSegmentDisplay {
  _BabylonNumbersSegmentDisplay(
      {Key? key,
      required Map<String, bool> segments,
      bool readOnly = false,
      void Function(Map<String, bool>)? onChanged})
      : super(
            key: key,
            initialSegments: _INITIAL_SEGMENTS,
            aspectRatio: _BABYLON_RELATIVE_DISPLAY_WIDTH / _BABYLON_RELATIVE_DISPLAY_HEIGHT,
            segments: segments,
            readOnly: false,
            onChanged: onChanged,
            type: SegmentDisplayType.CUSTOM,
            customPaint: (GCWTouchCanvas canvas, Size size, Map<String, bool> currentSegments, Function setSegmentState,
                Color segment_color_on, Color segment_color_off) {
              var paint = sketchSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;
              paint.strokeWidth = 3;

              var elements = {
                'a': [30.0, 40.0],
                'b': [60.0, 20.0],
                'c': [60.0, 60.0],
                'd': [90.0, 0.0],
                'e': [90.0, 40.0],
              };

              elements.forEach((key, value) {
                paint.color = segmentActive(currentSegments, key) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF; // 10
                var path = Path();

                double startX = value[0];
                double startY = value[1];

                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, -20), _relativeY(size, 20));
                path.relativeLineTo(_relativeX(size, 20), _relativeY(size, 20));

                path.moveTo(_relativeX(size, startX - 5), _relativeY(size, startY + 5));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 30));
                canvas.touchCanvas.drawPath(path, paint);

                paint.color = _TRANSPARENT_COLOR;
                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, -20), _relativeY(size, 0));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 40));
                path.relativeLineTo(_relativeX(size, 20), _relativeY(size, 0));
                path.close();

                canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
                  setSegmentState(key, !segmentActive(currentSegments, key));
                });
              });

              elements = {
                'f': [110.0, 10.0],
                'g': [140.0, 10.0],
                'h': [170.0, 10.0],
                'i': [110.0, 40.0],
                'j': [140.0, 40.0],
                'k': [170.0, 40.0],
                'l': [110.0, 70.0],
                'm': [140.0, 70.0],
                'n': [170.0, 70.0],
              };

              elements.forEach((key, value) {
                paint.color = segmentActive(currentSegments, key) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF; // 10
                var path = Path();

                double startX = value[0];
                double startY = value[1];

                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, 10), _relativeY(size, 10));
                path.moveTo(_relativeX(size, startX + 10), _relativeY(size, startY + 10));
                path.relativeLineTo(_relativeX(size, 10), _relativeY(size, -10));
                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, 20), _relativeY(size, 0));

                path.moveTo(_relativeX(size, startX + 10), _relativeY(size, startY + 10));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 10));
                canvas.touchCanvas.drawPath(path, paint);

                paint.color = _TRANSPARENT_COLOR;
                path.moveTo(_relativeX(size, startX - 5), _relativeY(size, startY - 5));
                path.relativeLineTo(_relativeX(size, 30), _relativeY(size, 0));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 30));
                path.relativeLineTo(_relativeX(size, -30), _relativeY(size, 0));
                path.close();

                canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
                  setSegmentState(key, !segmentActive(currentSegments, key));
                });
              });
            });
}
