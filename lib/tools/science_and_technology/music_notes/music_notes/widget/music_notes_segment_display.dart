part of 'package:gc_wizard/tools/science_and_technology/music_notes/music_notes/widget/music_notes.dart';

final _INITIAL_SEGMENTS = <String, bool>{
  bLabel: false,
  hashLabel: false,
  notePosition[0]: false,
  notePosition[1]: false,
  notePosition[2]: false,
  notePosition[3]: false,
  notePosition[4]: false,
  notePosition[5]: false,
  notePosition[6]: false,
  notePosition[7]: false,
  notePosition[8]: false,
  notePosition[9]: false,
  notePosition[10]: false,
  notePosition[11]: false,
  notePosition[12]: false,
  notePosition[13]: false,
  notePosition[14]: false,
  notePosition[15]: false,
  notePosition[16]: false,
  notePosition[17]: false,
  notePosition[18]: false,
  notePosition[19]: false,
  notePosition[20]: false,
  notePosition[21]: false,
  notePosition[22]: false,
  notePosition[23]: false,
  notePosition[24]: false,
  notePosition[25]: false,
  notePosition[26]: false,
  notePosition[27]: false,
  helpLine1: true,
  helpLine2: true,
  helpLine3: true,
  helpLine4: true,
  helpLine5: true,
  helpLineN1: true,
  helpLineN2: true,
  helpLineN3: true,
  helpLineN4: true,
  trebleClef: false,
  altClef: false,
  bassClef: false,
};

const _NOTES_RELATIVE_DISPLAY_WIDTH = 380;
const _NOTES_RELATIVE_DISPLAY_WIDTH_OUTPUT = 160;
const _NOTES_RELATIVE_DISPLAY_HEIGHT = 445;

class _NotesSegmentDisplay extends NSegmentDisplay {
  _NotesSegmentDisplay(
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
            aspectRatio: readOnly
                ? _NOTES_RELATIVE_DISPLAY_WIDTH_OUTPUT / _NOTES_RELATIVE_DISPLAY_HEIGHT
                : SEGMENTS_RELATIVE_DISPLAY_WIDTH / SEGMENTS_RELATIVE_DISPLAY_HEIGHT,
            type: SegmentDisplayType.CUSTOM,
            customPaint: (GCWTouchCanvas canvas, Size size, Map<String, bool> currentSegments, Function setSegmentState,
                Color segment_color_on, Color segment_color_off) {
              var paint = defaultSegmentPaint();
              var SEGMENTS_COLOR_ON = segment_color_on;
              var SEGMENTS_COLOR_OFF = segment_color_off;
              var LINE_OFFSET_X = size.width / _getSymbolWidth(readOnly) * 50.0;
              var LINE_OFFSET_Y = size.height / _NOTES_RELATIVE_DISPLAY_HEIGHT * 20.0;
              var LINE_DISTANCE = size.height / _NOTES_RELATIVE_DISPLAY_HEIGHT * 30.0;

              var lines = [
                helpLine5,
                helpLine4,
                helpLine3,
                helpLine2,
                helpLine1,
                '',
                '',
                '',
                '',
                '',
                helpLineN1,
                helpLineN2,
                helpLineN3,
                helpLineN4
              ];
              var pathL = Path();
              var counter = 0;
              paint.color = Colors.grey;
              for (var key in lines) {
                if (key.isEmpty || segmentActive(currentSegments, key)) {
                  pathL.addPath(
                      _createLine(key.isNotEmpty, size, Offset(0, counter * LINE_DISTANCE + LINE_OFFSET_Y),
                          LINE_OFFSET_X, readOnly),
                      const Offset(0, 0));
                }
                counter++;
              }
              var xOffset = readOnly ? 0.0 : -size.width / _getSymbolWidth(readOnly) * 100.0;
              if (segmentActive(currentSegments, trebleClef)) {
                pathL.addPath(_createTrebleClef(size, Offset(xOffset, 7 * LINE_DISTANCE + LINE_OFFSET_Y), readOnly),
                    const Offset(0, 0));
              } else if (segmentActive(currentSegments, altClef)) {
                pathL.addPath(_createAltClef(size, Offset(xOffset, 7 * LINE_DISTANCE + LINE_OFFSET_Y), readOnly),
                    const Offset(0, 0));
              } else if (segmentActive(currentSegments, bassClef)) {
                pathL.addPath(_createBassClef(size, Offset(xOffset, 7 * LINE_DISTANCE + LINE_OFFSET_Y), readOnly),
                    const Offset(0, 0));
              }

              canvas.touchCanvas.drawPath(pathL, paint);

              if (!readOnly || (readOnly && !_noteSelected(currentSegments))) {
                // if readOnly drawed in _drawNote (note position needed)
                _drawHash(
                    hashLabel,
                    _createHash(
                        size,
                        Offset(size.width / _getSymbolWidth(readOnly) * 25.0, 5 * LINE_DISTANCE + LINE_OFFSET_Y),
                        readOnly),
                    size,
                    canvas,
                    paint,
                    readOnly,
                    currentSegments,
                    setSegmentState,
                    SEGMENTS_COLOR_ON,
                    SEGMENTS_COLOR_OFF);

                _drawB(
                    bLabel,
                    _createB(
                        size,
                        Offset(size.width / _getSymbolWidth(readOnly) * 25.0, 9 * LINE_DISTANCE + LINE_OFFSET_Y),
                        readOnly),
                    size,
                    canvas,
                    paint,
                    readOnly,
                    currentSegments,
                    setSegmentState,
                    SEGMENTS_COLOR_ON,
                    SEGMENTS_COLOR_OFF);
              }

              var notePositions = [105, 35, -35, -105];
              counter = 0;
              for (var key in notePosition) {
                var offsetX = size.width /
                    _getSymbolWidth(readOnly) *
                    (readOnly
                        ? _getSymbolWidth(readOnly) / 2
                        : (_getSymbolWidth(readOnly) / 2 + notePositions[(counter % 4).toInt()] + LINE_OFFSET_X));

                _drawNote(
                    key,
                    _createNote(size, Offset(offsetX, counter * 0.5 * LINE_DISTANCE + LINE_OFFSET_Y), readOnly),
                    size,
                    canvas,
                    paint,
                    readOnly,
                    currentSegments,
                    setSegmentState,
                    SEGMENTS_COLOR_ON,
                    SEGMENTS_COLOR_OFF);
                counter++;
              }
            });

