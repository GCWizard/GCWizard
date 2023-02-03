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
  final Function(String, bool) setSegmentState;
  final Map<String, bool> segments;
  final BuildContext context;
  final SegmentDisplayType type;
  final Function customPaint;
  final Color segment_color_on;
  final Color segment_color_off;

  GCWTouchCanvas _touchCanvas;

  SegmentDisplayPainter(this.context, this.type, this.segments, this.setSegmentState,
      {this.customPaint, this.segment_color_on: SEGMENTS_COLOR_ON, this.segment_color_off: SEGMENTS_COLOR_OFF});

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
        customPaint(_touchCanvas, size, segments, setSegmentState, segment_color_on, segment_color_off);
        break;
    }
  }

  void _paintSixteenSegmentDisplay(Size size) {
    var paint = defaultSegmentPaint();
    var SEGMENTS_COLOR_ON = segment_color_on;
    var SEGMENTS_COLOR_OFF = segment_color_off;

    paint.color = segments['a1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA1 = Path();
    pathA1.moveTo(_relativeX(size, 1), 0);
    pathA1.lineTo(_relativeX(size, 30), 0);
    pathA1.lineTo(_relativeX(size, 30), _relativeY(size, 4));
    pathA1.lineTo(_relativeX(size, 26), _relativeY(size, 8));
    pathA1.lineTo(_relativeX(size, 9), _relativeY(size, 8));
    pathA1.close();

    _touchCanvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
      setSegmentState('a1', !segments['a1']);
    });

    paint.color = segments['a2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA2 = Path();
    pathA2.moveTo(_relativeX(size, 32), 0);
    pathA2.lineTo(_relativeX(size, 61), 0);
    pathA2.lineTo(_relativeX(size, 53), _relativeY(size, 8));
    pathA2.lineTo(_relativeX(size, 36), _relativeY(size, 8));
    pathA2.lineTo(_relativeX(size, 32), _relativeY(size, 4));
    pathA2.close();

    _touchCanvas.touchCanvas.drawPath(pathA2, paint, onTapDown: (tapDetail) {
      setSegmentState('a2', !segments['a2']);
    });

    paint.color = segments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathB = Path();
    pathB.moveTo(_relativeX(size, 62), _relativeY(size, 2));
    pathB.lineTo(_relativeX(size, 62), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 58), _relativeY(size, 47));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 10));
    pathB.close();

    _touchCanvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
      setSegmentState('b', !segments['b']);
    });

    paint.color = segments['c'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathC = Path();
    pathC.moveTo(_relativeX(size, 58), _relativeY(size, 51));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 55));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 96));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 88));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 55));
    pathC.close();

    _touchCanvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
      setSegmentState('c', !segments['c']);
    });

    paint.color = segments['d1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD1 = Path();
    pathD1.moveTo(_relativeX(size, 9), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 26), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 30), _relativeY(size, 94));
    pathD1.lineTo(_relativeX(size, 30), _relativeY(size, 98));
    pathD1.lineTo(_relativeX(size, 1), _relativeY(size, 98));
    pathD1.close();

    _touchCanvas.touchCanvas.drawPath(pathD1, paint, onTapDown: (tapDetail) {
      setSegmentState('d1', !segments['d1']);
    });

    paint.color = segments['d2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD2 = Path();
    pathD2.moveTo(_relativeX(size, 36), _relativeY(size, 90));
    pathD2.lineTo(_relativeX(size, 53), _relativeY(size, 90));
    pathD2.lineTo(_relativeX(size, 61), _relativeY(size, 98));
    pathD2.lineTo(_relativeX(size, 32), _relativeY(size, 98));
    pathD2.lineTo(_relativeX(size, 32), _relativeY(size, 94));
    pathD2.close();

    _touchCanvas.touchCanvas.drawPath(pathD2, paint, onTapDown: (tapDetail) {
      setSegmentState('d2', !segments['d2']);
    });

    paint.color = segments['e'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathE = Path();
    pathE.moveTo(_relativeX(size, 4), _relativeY(size, 51));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 55));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 88));
    pathE.lineTo(0, _relativeY(size, 96));
    pathE.lineTo(0, _relativeY(size, 55));
    pathE.close();

    _touchCanvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
      setSegmentState('e', !segments['e']);
    });

    paint.color = segments['f'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathF = Path();
    pathF.moveTo(0, _relativeY(size, 2));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 10));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 43));
    pathF.lineTo(_relativeX(size, 4), _relativeY(size, 47));
    pathF.lineTo(0, _relativeY(size, 43));
    pathF.close();

    _touchCanvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
      setSegmentState('f', !segments['f']);
    });

    paint.color = segments['g1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG1 = Path();
    pathG1.moveTo(_relativeX(size, 9), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 30), _relativeY(size, 49));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 9), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 5), _relativeY(size, 49));
    pathG1.close();

    _touchCanvas.touchCanvas.drawPath(pathG1, paint, onTapDown: (tapDetail) {
      setSegmentState('g1', !segments['g1']);
    });

    paint.color = segments['g2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG2 = Path();
    pathG2.moveTo(_relativeX(size, 36), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 57), _relativeY(size, 49));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 36), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 32), _relativeY(size, 49));
    pathG2.close();

    _touchCanvas.touchCanvas.drawPath(pathG2, paint, onTapDown: (tapDetail) {
      setSegmentState('g2', !segments['g2']);
    });

    paint.color = segments['h'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathH = Path();
    pathH.moveTo(_relativeX(size, 10), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 15), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 38));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 20), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 10), _relativeY(size, 15));
    pathH.close();

    _touchCanvas.touchCanvas.drawPath(pathH, paint, onTapDown: (tapDetail) {
      setSegmentState('h', !segments['h']);
    });

    paint.color = segments['i'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathI = Path();
    pathI.moveTo(_relativeX(size, 31), _relativeY(size, 6));
    pathI.lineTo(_relativeX(size, 35), _relativeY(size, 10));
    pathI.lineTo(_relativeX(size, 35), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 31), _relativeY(size, 47));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 10));
    pathI.close();

    _touchCanvas.touchCanvas.drawPath(pathI, paint, onTapDown: (tapDetail) {
      setSegmentState('i', !segments['i']);
    });

    paint.color = segments['j'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathJ = Path();
    pathJ.moveTo(_relativeX(size, 47), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 15));
    pathJ.lineTo(_relativeX(size, 42), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 38));
    pathJ.close();

    _touchCanvas.touchCanvas.drawPath(pathJ, paint, onTapDown: (tapDetail) {
      setSegmentState('j', !segments['j']);
    });

    paint.color = segments['k'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathK = Path();
    pathK.moveTo(_relativeX(size, 20), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 60));
    pathK.lineTo(_relativeX(size, 15), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 83));
    pathK.close();

    _touchCanvas.touchCanvas.drawPath(pathK, paint, onTapDown: (tapDetail) {
      setSegmentState('k', !segments['k']);
    });

    paint.color = segments['l'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathL = Path();
    pathL.moveTo(_relativeX(size, 31), _relativeY(size, 51));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 55));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 31), _relativeY(size, 92));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 55));
    pathL.close();

    _touchCanvas.touchCanvas.drawPath(pathL, paint, onTapDown: (tapDetail) {
      setSegmentState('l', !segments['l']);
    });

    paint.color = segments['m'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathM = Path();
    pathM.moveTo(_relativeX(size, 37), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 42), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 83));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 47), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 37), _relativeY(size, 60));
    pathM.close();

    _touchCanvas.touchCanvas.drawPath(pathM, paint, onTapDown: (tapDetail) {
      setSegmentState('m', !segments['m']);
    });

    paint.color = segments['dp'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    _touchCanvas.touchCanvas.drawCircle(
        Offset(_relativeX(size, 72), _relativeY(size, 94)), _relativeY(size, 4.5), paint, onTapDown: (tapDetail) {
      setSegmentState('dp', !segments['dp']);
    });
  }

  void _paintFourteenSegmentDisplay(Size size) {
    var paint = defaultSegmentPaint();
    var SEGMENTS_COLOR_ON = segment_color_on;
    var SEGMENTS_COLOR_OFF = segment_color_off;

    paint.color = segments['a'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA1 = Path();
    pathA1.moveTo(_relativeX(size, 1), 0);
    pathA1.lineTo(_relativeX(size, 61), 0);
    pathA1.lineTo(_relativeX(size, 53), _relativeY(size, 8));
    pathA1.lineTo(_relativeX(size, 9), _relativeY(size, 8));
    pathA1.close();

    _touchCanvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
      setSegmentState('a', !segments['a']);
    });

    paint.color = segments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathB = Path();
    pathB.moveTo(_relativeX(size, 62), _relativeY(size, 2));
    pathB.lineTo(_relativeX(size, 62), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 58), _relativeY(size, 47));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 10));
    pathB.close();

    _touchCanvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
      setSegmentState('b', !segments['b']);
    });

    paint.color = segments['c'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathC = Path();
    pathC.moveTo(_relativeX(size, 58), _relativeY(size, 51));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 55));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 96));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 88));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 55));
    pathC.close();

    _touchCanvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
      setSegmentState('c', !segments['c']);
    });

    paint.color = segments['d'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD1 = Path();
    pathD1.moveTo(_relativeX(size, 9), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 53), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 61), _relativeY(size, 98));
    pathD1.lineTo(_relativeX(size, 1), _relativeY(size, 98));
    pathD1.close();

    _touchCanvas.touchCanvas.drawPath(pathD1, paint, onTapDown: (tapDetail) {
      setSegmentState('d', !segments['d']);
    });

    paint.color = segments['e'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathE = Path();
    pathE.moveTo(_relativeX(size, 4), _relativeY(size, 51));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 55));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 88));
    pathE.lineTo(0, _relativeY(size, 96));
    pathE.lineTo(0, _relativeY(size, 55));
    pathE.close();

    _touchCanvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
      setSegmentState('e', !segments['e']);
    });

    paint.color = segments['f'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathF = Path();
    pathF.moveTo(0, _relativeY(size, 2));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 10));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 43));
    pathF.lineTo(_relativeX(size, 4), _relativeY(size, 47));
    pathF.lineTo(0, _relativeY(size, 43));
    pathF.close();

    _touchCanvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
      setSegmentState('f', !segments['f']);
    });

    paint.color = segments['g1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG1 = Path();
    pathG1.moveTo(_relativeX(size, 9), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 30), _relativeY(size, 49));
    pathG1.lineTo(_relativeX(size, 26), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 9), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 5), _relativeY(size, 49));
    pathG1.close();

    _touchCanvas.touchCanvas.drawPath(pathG1, paint, onTapDown: (tapDetail) {
      setSegmentState('g1', !segments['g1']);
    });

    paint.color = segments['g2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG2 = Path();
    pathG2.moveTo(_relativeX(size, 36), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 45));
    pathG2.lineTo(_relativeX(size, 57), _relativeY(size, 49));
    pathG2.lineTo(_relativeX(size, 53), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 36), _relativeY(size, 53));
    pathG2.lineTo(_relativeX(size, 32), _relativeY(size, 49));
    pathG2.close();

    _touchCanvas.touchCanvas.drawPath(pathG2, paint, onTapDown: (tapDetail) {
      setSegmentState('g2', !segments['g2']);
    });

    paint.color = segments['h'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathH = Path();
    pathH.moveTo(_relativeX(size, 10), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 15), _relativeY(size, 10));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 38));
    pathH.lineTo(_relativeX(size, 25), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 20), _relativeY(size, 43));
    pathH.lineTo(_relativeX(size, 10), _relativeY(size, 15));
    pathH.close();

    _touchCanvas.touchCanvas.drawPath(pathH, paint, onTapDown: (tapDetail) {
      setSegmentState('h', !segments['h']);
    });

    paint.color = segments['i'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathI = Path();
    pathI.moveTo(_relativeX(size, 35), _relativeY(size, 10));
    pathI.lineTo(_relativeX(size, 35), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 31), _relativeY(size, 47));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 43));
    pathI.lineTo(_relativeX(size, 27), _relativeY(size, 10));
    pathI.close();

    _touchCanvas.touchCanvas.drawPath(pathI, paint, onTapDown: (tapDetail) {
      setSegmentState('i', !segments['i']);
    });

    paint.color = segments['j'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathJ = Path();
    pathJ.moveTo(_relativeX(size, 47), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 10));
    pathJ.lineTo(_relativeX(size, 52), _relativeY(size, 15));
    pathJ.lineTo(_relativeX(size, 42), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 43));
    pathJ.lineTo(_relativeX(size, 37), _relativeY(size, 38));
    pathJ.close();

    _touchCanvas.touchCanvas.drawPath(pathJ, paint, onTapDown: (tapDetail) {
      setSegmentState('j', !segments['j']);
    });

    paint.color = segments['k'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathK = Path();
    pathK.moveTo(_relativeX(size, 20), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 55));
    pathK.lineTo(_relativeX(size, 25), _relativeY(size, 60));
    pathK.lineTo(_relativeX(size, 15), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 88));
    pathK.lineTo(_relativeX(size, 10), _relativeY(size, 83));
    pathK.close();

    _touchCanvas.touchCanvas.drawPath(pathK, paint, onTapDown: (tapDetail) {
      setSegmentState('k', !segments['k']);
    });

    paint.color = segments['l'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathL = Path();
    pathL.moveTo(_relativeX(size, 31), _relativeY(size, 51));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 55));
    pathL.lineTo(_relativeX(size, 35), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 88));
    pathL.lineTo(_relativeX(size, 27), _relativeY(size, 55));
    pathL.close();

    _touchCanvas.touchCanvas.drawPath(pathL, paint, onTapDown: (tapDetail) {
      setSegmentState('l', !segments['l']);
    });

    paint.color = segments['m'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathM = Path();
    pathM.moveTo(_relativeX(size, 37), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 42), _relativeY(size, 55));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 83));
    pathM.lineTo(_relativeX(size, 52), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 47), _relativeY(size, 88));
    pathM.lineTo(_relativeX(size, 37), _relativeY(size, 60));
    pathM.close();

    _touchCanvas.touchCanvas.drawPath(pathM, paint, onTapDown: (tapDetail) {
      setSegmentState('m', !segments['m']);
    });

    paint.color = segments['dp'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    _touchCanvas.touchCanvas.drawCircle(
        Offset(_relativeX(size, 72), _relativeY(size, 94)), _relativeY(size, 4.5), paint, onTapDown: (tapDetail) {
      setSegmentState('dp', !segments['dp']);
    });
  }

  void _paintSevenSegmentDisplay(Size size) {
    var paint = defaultSegmentPaint();
    var SEGMENTS_COLOR_ON = segment_color_on;
    var SEGMENTS_COLOR_OFF = segment_color_off;

    paint.color = segments['a'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathA1 = Path();
    pathA1.moveTo(_relativeX(size, 1), 0);
    pathA1.lineTo(_relativeX(size, 61), 0);
    pathA1.lineTo(_relativeX(size, 53), _relativeY(size, 8));
    pathA1.lineTo(_relativeX(size, 9), _relativeY(size, 8));
    pathA1.close();

    _touchCanvas.touchCanvas.drawPath(pathA1, paint, onTapDown: (tapDetail) {
      setSegmentState('a', !segments['a']);
    });

    paint.color = segments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathB = Path();
    pathB.moveTo(_relativeX(size, 62), _relativeY(size, 2));
    pathB.lineTo(_relativeX(size, 62), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 58), _relativeY(size, 47));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 43));
    pathB.lineTo(_relativeX(size, 54), _relativeY(size, 10));
    pathB.close();

    _touchCanvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
      setSegmentState('b', !segments['b']);
    });

    paint.color = segments['c'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathC = Path();
    pathC.moveTo(_relativeX(size, 58), _relativeY(size, 51));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 55));
    pathC.lineTo(_relativeX(size, 62), _relativeY(size, 96));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 88));
    pathC.lineTo(_relativeX(size, 54), _relativeY(size, 55));
    pathC.close();

    _touchCanvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
      setSegmentState('c', !segments['c']);
    });

    paint.color = segments['d'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathD1 = Path();
    pathD1.moveTo(_relativeX(size, 9), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 53), _relativeY(size, 90));
    pathD1.lineTo(_relativeX(size, 61), _relativeY(size, 98));
    pathD1.lineTo(_relativeX(size, 1), _relativeY(size, 98));
    pathD1.close();

    _touchCanvas.touchCanvas.drawPath(pathD1, paint, onTapDown: (tapDetail) {
      setSegmentState('d', !segments['d']);
    });

    paint.color = segments['e'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathE = Path();
    pathE.moveTo(_relativeX(size, 4), _relativeY(size, 51));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 55));
    pathE.lineTo(_relativeX(size, 8), _relativeY(size, 88));
    pathE.lineTo(0, _relativeY(size, 96));
    pathE.lineTo(0, _relativeY(size, 55));
    pathE.close();

    _touchCanvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
      setSegmentState('e', !segments['e']);
    });

    paint.color = segments['f'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathF = Path();
    pathF.moveTo(0, _relativeY(size, 2));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 10));
    pathF.lineTo(_relativeX(size, 8), _relativeY(size, 43));
    pathF.lineTo(_relativeX(size, 4), _relativeY(size, 47));
    pathF.lineTo(0, _relativeY(size, 43));
    pathF.close();

    _touchCanvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
      setSegmentState('f', !segments['f']);
    });

    paint.color = segments['g'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    var pathG1 = Path();
    pathG1.moveTo(_relativeX(size, 9), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 53), _relativeY(size, 45));
    pathG1.lineTo(_relativeX(size, 57), _relativeY(size, 49));
    pathG1.lineTo(_relativeX(size, 53), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 9), _relativeY(size, 53));
    pathG1.lineTo(_relativeX(size, 5), _relativeY(size, 49));
    pathG1.close();

    _touchCanvas.touchCanvas.drawPath(pathG1, paint, onTapDown: (tapDetail) {
      setSegmentState('g', !segments['g']);
    });

    paint.color = segments['dp'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
    _touchCanvas.touchCanvas.drawCircle(
        Offset(_relativeX(size, 72), _relativeY(size, 94)), _relativeY(size, 4.5), paint, onTapDown: (tapDetail) {
      setSegmentState('dp', !segments['dp']);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
