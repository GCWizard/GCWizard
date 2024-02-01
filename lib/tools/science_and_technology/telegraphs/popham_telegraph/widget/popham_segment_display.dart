part of 'package:gc_wizard/tools/science_and_technology/telegraphs/popham_telegraph/widget/popham_telegraph.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  '1': false,
  '2': false,
  '3': false,
  '4': false,
  '5': false,
  '6': false,
  'a': false,
  'b': false,
  'c': false,
  'd': false,
  'e': false,
  'f': false,
};

const _POPHAM_RELATIVE_DISPLAY_WIDTH = 110;
const _POPHAM_RELATIVE_DISPLAY_HEIGHT = 130;

class _PophamTelegraphSegmentDisplay extends NSegmentDisplay {
  _PophamTelegraphSegmentDisplay(
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
              var path00 = Path();
              path00.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 0, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 160);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 160);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 120);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 100);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 50);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 30);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 30);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 50);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 100);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 120);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 160);
              path00.lineTo(size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 160);
              path00.lineTo(size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 170);
              path00.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 0, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 170);
              path00.close();
              canvas.touchCanvas.drawPath(path00, paint);

              paint.color = segmentActive(currentSegments, '1') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path10 = Path();
              path10.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path10.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 50);
              path10.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 20, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 70);
              path10.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 62);
              path10.close();

              if (!readOnly || segmentActive(currentSegments, '1')) {
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('1', !segmentActive(currentSegments, '1'));
                });
              }

              paint.color = segmentActive(currentSegments, '2') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path20 = Path();
              path20.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path20.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path20.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path20.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path20.close();

              if (!readOnly || segmentActive(currentSegments, '2')) {
                canvas.touchCanvas.drawPath(path20, paint, onTapDown: (tapDetail) {
                  setSegmentState('2', !segmentActive(currentSegments, '2'));
                });
              }

              paint.color = segmentActive(currentSegments, '3') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path30 = Path();
              path30.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 30);
              path30.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 20, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 10);
              path30.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 15);
              path30.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path30.close();

              if (!readOnly || segmentActive(currentSegments, '3')) {
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('3', !segmentActive(currentSegments, '3'));
                });
              }

              paint.color = segmentActive(currentSegments, '4') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path40 = Path();
              path40.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 30);
              path40.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 80, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 10);
              path40.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 15);
              path40.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path40.close();

              if (!readOnly || segmentActive(currentSegments, '4')) {
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('4', !segmentActive(currentSegments, '4'));
                });
              }

              paint.color = segmentActive(currentSegments, '5') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path50 = Path();
              path50.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path50.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path50.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path50.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path50.close();

              if (!readOnly || segmentActive(currentSegments, '5')) {
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('5', !segmentActive(currentSegments, '5'));
                });
              }

              paint.color = segmentActive(currentSegments, '6') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path60 = Path();
              path60.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 50);
              path60.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 45);
              path60.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 60);
              path60.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 80, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 70);
              path60.close();

              if (!readOnly || segmentActive(currentSegments, '6')) {
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('6', !segmentActive(currentSegments, '6'));
                });
              }

              paint.color = segmentActive(currentSegments, 'a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var patha0 = Path();
              patha0.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              patha0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 120);
              patha0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 20, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 140);
              patha0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 130);
              patha0.close();

              if (!readOnly || segmentActive(currentSegments, 'a')) {
                canvas.touchCanvas.drawPath(patha0, paint, onTapDown: (tapDetail) {
                  setSegmentState('a', !segmentActive(currentSegments, 'a'));
                });
              }

              paint.color = segmentActive(currentSegments, 'b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathb0 = Path();
              pathb0.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              pathb0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              pathb0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              pathb0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              pathb0.close();

              if (!readOnly || segmentActive(currentSegments, 'b')) {
                canvas.touchCanvas.drawPath(pathb0, paint, onTapDown: (tapDetail) {
                  setSegmentState('b', !segmentActive(currentSegments, 'b'));
                });
              }

              paint.color = segmentActive(currentSegments, 'c') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathc0 = Path();
              pathc0.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 100);
              pathc0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 20, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 80);
              pathc0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 90);
              pathc0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              pathc0.close();

              if (!readOnly || segmentActive(currentSegments, 'c')) {
                canvas.touchCanvas.drawPath(pathc0, paint, onTapDown: (tapDetail) {
                  setSegmentState('c', !segmentActive(currentSegments, 'c'));
                });
              }

              paint.color = segmentActive(currentSegments, 'd') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathd0 = Path();
              pathd0.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 100);
              pathd0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              pathd0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 90);
              pathd0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 80, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 80);
              pathd0.close();

              if (!readOnly || segmentActive(currentSegments, 'd')) {
                canvas.touchCanvas.drawPath(pathd0, paint, onTapDown: (tapDetail) {
                  setSegmentState('d', !segmentActive(currentSegments, 'd'));
                });
              }

              paint.color = segmentActive(currentSegments, 'e') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathe0 = Path();
              pathe0.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              pathe0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 105);
              pathe0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              pathe0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              pathe0.close();

              if (!readOnly || segmentActive(currentSegments, 'e')) {
                canvas.touchCanvas.drawPath(pathe0, paint, onTapDown: (tapDetail) {
                  setSegmentState('e', !segmentActive(currentSegments, 'e'));
                });
              }

              paint.color = segmentActive(currentSegments, 'f') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathf0 = Path();
              pathf0.moveTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 55, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 120);
              pathf0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 60, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 115);
              pathf0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 90, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 130);
              pathf0.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 80, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 140);
              pathf0.close();

              if (!readOnly || segmentActive(currentSegments, 'f')) {
                canvas.touchCanvas.drawPath(pathf0, paint, onTapDown: (tapDetail) {
                  setSegmentState('f', !segmentActive(currentSegments, 'f'));
                });
              }
            });
}
