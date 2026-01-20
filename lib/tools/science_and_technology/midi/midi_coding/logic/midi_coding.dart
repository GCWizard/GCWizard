import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/midi/_common/logic/midi_data.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

const Map<int, String> MIDI_CODING = {
  0: 'midi_frequency',
  1: 'midi_helmholtz',
  2: 'midi_scientific',
  3: 'midi_german',
  4: 'midi_latin',
};

Map<int, String> mapIntMIDIKEYSToMapIntString(
  Map<int, MIDIKey> source,
  String Function(MIDIKey m) selector,
) {
  return source.map(
    (key, value) => MapEntry(key, selector(value)),
  );
}

Map<int, String> getCodeBook(int type) {
  Map<int, String> result = {};
  switch (type) {
    case 0:
      result = mapIntMIDIKEYSToMapIntString(
        MIDI_KEYS,
        (m) => m.frequency,
      );
    case 1:
      result = mapIntMIDIKEYSToMapIntString(
        MIDI_KEYS,
        (m) => m.helmholtz,
      );
    case 2:
      result = mapIntMIDIKEYSToMapIntString(
        MIDI_KEYS,
        (m) => m.scientific,
      );
    case 3:
      result = mapIntMIDIKEYSToMapIntString(
        MIDI_KEYS,
        (m) => m.german,
      );
    case 4:
      result = mapIntMIDIKEYSToMapIntString(
        MIDI_KEYS,
        (m) => m.latin,
      );
  }
  return result;
}

String encodeMIDI(String _currentEncodeInput, int _currentType) {
  Map<int, String> CODEBOOK = getCodeBook(_currentType);

  return _currentEncodeInput.split('').map((character) {
    var code = CODEBOOK[character.codeUnitAt(0)];
    return code ?? UNKNOWN_ELEMENT;
  }).join(' ');
}

String decodeMIDI(String _currentEncodeInput, int _currentType) {
  if (_currentEncodeInput.isEmpty) return '';

  Map<String, int> CODEBOOK = switchMapKeyValue(getCodeBook(_currentType));

  return _currentEncodeInput.split(' ').map((code) {
    var ascii = CODEBOOK[code];
    return ascii != null ? String.fromCharCode(ascii) : UNKNOWN_ELEMENT;
  }).join('');
}

class MIDINoteGraphicData {
  final int offset;
  final int lines;
  final bool line;
  final bool sharp;

  MIDINoteGraphicData(this.offset, this.lines, this.line, this.sharp);
}

