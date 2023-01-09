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
  'a': false,
  'b': false,
  'c': false,
  'd': false,
  'e': false,
  'f': false,
};

const _POPHAM_RELATIVE_DISPLAY_WIDTH = 110;
const _POPHAM_RELATIVE_DISPLAY_HEIGHT = 130;

class PophamTelegraphSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  PophamTelegraphSegmentDisplay({Key key, this.segments, this.readOnly: false, this.onChanged, this.tapeStyle: false})
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

              paint.color = currentSegments['1'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['1'])
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('1', !currentSegments['1']);
                });
              else
                canvas.touchCanvas.drawPath(path10, paint, onTapDown: (tapDetail) {
                  setSegmentState('1', !currentSegments['1']);
                });

              paint.color = currentSegments['2'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 45, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 30);
              path30.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 20, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 10);
              path30.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 10, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 15);
              path30.lineTo(
                  size.width / _POPHAM_RELATIVE_DISPLAY_WIDTH * 40, size.width / _POPHAM_RELATIVE_DISPLAY_HEIGHT * 35);
              path30.close();
              if (size.height < 180) if (currentSegments['3'])
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('3', !currentSegments['3']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(path30, paint, onTapDown: (tapDetail) {
                  setSegmentState('3', !currentSegments['3']);
                });

              paint.color = currentSegments['4'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['4'])
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('4', !currentSegments['4']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(path40, paint, onTapDown: (tapDetail) {
                  setSegmentState('4', !currentSegments['4']);
                });

              paint.color = currentSegments['5'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['5'])
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('5', !currentSegments['5']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(path50, paint, onTapDown: (tapDetail) {
                  setSegmentState('5', !currentSegments['5']);
                });

              paint.color = currentSegments['6'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['6'])
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('6', !currentSegments['6']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(path60, paint, onTapDown: (tapDetail) {
                  setSegmentState('6', !currentSegments['6']);
                });

              paint.color = currentSegments['a'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['a'])
                canvas.touchCanvas.drawPath(patha0, paint, onTapDown: (tapDetail) {
                  setSegmentState('a', !currentSegments['a']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(patha0, paint, onTapDown: (tapDetail) {
                  setSegmentState('a', !currentSegments['a']);
                });

              paint.color = currentSegments['b'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['b'])
                canvas.touchCanvas.drawPath(pathb0, paint, onTapDown: (tapDetail) {
                  setSegmentState('b', !currentSegments['b']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(pathb0, paint, onTapDown: (tapDetail) {
                  setSegmentState('b', !currentSegments['b']);
                });

              paint.color = currentSegments['c'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['c'])
                canvas.touchCanvas.drawPath(pathc0, paint, onTapDown: (tapDetail) {
                  setSegmentState('c', !currentSegments['c']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(pathc0, paint, onTapDown: (tapDetail) {
                  setSegmentState('c', !currentSegments['c']);
                });

              paint.color = currentSegments['d'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['d'])
                canvas.touchCanvas.drawPath(pathd0, paint, onTapDown: (tapDetail) {
                  setSegmentState('d', !currentSegments['d']);
                });
              else
                canvas.touchCanvas.drawPath(pathd0, paint, onTapDown: (tapDetail) {
                  setSegmentState('d', !currentSegments['d']);
                });

              paint.color = currentSegments['e'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['e'])
                canvas.touchCanvas.drawPath(pathe0, paint, onTapDown: (tapDetail) {
                  setSegmentState('e', !currentSegments['e']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(pathe0, paint, onTapDown: (tapDetail) {
                  setSegmentState('e', !currentSegments['e']);
                });

              paint.color = currentSegments['f'] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
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
              if (size.height < 180) if (currentSegments['f'])
                canvas.touchCanvas.drawPath(pathf0, paint, onTapDown: (tapDetail) {
                  setSegmentState('f', !currentSegments['f']);
                });
              else
                ;
              else
                canvas.touchCanvas.drawPath(pathf0, paint, onTapDown: (tapDetail) {
                  setSegmentState('f', !currentSegments['f']);
                });
            });
}
