import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';

Paint defaultSegmentPaint() {
  var paint = Paint();
  paint.strokeWidth = 0;
  paint.style = PaintingStyle.fill;

  return paint;
}

Paint sketchSegmentPaint() {
  var paint = Paint();
  paint.strokeWidth = 5;
  paint.style = PaintingStyle.stroke;
  return paint;
}

const SEGMENTS_RELATIVE_DISPLAY_WIDTH = 76.5;
const SEGMENTS_RELATIVE_DISPLAY_HEIGHT = 99;

const SEGMENTS_COLOR_ON = Colors.red;
const SEGMENTS_COLOR_OFF = Color.fromARGB(255, 80, 80, 80);

double _relativeX(Size size, double x) {
  return size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * x;
}

double _relativeY(Size size, double y) {
  return size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * y;
}

class SegmentDisplayPainter extends CustomPainter {
  final void Function(String, bool) setSegmentState;
  final Map<String, bool> segments;
  final BuildContext context;
  final SegmentDisplayType type;
  final void Function(GCWTouchCanvas, Size, Map<String, bool>, void Function(String, bool), Color, Color)? customPaint;
  final Color segment_color_on;
  final Color segment_color_off;

  late GCWTouchCanvas _touchCanvas;

  SegmentDisplayPainter(this.context, this.type, this.segments, this.setSegmentState,
      {this.customPaint, this.segment_color_on = SEGMENTS_COLOR_ON, this.segment_color_off = SEGMENTS_COLOR_OFF});

  @override
  void paint(Canvas canvas, Size size) {
    _touchCanvas = GCWTouchCanvas(context, canvas);

    switch (type) {
      case SegmentDisplayType.SEVEN:
        _paintSevenSegmentDisplay(size);
        break;
      case SegmentDisplayType.FOURTEEN:
        _paintFourteenSegmentDisplay(size);
        break;
      case SegmentDisplayType.SIXTEEN:
        _paintSixteenSegmentDisplay(size);
        break;
      case SegmentDisplayType.CUSTOM:
        if (customPaint != null) {
          customPaint!(_touchCanvas, size, segments, setSegmentState, segment_color_on, segment_color_off);
        }
        break;
      default:
    }
  }