List<MIDINoteGraphicData> _MIDINotesGraphic = [
  MIDINoteGraphicData(34, 15, false, true), //     0   c
  MIDINoteGraphicData(34, 15, false, false), //     1       is
  MIDINoteGraphicData(33, 14, true, true), //     2   d
  MIDINoteGraphicData(33, 14, true, false), //     3       is
  MIDINoteGraphicData(32, 14, false, true), //     4   e
  MIDINoteGraphicData(31, 13, false, true), //     5   f
  MIDINoteGraphicData(31, 13, true, false), //     6       is
  MIDINoteGraphicData(30, 13, true, true), //     7   g
  MIDINoteGraphicData(30, 13, false, false), //     8       is
  MIDINoteGraphicData(29, 12, false, true), //     9   a
  MIDINoteGraphicData(29, 12, true, false), //    10       is
  MIDINoteGraphicData(28, 12, true, true), //    11   h
  // 0 octave
  MIDINoteGraphicData(27, 11, false, true), //    12     c
  MIDINoteGraphicData(27, 11, false, false), //    13       is
  MIDINoteGraphicData(26, 11, true, true), //    14     d
  MIDINoteGraphicData(26, 11, true, false), //    15        is
  MIDINoteGraphicData(25, 10, false, true), //    16     e
  MIDINoteGraphicData(24, 10, false, true), //    17     f
  MIDINoteGraphicData(24, 10, true, false), //    18       is
  MIDINoteGraphicData(23, 9, true, true), //    19     g
  MIDINoteGraphicData(23, 9, false, false), //    20       is
  MIDINoteGraphicData(22, 9, false, true), //    21     a
  MIDINoteGraphicData(22, 8, true, false), //    22       is
  MIDINoteGraphicData(21, 8, true, true), //    23     h
  // 1st octave
  MIDINoteGraphicData(20, 8, false, true), //    24     c
  MIDINoteGraphicData(20, 8, false, false), //    25       is
  MIDINoteGraphicData(19, 7, true, true), //    26     d
  MIDINoteGraphicData(19, 7, true, false), //    27       is
  MIDINoteGraphicData(18, 7, false, true), //    28     e
  MIDINoteGraphicData(17, 0, false, true), //    29     f
  MIDINoteGraphicData(17, 0, true, false), //    30       is
  MIDINoteGraphicData(16, 0, true, true), //    31     g
  MIDINoteGraphicData(16, 0, false, false), //    32       is
  MIDINoteGraphicData(15, 0, false, true), //    33     a
  MIDINoteGraphicData(15, 0, true, false), //    34       is
  MIDINoteGraphicData(14, 0, true, true), //    35     h
  // 2nd octave
  MIDINoteGraphicData(13, 0, false, true), //    36   c
  MIDINoteGraphicData(13, 0, false, false), //    37       is
  MIDINoteGraphicData(12, 0, true, true), //    38   d
  MIDINoteGraphicData(12, 0, true, false), //    39       is
  MIDINoteGraphicData(11, 0, false, true), //    40   e
  MIDINoteGraphicData(10, 0, false, true), //    41   f
  MIDINoteGraphicData(10, 0, true, false), //    42       is
  MIDINoteGraphicData(9, 0, true, true), //    43   g
  MIDINoteGraphicData(9, 0, false, false), //    44       is
  MIDINoteGraphicData(8, 0, false, true), //    45   a
  MIDINoteGraphicData(8, 0, true, false), //    46       is
  MIDINoteGraphicData(7, 0, true, true), //    47   h
  // 3rd octave
  MIDINoteGraphicData(6, 1, true, true), //    48   C3  c
  MIDINoteGraphicData(6, 1, true, false), //    49     is
  MIDINoteGraphicData(5, 0, false, true), //    50   D3  d
  MIDINoteGraphicData(5, 0, false, false), //    51     is
  MIDINoteGraphicData(4, 0, true, true), //    52   E3  e
  MIDINoteGraphicData(3, 0, false, true), //    53   F3  f
  MIDINoteGraphicData(3, 0, false, false), //    54     is
  MIDINoteGraphicData(2, 0, true, true), //    55   G3  g
  MIDINoteGraphicData(2, 0, true, false), //    56     is
  MIDINoteGraphicData(1, 0, false, true), //    57   A3  a
  MIDINoteGraphicData(1, 0, false, false), //    58     is
  MIDINoteGraphicData(0, 0, true, true), //    59   B3  h
  // 4th octave
  MIDINoteGraphicData(-1, 0, false, true), //    60   C4  c'    Middle C
  MIDINoteGraphicData(-1, 0, false, false), //    61     is
  MIDINoteGraphicData(-2, 0, true, true), //    62   D4
  MIDINoteGraphicData(-2, 0, true, false), //    63     is
  MIDINoteGraphicData(-3, 0, false, true), //    64   E4
  MIDINoteGraphicData(-4, 0, true, true), //    65   F4
  MIDINoteGraphicData(-4, 0, true, false), //    66     is
  MIDINoteGraphicData(-5, 0, false, true), //    67   G4
  MIDINoteGraphicData(-5, 0, false, false), //    68     is
  MIDINoteGraphicData(-6, 1, true, true), //    69   A
  MIDINoteGraphicData(-6, 1, true, false), //    70     is
  MIDINoteGraphicData(-7, 1, false, true), //    71   B
  // 5th octave
  MIDINoteGraphicData(-8, 2, false, true), //    72    c
  MIDINoteGraphicData(-8, 2, false, false), //    73
  MIDINoteGraphicData(-9, 2, true, true), //    74    d
  MIDINoteGraphicData(-9, 2, true, false), //    75
  MIDINoteGraphicData(-10, 3, false, true), //    76    e
  MIDINoteGraphicData(-11, 3, false, true), //    77    f
  MIDINoteGraphicData(-11, 3, true, false), //    78
  MIDINoteGraphicData(-12, 4, true, true), //    79    g
  MIDINoteGraphicData(-12, 4, false, true), //    80
  MIDINoteGraphicData(-13, 4, false, false), //    81    a
  MIDINoteGraphicData(-13, 4, true, true), //    82
  MIDINoteGraphicData(-14, 5, true, false), //    83    h
  // 6th octave
  MIDINoteGraphicData(-15, 5, false, true), //    84   c
  MIDINoteGraphicData(-15, 5, false, true), //    85      is
  MIDINoteGraphicData(-16, 6, true, false), //    86   d
  MIDINoteGraphicData(-16, 6, true, true), //    87      is
  MIDINoteGraphicData(-17, 6, false, false), //    88   e
  MIDINoteGraphicData(-18, 7, false, true), //    89   f
  MIDINoteGraphicData(-18, 7, true, false), //    90      is
  MIDINoteGraphicData(-19, 7, true, true), //    91   g
  MIDINoteGraphicData(-19, 7, false, false), //    92      is
  MIDINoteGraphicData(-20, 8, false, true), //    93   a
  MIDINoteGraphicData(-20, 8, true, false), //    94      is
  MIDINoteGraphicData(-21, 8, true, true), //    95   h
  // 7th octave
  MIDINoteGraphicData(-22, 9, false, true), //    96   c
  MIDINoteGraphicData(-22, 9, false, false), //    97
  MIDINoteGraphicData(-23, 9, true, true), //    98   d
  MIDINoteGraphicData(-23, 9, true, false), //    99
  MIDINoteGraphicData(-24, 10, false, true), //   100   e
  MIDINoteGraphicData(-25, 10, false, true), //   101   f
  MIDINoteGraphicData(-25, 10, true, false), //   102
  MIDINoteGraphicData(-26, 11, true, true), //   103   g
  MIDINoteGraphicData(-26, 11, false, false), //   104
  MIDINoteGraphicData(-27, 11, false, true), //   105   a
  MIDINoteGraphicData(-27, 11, true, false), //   106
  MIDINoteGraphicData(-28, 12, true, true), //   107   h
  // 8th octave
  MIDINoteGraphicData(-29, 12, false, true), //   108   c
  MIDINoteGraphicData(-29, 12, false, false), //   109
  MIDINoteGraphicData(-30, 13, true, true), //   110   d
  MIDINoteGraphicData(-30, 13, true, false), //   111
  MIDINoteGraphicData(-31, 13, false, true), //   112   e
  MIDINoteGraphicData(-32, 14, false, true), //   113   f
  MIDINoteGraphicData(-32, 14, true, false), //   114
  MIDINoteGraphicData(-33, 14, true, true), //   115   g
  MIDINoteGraphicData(-33, 14, false, false), //   116
  MIDINoteGraphicData(-34, 15, false, true), //   117   a
  MIDINoteGraphicData(-34, 15, true, false), //   118
  MIDINoteGraphicData(-35, 15, true, true), //   119   h
  // 9th octave
  MIDINoteGraphicData(-36, 16, false, true), //   120   c
  MIDINoteGraphicData(-36, 16, false, false), //   121      is
  MIDINoteGraphicData(-37, 16, true, true), //   122   d
  MIDINoteGraphicData(-37, 16, true, false), //   123      is
  MIDINoteGraphicData(-38, 17, false, true), //   124   e
  MIDINoteGraphicData(-39, 17, false, true), //   125   f
  MIDINoteGraphicData(-39, 17, true, false), //   126      is
  MIDINoteGraphicData(-40, 18, true, true), //   127   g
];

