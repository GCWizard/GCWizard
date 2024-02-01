part of 'package:gc_wizard/tools/crypto_and_encodings/shadoks_numbers/widget/shadoks_numbers.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a': true,
  'b': false,
  'c': false,
  'd': false,
};

const _SHADOKS_RELATIVE_DISPLAY_WIDTH = 100;
const _SHADOKS_RELATIVE_DISPLAY_HEIGHT = 100;

const _TRANSPARENT_COLOR = Color.fromARGB(0, 0, 0, 0);

double _relativeX(Size size, double x) {
  return size.width / _SHADOKS_RELATIVE_DISPLAY_WIDTH * x;
}

double _relativeY(Size size, double y) {
  return size.height / _SHADOKS_RELATIVE_DISPLAY_HEIGHT * y;
}

class _ShadoksNumbersSegmentDisplay extends NSegmentDisplay {
  _ShadoksNumbersSegmentDisplay(
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
            aspectRatio: _SHADOKS_RELATIVE_DISPLAY_WIDTH / _SHADOKS_RELATIVE_DISPLAY_HEIGHT,
            type: SegmentDisplayType.CUSTOM,
            customPaint: (GCWTouchCanvas canvas, Size size, Map<String, bool> currentSegments, Function setSegmentState,
                Color segment_color_on, Color segment_color_off) {
              var paint = defaultSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;

              paint.color = segmentActive(currentSegments, 'b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              paint.style = PaintingStyle.stroke;
              paint.strokeWidth = size.height > 100 ? 7.0 : 3.5;

              var elements = {
                'b': [80.0, 20.0, 0.0, 60.0],
                'c': [80.0, 80.0, -60.0, 0.0],
                'd': [20.0, 80.0, 60.0, -60.0]
              };

              elements.forEach((key, value) {
                var path = Path();

                paint.color = segmentActive(currentSegments, key) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;

                path.moveTo(_relativeX(size, value[0]), _relativeY(size, value[1]));
                path.relativeLineTo(_relativeX(size, value[2]), _relativeY(size, value[3]));
                canvas.touchCanvas.drawPath(path, paint);
              });

              paint.color = segmentActive(currentSegments, 'a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              paint.style = PaintingStyle.stroke;

              paint.strokeWidth = size.height > 100 ? 6.0 : 3.0;
              canvas.touchCanvas
                  .drawCircle(Offset(_relativeX(size, 50), _relativeY(size, 50)), _relativeX(size, 43), paint);

              paint.color = _TRANSPARENT_COLOR;
              paint.style = PaintingStyle.fill;

              canvas.touchCanvas
                  .drawCircle(Offset(_relativeX(size, 50), _relativeY(size, 50)), _relativeX(size, 55), paint,
                      onTapDown: (tapDetail) {
                if (segmentActive(currentSegments, 'a')) return;

                setSegmentState('a', !segmentActive(currentSegments, 'a'));
                setSegmentState('b', false);
                setSegmentState('c', false);
                setSegmentState('d', false);
              });

              elements = {
                'b': [75.0, 15.0, 0.0, 70.0, 10.0, 0.0, 0.0, -70.0],
                'c': [85.0, 85.0, -70.0, 0.0, 0.0, -10.0, 70.0, 0.0],
                'd': [79.0, 11.0, 9.0, 9.0, -69.0, 69.0, -9.0, -9.0]
              };

              elements.forEach((key, value) {
                var path = Path();
                path.moveTo(_relativeX(size, value[0]), _relativeY(size, value[1]));
                path.relativeLineTo(_relativeX(size, value[2]), _relativeY(size, value[3]));
                path.relativeLineTo(_relativeX(size, value[4]), _relativeY(size, value[5]));
                path.relativeLineTo(_relativeX(size, value[6]), _relativeY(size, value[7]));
                path.close();
                canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
                  setSegmentState(key, !segmentActive(currentSegments, key));
                  setSegmentState(
                      'a', ['b', 'c', 'd'].where((elem) => segmentActive(currentSegments, elem)).toList().isEmpty);
                });
              });
            });
}
