part of 'package:gc_wizard/tools/science_and_technology/telegraphs/prussia_telegraph/widget/prussia_telegraph.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a1': false,
  'a2': false,
  'a3': false,
  'a4': false,
  'a5': false,
  'a6': false,
  'b1': false,
  'b2': false,
  'b3': false,
  'b4': false,
  'b5': false,
  'b6': false,
  'c1': false,
  'c2': false,
  'c3': false,
  'c4': false,
  'c5': false,
  'c6': false,
};

const _PRUSSIA_RELATIVE_DISPLAY_WIDTH = 120;
const _PRUSSIA_RELATIVE_DISPLAY_HEIGHT = 220;

class PrussiaTelegraphSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  PrussiaTelegraphSegmentDisplay({Key key, this.segments, this.readOnly: false, this.onChanged, this.tapeStyle: false})
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

              paint.color = SEGMENTS_COLOR_ON;
              var path0 = Path();
              path0.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 10);
              path0.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 10);
              path0.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 280);
              path0.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 280);
              path0.close();
              canvas.touchCanvas.drawPath(path0, paint);

              paint.color = currentSegments['c1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC1 = Path();
              pathC1.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 40);
              pathC1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 20);
              pathC1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 30);
              pathC1.close();
              canvas.touchCanvas.drawPath(pathC1, paint, onTapDown: (tapDetail) {
                setSegmentState('c1', !currentSegments['c1']);
                if (currentSegments['c1']) {
                  setSegmentState('c2', false);
                  setSegmentState('c3', false);
                }
              });

              paint.color = currentSegments['c2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC2 = Path();
              pathC2.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 60);
              pathC2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 60);
              pathC2.close();
              canvas.touchCanvas.drawPath(pathC2, paint, onTapDown: (tapDetail) {
                setSegmentState('c2', !currentSegments['c2']);
                if (currentSegments['c2']) {
                  setSegmentState('c1', false);
                  setSegmentState('c3', false);
                }
              });

              paint.color = currentSegments['c3'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC3 = Path();
              pathC3.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 60);
              pathC3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 80);
              pathC3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 90);
              pathC3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 70);
              pathC3.close();
              canvas.touchCanvas.drawPath(pathC3, paint, onTapDown: (tapDetail) {
                setSegmentState('c3', !currentSegments['c3']);
                if (currentSegments['c3']) {
                  setSegmentState('c1', false);
                  setSegmentState('c2', false);
                }
              });

              paint.color = currentSegments['c4'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC4 = Path();
              pathC4.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 60);
              pathC4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 70);
              pathC4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 30,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 90);
              pathC4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 80);
              pathC4.close();
              canvas.touchCanvas.drawPath(pathC4, paint, onTapDown: (tapDetail) {
                setSegmentState('c4', !currentSegments['c4']);
                if (currentSegments['c4']) {
                  setSegmentState('c5', false);
                  setSegmentState('c6', false);
                }
              });

              paint.color = currentSegments['c5'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC5 = Path();
              pathC5.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 60);
              pathC5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 60);
              pathC5.close();
              canvas.touchCanvas.drawPath(pathC5, paint, onTapDown: (tapDetail) {
                setSegmentState('c5', !currentSegments['c5']);
                if (currentSegments['c5']) {
                  setSegmentState('c4', false);
                  setSegmentState('c6', false);
                }
              });

              paint.color = currentSegments['c6'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC6 = Path();
              pathC6.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 30);
              pathC6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 30,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 20);
              pathC6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 40);
              pathC6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 50);
              pathC6.close();
              canvas.touchCanvas.drawPath(pathC6, paint, onTapDown: (tapDetail) {
                setSegmentState('c6', !currentSegments['c6']);
                if (currentSegments['c6']) {
                  setSegmentState('c4', false);
                  setSegmentState('c5', false);
                }
              });

              paint.color = currentSegments['b1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB1 = Path();
              pathB1.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 120);
              pathB1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 100);
              pathB1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 110);
              pathB1.close();
              canvas.touchCanvas.drawPath(pathB1, paint, onTapDown: (tapDetail) {
                setSegmentState('b1', !currentSegments['b1']);
                if (currentSegments['b1']) {
                  setSegmentState('b2', false);
                  setSegmentState('b3', false);
                }
              });

              paint.color = currentSegments['b2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB2 = Path();
              pathB2.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 140);
              pathB2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 140);
              pathB2.close();
              canvas.touchCanvas.drawPath(pathB2, paint, onTapDown: (tapDetail) {
                setSegmentState('b2', !currentSegments['b2']);
                if (currentSegments['b2']) {
                  setSegmentState('b1', false);
                  setSegmentState('b3', false);
                }
              });

              paint.color = currentSegments['b3'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB3 = Path();
              pathB3.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 140);
              pathB3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 160);
              pathB3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 170);
              pathB3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 150);
              pathB3.close();
              canvas.touchCanvas.drawPath(pathB3, paint, onTapDown: (tapDetail) {
                setSegmentState('b3', !currentSegments['b3']);
                if (currentSegments['b3']) {
                  setSegmentState('b1', false);
                  setSegmentState('b2', false);
                }
              });

              paint.color = currentSegments['b4'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB4 = Path();
              pathB4.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 140);
              pathB4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 150);
              pathB4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 30,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 170);
              pathB4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 160);
              pathB4.close();
              canvas.touchCanvas.drawPath(pathB4, paint, onTapDown: (tapDetail) {
                setSegmentState('b4', !currentSegments['b4']);
                if (currentSegments['b4']) {
                  setSegmentState('b6', false);
                  setSegmentState('b5', false);
                }
              });

              paint.color = currentSegments['b5'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB5 = Path();
              pathB5.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 140);
              pathB5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 140);
              pathB5.close();
              canvas.touchCanvas.drawPath(pathB5, paint, onTapDown: (tapDetail) {
                setSegmentState('b5', !currentSegments['b5']);
                if (currentSegments['b5']) {
                  setSegmentState('b4', false);
                  setSegmentState('b6', false);
                }
              });

              paint.color = currentSegments['b6'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB6 = Path();
              pathB6.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 110);
              pathB6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 30,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 100);
              pathB6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 120);
              pathB6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 130);
              pathB6.close();
              canvas.touchCanvas.drawPath(pathB6, paint, onTapDown: (tapDetail) {
                setSegmentState('b6', !currentSegments['b6']);
                if (currentSegments['b6']) {
                  setSegmentState('b4', false);
                  setSegmentState('b5', false);
                }
              });

              paint.color = currentSegments['a1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA1 = Path();
              pathA1.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 200);
              pathA1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 180);
              pathA1.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 190);
              pathA1.close();
              canvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
                setSegmentState('a1', !currentSegments['a1']);
                if (currentSegments['a1']) {
                  setSegmentState('a2', false);
                  setSegmentState('a3', false);
                }
              });

              paint.color = currentSegments['a2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA2 = Path();
              pathA2.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 100,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 220);
              pathA2.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 220);
              pathA2.close();
              canvas.touchCanvas.drawPath(pathA2, paint, onTapDown: (tapDetail) {
                setSegmentState('a2', !currentSegments['a2']);
                if (currentSegments['a2']) {
                  setSegmentState('a1', false);
                  setSegmentState('a3', false);
                }
              });

              paint.color = currentSegments['a3'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA3 = Path();
              pathA3.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 220);
              pathA3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 90,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 240);
              pathA3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 80,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 250);
              pathA3.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 60,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 230);
              pathA3.close();
              canvas.touchCanvas.drawPath(pathA3, paint, onTapDown: (tapDetail) {
                setSegmentState('a3', !currentSegments['a3']);
                if (currentSegments['a3']) {
                  setSegmentState('a1', false);
                  setSegmentState('a2', false);
                }
              });

              paint.color = currentSegments['a4'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA4 = Path();
              pathA4.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 220);
              pathA4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 230);
              pathA4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 30,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 250);
              pathA4.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 240);
              pathA4.close();
              canvas.touchCanvas.drawPath(pathA4, paint, onTapDown: (tapDetail) {
                setSegmentState('a4', !currentSegments['a4']);
                if (currentSegments['a4']) {
                  setSegmentState('a6', false);
                  setSegmentState('a6', false);
                }
              });

              paint.color = currentSegments['a5'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA5 = Path();
              pathA5.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 220);
              pathA5.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 10,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 220);
              pathA5.close();
              canvas.touchCanvas.drawPath(pathA5, paint, onTapDown: (tapDetail) {
                setSegmentState('a5', !currentSegments['a5']);
                if (currentSegments['a5']) {
                  setSegmentState('a4', false);
                  setSegmentState('a6', false);
                }
              });

              paint.color = currentSegments['a6'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA6 = Path();
              pathA6.moveTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 20,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 190);
              pathA6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 30,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 180);
              pathA6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 200);
              pathA6.lineTo(size.width / _PRUSSIA_RELATIVE_DISPLAY_WIDTH * 50,
                  size.width / _PRUSSIA_RELATIVE_DISPLAY_HEIGHT * 210);
              pathA6.close();
              canvas.touchCanvas.drawPath(pathA6, paint, onTapDown: (tapDetail) {
                setSegmentState('a6', !currentSegments['a6']);
                if (currentSegments['a6']) {
                  setSegmentState('a4', false);
                  setSegmentState('a5', false);
                }
              });
            });
}
