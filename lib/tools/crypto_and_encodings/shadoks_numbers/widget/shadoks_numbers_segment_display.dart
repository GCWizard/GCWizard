part of 'package:gc_wizard/tools/crypto_and_encodings/shadoks_numbers/widget/shadoks_numbers.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a': true,
  'b': false,
  'c': false,
  'd': false,
};

const _SHADOKS_RELATIVE_DISPLAY_WIDTH = 100;
const _SHADOKS_RELATIVE_DISPLAY_HEIGHT = 100;

final _TRANSPARENT_COLOR = Color.fromARGB(0, 0, 0, 0);

double _relativeX(Size size, double x) {
  return size.width / _SHADOKS_RELATIVE_DISPLAY_WIDTH * x;
}

double _relativeY(Size size, double y) {
  return size.height / _SHADOKS_RELATIVE_DISPLAY_HEIGHT * y;
}

class _ShadoksNumbersSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  _ShadoksNumbersSegmentDisplay({Key key, this.segments, this.readOnly: false, this.onChanged, this.tapeStyle: false})
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

              paint.color = currentSegments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              paint.style = PaintingStyle.stroke;
              paint.strokeWidth = size.height > 100 ? 7.0 : 3.5;

              [
                [80.0, 20.0, 0.0, 60.0, 'b'],
                [80.0, 80.0, -60.0, 0.0, 'c'],
                [20.0, 80.0, 60.0, -60.0, 'd']
              ].forEach((element) {
                var path = Path();

                paint.color = currentSegments[element[4]] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;

                path.moveTo(_relativeX(size, element[0]), _relativeY(size, element[1]));
                path.relativeLineTo(_relativeX(size, element[2]), _relativeY(size, element[3]));
                canvas.touchCanvas.drawPath(path, paint);
              });

              paint.color = currentSegments['a'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              paint.style = PaintingStyle.stroke;

              paint.strokeWidth = size.height > 100 ? 6.0 : 3.0;
              canvas.touchCanvas
                  .drawCircle(Offset(_relativeX(size, 50), _relativeY(size, 50)), _relativeX(size, 43), paint);

              paint.color = _TRANSPARENT_COLOR;
              paint.style = PaintingStyle.fill;

              canvas.touchCanvas
                  .drawCircle(Offset(_relativeX(size, 50), _relativeY(size, 50)), _relativeX(size, 55), paint,
                      onTapDown: (tapDetail) {
                if (currentSegments['a']) return;

                setSegmentState('a', !currentSegments['a']);
                setSegmentState('b', false);
                setSegmentState('c', false);
                setSegmentState('d', false);
              });

              [
                [75.0, 15.0, 0.0, 70.0, 10.0, 0.0, 0.0, -70.0, 'b'],
                [85.0, 85.0, -70.0, 0.0, 0.0, -10.0, 70.0, 0.0, 'c'],
                [79.0, 11.0, 9.0, 9.0, -69.0, 69.0, -9.0, -9.0, 'd']
              ].forEach((element) {
                var path = Path();
                path.moveTo(_relativeX(size, element[0]), _relativeY(size, element[1]));
                path.relativeLineTo(_relativeX(size, element[2]), _relativeY(size, element[3]));
                path.relativeLineTo(_relativeX(size, element[4]), _relativeY(size, element[5]));
                path.relativeLineTo(_relativeX(size, element[6]), _relativeY(size, element[7]));
                path.close();
                canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
                  setSegmentState(element[8], !currentSegments[element[8]]);
                  setSegmentState('a', ['b', 'c', 'd'].where((elem) => currentSegments[elem]).toList().length == 0);
                });
              });
            });
}
