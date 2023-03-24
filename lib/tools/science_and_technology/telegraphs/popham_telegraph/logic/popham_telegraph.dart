//Fred B. Wrixon, Geheimsprachen, Könemann-Verlag, ISBN 978-3-8331-2562-1, S. 450

import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/constants.dart';

const Map<String, List<String>> _POPHAM = {
  ' ': [],
  '1': ['1'],
  '2': ['2'],
  '3': ['3'],
  '4': ['4'],
  '5': ['5'],
  '6': ['6'],
  '7': ['1', 'a'],
  '8': ['1', 'b'],
  '9': ['1', 'c'],
  '0': ['1', 'd'],
  'A': ['a'],
  'B': ['b'],
  'C': ['c'],
  'D': ['d'],
  'E': ['e'],
  'F': ['f'],
  'G': ['1', 'e'],
  'H': ['1', 'f'],
  'I': ['2', 'a'],
  'J': ['2', 'b'],
  'K': ['2', 'c'],
  'L': ['2', 'd'],
  'M': ['2', 'e'],
  'N': ['2', 'f'],
  'O': ['3', 'a'],
  'P': ['3', 'b'],
  'Q': ['3', 'c'],
  'R': ['3', 'd'],
  'S': ['3', 'e'],
  'T': ['3', 'f'],
  'U': ['4', 'a'],
  'V': ['4', 'b'],
  'W': ['4', 'c'],
  'X': ['4', 'd'],
  'Y': ['4', 'e'],
  'Z': ['4', 'f'],
};

Segments encodePopham(String input) {
  if (input.isEmpty) Segments.Empty();

  List<String> inputs = input.toUpperCase().split('');
  List<List<String>> result = [];

  for (int i = 0; i < inputs.length; i++) {
    result.add(_POPHAM[inputs[i]]!);
  }
  return Segments(displays: result);
}

SegmentsText decodeVisualPopham(List<String> inputs) {
  if (inputs.isEmpty) return SegmentsText(displays: [], text: '');

  var displays = <List<String>>[];
  var segment = <String>[];
  for (var element in inputs) {
    segment = _stringToSegment(element);
    displays.add(segment);
  }

  Map<String, String> CODEBOOK = {};
  _POPHAM.forEach((key, value) {
    CODEBOOK[value.join('')] = key;
  });
  CODEBOOK[''] = ' ';

  List<String> text = inputs.map((input) {
    var char = '';
    if (CODEBOOK[input] == null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      char = char + CODEBOOK[input]!;
    }

    return char;
  }).toList();
  return SegmentsText(displays: displays, text: text.join(''));
}

List<String> _stringToSegment(String input) {
  List<String> result = [];
  for (int i = 0; i < input.length; i++) {
    result.add(input[i]);
  }

  return result;
}
