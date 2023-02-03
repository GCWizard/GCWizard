part of 'package:gc_wizard/tools/crypto_and_encodings/cistercian_numbers/widget/cistercian_numbers.dart';

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
  'k': true,
  'l': false,
  'm': false,
  'n': false,
  'o': false,
  'p': false,
  'q': false,
  'r': false,
  's': false,
  't': false,
  'u': false
};

class _CistercianNumbersSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  _CistercianNumbersSegmentDisplay(
      {Key key,
      this.segments,
      this.readOnly: false,
      this.onChanged,
      this.tapeStyle: false})
      : super(
            key: key,
            initialSegments: _INITIAL_SEGMENTS,
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
              var paint = defaultSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;

              paint.color =
                  currentSegments['a'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathA = Path();
              pathA.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0, 0);
              pathA.lineTo(
                  size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25, 0);
              pathA.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathA.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathA.close();

              canvas.touchCanvas.drawPath(pathA, paint, onTapDown: (tapDetail) {
                setSegmentState('a', !currentSegments['a']);
              });

              paint.color =
                  currentSegments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathB = Path();
              pathB.moveTo(
                  size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30, 0);
              pathB.lineTo(
                  size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55, 0);
              pathB.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathB.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathB.close();

              canvas.touchCanvas.drawPath(pathB, paint, onTapDown: (tapDetail) {
                setSegmentState('b', !currentSegments['b']);
              });

              paint.color =
                  currentSegments['c'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathC = Path();
              pathC.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 0);
              pathC.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathC.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathC.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 30);
              pathC.close();

              canvas.touchCanvas.drawPath(pathC, paint, onTapDown: (tapDetail) {
                setSegmentState('c', !currentSegments['c']);
              });

              paint.color =
                  currentSegments['d'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathD = Path();
              pathD.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathD.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 0);
              pathD.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 30);
              pathD.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathD.close();

              canvas.touchCanvas.drawPath(pathD, paint, onTapDown: (tapDetail) {
                setSegmentState('d', !currentSegments['d']);
              });

              paint.color =
                  currentSegments['e'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathE = Path();
              pathE.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 22);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 12,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 12);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 22,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 8);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 18,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18);
              pathE.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 8,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathE.close();

              canvas.touchCanvas.drawPath(pathE, paint, onTapDown: (tapDetail) {
                setSegmentState('e', !currentSegments['e']);
              });

              paint.color =
                  currentSegments['f'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathF = Path();
              pathF.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 8,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 12);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 18,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 22);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 22,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 12,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathF.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 8);
              pathF.close();

              canvas.touchCanvas.drawPath(pathF, paint, onTapDown: (tapDetail) {
                setSegmentState('f', !currentSegments['f']);
              });

              paint.color =
                  currentSegments['g'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathG = Path();
              pathG.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 22);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 37,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 12);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 47,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 8);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 43,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18);
              pathG.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 33,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathG.close();

              canvas.touchCanvas.drawPath(pathG, paint, onTapDown: (tapDetail) {
                setSegmentState('g', !currentSegments['g']);
              });

              paint.color =
                  currentSegments['h'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathH = Path();
              pathH.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 33,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 5);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 12);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 43,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 22);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 47,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 18);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 37,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 15);
              pathH.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 8);
              pathH.close();

              canvas.touchCanvas.drawPath(pathH, paint, onTapDown: (tapDetail) {
                setSegmentState('h', !currentSegments['h']);
              });

              paint.color =
                  currentSegments['i'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathI = Path();
              pathI.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathI.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathI.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 30);
              pathI.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 30);
              pathI.close();

              canvas.touchCanvas.drawPath(pathI, paint, onTapDown: (tapDetail) {
                setSegmentState('i', !currentSegments['i']);
              });

              paint.color =
                  currentSegments['j'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathJ = Path();
              pathJ.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathJ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 25);
              pathJ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 30);
              pathJ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 30);
              pathJ.close();

              canvas.touchCanvas.drawPath(pathJ, paint, onTapDown: (tapDetail) {
                setSegmentState('j', !currentSegments['j']);
              });

              paint.color = SEGMENTS_COLOR_ON; // k is always on
              var pathK = Path();
              pathK.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 0);
              pathK.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 0);
              pathK.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathK.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathK.close();

              canvas.touchCanvas.drawPath(pathK, paint);

              paint.color =
                  currentSegments['l'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathL = Path();
              pathL.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 50);
              pathL.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 50);
              pathL.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathL.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathL.close();

              canvas.touchCanvas.drawPath(pathL, paint, onTapDown: (tapDetail) {
                setSegmentState('l', !currentSegments['l']);
              });

              paint.color =
                  currentSegments['m'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathM = Path();
              pathM.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 50);
              pathM.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 50);
              pathM.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathM.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathM.close();

              canvas.touchCanvas.drawPath(pathM, paint, onTapDown: (tapDetail) {
                setSegmentState('m', !currentSegments['m']);
              });

              paint.color =
                  currentSegments['n'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathN = Path();
              pathN.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 50);
              pathN.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathN.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathN.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathN.close();

              canvas.touchCanvas.drawPath(pathN, paint, onTapDown: (tapDetail) {
                setSegmentState('n', !currentSegments['n']);
              });

              paint.color =
                  currentSegments['o'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathO = Path();
              pathO.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathO.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 50);
              pathO.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathO.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathO.close();

              canvas.touchCanvas.drawPath(pathO, paint, onTapDown: (tapDetail) {
                setSegmentState('o', !currentSegments['o']);
              });

              paint.color =
                  currentSegments['p'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathP = Path();
              pathP.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 72);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 12,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 62);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 22,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 58);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 18,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 68);
              pathP.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 8,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathP.close();

              canvas.touchCanvas.drawPath(pathP, paint, onTapDown: (tapDetail) {
                setSegmentState('p', !currentSegments['p']);
              });

              paint.color =
                  currentSegments['q'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathQ = Path();
              pathQ.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 8,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 62);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 18,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 72);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 22,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 68);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 15,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 12,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathQ.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 58);
              pathQ.close();

              canvas.touchCanvas.drawPath(pathQ, paint, onTapDown: (tapDetail) {
                setSegmentState('q', !currentSegments['q']);
              });

              paint.color =
                  currentSegments['r'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathR = Path();
              pathR.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 72);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 37,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 62);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 47,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 58);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 43,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 68);
              pathR.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 33,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathR.close();

              canvas.touchCanvas.drawPath(pathR, paint, onTapDown: (tapDetail) {
                setSegmentState('r', !currentSegments['r']);
              });

              paint.color =
                  currentSegments['s'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathS = Path();
              pathS.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 33,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 55);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 62);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 43,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 72);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 47,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 68);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 40,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 37,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 65);
              pathS.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 58);
              pathS.close();

              canvas.touchCanvas.drawPath(pathS, paint, onTapDown: (tapDetail) {
                setSegmentState('s', !currentSegments['s']);
              });

              paint.color =
                  currentSegments['t'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathT = Path();
              pathT.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 5,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathT.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathT.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 25,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathT.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 0,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathT.close();

              canvas.touchCanvas.drawPath(pathT, paint, onTapDown: (tapDetail) {
                setSegmentState('t', !currentSegments['t']);
              });

              paint.color =
                  currentSegments['u'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
              var pathU = Path();
              pathU.moveTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathU.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 50,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 75);
              pathU.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 55,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathU.lineTo(size.width / SEGMENTS_RELATIVE_DISPLAY_WIDTH * 30,
                  size.height / SEGMENTS_RELATIVE_DISPLAY_HEIGHT * 80);
              pathU.close();

              canvas.touchCanvas.drawPath(pathU, paint, onTapDown: (tapDetail) {
                setSegmentState('u', !currentSegments['u']);
              });
            });
}