  void _paintSixteenSegmentDisplay(Size size) {
    var paint = defaultSegmentPaint();
    var SEGMENTS_COLOR_ON = segment_color_on;
    var SEGMENTS_COLOR_OFF = segment_color_off;

    paint.color = segmentActive(segments, 'a1') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA1 = Path();
    pathA1.moveTo(_relativeX(size, 1), 0);
    pathA1.lineTo(_relativeX(size, 30), 0);
    pathA1.lineTo(_relativeX(size, 30), _relativeY(size, 4));
    pathA1.lineTo(_relativeX(size, 26), _relativeY(size, 8));
    pathA1.lineTo(_relativeX(size, 9), _relativeY(size, 8));
    pathA1.close();

    _touchCanvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
      setSegmentState('a1', !segmentActive(segments, 'a1'));
    });

    paint.color = segmentActive(segments, 'a2') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA2 = Path();
    pathA2.moveTo(_relativeX(size, 32), 0);
    pathA2.lineTo(_relativeX(size, 61), 0);
    pathA2.lineTo(_relativeX(size, 53), _relativeY(size, 8));
    pathA2.lineTo(_relativeX(size, 36), _relativeY(size, 8));
    pathA2.lineTo(_relativeX(size, 32), _relativeY(size, 4));
    pathA2.close();

    _touchCanvas.touchCanvas.drawPath(pathA2, paint, onTapDown: (tapDetail) {
      setSegmentState('a2', !segmentActive(segments, 'a2'));
    });

    paint.color = segmentActive(segments, 'b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathB = Path();
    pathB.moveTo(_relativeX(size, 62), _relativeY(size, 2));
    pathB.lineTo(_relativeX(size, 62), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 58), _relativeY(size, 47));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 10));
    pathB.close();

    _touchCanvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
      setSegmentState('b', !segmentActive(segments, 'b'));
    });

    paint.color = segmentActive(segments, 'c') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathC = Path();
    pathC.moveTo(_relativeX(size, 58), _relativeY(size, 51));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 55));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 96));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 88));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 55));
    pathC.close();

    _touchCanvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
      setSegmentState('c', !segmentActive(segments, 'c'));
    });

    paint.color = segmentActive(segments, 'd1') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD1 = Path();
    pathD1.moveTo(_relativeX(size, 9), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 26), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 30), _relativeY(size, 94));
    pathD1.lineTo(_relativeX(size, 30), _relativeY(size, 98));
    pathD1.lineTo(_relativeX(size, 1), _relativeY(size, 98));
    pathD1.close();

    _touchCanvas.touchCanvas.drawPath(pathD1, paint, onTapDown: (tapDetail) {
      setSegmentState('d1', !segmentActive(segments, 'd1'));
    });

    paint.color = segmentActive(segments, 'd2') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD2 = Path();
    pathD2.moveTo(_relativeX(size, 36), _relativeY(size, 90));
    pathD2.lineTo(_relativeX(size, 53), _relativeY(size, 90));
    pathD2.lineTo(_relativeX(size, 61), _relativeY(size, 98));
    pathD2.lineTo(_relativeX(size, 32), _relativeY(size, 98));
    pathD2.lineTo(_relativeX(size, 32), _relativeY(size, 94));
    pathD2.close();

    _touchCanvas.touchCanvas.drawPath(pathD2, paint, onTapDown: (tapDetail) {
      setSegmentState('d2', !segmentActive(segments, 'd2'));
    });

    paint.color = segmentActive(segments, 'e') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathE = Path();
    pathE.moveTo(_relativeX(size, 4), _relativeY(size, 51));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 55));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 88));
    pathE.lineTo(0, _relativeY(size, 96));
    pathE.lineTo(0, _relativeY(size, 55));
    pathE.close();

    _touchCanvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
      setSegmentState('e', !segmentActive(segments, 'e'));
    });

    paint.color = segmentActive(segments, 'f') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathF = Path();
    pathF.moveTo(0, _relativeY(size, 2));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 10));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 43));
    pathF.lineTo(_relativeX(size, 4), _relativeY(size, 47));
    pathF.lineTo(0, _relativeY(size, 43));
    pathF.close();

    _touchCanvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
      setSegmentState('f', !segmentActive(segments, 'f'));
    });

    paint.color = segmentActive(segments, 'g1') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG1 = Path();
    pathG1.moveTo(_relativeX(size, 9), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 30), _relativeY(size, 49));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 9), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 5), _relativeY(size, 49));
    pathG1.close();

    _touchCanvas.touchCanvas.drawPath(pathG1, paint, onTapDown: (tapDetail) {
      setSegmentState('g1', !segmentActive(segments, 'g1'));
    });

    paint.color = segmentActive(segments, 'g2') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG2 = Path();
    pathG2.moveTo(_relativeX(size, 36), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 57), _relativeY(size, 49));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 36), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 32), _relativeY(size, 49));
    pathG2.close();

    _touchCanvas.touchCanvas.drawPath(pathG2, paint, onTapDown: (tapDetail) {
      setSegmentState('g2', !segmentActive(segments, 'g2'));
    });

    paint.color = segmentActive(segments, 'h') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathH = Path();
    pathH.moveTo(_relativeX(size, 10), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 15), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 38));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 20), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 10), _relativeY(size, 15));
    pathH.close();

    _touchCanvas.touchCanvas.drawPath(pathH, paint, onTapDown: (tapDetail) {
      setSegmentState('h', !segmentActive(segments, 'h'));
    });

    paint.color = segmentActive(segments, 'i') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathI = Path();
    pathI.moveTo(_relativeX(size, 31), _relativeY(size, 6));
    pathI.lineTo(_relativeX(size, 35), _relativeY(size, 10));
    pathI.lineTo(_relativeX(size, 35), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 31), _relativeY(size, 47));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 10));
    pathI.close();

    _touchCanvas.touchCanvas.drawPath(pathI, paint, onTapDown: (tapDetail) {
      setSegmentState('i', !segmentActive(segments, 'i'));
    });

    paint.color = segmentActive(segments, 'j') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathJ = Path();
    pathJ.moveTo(_relativeX(size, 47), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 15));
    pathJ.lineTo(_relativeX(size, 42), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 38));
    pathJ.close();

    _touchCanvas.touchCanvas.drawPath(pathJ, paint, onTapDown: (tapDetail) {
      setSegmentState('j', !segmentActive(segments, 'j'));
    });

    paint.color = segmentActive(segments, 'k') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathK = Path();
    pathK.moveTo(_relativeX(size, 20), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 60));
    pathK.lineTo(_relativeX(size, 15), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 83));
    pathK.close();

    _touchCanvas.touchCanvas.drawPath(pathK, paint, onTapDown: (tapDetail) {
      setSegmentState('k', !segmentActive(segments, 'k'));
    });

    paint.color = segmentActive(segments, 'l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathL = Path();
    pathL.moveTo(_relativeX(size, 31), _relativeY(size, 51));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 55));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 31), _relativeY(size, 92));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 55));
    pathL.close();

    _touchCanvas.touchCanvas.drawPath(pathL, paint, onTapDown: (tapDetail) {
      setSegmentState('l', !segmentActive(segments, 'l'));
    });

    paint.color = segmentActive(segments, 'm') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathM = Path();
    pathM.moveTo(_relativeX(size, 37), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 42), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 83));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 47), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 37), _relativeY(size, 60));
    pathM.close();

    _touchCanvas.touchCanvas.drawPath(pathM, paint, onTapDown: (tapDetail) {
      setSegmentState('m', !segmentActive(segments, 'm'));
    });

    paint.color = segmentActive(segments, 'dp') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    _touchCanvas.touchCanvas.drawCircle(
        Offset(_relativeX(size, 72), _relativeY(size, 94)), _relativeY(size, 4.5), paint, onTapDown: (tapDetail) {
      setSegmentState('dp', !segmentActive(segments, 'dp'));
    });

    //only for create the dropdown images
    // _paintText('a1', (30-5)/2.0+5, (8-0)/2.0+0, size);
    // _paintText('a2', (53-36)/2.0+36, (8-0)/2.0+0, size);
    // _paintText('b', 58, (43-10)/2.0+10, size);
    // _paintText('c', 58, (88-55)/2.0+55, size);
    // _paintText('d1', (30-5)/2.0+5, 94, size);
    // _paintText('d2', (53-36)/2.0+36, 94, size);
    // _paintText('e', (8-0)/2.0+0, (88-55)/2.0+55, size);
    // _paintText('f', (8-0)/2.0+0, (43-10)/2.0+10, size);
    // _paintText('g1', (30-5)/2.0+5, (53-45)/2.0+45, size);
    // _paintText('g2', (53-36)/2.0+36, (53-45)/2.0+45, size);
    // _paintText('h', (25-10)/2.0+10, (43-10)/2.0+10, size);
    // _paintText('i', (35-27)/2+27, (47-6)/2.0+6, size);
    // _paintText('j', (52-37)/2.0+37, (43-10)/2.0+10, size);
    // _paintText('k', (25-10)/2.0+10, (88-55)/2.0+55, size);
    // _paintText('l', (35-27)/2.0+27, (92-51)/2.0+51, size);
    // _paintText('m', (52-37)/2.0+37, (88-55)/2.0+55, size);
    // _paintText('dp', 72, 94-10, size);
  }

  void _paintFourteenSegmentDisplay(Size size) {
    var paint = defaultSegmentPaint();
    var SEGMENTS_COLOR_ON = segment_color_on;
    var SEGMENTS_COLOR_OFF = segment_color_off;

    paint.color = segmentActive(segments, 'a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA1 = Path();
    pathA1.moveTo(_relativeX(size, 1), 0);
    pathA1.lineTo(_relativeX(size, 61), 0);
    pathA1.lineTo(_relativeX(size, 53), _relativeY(size, 8));
    pathA1.lineTo(_relativeX(size, 9), _relativeY(size, 8));
    pathA1.close();

    _touchCanvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
      setSegmentState('a', !segmentActive(segments, 'a'));
    });

    paint.color = segmentActive(segments, 'b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathB = Path();
    pathB.moveTo(_relativeX(size, 62), _relativeY(size, 2));
    pathB.lineTo(_relativeX(size, 62), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 58), _relativeY(size, 47));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 10));
    pathB.close();

    _touchCanvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
      setSegmentState('b', !segmentActive(segments, 'b'));
    });

    paint.color = segmentActive(segments, 'c') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathC = Path();
    pathC.moveTo(_relativeX(size, 58), _relativeY(size, 51));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 55));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 96));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 88));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 55));
    pathC.close();

    _touchCanvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
      setSegmentState('c', !segmentActive(segments, 'c'));
    });

    paint.color = segmentActive(segments, 'd') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD1 = Path();
    pathD1.moveTo(_relativeX(size, 9), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 53), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 61), _relativeY(size, 98));
    pathD1.lineTo(_relativeX(size, 1), _relativeY(size, 98));
    pathD1.close();

    _touchCanvas.touchCanvas.drawPath(pathD1, paint, onTapDown: (tapDetail) {
      setSegmentState('d', !segmentActive(segments, 'd'));
    });

    paint.color = segmentActive(segments, 'e') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathE = Path();
    pathE.moveTo(_relativeX(size, 4), _relativeY(size, 51));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 55));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 88));
    pathE.lineTo(0, _relativeY(size, 96));
    pathE.lineTo(0, _relativeY(size, 55));
    pathE.close();

    _touchCanvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
      setSegmentState('e', !segmentActive(segments, 'e'));
    });

    paint.color = segmentActive(segments, 'f') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathF = Path();
    pathF.moveTo(0, _relativeY(size, 2));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 10));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 43));
    pathF.lineTo(_relativeX(size, 4), _relativeY(size, 47));
    pathF.lineTo(0, _relativeY(size, 43));
    pathF.close();

    _touchCanvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
      setSegmentState('f', !segmentActive(segments, 'f'));
    });

    paint.color = segmentActive(segments, 'g1') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG1 = Path();
    pathG1.moveTo(_relativeX(size, 9), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 30), _relativeY(size, 49));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 9), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 5), _relativeY(size, 49));
    pathG1.close();

    _touchCanvas.touchCanvas.drawPath(pathG1, paint, onTapDown: (tapDetail) {
      setSegmentState('g1', !segmentActive(segments, 'g1'));
    });

    paint.color = segmentActive(segments, 'g2') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG2 = Path();
    pathG2.moveTo(_relativeX(size, 36), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 57), _relativeY(size, 49));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 36), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 32), _relativeY(size, 49));
    pathG2.close();

    _touchCanvas.touchCanvas.drawPath(pathG2, paint, onTapDown: (tapDetail) {
      setSegmentState('g2', !segmentActive(segments, 'g2'));
    });

    paint.color = segmentActive(segments, 'h') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathH = Path();
    pathH.moveTo(_relativeX(size, 10), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 15), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 38));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 20), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 10), _relativeY(size, 15));
    pathH.close();

    _touchCanvas.touchCanvas.drawPath(pathH, paint, onTapDown: (tapDetail) {
      setSegmentState('h', !segmentActive(segments, 'h'));
    });

    paint.color = segmentActive(segments, 'i') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathI = Path();
    pathI.moveTo(_relativeX(size, 35), _relativeY(size, 10));
    pathI.lineTo(_relativeX(size, 35), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 31), _relativeY(size, 47));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 10));
    pathI.close();

    _touchCanvas.touchCanvas.drawPath(pathI, paint, onTapDown: (tapDetail) {
      setSegmentState('i', !segmentActive(segments, 'i'));
    });

    paint.color = segmentActive(segments, 'j') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathJ = Path();
    pathJ.moveTo(_relativeX(size, 47), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 15));
    pathJ.lineTo(_relativeX(size, 42), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 38));
    pathJ.close();

    _touchCanvas.touchCanvas.drawPath(pathJ, paint, onTapDown: (tapDetail) {
      setSegmentState('j', !segmentActive(segments, 'j'));
    });

    paint.color = segmentActive(segments, 'k') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathK = Path();
    pathK.moveTo(_relativeX(size, 20), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 60));
    pathK.lineTo(_relativeX(size, 15), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 83));
    pathK.close();

    _touchCanvas.touchCanvas.drawPath(pathK, paint, onTapDown: (tapDetail) {
      setSegmentState('k', !segmentActive(segments, 'k'));
    });

    paint.color = segmentActive(segments, 'l') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathL = Path();
    pathL.moveTo(_relativeX(size, 31), _relativeY(size, 51));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 55));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 55));
    pathL.close();

    _touchCanvas.touchCanvas.drawPath(pathL, paint, onTapDown: (tapDetail) {
      setSegmentState('l', !segmentActive(segments, 'l'));
    });

    paint.color = segmentActive(segments, 'm') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathM = Path();
    pathM.moveTo(_relativeX(size, 37), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 42), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 83));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 47), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 37), _relativeY(size, 60));
    pathM.close();

    _touchCanvas.touchCanvas.drawPath(pathM, paint, onTapDown: (tapDetail) {
      setSegmentState('m', !segmentActive(segments, 'm'));
    });

    paint.color = segmentActive(segments, 'dp') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    _touchCanvas.touchCanvas.drawCircle(
        Offset(_relativeX(size, 72), _relativeY(size, 94)), _relativeY(size, 4.5), paint, onTapDown: (tapDetail) {
      setSegmentState('dp', !segmentActive(segments, 'dp'));
    });

    //only for create the dropdown images
    // _paintText('a', (61-1)/2.0+1, (8-0)/2.0+0, size);
    // _paintText('b', 58, (43-10)/2.0+10, size);
    // _paintText('c', 58, (88-55)/2.0+55, size);
    // _paintText('d', (61-1)/2.0+1, 94, size);
    // _paintText('e', (8-0)/2.0+0, (88-55)/2.0+55, size);
    // _paintText('f', (8-0)/2.0+0, (43-10)/2.0+10, size);
    // _paintText('g1', (30-5)/2.0+5, (53-45)/2.0+45, size);
    // _paintText('g2', (53-36)/2.0+36, (53-45)/2.0+45, size);
    // _paintText('h', (25-10)/2.0+10, (43-10)/2.0+10, size);
    // _paintText('i', (35-27)/2+27, (47-6)/2.0+6, size);
    // _paintText('j', (52-37)/2.0+37, (43-10)/2.0+10, size);
    // _paintText('k', (25-10)/2.0+10, (88-55)/2.0+55, size);
    // _paintText('l', (35-27)/2.0+27, (92-51)/2.0+51, size);
    // _paintText('m',  (52-37)/2.0+37, (88-55)/2.0+55, size);
    // _paintText('dp', 72, 94-10, size);
  }

  void _paintSevenSegmentDisplay(Size size) {
    var paint = defaultSegmentPaint();
    var SEGMENTS_COLOR_ON = segment_color_on;
    var SEGMENTS_COLOR_OFF = segment_color_off;

    paint.color = segmentActive(segments, 'a') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA1 = Path();
    pathA1.moveTo(_relativeX(size, 1), 0);
    pathA1.lineTo(_relativeX(size, 61), 0);
    pathA1.lineTo(_relativeX(size, 53), _relativeY(size, 8));
    pathA1.lineTo(_relativeX(size, 9), _relativeY(size, 8));
    pathA1.close();

    _touchCanvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
      setSegmentState('a', !segmentActive(segments, 'a'));
    });

    paint.color = segmentActive(segments, 'b') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathB = Path();
    pathB.moveTo(_relativeX(size, 62), _relativeY(size, 2));
    pathB.lineTo(_relativeX(size, 62), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 58), _relativeY(size, 47));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 10));
    pathB.close();

    _touchCanvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
      setSegmentState('b', !segmentActive(segments, 'b'));
    });

    paint.color = segmentActive(segments, 'c') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathC = Path();
    pathC.moveTo(_relativeX(size, 58), _relativeY(size, 51));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 55));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 96));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 88));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 55));
    pathC.close();

    _touchCanvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
      setSegmentState('c', !segmentActive(segments, 'c'));
    });

    paint.color = segmentActive(segments, 'd') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD1 = Path();
    pathD1.moveTo(_relativeX(size, 9), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 53), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 61), _relativeY(size, 98));
    pathD1.lineTo(_relativeX(size, 1), _relativeY(size, 98));
    pathD1.close();

    _touchCanvas.touchCanvas.drawPath(pathD1, paint, onTapDown: (tapDetail) {
      setSegmentState('d', !segmentActive(segments, 'd'));
    });

    paint.color = segmentActive(segments, 'e') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathE = Path();
    pathE.moveTo(_relativeX(size, 4), _relativeY(size, 51));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 55));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 88));
    pathE.lineTo(0, _relativeY(size, 96));
    pathE.lineTo(0, _relativeY(size, 55));
    pathE.close();

    _touchCanvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
      setSegmentState('e', !segmentActive(segments, 'e'));
    });

    paint.color = segmentActive(segments, 'f') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathF = Path();
    pathF.moveTo(0, _relativeY(size, 2));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 10));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 43));
    pathF.lineTo(_relativeX(size, 4), _relativeY(size, 47));
    pathF.lineTo(0, _relativeY(size, 43));
    pathF.close();

    _touchCanvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
      setSegmentState('f', !segmentActive(segments, 'f'));
    });

    paint.color = segmentActive(segments, 'g') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG1 = Path();
    pathG1.moveTo(_relativeX(size, 9), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 53), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 57), _relativeY(size, 49));
    pathG1.lineTo(_relativeX(size, 53), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 9), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 5), _relativeY(size, 49));
    pathG1.close();

    _touchCanvas.touchCanvas.drawPath(pathG1, paint, onTapDown: (tapDetail) {
      setSegmentState('g', !segmentActive(segments, 'g'));
    });

    paint.color = segmentActive(segments, 'dp') ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    _touchCanvas.touchCanvas.drawCircle(
        Offset(_relativeX(size, 72), _relativeY(size, 94)), _relativeY(size, 4.5), paint, onTapDown: (tapDetail) {
      setSegmentState('dp', !segmentActive(segments, 'dp'));
    });

    //only for create the dropdown images
    // _paintText('a', (61-1)/2.0+1, (8-0)/2.0+0, size);
    // _paintText('b', 58, (43-10)/2.0+10, size);
    // _paintText('c', 58, (88-55)/2.0+55, size);
    // _paintText('d', (61-1)/2.0+1, 94, size);
    // _paintText('e', (8-0)/2.0+0, (88-55)/2.0+55, size);
    // _paintText('f', (8-0)/2.0+0, (43-10)/2.0+10, size);
    // _paintText('g', (61-1)/2.0+1, (53-45)/2.0+45, size);
    // _paintText('dp', 72, 94-10, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  //only for create the dropdown images
  // Paint defaultSegmentPaint() {
  //   var paint = Paint();
  //   paint.strokeWidth = 2;
  //   paint.style = PaintingStyle.stroke;
  //
  //   return paint;
  // }

  // void _paintText(String text, double x, double y, Size size) {
  //   const _7SegmentTo12345678 = {'1': 'a', '2': 'b', '3': 'c', '4': 'd', '5': 'e', '6': 'f', '7': 'g', '8': 'dp' };
  //
  //   const _14SegmentTo_hij_g1g2_mlk = {'a': 'a', 'b': 'b', 'c': 'c', 'd': 'd', 'e': 'e', 'f': 'f', 'g1': 'g1', 'g2': 'g2', 'h': 'h', 'i': 'i', 'j': 'j', 'k': 'm', 'l': 'l', 'm': 'k', 'dp': 'dp' };
  //   const _14SegmentTo_pgh_nj_mlk   = {'a': 'a', 'b': 'b', 'c': 'c', 'd': 'd', 'e': 'e', 'f': 'f', 'n': 'g1', 'j': 'g2', 'p': 'h', 'g': 'i', 'h': 'j', 'm': 'k', 'l': 'l', 'k': 'm', 'dp1': 'dp' };
  //   const _14SegmentTo_kmn_g1g2_rst = {'a': 'a', 'b': 'b', 'c': 'c', 'd': 'd', 'e': 'e', 'f': 'f', 'g1': 'g1', 'g2': 'g2', 'k': 'h', 'm': 'i', 'n': 'j', 't': 'm', 's': 'l', 'r': 'k', 'dp': 'dp' };
  //   const _14SegmentTo_ghj_pk_nmi   = {'a': 'a', 'b': 'b', 'c': 'c', 'd': 'd', 'e': 'e', 'f': 'f', 'p': 'g1', 'k': 'g2', 'g': 'h', 'h': 'i', 'j': 'j', 'i': 'm', 'm': 'l', 'n': 'k', 'dp': 'dp' };
  //   const _14SegmentTo_hjk_g1g2_nml = {'a': 'a', 'b': 'b', 'c': 'c', 'd': 'd', 'e': 'e', 'f': 'f', 'g1': 'g1', 'g2': 'g2', 'h': 'h', 'j': 'i', 'k': 'j', 'l': 'm', 'm': 'l', 'n': 'k', 'dp': 'dp' };
  //
  //   var labels = switchMapKeyValue(_14SegmentTo_ghj_pk_nmi);
  //   text = labels[text]!;
  //
  //   var fontSize = _relativeX(size, 7.0);
  //   TextPainter textPainter = _buildTextPainter(text, Colors.black, fontSize);
  //   textPainter.layout();
  //   textPainter.paint(_touchCanvas.canvas, Offset(_relativeX(size, x) - textPainter.width / 2
  //       , _relativeY(size, y) - textPainter.height / 2));
  // }
  //
  // TextPainter _buildTextPainter(String text, Color color, double fontsize) {
  //   TextSpan span = TextSpan(
  //       style: gcwTextStyle().copyWith(color: color, fontSize: fontsize),
  //       text: text);
  //   TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr, textAlign: TextAlign.center);
  //   textPainter.layout();
  //
  //   return textPainter;
  // }
}
