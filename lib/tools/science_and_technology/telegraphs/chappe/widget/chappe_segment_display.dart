part of 'package:gc_wizard/tools/science_and_technology/telegraphs/chappe/widget/chappe.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  '10': false,
  '20': false,
  '30': false,
  '40': false,
  '50': false,
  '60': false,
  '70': false,
  '80': false,
  '1l': false,
  '2l': false,
  '3l': false,
  '4l': false,
  '5l': false,
  '6l': false,
  '7l': false,
  '8l': false,
  '1r': false,
  '2r': false,
  '3r': false,
  '4r': false,
  '5r': false,
  '6r': false,
  '7r': false,
  '8r': false,
  '1o': false,
  '2o': false,
  '3o': false,
  '4o': false,
  '5o': false,
  '6o': false,
  '7o': false,
  '8o': false,
  '1u': false,
  '2u': false,
  '3u': false,
  '4u': false,
  '5u': false,
  '6u': false,
  '7u': false,
  '8u': false,
  '1a': false,
  '2a': false,
  '3a': false,
  '4a': false,
  '5a': false,
  '6a': false,
  '7a': false,
  '8a': false,
  '1b': false,
  '2b': false,
  '3b': false,
  '4b': false,
  '5b': false,
  '6b': false,
  '7b': false,
  '8b': false,
};

const _CHAPPE_RELATIVE_DISPLAY_WIDTH = 180;
const _CHAPPE_RELATIVE_DISPLAY_HEIGHT = 200;

class _ChappeTelegraphSegmentDisplay extends NSegmentDisplay {
  _ChappeTelegraphSegmentDisplay(
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

              paint.color = segmentActive(currentSegments, '20') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path20 = Path();
              path20.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path20.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path20.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path20.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path20.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 50);
              path20.close();

              if (!readOnly || segmentActive(currentSegments, '20')) {
                canvas.touchCanvas.drawPath(path20, paint, onTapDown: (tapDetail) {
                  setSegmentState('20', !segmentActive(currentSegments, '20'));
                });
              }

