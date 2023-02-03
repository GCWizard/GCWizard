part of 'package:gc_wizard/tools/science_and_technology/telegraphs/ohlsen_telegraph/widget/ohlsen_telegraph.dart';

const _INITIAL_SEGMENTS = <String, bool>{
  'a1o': false,
  'a1m': false,
  'a1u': false,
  'a2o': false,
  'a2m': false,
  'a2u': false,
  'b1o': false,
  'b1m': false,
  'b1u': false,
  'b2o': false,
  'b2m': false,
  'b2u': false,
  'c1o': false,
  'c1m': false,
  'c1u': false,
  'c2o': false,
  'c2m': false,
  'c2u': false,
};

const _OHLSEN_RELATIVE_DISPLAY_WIDTH = 150;
const _OHLSEN_RELATIVE_DISPLAY_HEIGHT = 160;
const _OHLSEN_RADIUS = 10.0;

class _OhlsenSegmentDisplay extends NSegmentDisplay {
  final Map<String, bool> segments;
  final bool readOnly;
  final Function onChanged;
  final bool tapeStyle;

  _OhlsenSegmentDisplay({Key key, this.segments, this.readOnly: false, this.onChanged, this.tapeStyle: false})
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

              var width = size.height / _OHLSEN_RELATIVE_DISPLAY_HEIGHT * _OHLSEN_RADIUS;
              var heightRect = size.height / _OHLSEN_RELATIVE_DISPLAY_HEIGHT * _OHLSEN_RADIUS / 3;

              var shutterSegments = {
                '1': 'a1o',
                '2': 'a1m',
                '3': 'a1u',
                '4': 'a2o',
                '5': 'a2m',
                '6': 'a2u',
                '7': 'b1o',
                '8': 'b1m',
                '9': 'b1u',
                '10': 'b2o',
                '11': 'b2m',
                '12': 'b2u',
                '13': 'c1o',
                '14': 'c1m',
                '15': 'c1u',
                '16': 'c2o',
                '17': 'c2m',
                '18': 'c2u',
              };
              var shutters = {
                '1': [10, 40, width, width],
                '2': [10, 62, width, heightRect],
                '3': [10, 70, width, width],
                '4': [10, 100, width, width],
                '5': [10, 122, width, heightRect],
                '6': [10, 130, width, width],
                '7': [50, 40, width, width],
                '8': [50, 62, width, heightRect],
                '9': [50, 70, width, width],
                '10': [50, 100, width, width],
                '11': [50, 122, width, heightRect],
                '12': [50, 130, width, width],
                '13': [90, 40, width, width],
                '14': [90, 62, width, heightRect],
                '15': [90, 70, width, width],
                '16': [90, 100, width, width],
                '17': [90, 122, width, heightRect],
                '18': [90, 130, width, width],
              };

              paint.color = Colors.black;
              shutters.forEach((key, value) {
                canvas.touchCanvas.drawRect(
                    Offset(size.width / _OHLSEN_RELATIVE_DISPLAY_WIDTH * (value[0] - 1),
                            size.height / _OHLSEN_RELATIVE_DISPLAY_HEIGHT * (value[1]) - 1) &
                        Size(value[2] * 3 + 2, value[3] * 2 + 2),
                    paint);

                if (size.height < 50) return;
              });

              shutters.forEach((key, value) {
                paint.color = currentSegments[shutterSegments[key]] ? SEGMENTS_COLOR_ON : SEGMENTS_COLOR_OFF;
                canvas.touchCanvas.drawRect(
                    Offset(size.width / _OHLSEN_RELATIVE_DISPLAY_WIDTH * value[0],
                            size.height / _OHLSEN_RELATIVE_DISPLAY_HEIGHT * value[1]) &
                        Size(value[2] * 3, value[3] * 2),
                    paint, onTapDown: (tapDetail) {
                  setSegmentState(shutterSegments[key], !currentSegments[shutterSegments[key]]);
                  if (key == '1') {
                    setSegmentState(shutterSegments['2'], false);
                    setSegmentState(shutterSegments['3'], false);
                  }
                  if (key == '2') {
                    setSegmentState(shutterSegments['1'], false);
                    setSegmentState(shutterSegments['3'], false);
                  }
                  if (key == '3') {
                    setSegmentState(shutterSegments['1'], false);
                    setSegmentState(shutterSegments['2'], false);
                  }
                  if (key == '4') {
                    setSegmentState(shutterSegments['5'], false);
                    setSegmentState(shutterSegments['6'], false);
                  }
                  if (key == '5') {
                    setSegmentState(shutterSegments['4'], false);
                    setSegmentState(shutterSegments['6'], false);
                  }
                  if (key == '6') {
                    setSegmentState(shutterSegments['4'], false);
                    setSegmentState(shutterSegments['5'], false);
                  }
                  if (key == '7') {
                    setSegmentState(shutterSegments['8'], false);
                    setSegmentState(shutterSegments['9'], false);
                  }
                  if (key == '8') {
                    setSegmentState(shutterSegments['7'], false);
                    setSegmentState(shutterSegments['9'], false);
                  }
                  if (key == '9') {
                    setSegmentState(shutterSegments['7'], false);
                    setSegmentState(shutterSegments['8'], false);
                  }
                  if (key == '10') {
                    setSegmentState(shutterSegments['11'], false);
                    setSegmentState(shutterSegments['12'], false);
                  }
                  if (key == '11') {
                    setSegmentState(shutterSegments['10'], false);
                    setSegmentState(shutterSegments['12'], false);
                  }
                  if (key == '12') {
                    setSegmentState(shutterSegments['10'], false);
                    setSegmentState(shutterSegments['11'], false);
                  }
                  if (key == '13') {
                    setSegmentState(shutterSegments['14'], false);
                    setSegmentState(shutterSegments['15'], false);
                  }
                  if (key == '14') {
                    setSegmentState(shutterSegments['13'], false);
                    setSegmentState(shutterSegments['15'], false);
                  }
                  if (key == '15') {
                    setSegmentState(shutterSegments['13'], false);
                    setSegmentState(shutterSegments['14'], false);
                  }
                  if (key == '16') {
                    setSegmentState(shutterSegments['17'], false);
                    setSegmentState(shutterSegments['18'], false);
                  }
                  if (key == '17') {
                    setSegmentState(shutterSegments['16'], false);
                    setSegmentState(shutterSegments['18'], false);
                  }
                  if (key == '18') {
                    setSegmentState(shutterSegments['16'], false);
                    setSegmentState(shutterSegments['17'], false);
                  }
                });

                if (size.height < 50) return;
              });
            });
}
