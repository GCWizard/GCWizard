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

final _TRANSPARENT_COLOR = Color.fromARGB(0, 0, 0, 0);

class _BabylonNumbersSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  _BabylonNumbersSegmentDisplay(
      {Key key,
      this.segments,
      this.readOnly: false,
      this.onChanged,
      this.tapeStyle: false})
      : super(
            key: key,
            initialSegments: _INITIAL_SEGMENTS,
            aspectRatio: _BABYLON_RELATIVE_DISPLAY_WIDTH /
                _BABYLON_RELATIVE_DISPLAY_HEIGHT,
            segments: segments,
            readOnly: readOnly,
            onChanged: onChanged,
            type: SegmentDisplayType.CUSTOM,
            customPaint: (GCWTouchCanvas canvas,
                Size size,
                Map<String, bool> currentSegments,
                Function setSegmentState,
                Color segment_color_on,
                Color segment_color_off) {
              var paint = sketchSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;
              paint.strokeWidth = 3;

              [
                {'segment': 'a', 'startX': 30.0, 'startY': 40.0},
                {'segment': 'b', 'startX': 60.0, 'startY': 20.0},
                {'segment': 'c', 'startX': 60.0, 'startY': 60.0},
                {'segment': 'd', 'startX': 90.0, 'startY': 0.0},
                {'segment': 'e', 'startX': 90.0, 'startY': 40.0}
              ].forEach((element) {
                paint.color = currentSegments[element['segment']]
                    ? SEGMENTS_COLOR_ON
                    : SEGMENTS_COLOR_OFF; // 10
                var path = Path();

                double startX = element['startX'];
                double startY = element['startY'];

                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(
                    _relativeX(size, -20), _relativeY(size, 20));
                path.relativeLineTo(_relativeX(size, 20), _relativeY(size, 20));

                path.moveTo(
                    _relativeX(size, startX - 5), _relativeY(size, startY + 5));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 30));
                canvas.touchCanvas.drawPath(path, paint);

                paint.color = _TRANSPARENT_COLOR;
                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, -20), _relativeY(size, 0));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 40));
                path.relativeLineTo(_relativeX(size, 20), _relativeY(size, 0));
                path.close();

                canvas.touchCanvas.drawPath(path, paint,
                    onTapDown: (tapDetail) {
                  setSegmentState(
                      element['segment'], !currentSegments[element['segment']]);
                });
              });

              [
                {'segment': 'f', 'startX': 110.0, 'startY': 10.0},
                {'segment': 'g', 'startX': 140.0, 'startY': 10.0},
                {'segment': 'h', 'startX': 170.0, 'startY': 10.0},
                {'segment': 'i', 'startX': 110.0, 'startY': 40.0},
                {'segment': 'j', 'startX': 140.0, 'startY': 40.0},
                {'segment': 'k', 'startX': 170.0, 'startY': 40.0},
                {'segment': 'l', 'startX': 110.0, 'startY': 70.0},
                {'segment': 'm', 'startX': 140.0, 'startY': 70.0},
                {'segment': 'n', 'startX': 170.0, 'startY': 70.0}
              ].forEach((element) {
                paint.color = currentSegments[element['segment']]
                    ? SEGMENTS_COLOR_ON
                    : SEGMENTS_COLOR_OFF; // 10
                var path = Path();

                double startX = element['startX'];
                double startY = element['startY'];

                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, 10), _relativeY(size, 10));
                path.moveTo(_relativeX(size, startX + 10),
                    _relativeY(size, startY + 10));
                path.relativeLineTo(
                    _relativeX(size, 10), _relativeY(size, -10));
                path.moveTo(_relativeX(size, startX), _relativeY(size, startY));
                path.relativeLineTo(_relativeX(size, 20), _relativeY(size, 0));

                path.moveTo(_relativeX(size, startX + 10),
                    _relativeY(size, startY + 10));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 10));
                canvas.touchCanvas.drawPath(path, paint);

                paint.color = _TRANSPARENT_COLOR;
                path.moveTo(
                    _relativeX(size, startX - 5), _relativeY(size, startY - 5));
                path.relativeLineTo(_relativeX(size, 30), _relativeY(size, 0));
                path.relativeLineTo(_relativeX(size, 0), _relativeY(size, 30));
                path.relativeLineTo(_relativeX(size, -30), _relativeY(size, 0));
                path.close();

                canvas.touchCanvas.drawPath(path, paint,
                    onTapDown: (tapDetail) {
                  setSegmentState(
                      element['segment'], !currentSegments[element['segment']]);
                });
              });
            });
}