  static int _getSymbolWidth(bool readOnly) {
    return readOnly ? _NOTES_RELATIVE_DISPLAY_WIDTH_OUTPUT : _NOTES_RELATIVE_DISPLAY_WIDTH;
  }

  static void _drawNote(String note, Path path, Size size, GCWTouchCanvas canvas, Paint paint, bool readOnly,
      Map<String, bool> currentSegments, Function setSegmentState, Color colorOn, Color colorOff) {
    var active = segmentActive(currentSegments, note);
    paint.color = active ? colorOn : colorOff;
    if (active || !readOnly) {
      canvas.touchCanvas.drawPath(path, paint);
      path.addRect(path.getBounds().inflate(size.width / _getSymbolWidth(readOnly) * 10));
      paint.color = Colors.transparent;
      canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
        _setNotesState(note, currentSegments, setSegmentState);
      });
    }

    if (active && readOnly) {
      var bounds = path.getBounds();
      _drawHash(
          hashLabel,
          _createHash(
              size, Offset(bounds.center.dx - size.width / _getSymbolWidth(readOnly) * 60, bounds.center.dy), readOnly),
          size,
          canvas,
          paint,
          readOnly,
          currentSegments,
          setSegmentState,
          colorOn,
          colorOff);

      _drawB(
          bLabel,
          _createB(
              size, Offset(bounds.center.dx - size.width / _getSymbolWidth(readOnly) * 60, bounds.center.dy), readOnly),
          size,
          canvas,
          paint,
          readOnly,
          currentSegments,
          setSegmentState,
          colorOn,
          colorOff);
    }
  }

  static void _drawHash(String label, Path path, Size size, GCWTouchCanvas canvas, Paint paint, bool readOnly,
      Map<String, bool> currentSegments, Function setSegmentState, Color colorOn, Color colorOff) {
    var active = segmentActive(currentSegments, label);
    paint.color = active ? colorOn : colorOff;
    if (active || !readOnly) {
      canvas.touchCanvas.drawPath(path, paint);
      path.addRect(path.getBounds().inflate(size.width / _getSymbolWidth(readOnly) * 10));
      paint.color = Colors.transparent;
      canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
        setSegmentState(label, !segmentActive(currentSegments, label));
        if (segmentActive(currentSegments, label)) setSegmentState(bLabel, false);
      });
    }
  }

  static void _drawB(String label, Path path, Size size, GCWTouchCanvas canvas, Paint paint, bool readOnly,
      Map<String, bool> currentSegments, Function setSegmentState, Color colorOn, Color colorOff) {
    var active = segmentActive(currentSegments, label);
    paint.color = active ? colorOn : colorOff;
    if (active || !readOnly) {
      canvas.touchCanvas.drawPath(path, paint);
      path.addRect(path.getBounds().inflate(size.width / _getSymbolWidth(readOnly) * 10));
      paint.color = Colors.transparent;
      canvas.touchCanvas.drawPath(path, paint, onTapDown: (tapDetail) {
        setSegmentState(label, !segmentActive(currentSegments, label));
        if (segmentActive(currentSegments, label)) setSegmentState(hashLabel, false);
      });
    }
  }

  static void _setNotesState(String tappedNote, Map<String, bool> currentSegments, Function setSegmentState) {
    var newState = !segmentActive(currentSegments, tappedNote);
    if (newState) {
      for (var i = 1; i <= 5; i++) {
        setSegmentState(i.toString(), false);
        setSegmentState(i.toString() + 's', false);
        setSegmentState('-' + i.toString(), false);
        setSegmentState('-' + i.toString() + 's', false);
        setSegmentState(i.toString() + 'h', false);
        setSegmentState(i.toString() + 'hs', false);
        setSegmentState('-' + i.toString() + 'h', false);
        setSegmentState('-' + i.toString() + 'hs', false);
      }
    }
    setSegmentState(tappedNote, newState);
  }

  static Path _createLine(bool shortLine, Size size, Offset offset, double lineOffsetX, bool readOnly) {
    var path = Path();
    if (shortLine) {
      var rect = Rect.fromCenter(
          center: Offset(
              size.width / _getSymbolWidth(readOnly) * (_getSymbolWidth(readOnly) / 2 + (readOnly ? 0 : lineOffsetX)),
              0.0),
          width: readOnly ? size.width / _getSymbolWidth(readOnly) * 70 : size.width / _getSymbolWidth(readOnly) * 260,
          height: max(1.0, size.height / _NOTES_RELATIVE_DISPLAY_HEIGHT * 2));
      path.addRect(rect);
    } else {
      var rect = Rect.fromCenter(
          center: Offset(
              size.width / _getSymbolWidth(readOnly) * (_getSymbolWidth(readOnly) / 2 + (readOnly ? 0 : lineOffsetX)),
              0.0),
          width: size.width / _getSymbolWidth(readOnly) * (readOnly ? 380 : 340),
          height: max(1.0, size.height / _NOTES_RELATIVE_DISPLAY_HEIGHT * 2));
      path.addRect(rect);
    }
    path = path.shift(offset);
    return path;
  }

  static Path _createNote(Size size, Offset offset, bool readOnly) {
    var path = Path();
    var rect = Rect.fromCenter(
        center: offset,
        width: max(3, size.width / _getSymbolWidth(readOnly) * 45),
        height: max(2, size.height / _NOTES_RELATIVE_DISPLAY_HEIGHT * 28));
    path.addOval(rect);

    return path;
  }

  static Path _createHash(Size size, Offset offset, bool readOnly) {
    var path = Path();
    var scale = 0.8 * size.width / _getSymbolWidth(readOnly);

    path.moveTo(-19.201, -8.436);
    path.moveTo(-11.389, -12.587);
    path.lineTo(-11.389, -25.77);
    path.lineTo(-6.359, -25.770);
    path.lineTo(-6.359, -15.272);
    path.lineTo(6.385, -22.059);
    path.lineTo(6.385, -35.34);
    path.lineTo(11.414, -35.34);
    path.lineTo(11.414, -24.745);
    path.lineTo(19.227, -28.895);
    path.lineTo(19.227, -21.473);
    path.lineTo(11.414, -17.323);
    path.lineTo(11.414, 4.454);
    path.lineTo(19.227, 0.304);
    path.lineTo(19.227, 7.726);
    path.lineTo(11.414, 11.876);
    path.lineTo(11.414, 26.232);
    path.lineTo(6.385, 26.232);
    path.lineTo(6.385, 14.562);
    path.lineTo(-6.359, 21.349);
    path.lineTo(-6.359, 34.679);
    path.lineTo(-11.389, 34.679);
    path.lineTo(-11.389, 24.035);
    path.lineTo(-19.201, 28.185);
    path.lineTo(-19.201, 20.763);
    path.lineTo(-11.389, 16.613);
    path.lineTo(-11.389, -5.165);
    path.lineTo(-19.201, -1.014);
    path.lineTo(-19.201, -8.436);
    path.close();
    path.moveTo(-6.359, 13.927);
    path.lineTo(6.385, 7.140);
    path.lineTo(6.385, -14.637);
    path.lineTo(-6.359, -7.850);
    path.lineTo(-6.359, 13.927);
    path.close();

    final translateM =
        Float64List.fromList([scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, scale, 0, offset.dx, offset.dy, 0, 1]);
    return path.transform(translateM);
  }

  static Path _createB(Size size, Offset offset, bool readOnly) {
    var path = Path();
    var scale = 0.8 * size.width / _getSymbolWidth(readOnly);

    path.moveTo(1.234, 15.737);
    path.lineTo(-4.796, 17.079);
    path.lineTo(-8.447, 17.436);
    path.lineTo(-10.509, 17.494);
    path.lineTo(-12.364, 17.494);
    path.lineTo(-12.364, -52.525);
    path.lineTo(-7.335, -52.525);
    path.lineTo(-7.335, -11.217);
    path.lineTo(-4.080, -13.717);
    path.lineTo(-1.720, -15.050);
    path.lineTo(2.046, -16.212);
    path.lineTo(5.018, -16.441);
    path.lineTo(7.643, -16.191);
    path.lineTo(9.950, -15.440);
    path.lineTo(13.563, -12.633);
    path.lineTo(15.243, -9.802);
    path.lineTo(15.785, -8.287);
    path.lineTo(16.453, -4.744);
    path.lineTo(16.542, -2.721);
    path.lineTo(16.263, 0.778);
    path.lineTo(15.272, 4.237);
    path.lineTo(12.011, 9.345);
    path.lineTo(6.996, 13.271);
    path.lineTo(1.234, 15.737);
    path.close();
    path.moveTo(7.655, -6.212);
    path.lineTo(6.312, -9.044);
    path.lineTo(4.042, -10.948);
    path.lineTo(2.246, -11.539);
    path.lineTo(0.819, -11.656);
    path.lineTo(-3.453, -10.704);
    path.lineTo(-7.277, -8.333);
    path.lineTo(-7.335, 14.858);
    path.lineTo(-3.716, 14.192);
    path.lineTo(-0.572, 12.978);
    path.lineTo(3.065, 10.441);
    path.lineTo(4.262, 9.169);
    path.lineTo(7.143, 3.822);
    path.lineTo(8.035, -0.993);
    path.lineTo(8.095, -2.721);
    path.lineTo(7.868, -5.274);
    path.close();

    final translateM =
        Float64List.fromList([scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, scale, 0, offset.dx, offset.dy, 0, 1]);
    return path.transform(translateM);
  }

  static Path _createAltClef(Size size, Offset offset, bool readOnly) {
    var path = Path();
    var scale = size.width / _getSymbolWidth(readOnly);

    path.addRect(const Rect.fromLTWH(0, -60, 15.066, 120.002));
    path.addRect(const Rect.fromLTWH(20.116, -60, 4.964, 120.002));

    path.moveTo(44.065, -52.249);
    path.lineTo(45.806, -52.075);
    path.lineTo(48.941, -51.640);
    path.lineTo(51.467, -50.159);
    path.lineTo(53.208, -47.982);
    path.lineTo(53.818, -45.282);
    path.lineTo(53.208, -42.234);
    path.lineTo(51.467, -39.883);
    path.lineTo(48.767, -38.316);
    path.lineTo(45.371, -37.706);
    path.lineTo(41.887, -38.229);
    path.lineTo(39.014, -39.970);
    path.lineTo(37.011, -42.583);
    path.lineTo(36.314, -45.805);
    path.lineTo(37.794, -51.204);
    path.lineTo(42.410, -55.994);
    path.lineTo(49.028, -59.390);
    path.lineTo(56.866, -60.522);
    path.lineTo(66.881, -58.693);
    path.lineTo(74.979, -53.294);
    path.lineTo(80.379, -45.108);
    path.lineTo(82.207, -35.268);
    path.lineTo(80.117, -24.034);
    path.lineTo(73.760, -14.629);
    path.lineTo(64.268, -8.185);
    path.lineTo(52.947, -6.008);
    path.lineTo(48.506, -6.530);
    path.lineTo(44.152, -8.010);
    path.lineTo(41.365, -3.308);
    path.lineTo(37.185, 0.088);
    path.lineTo(39.972, 2.265);
    path.lineTo(42.932, 5.575);
    path.lineTo(43.803, 6.794);
    path.lineTo(44.500, 8.274);
    path.lineTo(48.941, 6.794);
    path.lineTo(53.121, 6.271);
    path.lineTo(64.268, 8.361);
    path.lineTo(73.673, 14.718);
    path.lineTo(80.030, 24.036);
    path.lineTo(82.207, 35.183);
    path.lineTo(80.466, 44.937);
    path.lineTo(75.066, 52.948);
    path.lineTo(66.968, 58.26);
    path.lineTo(57.040, 60.002);
    path.lineTo(49.115, 58.87);
    path.lineTo(42.497, 55.648);
    path.lineTo(37.882, 50.858);
    path.lineTo(36.314, 45.285);
    path.lineTo(36.924, 42.150);
    path.lineTo(39.014, 39.624);
    path.lineTo(41.974, 37.883);
    path.lineTo(45.545, 37.186);
    path.lineTo(48.941, 37.622);
    path.lineTo(51.728, 39.363);
    path.lineTo(53.644, 41.889);
    path.lineTo(54.253, 44.937);
    path.lineTo(53.644, 47.462);
    path.lineTo(51.902, 49.552);
    path.lineTo(49.377, 51.032);
    path.lineTo(46.329, 51.555);
    path.lineTo(45.980, 51.555);
    path.lineTo(45.632, 51.555);
    path.lineTo(44.413, 51.642);
    path.lineTo(43.977, 52.252);
    path.lineTo(44.848, 53.993);
    path.lineTo(47.635, 55.822);
    path.lineTo(51.292, 57.215);
    path.lineTo(55.037, 57.651);
    path.lineTo(65.139, 51.903);
    path.lineTo(68.448, 34.748);
    path.lineTo(65.226, 16.547);
    path.lineTo(55.385, 10.451);
    path.lineTo(49.899, 10.974);
    path.lineTo(46.242, 12.716);
    path.lineTo(43.542, 16.634);
    path.lineTo(41.800, 22.817);
    path.lineTo(40.842, 18.463);
    path.lineTo(39.449, 14.806);
    path.lineTo(37.620, 11.409);
    path.lineTo(35.182, 7.926);
    path.lineTo(30.828, 3.485);
    path.lineTo(25.516, -0.173);
    path.lineTo(30.392, -3.482);
    path.lineTo(34.834, -8.010);
    path.lineTo(39.188, -15.064);
    path.lineTo(41.452, -22.815);
    path.lineTo(42.845, -17.590);
    path.lineTo(44.761, -14.106);
    path.lineTo(48.854, -11.407);
    path.lineTo(55.037, -10.536);
    path.lineTo(64.790, -16.632);
    path.lineTo(68.100, -34.745);
    path.lineTo(64.790, -52.162);
    path.lineTo(54.776, -57.997);
    path.lineTo(51.118, -57.561);
    path.lineTo(47.461, -56.168);
    path.lineTo(44.674, -54.426);
    path.lineTo(43.629, -52.772);
    path.lineTo(44.065, -52.249);
    path.close();

    final translateM =
        Float64List.fromList([scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, scale, 0, offset.dx, offset.dy, 0, 1]);
    return path.transform(translateM);
  }

  static Path _createBassClef(Size size, Offset offset, bool readOnly) {
    var path = Path();
    var scale = size.width / _getSymbolWidth(readOnly);

    path.moveTo(14.804, -50.640);
    path.lineTo(14.282, -46.460);
    path.lineTo(14.456, -45.415);
    path.lineTo(15.675, -43.412);
    path.lineTo(18.113, -42.105);
    path.lineTo(20.639, -41.496);
    path.lineTo(24.122, -41.060);
    path.lineTo(27.867, -39.841);
    path.lineTo(29.957, -37.142);
    path.lineTo(30.392, -34.877);
    path.lineTo(30.654, -31.394);
    path.lineTo(29.783, -27.824);
    path.lineTo(26.996, -24.950);
    path.lineTo(22.816, -23.034);
    path.lineTo(17.591, -22.337);
    path.lineTo(12.366, -23.034);
    path.lineTo(8.186, -25.124);
    path.lineTo(5.225, -28.869);
    path.lineTo(4.180, -34.094);
    path.lineTo(6.270, -45.153);
    path.lineTo(12.888, -55.255);
    path.lineTo(20.726, -60.132);
    path.lineTo(32.395, -61.786);
    path.lineTo(47.896, -58.651);
    path.lineTo(59.217, -49.159);
    path.lineTo(64.094, -40.015);
    path.lineTo(65.661, -30.088);
    path.lineTo(61.307, -15.284);
    path.lineTo(48.332, 0.653);
    path.lineTo(34.921, 11.713);
    path.lineTo(18.810, 22.163);
    path.lineTo(6.880, 28.433);
    path.lineTo(0.958, 30.000);
    path.lineTo(0.523, 27.823);
    path.lineTo(9.753, 23.904);
    path.lineTo(19.681, 17.634);
    path.lineTo(33.789, 5.530);
    path.lineTo(42.236, -6.314);
    path.lineTo(45.458, -14.500);
    path.lineTo(47.461, -23.469);
    path.lineTo(48.157, -28.607);
    path.lineTo(48.332, -33.658);
    path.lineTo(45.806, -46.547);
    path.lineTo(38.230, -54.820);
    path.lineTo(33.702, -56.736);
    path.lineTo(28.825, -57.432);
    path.lineTo(22.119, -56.387);
    path.lineTo(16.807, -53.165);
    path.lineTo(14.804, -50.640);

    path.addOval(const Rect.fromLTWH(70.016, -26.692, 16.300, 16.300));

    path.addOval(const Rect.fromLTWH(70.016, -52.381, 16.300, 16.300));

    final translateM =
        Float64List.fromList([scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, scale, 0, offset.dx, offset.dy, 0, 1]);
    return path.transform(translateM);
  }

  static Path _createTrebleClef(Size size, Offset offset, bool readOnly) {
    var path = Path();
    var scale = size.width / _getSymbolWidth(readOnly);

    path.moveTo(52.947, -96.333);
    path.lineTo(60.262, -76.13);
    path.lineTo(61.133, -67.595);
    path.lineTo(55.995, -40.425);
    path.lineTo(40.755, -20.483);
    path.lineTo(44.326, -2.021);
    path.lineTo(47.374, -2.369);
    path.lineTo(50.596, -2.456);
    path.lineTo(62.875, 0.069);
    path.lineTo(72.367, 7.732);
    path.lineTo(77.940, 18.270);
    path.lineTo(79.856, 31.158);
    path.lineTo(78.114, 40.824);
    path.lineTo(72.976, 49.097);
    path.lineTo(65.400, 54.932);
    path.lineTo(55.908, 58.328);
    path.lineTo(60.785, 85.673);
    path.lineTo(61.046, 87.501);
    path.lineTo(61.133, 88.982);
    path.lineTo(59.391, 96.819);
    path.lineTo(54.079, 103.525);
    path.lineTo(46.677, 108.14);
    path.lineTo(38.578, 109.708);
    path.lineTo(31.699, 108.227);
    path.lineTo(25.167, 103.786);
    path.lineTo(20.465, 97.603);
    path.lineTo(18.897, 90.811);
    path.lineTo(19.942, 85.673);
    path.lineTo(22.903, 81.318);
    path.lineTo(27.344, 78.357);
    path.lineTo(32.569, 77.400);
    path.lineTo(37.446, 78.270);
    path.lineTo(41.539, 80.796);
    path.lineTo(44.239, 84.628);
    path.lineTo(45.197, 89.243);
    path.lineTo(44.326, 94.120);
    path.lineTo(41.539, 98.387);
    path.lineTo(37.533, 101.261);
    path.lineTo(32.918, 102.219);
    path.lineTo(31.873, 102.219);
    path.lineTo(30.828, 102.219);
    path.lineTo(35.966, 105.702);
    path.lineTo(41.104, 106.834);
    path.lineTo(43.716, 106.399);
    path.lineTo(47.112, 105.092);
    path.lineTo(55.734, 98.213);
    path.lineTo(58.608, 88.982);
    path.lineTo(58.520, 87.240);
    path.lineTo(58.259, 85.324);
    path.lineTo(53.644, 59.460);
    path.lineTo(47.983, 60.070);
    path.lineTo(41.800, 60.331);
    path.lineTo(25.864, 57.196);
    path.lineTo(12.366, 47.878);
    path.lineTo(3.135, 34.293);
    path.lineTo(0.087, 18.270);
    path.lineTo(6.444, -1.586);
    path.lineTo(25.429, -26.492);
    path.lineTo(29.783, -31.194);
    path.lineTo(34.921, -36.071);
    path.lineTo(33.353, -41.209);
    path.lineTo(31.699, -49.569);
    path.lineTo(30.479, -57.929);
    path.lineTo(30.044, -63.764);
    path.lineTo(31.350, -75.607);
    path.lineTo(35.269, -87.102);
    path.lineTo(41.191, -96.594);
    path.lineTo(47.722, -99.729);
    path.lineTo(52.947, -96.333);
    path.close();
    path.moveTo(26.909, 7.994);
    path.lineTo(41.713, -1.499);
    path.lineTo(38.491, -18.132);
    path.lineTo(35.704, -15.693);
    path.lineTo(30.915, -10.817);
    path.lineTo(15.675, 9.648);
    path.lineTo(10.537, 26.717);
    path.lineTo(13.150, 38.125);
    path.lineTo(21.161, 48.139);
    path.lineTo(31.873, 54.758);
    path.lineTo(43.629, 57.022);
    path.lineTo(47.896, 56.586);
    path.lineTo(52.599, 55.28);
    path.lineTo(43.542, 10.258);
    path.lineTo(36.662, 12.522);
    path.lineTo(31.089, 17.312);
    path.lineTo(27.431, 23.669);
    path.lineTo(26.212, 30.984);
    path.lineTo(29.260, 39.866);
    path.lineTo(38.578, 47.791);
    path.lineTo(42.410, 49.707);
    path.lineTo(45.197, 50.404);
    path.lineTo(45.197, 51.536);
    path.lineTo(41.974, 50.752);
    path.lineTo(37.882, 48.923);
    path.lineTo(25.429, 38.734);
    path.lineTo(21.248, 24.714);
    path.lineTo(22.642, 15.831);
    path.lineTo(26.909, 7.994);
    path.close();
    path.moveTo(55.995, -76.565);
    path.lineTo(52.337, -84.141);
    path.lineTo(48.854, -85.36);
    path.lineTo(44.065, -82.400);
    path.lineTo(39.188, -73.430);
    path.lineTo(35.966, -64.112);
    path.lineTo(34.921, -56.971);
    path.lineTo(35.095, -52.704);
    path.lineTo(35.617, -47.043);
    path.lineTo(36.488, -41.209);
    path.lineTo(37.272, -37.813);
    path.lineTo(40.755, -41.035);
    path.lineTo(45.806, -45.998);
    path.lineTo(53.731, -58.800);
    path.lineTo(56.343, -72.037);
    path.lineTo(55.995, -76.565);
    path.close();
    path.moveTo(49.202, 10.258);
    path.lineTo(46.416, 10.345);
    path.lineTo(55.124, 53.800);
    path.lineTo(61.917, 51.187);
    path.lineTo(67.490, 46.398);
    path.lineTo(71.061, 40.128);
    path.lineTo(72.280, 32.900);
    path.lineTo(70.625, 23.930);
    path.lineTo(65.574, 16.702);
    path.lineTo(58.085, 11.825);
    path.lineTo(49.202, 10.258);
    path.close();

    final translateM =
        Float64List.fromList([scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, scale, 0, offset.dx, offset.dy, 0, 1]);
    return path.transform(translateM);
  }

  static bool _noteSelected(Map<String, bool> currentSegments) {
    var regExp = RegExp(r'^-?\d');
    return currentSegments.entries.any((element) {
      if (element.value == false) return false;
      return regExp.hasMatch(element.key);
    });
  }
}
