//Fred B. Wrixon, Geheimsprachen, Könemann-Verlag, ISBN 978-3-8331-2562-1, S. 450

import 'package:gc_wizard/utils/constants.dart';

final Map<String, List<String>> POPHAM = {
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

List<List<String>> encodePopham(String input) {
  if (input == null || input == '') return [];

  List<String> inputs = input.toUpperCase().split('');
  List<List<String>> result = [];

  for (int i = 0; i < inputs.length; i++) {
    result.add(POPHAM[inputs[i]]);
  }
  return result;
}

Map<String, dynamic> decodeVisualPopham(List<String> inputs) {
  if (inputs == null || inputs.length == 0) return {'displays': <List<String>>[], 'chars': ''};

  var displays = <List<String>>[];
  var segment = <String>[];
  inputs.forEach((element) {
    segment = _stringToSegment(element);
    displays.add(segment);
  });

  Map<String, String> CODEBOOK = {};
  POPHAM.forEach((key, value) {
    CODEBOOK[value.join('')] = key;
  });
  CODEBOOK[''] = ' ';

  List<String> text = inputs.where((input) => input != null).map((input) {
    var char = '';
    if (CODEBOOK[input] == null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      char = char + CODEBOOK[input];
    }

    return char;
  }).toList();
  return {'displays': displays, 'chars': text.join('')};
}

List<String> _stringToSegment(String input) {
  List<String> result = [];
  for (int i = 0; i < input.length; i++) result.add(input[i]);

  return result;
}