const _BREAK =
    '############' + '############' + '############' + '############';

const _CROSS = '      #    #' +
    '     #    # ' +
    '  ##########' +
    '    #    #  ' +
    '   #    #   ' +
    '##########  ' +
    ' #    #     ' +
    '#    #      ';

const _NOTE = '    ####    ' +
    '  ##    ##  ' +
    ' #        # ' +
    '#          #' +
    ' #        # ' +
    '  ##    ##  ' +
    '    ####    ';

const _VIOLIN_KEY = '       ##            ' +
    '      ###            ' +
    '     ##  #           ' +
    '    ###   #          ' +
    '    ##     #         ' +
    '    ##      #        ' +
    '    ##      ##       ' +
    '    ##      ##       ' +
    '    ##      ##       ' +
    '     #     ##        ' +
    '      #   ##         ' +
    '      #  ##          ' +
    '       ###           ' +
    '     ####            ' +
    '   #### #            ' +
    '  ####  #            ' +
    ' ####   #            ' +
    ' ###    #            ' +
    '###     ########     ' +
    '##    #############  ' +
    '##   ##    #      ###' +
    '##   ##    #      ###' +
    '##    ##   #       ##' +
    '##    ##   #       ##' +
    ' ##    #   #       ##' +
    ' ##    #   #       ##' +
    '  ##        #      ##' +
    '  ##        #      ##' +
    '   ##       #     ## ' +
    '    ###     #    ##  ' +
    '       ##########    ' +
    '             #       ' +
    '             #       ' +
    '             #       ' +
    '              #      ' +
    '              #      ' +
    '              #      ' +
    '               #     ' +
    '   ###         #     ' +
    '  #####        #     ' +
    '   ###        ##     ' +
    '    ###      ##      ' +
    '       ######        ';