              paint.color = segmentActive(currentSegments, '2l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path2l = Path();
              path2l.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 60);
              path2l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path2l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 50);
              path2l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 25, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 65);
              path2l.close();

              if (!readOnly || segmentActive(currentSegments, '2l')) {
                canvas.touchCanvas.drawPath(path2l, paint, onTapDown: (tapDetail) {
                  setSegmentState('2l', !segmentActive(currentSegments, '2l'));
                });
              }

              paint.color = segmentActive(currentSegments, '2r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path2r = Path();
              path2r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path2r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 60, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path2r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 65, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 25);
              path2r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path2r.close();

              if (!readOnly || segmentActive(currentSegments, '2r')) {
                canvas.touchCanvas.drawPath(path2r, paint, onTapDown: (tapDetail) {
                  setSegmentState('2r', !segmentActive(currentSegments, '2r'));
                });
              }

              paint.color = segmentActive(currentSegments, '30') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path30 = Path();
              path30.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path30.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path30.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path30.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path30.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path30.close();

              if (!readOnly || segmentActive(currentSegments, '30')) {
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('30', !segmentActive(currentSegments, '30'));
                });
              }

              paint.color = segmentActive(currentSegments, '3l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path3l = Path();
              path3l.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3l.close();

              if (!readOnly || segmentActive(currentSegments, '3l')) {
                canvas.touchCanvas.drawPath(path3l, paint, onTapDown: (tapDetail) {
                  setSegmentState('3l', !segmentActive(currentSegments, '3l'));
                });
              }

              paint.color = segmentActive(currentSegments, '3r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path3r = Path();
              path3r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3r.close();

              if (!readOnly || segmentActive(currentSegments, '3r')) {
                canvas.touchCanvas.drawPath(path3r, paint, onTapDown: (tapDetail) {
                  setSegmentState('3r', !segmentActive(currentSegments, '3r'));
                });
              }

              paint.color = segmentActive(currentSegments, '3a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path3a = Path();
              path3a.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 0);
              path3a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 10);
              path3a.close();

              if (!readOnly || segmentActive(currentSegments, '3a')) {
                canvas.touchCanvas.drawPath(path3a, paint, onTapDown: (tapDetail) {
                  setSegmentState('3a', !segmentActive(currentSegments, '3a'));
                });
              }

              paint.color = segmentActive(currentSegments, '3b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path3b = Path();
              path3b.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 0);
              path3b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path3b.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 10);
              path3b.close();

              if (!readOnly || segmentActive(currentSegments, '3b')) {
                canvas.touchCanvas.drawPath(path3b, paint, onTapDown: (tapDetail) {
                  setSegmentState('3b', !segmentActive(currentSegments, '3b'));
                });
              }

              paint.color = segmentActive(currentSegments, '3u') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path3u = Path();
              path3u.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 50);
              path3u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path3u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3u.close();

              if (!readOnly || segmentActive(currentSegments, '3u')) {
                canvas.touchCanvas.drawPath(path3u, paint, onTapDown: (tapDetail) {
                  setSegmentState('3u', !segmentActive(currentSegments, '3u'));
                });
              }

              paint.color = segmentActive(currentSegments, '3o') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path3o = Path();
              path3o.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 50);
              path3o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path3o.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 30);
              path3o.close();

              if (!readOnly || segmentActive(currentSegments, '3o')) {
                canvas.touchCanvas.drawPath(path3o, paint, onTapDown: (tapDetail) {
                  setSegmentState('3o', !segmentActive(currentSegments, '3o'));
                });
              }

              paint.color = segmentActive(currentSegments, '40') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path40 = Path();
              path40.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 80);
              path40.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path40.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path40.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 50);
              path40.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 90);
              path40.close();

              if (!readOnly || segmentActive(currentSegments, '40')) {
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('40', !segmentActive(currentSegments, '40'));
                });
              }

              paint.color = segmentActive(currentSegments, '4l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path4l = Path();
              path4l.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path4l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 130, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 20);
              path4l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 125, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 25);
              path4l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path4l.close();

              if (!readOnly || segmentActive(currentSegments, '4l')) {
                canvas.touchCanvas.drawPath(path4l, paint, onTapDown: (tapDetail) {
                  setSegmentState('4l', !segmentActive(currentSegments, '4l'));
                });
              }

              paint.color = segmentActive(currentSegments, '4r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path4r = Path();
              path4r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 40);
              path4r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 60);
              path4r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 165, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 65);
              path4r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 50);
              path4r.close();

              if (!readOnly || segmentActive(currentSegments, '4r')) {
                canvas.touchCanvas.drawPath(path4r, paint, onTapDown: (tapDetail) {
                  setSegmentState('4r', !segmentActive(currentSegments, '4r'));
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

              paint.color = segmentActive(currentSegments, '60') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path60 = Path();
              path60.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path60.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path60.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 140);
              path60.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path60.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path60.close();

              if (!readOnly || segmentActive(currentSegments, '60')) {
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('60', !segmentActive(currentSegments, '60'));
                });
              }

              paint.color = segmentActive(currentSegments, '6l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path6l = Path();
              path6l.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path6l.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 130);
              path6l.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 165,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 125);
              path6l.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 140);
              path6l.close();

              if (!readOnly || segmentActive(currentSegments, '6l')) {
                canvas.touchCanvas.drawPath(path6l, paint, onTapDown: (tapDetail) {
                  setSegmentState('6l', !segmentActive(currentSegments, '6l'));
                });
              }

              paint.color = segmentActive(currentSegments, '6r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path6r = Path();
              path6r.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path6r.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 130,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path6r.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 125,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 165);
              path6r.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path6r.close();

              if (!readOnly || segmentActive(currentSegments, '6r')) {
                canvas.touchCanvas.drawPath(path6r, paint, onTapDown: (tapDetail) {
                  setSegmentState('6r', !segmentActive(currentSegments, '6r'));
                });
              }

              paint.color = segmentActive(currentSegments, '70') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path70 = Path();
              path70.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path70.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path70.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path70.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path70.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path70.close();

              if (!readOnly || segmentActive(currentSegments, '70')) {
                canvas.touchCanvas.drawPath(path70, paint, onTapDown: (tapDetail) {
                  setSegmentState('70', !segmentActive(currentSegments, '70'));
                });
              }

              paint.color = segmentActive(currentSegments, '7l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path7l = Path();
              path7l.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7l.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7l.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7l.close();

              if (!readOnly || segmentActive(currentSegments, '7l')) {
                canvas.touchCanvas.drawPath(path7l, paint, onTapDown: (tapDetail) {
                  setSegmentState('7l', !segmentActive(currentSegments, '7l'));
                });
              }

              paint.color = segmentActive(currentSegments, '7r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path7r = Path();
              path7r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 95, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7r.close();

              if (!readOnly || segmentActive(currentSegments, '7r')) {
                canvas.touchCanvas.drawPath(path7r, paint, onTapDown: (tapDetail) {
                  setSegmentState('7r', !segmentActive(currentSegments, '7r'));
                });
              }

              paint.color = segmentActive(currentSegments, '7a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path7a = Path();
              path7a.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 190);
              path7a.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 180);
              path7a.close();

              if (!readOnly || segmentActive(currentSegments, '7a')) {
                canvas.touchCanvas.drawPath(path7a, paint, onTapDown: (tapDetail) {
                  setSegmentState('7a', !segmentActive(currentSegments, '7a'));
                });
              }

              paint.color = segmentActive(currentSegments, '7b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path7b = Path();
              path7b.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7b.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path7b.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 190);
              path7b.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 180);
              path7b.close();

              if (!readOnly || segmentActive(currentSegments, '7b')) {
                canvas.touchCanvas.drawPath(path7b, paint, onTapDown: (tapDetail) {
                  setSegmentState('7b', !segmentActive(currentSegments, '7b'));
                });
              }

              paint.color = segmentActive(currentSegments, '7u') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path7u = Path();
              path7u.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 140);
              path7u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 70, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path7u.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7u.close();

              if (!readOnly || segmentActive(currentSegments, '7u')) {
                canvas.touchCanvas.drawPath(path7u, paint, onTapDown: (tapDetail) {
                  setSegmentState('7u', !segmentActive(currentSegments, '7u'));
                });
              }

              paint.color = segmentActive(currentSegments, '7o') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path7o = Path();
              path7o.moveTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7o.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 140);
              path7o.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 120,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path7o.lineTo(size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 160);
              path7o.close();

              if (!readOnly || segmentActive(currentSegments, '7o')) {
                canvas.touchCanvas.drawPath(path7o, paint, onTapDown: (tapDetail) {
                  setSegmentState('7o', !segmentActive(currentSegments, '7o'));
                });
              }

              paint.color = segmentActive(currentSegments, '80') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path80 = Path();
              path80.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 80, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 100);
              path80.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 90, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 110);
              path80.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path80.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path80.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 140);
              path80.close();

              if (!readOnly || segmentActive(currentSegments, '80')) {
                canvas.touchCanvas.drawPath(path80, paint, onTapDown: (tapDetail) {
                  setSegmentState('80', !segmentActive(currentSegments, '80'));
                });
              }

              paint.color = segmentActive(currentSegments, '8l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path8l = Path();
              path8l.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path8l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 60, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 170);
              path8l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 65, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 165);
              path8l.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 50, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path8l.close();

              if (!readOnly || segmentActive(currentSegments, '8l')) {
                canvas.touchCanvas.drawPath(path8l, paint, onTapDown: (tapDetail) {
                  setSegmentState('8l', !segmentActive(currentSegments, '8l'));
                });
              }

              paint.color = segmentActive(currentSegments, '8r') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path8r = Path();
              path8r.moveTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 150);
              path8r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 20, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 130);
              path8r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 25, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 125);
              path8r.lineTo(
                  size.width / _CHAPPE_RELATIVE_DISPLAY_WIDTH * 40, size.width / _CHAPPE_RELATIVE_DISPLAY_HEIGHT * 140);
              path8r.close();

              if (!readOnly || segmentActive(currentSegments, '8r')) {
                canvas.touchCanvas.drawPath(path8r, paint, onTapDown: (tapDetail) {
                  setSegmentState('8r', !segmentActive(currentSegments, '8r'));
                });
              }
            });
}
