part of 'package:gc_wizard/tools/science_and_technology/telegraphs/foy_breguet/widget/foy_breguet.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  '10': false,
  '50': false,
  '1l': false,
  '5l': false,
  '1r': false,
  '5r': false,
  '1o': false,
  '5o': false,
  '1u': false,
  '5u': false,
  '1a': false,
  '5a': false,
  '1b': false,
  '5b': false,
};

const _CHAPPE_RELATIVE_DISPLAY_WIDTH = 180;
const _CHAPPE_RELATIVE_DISPLAY_HEIGHT = 200;

class _FoyBreguetTelegraphSegmentDisplay extends NSegmentDisplay {
  _FoyBreguetTelegraphSegmentDisplay(
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

              paint.color = Colors.grey;
              canvas.touchCanvas.drawCircle(
                  Offset(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95,
                      size.height / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 74),
                  size.height / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 13.0,
                  paint);

              var path00 = Path();
              path00.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path00.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path00.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 220);
              path00.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 220);
              path00.close();
              canvas.touchCanvas.drawPath(path00, paint);

              paint.color = segmentActive(currentSegments, '10') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path10 = Path();
              path10.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path10.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path10.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path10.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path10.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path10.close();

              if (!readOnly || segmentActive(currentSegments, '10')) {
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('10', !segmentActive(currentSegments, '10'));
                });
              }

              paint.color = segmentActive(currentSegments, '1l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path1l = Path();
              path1l.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path1l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path1l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path1l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path1l.close();

              if (!readOnly || segmentActive(currentSegments, '1l')) {
                canvas.touchCanvas.drawPath(path1l, paint, onTapDown: (tapDetail) {
                  setSegmentState('1l', !segmentActive(currentSegments, '1l'));
                });
              }

              paint.color = segmentActive(currentSegments, '1r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path1r = Path();
              path1r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path1r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path1r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path1r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path1r.close();

              if (!readOnly || segmentActive(currentSegments, '1r')) {
                canvas.touchCanvas.drawPath(path1r, paint, onTapDown: (tapDetail) {
                  setSegmentState('1r', !segmentActive(currentSegments, '1r'));
                });
              }

              paint.color = segmentActive(currentSegments, '1o') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path1o = Path();
              path1o.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path1o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path1o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 60, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path1o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path1o.close();

              if (!readOnly || segmentActive(currentSegments, '1o')) {
                canvas.touchCanvas.drawPath(path1o, paint, onTapDown: (tapDetail) {
                  setSegmentState('1o', !segmentActive(currentSegments, '1o'));
                });
              }

              paint.color = segmentActive(currentSegments, '1u') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path1u = Path();
              path1u.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 30, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path1u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path1u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 60, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path1u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path1u.close();

              if (!readOnly || segmentActive(currentSegments, '1u')) {
                canvas.touchCanvas.drawPath(path1u, paint, onTapDown: (tapDetail) {
                  setSegmentState('1u', !segmentActive(currentSegments, '1u'));
                });
              }

              paint.color = segmentActive(currentSegments, '1a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path1a = Path();
              path1a.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path1a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 0, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path1a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 10, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path1a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path1a.close();

              if (!readOnly || segmentActive(currentSegments, '1a')) {
                canvas.touchCanvas.drawPath(path1a, paint, onTapDown: (tapDetail) {
                  setSegmentState('1a', !segmentActive(currentSegments, '1a'));
                });
              }

              paint.color = segmentActive(currentSegments, '1b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path1b = Path();
              path1b.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path1b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 0, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path1b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 10, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path1b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path1b.close();

              if (!readOnly || segmentActive(currentSegments, '1b')) {
                canvas.touchCanvas.drawPath(path1b, paint, onTapDown: (tapDetail) {
                  setSegmentState('1b', !segmentActive(currentSegments, '1b'));
                });
              }

              paint.color = segmentActive(currentSegments, '50') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path50 = Path();
              path50.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path50.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path50.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path50.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path50.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path50.close();

              if (!readOnly || segmentActive(currentSegments, '50')) {
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('50', !segmentActive(currentSegments, '50'));
                });
              }

              paint.color = segmentActive(currentSegments, '5l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path5l = Path();
              path5l.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path5l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path5l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path5l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path5l.close();

              if (!readOnly || segmentActive(currentSegments, '5l')) {
                canvas.touchCanvas.drawPath(path5l, paint, onTapDown: (tapDetail) {
                  setSegmentState('5l', !segmentActive(currentSegments, '5l'));
                });
              }

              paint.color = segmentActive(currentSegments, '5r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path5r = Path();
              path5r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path5r.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path5r.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path5r.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path5r.close();

              if (!readOnly || segmentActive(currentSegments, '5r')) {
                canvas.touchCanvas.drawPath(path5r, paint, onTapDown: (tapDetail) {
                  setSegmentState('5r', !segmentActive(currentSegments, '5r'));
                });
              }

              paint.color = segmentActive(currentSegments, '5o') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path5o = Path();
              path5o.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 130, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path5o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path5o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path5o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path5o.close();

              if (!readOnly || segmentActive(currentSegments, '5o')) {
                canvas.touchCanvas.drawPath(path5o, paint, onTapDown: (tapDetail) {
                  setSegmentState('5o', !segmentActive(currentSegments, '5o'));
                });
              }

              paint.color = segmentActive(currentSegments, '5u') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path5u = Path();
              path5u.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 130,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path5u.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path5u.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 160,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path5u.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path5u.close();

              if (!readOnly || segmentActive(currentSegments, '5u')) {
                canvas.touchCanvas.drawPath(path5u, paint, onTapDown: (tapDetail) {
                  setSegmentState('5u', !segmentActive(currentSegments, '5u'));
                });
              }

              paint.color = segmentActive(currentSegments, '5a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path5a = Path();
              path5a.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 190, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path5a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 180, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 70);
              path5a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path5a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path5a.close();

              if (!readOnly || segmentActive(currentSegments, '5a')) {
                canvas.touchCanvas.drawPath(path5a, paint, onTapDown: (tapDetail) {
                  setSegmentState('5a', !segmentActive(currentSegments, '5a'));
                });
              }

              paint.color = segmentActive(currentSegments, '5b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path5b = Path();
              path5b.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 190,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path5b.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 180,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 120);
              path5b.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path5b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 95);
              path5b.close();

              if (!readOnly || segmentActive(currentSegments, '5b')) {
                canvas.touchCanvas.drawPath(path5b, paint, onTapDown: (tapDetail) {
                  setSegmentState('5b', !segmentActive(currentSegments, '5b'));
                });
              }
            });
}
