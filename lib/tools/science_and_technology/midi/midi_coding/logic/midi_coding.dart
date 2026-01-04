import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/midi/_common/logic/midi_data.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

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
    return code ?? '';
  }).join(' ');
}

String decodeMIDI(String _currentEncodeInput, int _currentType) {
  if (_currentEncodeInput.isEmpty) return '';

  Map<String, int> CODEBOOK = switchMapKeyValue(getCodeBook(_currentType));

  return _currentEncodeInput.split(' ').map((code) {
    var ascii = CODEBOOK[code];
    return ascii != null ? String.fromCharCode(ascii) : '';
  }).join('');
}

class MIDINoteGraphicData {
  final int offset;
  final bool line;
  final bool sharp;

  MIDINoteGraphicData(this.offset, this.line, this.sharp);
}

List<MIDINoteGraphicData> _MIDINotesGraphic = [
  MIDINoteGraphicData(0, false, true),   //     0
  MIDINoteGraphicData(0, false, false),  //     1
  MIDINoteGraphicData(1, true, true),    //     2
  MIDINoteGraphicData(1, true, false),   //     3
  MIDINoteGraphicData(2, false, true),   //     4
  MIDINoteGraphicData(2, false, true),   //     5
  MIDINoteGraphicData(3, true, false),   //     6
  MIDINoteGraphicData(3, true, true),    //     7
  MIDINoteGraphicData(4, false, false),  //     8
  MIDINoteGraphicData(4, false, true),   //     9
  MIDINoteGraphicData(5, true, false),   //    10
  MIDINoteGraphicData(5, true, true),    //    11
  MIDINoteGraphicData(6, false, true),   //    12
  MIDINoteGraphicData(6, false, false),  //    13
  MIDINoteGraphicData(7, true, true),    //    14
  MIDINoteGraphicData(7, true, false),   //    15
  MIDINoteGraphicData(8, false, true),   //    16
  MIDINoteGraphicData(8, false, true),   //    17
  MIDINoteGraphicData(9, true, false),   //    18
  MIDINoteGraphicData(9, true, true),    //    19
  MIDINoteGraphicData(10, false, true),  //    20
  MIDINoteGraphicData(10, false, false), //    21
  MIDINoteGraphicData(11, true, true),   //    22
  MIDINoteGraphicData(11, true, false),  //    23
  MIDINoteGraphicData(12, false, true),  //    24
  MIDINoteGraphicData(12, false, true),  //    25
  MIDINoteGraphicData(13, true, false),  //    26
  MIDINoteGraphicData(13, true, true),   //    27
  MIDINoteGraphicData(14, false, false), //    28
  MIDINoteGraphicData(14, false, true),  //    29
  MIDINoteGraphicData(15, true, false),  //    30
  MIDINoteGraphicData(15, true, true),   //    31
  MIDINoteGraphicData(16, false, true),  //    32
  MIDINoteGraphicData(16, false, false), //    33
  MIDINoteGraphicData(17, true, true),   //    34
  MIDINoteGraphicData(17, true, false),  //    35
  MIDINoteGraphicData(18, false, true),  //    36
  MIDINoteGraphicData(18, false, true),  //    37
  MIDINoteGraphicData(19, true, false),  //    38
  MIDINoteGraphicData(19, true, true),   //    39
  MIDINoteGraphicData(20, false, true),  //    40
  MIDINoteGraphicData(20, false, false), //    41
  MIDINoteGraphicData(21, true, true),   //    42
  MIDINoteGraphicData(21, true, false),  //    43
  MIDINoteGraphicData(22, false, true),  //    44
  MIDINoteGraphicData(22, false, true),  //    45
  MIDINoteGraphicData(23, true, false),  //    46
  MIDINoteGraphicData(23, true, true),   //    47
  MIDINoteGraphicData(24, false, false), //    48
  MIDINoteGraphicData(24, false, true),  //    49
  MIDINoteGraphicData(25, true, false),  //    50
  MIDINoteGraphicData(25, true, true),   //    51
  MIDINoteGraphicData(26, false, true),  //    52
  MIDINoteGraphicData(26, false, false), //    53
  MIDINoteGraphicData(27, true, true),   //    54
  MIDINoteGraphicData(27, true, false),  //    55
  MIDINoteGraphicData(28, false, true),  //    56
  MIDINoteGraphicData(28, false, true),  //    57
  MIDINoteGraphicData(29, true, false),  //    58
  MIDINoteGraphicData(29, true, true),   //    59
  MIDINoteGraphicData(30, false, true),  //    60
  MIDINoteGraphicData(30, false, false), //    61
  MIDINoteGraphicData(31, true, true),   //    62
  MIDINoteGraphicData(31, true, false),  //    63
  MIDINoteGraphicData(32, false, true),  //    64
  MIDINoteGraphicData(32, false, true),  //    65
  MIDINoteGraphicData(33, true, false),  //    66
  MIDINoteGraphicData(33, true, true),   //    67
  MIDINoteGraphicData(34, false, false), //    68
  MIDINoteGraphicData(34, false, true),  //    69
  MIDINoteGraphicData(35, true, false),  //    70
  MIDINoteGraphicData(35, true, true),   //    71
  MIDINoteGraphicData(36, false, true),  //    72
  MIDINoteGraphicData(36, false, false), //    73
  MIDINoteGraphicData(37, true, true),   //    74
  MIDINoteGraphicData(37, true, false),  //    75
  MIDINoteGraphicData(38, false, true),  //    76
  MIDINoteGraphicData(38, false, true),  //    77
  MIDINoteGraphicData(39, true, false),  //    78
  MIDINoteGraphicData(39, true, true),   //    79
  MIDINoteGraphicData(40, false, true),  //    80
  MIDINoteGraphicData(40, false, false), //    81
  MIDINoteGraphicData(41, true, true),   //    82
  MIDINoteGraphicData(41, true, false),  //    83
  MIDINoteGraphicData(42, false, true),  //    84
  MIDINoteGraphicData(42, false, true),  //    85
  MIDINoteGraphicData(43, true, false),  //    86
  MIDINoteGraphicData(43, true, true),   //    87
  MIDINoteGraphicData(44, false, false), //    88
  MIDINoteGraphicData(44, false, true),  //    89
  MIDINoteGraphicData(45, true, false),  //    90
  MIDINoteGraphicData(45, true, true),   //    91
  MIDINoteGraphicData(46, false, true),  //    92
  MIDINoteGraphicData(46, false, false), //    93
  MIDINoteGraphicData(47, true, true),   //    94
  MIDINoteGraphicData(47, true, false),  //    95
  MIDINoteGraphicData(48, false, true),  //    96
  MIDINoteGraphicData(48, false, true),  //    97
  MIDINoteGraphicData(49, true, false),  //    98
  MIDINoteGraphicData(49, true, true),   //    99
  MIDINoteGraphicData(50, false, true),  //   100
  MIDINoteGraphicData(50, false, false), //   101
  MIDINoteGraphicData(51, true, true),   //   102
  MIDINoteGraphicData(51, true, false),  //   103
  MIDINoteGraphicData(52, false, true),  //   104
  MIDINoteGraphicData(52, false, true),  //   105
  MIDINoteGraphicData(53, true, false),  //   106
  MIDINoteGraphicData(53, true, true),   //   107
  MIDINoteGraphicData(54, false, false), //   108
  MIDINoteGraphicData(54, false, true),  //   109
  MIDINoteGraphicData(55, true, false),  //   110
  MIDINoteGraphicData(55, true, true),   //   111
  MIDINoteGraphicData(56, false, true),  //   112
  MIDINoteGraphicData(56, false, false), //   113
  MIDINoteGraphicData(57, true, true),   //   114
  MIDINoteGraphicData(57, true, false),  //   115
  MIDINoteGraphicData(58, false, true),  //   116
  MIDINoteGraphicData(58, false, true),  //   117
  MIDINoteGraphicData(59, true, false),  //   118
  MIDINoteGraphicData(59, true, true),   //   119
  MIDINoteGraphicData(60, false, true),  //   120
  MIDINoteGraphicData(60, false, false), //   121
  MIDINoteGraphicData(61, true, true),   //   122
  MIDINoteGraphicData(61, true, false),  //   123
  MIDINoteGraphicData(62, false, true),  //   124
  MIDINoteGraphicData(62, false, true),  //   125
  MIDINoteGraphicData(63, true, false),  //   126
  MIDINoteGraphicData(63, true, false),  //   127
];