const _BASS_KEY =
    '    #####            ' +
    '  ##     ##          ' +
    ' #        ###        ' +
    '#          ###    ## ' +
    '#           ###  ####' +
    '#           ###  ####' +
    '#           ###   ## ' +
    '####        ###      ' +
    ' ####       ###      ' +
    ' ####       ###      ' +
    '  ##        ###      ' +
    '            ###      ' +
    '            ###      ' +
    '            ###   ## ' +
    '            ###  ####' +
    '            ###  ####' +
    '            ###   ## ' +
    '            ###      ' +
    '            ###      ' +
    '            ###      ' +
    '           ###       ' +
    '           ###       ' +
    '           ###       ' +
    '           ###       ' +
    '           ###       ' +
    '          ###        ' +
    '          ###        ' +
    '          ###        ' +
    '          ###        ' +
    '         ###         ' +
    '         ###         ' +
    '         ###         ' +
    '        ###          ' +
    '       ###           ' +
    '      ###            ' +
    '     ##              ' +
    '   ##                ' +
    '##                   ';

Future<Uint8List> MIDINotes2Image(
  String input,
) async {
  const BOUNDS = 10.0;
  const CROSS_WIDTH = 12;
  const CROSS_HEIGHT = 8;
  const NOTE_WIDTH = 15;
  const NOTE_HEIGHT = 10;
  const VIOLIN_KEY_WIDTH = 21;
  const VIOLIN_KEY_HEIGHT = 43;
  const BASS_KEY_WIDTH = 21;
  const BASS_KEY_HEIGHT = 38;
  const BREAK_WIDTH = 12;
  const BREAK_HEIGHT = 4;
  const NOTE_SHEET_HEIGHT = 650.0;
  const BASELINE = NOTE_SHEET_HEIGHT / 2;
  const SPACE = NOTE_WIDTH;
  const LINE_SPACE = 10.0;

  double calcWidth(String input) {
    double result = BOUNDS + VIOLIN_KEY_WIDTH + SPACE + BOUNDS;

    input.split('').forEach((character) {
      int note = character.codeUnitAt(0);
      result = result + NOTE_WIDTH + SPACE;
      if (note > 127) {
        result = result + BREAK_WIDTH + SPACE;
      } else if (_MIDINotesGraphic[note].sharp) {
        result = result + CROSS_WIDTH + SPACE;
      }
    });
    return result;
  }

  var width = calcWidth(input);
  var height = BOUNDS + NOTE_SHEET_HEIGHT + BOUNDS;

  final canvasRecorder = ui.PictureRecorder();
  final canvas =
      ui.Canvas(canvasRecorder, ui.Rect.fromLTWH(0, 0, width, height));

  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  paint.color = Colors.black;
  paint.strokeWidth = 1.0;
  paint.style = PaintingStyle.stroke;

  // draw lines
  double yOffset = BOUNDS + BASELINE;
  double xOffset = BOUNDS;
  canvas.drawLine(Offset(BOUNDS, yOffset + 2 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 2 * LINE_SPACE), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset + LINE_SPACE),
      Offset(width - BOUNDS, yOffset + LINE_SPACE), paint);
  canvas.drawLine(
      Offset(BOUNDS, yOffset), Offset(width - BOUNDS, yOffset), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset - LINE_SPACE),
      Offset(width - BOUNDS, yOffset - LINE_SPACE), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset - 2 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset - 2 * LINE_SPACE), paint);

  canvas.drawLine(Offset(BOUNDS, yOffset - 2 * LINE_SPACE),
      Offset(BOUNDS, yOffset + 2 * LINE_SPACE), paint);
  canvas.drawLine(Offset(width - BOUNDS, yOffset - 2 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 2 * LINE_SPACE), paint);

  // draw lines bass
  canvas.drawLine(Offset(BOUNDS, yOffset + 4 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 4 * LINE_SPACE), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset + 5 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 5 * LINE_SPACE), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset + 6 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 6 * LINE_SPACE), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset + 7 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 7 * LINE_SPACE), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset + 8 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 8 * LINE_SPACE), paint);

  canvas.drawLine(Offset(BOUNDS, yOffset + 8 * LINE_SPACE),
      Offset(BOUNDS, yOffset + 4 * LINE_SPACE), paint);
  canvas.drawLine(Offset(width - BOUNDS, yOffset + 8 * LINE_SPACE),
      Offset(width - BOUNDS, yOffset + 4 * LINE_SPACE), paint);

  xOffset = BOUNDS + SPACE;

  // draw VIOLIN KEY
  yOffset = BOUNDS + (NOTE_SHEET_HEIGHT ~/ 2) - 17;
  for (int y = 0; y < VIOLIN_KEY_HEIGHT; y++) {
    for (int x = 0; x < VIOLIN_KEY_WIDTH; x++) {
      if (_VIOLIN_KEY[y * VIOLIN_KEY_WIDTH + x] == '#') {
        canvas.drawCircle(Offset(xOffset + x, yOffset + y), 0.5, paint);
      }
    }
  }

  // draw BASS KEY
  yOffset = BOUNDS + BASELINE + 4 * LINE_SPACE;
  for (int y = 0; y < BASS_KEY_HEIGHT; y++) {
    for (int x = 0; x < BASS_KEY_WIDTH; x++) {
      if (_BASS_KEY[y * BASS_KEY_WIDTH + x] == '#') {
        canvas.drawCircle(Offset(xOffset + x, yOffset + y), 0.5, paint);
      }
    }
  }

  // draw NOTES
  xOffset = BOUNDS + VIOLIN_KEY_WIDTH + 2 * SPACE;
  yOffset = 0.0;

  input.split('').forEach((character) {
    int note = character.codeUnitAt(0);
    if (note > 127) {
      // draw break
      paint.style = PaintingStyle.stroke;
      xOffset = xOffset + NOTE_WIDTH + SPACE / 4;
      for (int y = 0; y < BREAK_HEIGHT; y++) {
        for (int x = 0; x < BREAK_WIDTH; x++) {
          if (_BREAK[y * BREAK_WIDTH + x] == '#') {
            canvas.drawCircle(Offset(xOffset + x, BOUNDS + BASELINE + y), 0.5, paint);
          }
        }
      }
      xOffset = xOffset + BREAK_WIDTH + SPACE;
    } else {
      // draw Note
      paint.style = PaintingStyle.fill;
      yOffset = BOUNDS +
          NOTE_SHEET_HEIGHT / 2 +
          _MIDINotesGraphic[note].offset * LINE_SPACE / 2 -
          LINE_SPACE / 2;

      canvas.drawOval(
          Rect.fromLTWH(xOffset, yOffset, NOTE_WIDTH * 1.0, NOTE_HEIGHT * 1.0),
          paint);

      // draw cross
      paint.style = PaintingStyle.stroke;
      if (!_MIDINotesGraphic[note].sharp) {
        xOffset = xOffset + NOTE_WIDTH + SPACE / 4;
        for (int y = 0; y < CROSS_HEIGHT; y++) {
          for (int x = 0; x < CROSS_WIDTH; x++) {
            if (_CROSS[y * CROSS_WIDTH + x] == '#') {
              canvas.drawCircle(Offset(xOffset + x, yOffset + y), 0.5, paint);
            }
          }
        }
      }

      // draw lines
      paint.style = PaintingStyle.stroke;
      if (_MIDINotesGraphic[note].offset < 0) {
        yOffset = BOUNDS + BASELINE - 2 * LINE_SPACE;
      } else {
        yOffset = BOUNDS + BASELINE + 2 * LINE_SPACE;
      }

      for (int i = 0; i < _MIDINotesGraphic[note].lines; i++) {
        if (_MIDINotesGraphic[note].offset < 0) {
          yOffset = yOffset - LINE_SPACE;
        } else {
          yOffset = yOffset + LINE_SPACE;
        }
        if (_MIDINotesGraphic[note].sharp) {
          if ((_MIDINotesGraphic[note].offset < 0) ||
              (_MIDINotesGraphic[note].offset > 0 &&
                  _MIDINotesGraphic[note].lines == 1) ||
              (_MIDINotesGraphic[note].offset > 0 && i > 6)) {
            canvas.drawLine(Offset(xOffset - SPACE / 3, yOffset),
                Offset(xOffset + NOTE_WIDTH + SPACE / 3, yOffset), paint);
          }
        } else {
          if ((_MIDINotesGraphic[note].offset < 0) ||
              (_MIDINotesGraphic[note].offset > 0 &&
                  _MIDINotesGraphic[note].lines == 1) ||
              (_MIDINotesGraphic[note].offset > 0 && i > 6)) {
            canvas.drawLine(Offset(xOffset - NOTE_WIDTH - SPACE / 3, yOffset),
                Offset(xOffset + NOTE_WIDTH + SPACE / 3, yOffset), paint);
          }
        }
      }
      xOffset = xOffset + NOTE_WIDTH + SPACE;
    }
  });

  final img = await canvasRecorder
      .endRecording()
      .toImage(width.floor(), height.floor());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return trimNullBytes(data!.buffer.asUint8List());
  }
