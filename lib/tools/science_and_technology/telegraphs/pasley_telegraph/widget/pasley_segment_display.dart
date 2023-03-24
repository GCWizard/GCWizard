part of 'package:gc_wizard/tools/science_and_technology/telegraphs/pasley_telegraph/widget/pasley_telegraph.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  '1': false,
  '2': false,
  '3': false,
  '4': false,
  '5': false,
  '6': false,
  '7': false,
};

const _PASLEY_RELATIVE_DISPLAY_WIDTH = 180;
const _PASLEY_RELATIVE_DISPLAY_HEIGHT = 200;


class _PasleyTelegraphSegmentDisplay extends NSegmentDisplay {

  _PasleyTelegraphSegmentDisplay({
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

              paint.color = Colors.grey;
              canvas.touchCanvas.drawCircle(
                  Offset(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 95,
                      size.height / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 74),
                  size.height / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 13.0,
                  paint);

              var path00 = Path();
              path00.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 20, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 90, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 90, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 120);
              path00.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 120);
              path00.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 210);
              path00.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 170,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 220);
              path00.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 20, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 220);
              path00.close();

              canvas.touchCanvas.drawPath(path00, paint);

              paint.color = segmentActive(currentSegments, '1') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path10 = Path();
              path10.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 30, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 88);
              path10.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 80, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 88);
              path10.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 80, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 102);
              path10.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 30, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 102);
              path10.close();

              if (!readOnly || segmentActive(currentSegments, '1')) {
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('1', !segmentActive(currentSegments, '1'));
                });
              }

              paint.color = segmentActive(currentSegments, '2') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path20 = Path();
              path20.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 50, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 40);
              path20.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 90, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 80);
              path20.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 80, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 90);
              path20.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 40, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 50);
              path20.close();

              if (!readOnly || segmentActive(currentSegments, '2')) {
                canvas.touchCanvas.drawPath(path20, paint, onTapDown: (tapDetail) {
                  setSegmentState('2', !segmentActive(currentSegments, '2'));
                });
              }

              paint.color = segmentActive(currentSegments, '3') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path30 = Path();
              path30.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 102, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 30);
              path30.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 102, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 80);
              path30.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 88, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 80);
              path30.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 88, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 30);
              path30.close();

              if (!readOnly || segmentActive(currentSegments, '3')) {
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('3', !segmentActive(currentSegments, '3'));
                });
              }

              paint.color = segmentActive(currentSegments, '4') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path40 = Path();
              path40.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 100, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 80);
              path40.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 140, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 40);
              path40.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 150, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 50);
              path40.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 110, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 90);
              path40.close();

              if (!readOnly || segmentActive(currentSegments, '4')) {
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('4', !segmentActive(currentSegments, '4'));
                });
              }

              paint.color = segmentActive(currentSegments, '5') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path50 = Path();
              path50.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 160, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 88);
              path50.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 110, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 88);
              path50.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 102);
              path50.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 160,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 102);
              path50.close();

              if (!readOnly || segmentActive(currentSegments, '5')) {
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('5', !segmentActive(currentSegments, '5'));
                });
              }

              paint.color = segmentActive(currentSegments, '6') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path60 = Path();
              path60.moveTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 110);
              path60.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 110,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 100);
              path60.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 140);
              path60.lineTo(size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 150);
              path60.close();

              if (!readOnly || segmentActive(currentSegments, '6')) {
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('6', !segmentActive(currentSegments, '6'));
                });
              }

              paint.color = segmentActive(currentSegments, '7') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var path70 = Path();
              path70.moveTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 80, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 100);
              path70.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 90, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 110);
              path70.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 50, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 150);
              path70.lineTo(
                  size.width / _PASLEY_RELATIVE_DISPLAY_WIDTH * 40, size.width / _PASLEY_RELATIVE_DISPLAY_HEIGHT * 140);
              path70.close();

              if (!readOnly || segmentActive(currentSegments, '7')) {
                canvas.touchCanvas.drawPath(path70, paint, onTapDown: (tapDetail) {
                  setSegmentState('7', !segmentActive(currentSegments, '7'));
                });
              }
            });
}