const _CROSS =
    '      #    #' +
    '     #    # ' +
    '  ##########' +
    '    #    #  ' +
    '   #    #   ' +
    '##########  ' +
    ' #    #     ' +
    '#    #      ';

const _NOTE =
    '    ####    ' +
    '  ##    ##  ' +
    ' #        # ' +
    '#          #' +
    ' #        # ' +
    '  ##    ##  ' +
    '    ####    ';

const _KEY =
    '       ##            ' +
    '      #  #           ' +
    '     ##  #           ' +
    '    ##    #          ' +
    '    ##    #          ' +
    '    ##    ##         ' +
    '     #    ##         ' +
    '      #  ##          ' +
    '      #  #           ' +
    '       ##            ' +
    '     ####            ' +
    '   ###  #            ' +
    ' ###    #            ' +
    '##      ########     ' +
    '##    #############  ' +
    '##   ##    #      ###' +
    '##   ##    #      ###' +
    '##    ##   #       ##' +
    ' ##    #   #       ##' +
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


Future<Uint8List> MIDINotes2Image(String input,) async {
  const BOUNDS = 10.0;
  const CROSS_WIDTH = 12;
  const CROSS_HEIGHT = 8;
  const NOTE_WIDTH = 12;
  const NOTE_HEIGHT = 8;
  const KEY_WIDTH = 21;
  const KEY_HEIGHT = 35;
  const NOTE_SHEET_HEIGHT = 650.0;
  const SPACE = NOTE_WIDTH;

  var width = BOUNDS + KEY_WIDTH + input.length * (NOTE_WIDTH + SPACE) * 2 + BOUNDS;
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
  double yOffset = BOUNDS + (NOTE_SHEET_HEIGHT ~/ 2);
  double xOffset = BOUNDS;
  canvas.drawLine(Offset(BOUNDS, yOffset + 20), Offset(width - BOUNDS, yOffset + 20), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset + 10), Offset(width - BOUNDS, yOffset + 10), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset), Offset(width - BOUNDS, yOffset), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset - 10), Offset(width - BOUNDS, yOffset - 10), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset - 20), Offset(width - BOUNDS, yOffset - 20), paint);
  canvas.drawLine(Offset(BOUNDS, yOffset - 20), Offset(BOUNDS, yOffset + 20), paint);
  canvas.drawLine(Offset(width - BOUNDS, yOffset - 20), Offset(width - BOUNDS, yOffset + 20), paint);


  // draw KEY
  xOffset = BOUNDS + SPACE;
  yOffset = BOUNDS + (NOTE_SHEET_HEIGHT ~/ 2) - 17;
  for (int y = 0; y < KEY_HEIGHT; y++) {
    for (int x = 0; x < KEY_WIDTH; x++) {
      if (_KEY[y * KEY_WIDTH + x] == '#') {
        canvas.drawCircle(Offset(xOffset + x, yOffset + y), 0.5, paint);
      }
    }
  }

  // draw NOTES
  xOffset = BOUNDS + KEY_WIDTH + SPACE;
  yOffset = 0.0;
  input.split('').forEach((character) {
    int note = character.codeUnitAt(0);
    yOffset = BOUNDS + _MIDINotesGraphic[note].offset * 10 + 5;

    // draw Note
    paint.style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromLTWH(xOffset, yOffset, NOTE_WIDTH * 1.0, NOTE_HEIGHT * 1.0), paint);

    //draw cross
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

    xOffset = xOffset + NOTE_WIDTH + SPACE;
  });

  final img = await canvasRecorder
      .endRecording()
      .toImage(width.floor(), height.floor());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData != null) {
    return trimNullBytes(data!.buffer.asUint8List());
  }
  return trimNullBytes(Uint8List.fromList([]));
}
