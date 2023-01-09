import 'package:flutter/material.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/segment_display.dart';
import 'package:gc_wizard/widgets/common/gcw_touchcanvas.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/segment_display/base/n_segment_display.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/segment_display/base/painter.dart';

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

class PasleyTelegraphSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  PasleyTelegraphSegmentDisplay({Key key, this.segments, this.readOnly: false, this.onChanged, this.tapeStyle: false})
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

              paint.color = currentSegments['1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['1'])
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('1', !currentSegments['1']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('1', !currentSegments['1']);
                });

              paint.color = currentSegments['2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['2'])
                canvas.touchCanvas.drawPath(path20, paint, onTapDown: (tapDetail) {
                  setSegmentState('2', !currentSegments['2']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(path20, paint, onTapDown: (tapDetail) {
                  setSegmentState('2', !currentSegments['2']);
                });

              paint.color = currentSegments['3'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['3'])
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('3', !currentSegments['3']);
                });
              else
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('3', !currentSegments['3']);
                });

              paint.color = currentSegments['4'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['4'])
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('4', !currentSegments['4']);
                });
              else
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('4', !currentSegments['4']);
                });

              paint.color = currentSegments['5'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['5'])
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('5', !currentSegments['5']);
                });
              else
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('5', !currentSegments['5']);
                });

              paint.color = currentSegments['6'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['6'])
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('6', !currentSegments['6']);
                });
              else
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('6', !currentSegments['6']);
                });

              paint.color = currentSegments['7'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['7'])
                canvas.touchCanvas.drawPath(path70, paint, onTapDown: (tapDetail) {
                  setSegmentState('7', !currentSegments['7']);
                });
              else
                canvas.touchCanvas.drawPath(path70, paint, onTapDown: (tapDetail) {
                  setSegmentState('7', !currentSegments['7']);
                });
            });
}
