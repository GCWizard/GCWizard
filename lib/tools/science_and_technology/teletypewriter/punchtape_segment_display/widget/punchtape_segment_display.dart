import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  '1': false,
  '2': false,
  '3': false,
  '4': false,
  '5': false,
  '6': false,
  '7': false,
  '8': false
};

class PUNCHTAPESegmentDisplay extends NSegmentDisplay {
  final TeletypewriterCodebook codeBook;

  PUNCHTAPESegmentDisplay(this.codeBook,
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
              int punchHoles = PUNCHTAPE_DEFINITION[codeBook]!.punchHoles;
              int sprocketHole = PUNCHTAPE_DEFINITION[codeBook]!.sprocketHole;

              var paint = defaultSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;

              int _PUNCHTAPE_RELATIVE_DISPLAY_WIDTH = (punchHoles + 1) * 30; //5 holes. 180
              int _PUNCHTAPE_RELATIVE_DISPLAY_HEIGHT = 60; //60;

              const _PUNCHTAPE_RADIUS = 20.0;

              Map<String, List<int>> circles = {};
              int x = 10;

              for (int i = 1; i <= punchHoles; i++) {
                if (i == sprocketHole) x = x + 30;
                List<int> coordsList = [];
                coordsList.add(x);
                coordsList.add(30);
                circles[i.toString()] = [];
                circles[i.toString()]!.addAll(coordsList);
                x = x + 30;
              }
              //circles = {'1': [10, 30], '2': [40, 30], '3': [100, 30],'4': [130, 30],'5': [160, 30]};

              var pointSize = size.height / _PUNCHTAPE_RELATIVE_DISPLAY_HEIGHT * _PUNCHTAPE_RADIUS;

              // print punchHoles
              circles.forEach((key, value) {
                paint.color = Colors.black;
                canvas.touchCanvas.drawCircle(
                    Offset(size.width / _PUNCHTAPE_RELATIVE_DISPLAY_WIDTH * (value[0]),
                        size.height / _PUNCHTAPE_RELATIVE_DISPLAY_HEIGHT * (value[1])),
                    pointSize + 2,
                    paint);

                if (size.height < 50) return;
              });

              circles.forEach((key, value) {
                paint.color = segmentActive(currentSegments, key) ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
                canvas.touchCanvas.drawCircle(
                    Offset(size.width / _PUNCHTAPE_RELATIVE_DISPLAY_WIDTH * value[0],
                        size.height / _PUNCHTAPE_RELATIVE_DISPLAY_HEIGHT * value[1]),
                    pointSize,
                    paint, onTapDown: (tapDetail) {
                  setSegmentState(key, !segmentActive(currentSegments, key));
                });

                if (size.height < 50) return;
              });

              // print leadingHole
              if (sprocketHole != 0) {
                paint.color = Colors.grey;
                canvas.touchCanvas.drawCircle(
                    Offset(size.width / _PUNCHTAPE_RELATIVE_DISPLAY_WIDTH * (10 + (sprocketHole - 1) * 30),
                        size.height / _PUNCHTAPE_RELATIVE_DISPLAY_HEIGHT * 30.0),
                    pointSize / 2.0,
                    paint);
              }
            });
}
