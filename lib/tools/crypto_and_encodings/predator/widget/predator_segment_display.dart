part of 'package:gc_wizard/tools/crypto_and_encodings/predator/widget/predator.dart';

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
};

const _PREDATOR_RELATIVE_DISPLAY_WIDTH = 170; //110;
const _PREDATOR_RELATIVE_DISPLAY_HEIGHT = 300; //100;

class _PredatorSegmentDisplay extends NSegmentDisplay {
  _PredatorSegmentDisplay(
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

              paint.color = segmentActive(currentSegments, 'a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA = Path();
              pathA.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 0,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 98);
              pathA.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 98);
              pathA.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 113);
              pathA.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 0,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 113);
              pathA.close();

              if (!readOnly || segmentActive(currentSegments, 'a')) {
                canvas.touchCanvas.drawPath(pathA, paint, onTapDown: (tapDetail) {
                  setSegmentState('a', !segmentActive(currentSegments, 'a'));
                });
              }

              paint.color = segmentActive(currentSegments, 'b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB = Path();
              pathB.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 70,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 0);
              pathB.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 0);
              pathB.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 80);
              pathB.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 70,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 80);
              pathB.close();

              if (!readOnly || segmentActive(currentSegments, 'b')) {
                canvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
                  setSegmentState('b', !segmentActive(currentSegments, 'b'));
                });
              }

              paint.color = segmentActive(currentSegments, 'c') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC = Path();
              pathC.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 80);
              pathC.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 130,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 40);
              pathC.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 90);
              pathC.close();

              if (!readOnly || segmentActive(currentSegments, 'c')) {
                canvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
                  setSegmentState('c', !segmentActive(currentSegments, 'c'));
                });
              }

              paint.color = segmentActive(currentSegments, 'd') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathD = Path();
              pathD.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 98);
              pathD.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 98);
              pathD.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 150,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 113);
              pathD.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 113);
              pathD.close();

              if (!readOnly || segmentActive(currentSegments, 'd')) {
                canvas.touchCanvas.drawPath(pathD, paint, onTapDown: (tapDetail) {
                  setSegmentState('d', !segmentActive(currentSegments, 'd'));
                });
              }

              paint.color = segmentActive(currentSegments, 'e') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathE = Path();
              pathE.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 120);
              pathE.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 130);
              pathE.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 170);
              pathE.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 160);
              pathE.close();

              if (!readOnly || segmentActive(currentSegments, 'e')) {
                canvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
                  setSegmentState('e', !segmentActive(currentSegments, 'e'));
                });
              }

              paint.color = segmentActive(currentSegments, 'f') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathF = Path();
              pathF.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 130);
              pathF.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 120);
              pathF.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 160);
              pathF.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 130,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 170);
              pathF.close();

              if (!readOnly || segmentActive(currentSegments, 'f')) {
                canvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
                  setSegmentState('f', !segmentActive(currentSegments, 'f'));
                });
              }

              paint.color = segmentActive(currentSegments, 'g') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathG = Path();
              pathG.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 190);
              pathG.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 180);
              pathG.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 220);
              pathG.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 230);
              pathG.close();

              if (!readOnly || segmentActive(currentSegments, 'g')) {
                canvas.touchCanvas.drawPath(pathG, paint, onTapDown: (tapDetail) {
                  setSegmentState('g', !segmentActive(currentSegments, 'g'));
                });
              }

              paint.color = segmentActive(currentSegments, 'h') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathH = Path();
              pathH.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 220);
              pathH.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 130,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 180);
              pathH.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 140,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 190);
              pathH.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 230);
              pathH.close();

              if (!readOnly || segmentActive(currentSegments, 'h')) {
                canvas.touchCanvas.drawPath(pathH, paint, onTapDown: (tapDetail) {
                  setSegmentState('h', !segmentActive(currentSegments, 'h'));
                });
              }

              paint.color = segmentActive(currentSegments, 'i') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathI = Path();
              pathI.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 240);
              pathI.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 240);
              pathI.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 310);
              pathI.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 310);
              pathI.close();

              if (!readOnly || segmentActive(currentSegments, 'i')) {
                canvas.touchCanvas.drawPath(pathI, paint, onTapDown: (tapDetail) {
                  setSegmentState('i', !segmentActive(currentSegments, 'i'));
                });
              }

              paint.color = segmentActive(currentSegments, 'j') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathJ = Path();
              pathJ.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 70,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 240);
              pathJ.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 240);
              pathJ.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 310);
              pathJ.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 70,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 310);
              pathJ.close();

              if (!readOnly || segmentActive(currentSegments, 'j')) {
                canvas.touchCanvas.drawPath(pathJ, paint, onTapDown: (tapDetail) {
                  setSegmentState('j', !segmentActive(currentSegments, 'j'));
                });
              }

              paint.color = segmentActive(currentSegments, 'k') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathK = Path();
              pathK.moveTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 240);
              pathK.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 240);
              pathK.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 310);
              pathK.lineTo(size.width / _PREDATOR_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PREDATOR_RELATIVE_DISPLAY_HEIGHT * 310);
              pathK.close();

              if (!readOnly || segmentActive(currentSegments, 'k')) {
                canvas.touchCanvas.drawPath(pathK, paint, onTapDown: (tapDetail) {
                  setSegmentState('k', !segmentActive(currentSegments, 'k'));
                });
              }
            });
}
