import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

const Map<String, List<String>> _CODEBOOK_FOYBREGUET = {
  'A': ['10', '1u', '50'],
  'B': ['10', '1l', '50'],
  'C': ['10', '1a', '50'],
  'D': ['10', '1b', '50', '5a'],
  'E': ['10', '1b', '50'],
  'F': ['10', '1r', '50'],
  'G': ['10', '1o', '50'],
  'H': ['10', '50', '5o'],
  'I': ['10', '50', '5l'],
  'J': ['10', '1l', '50', '5a'],
  'K': ['10', '50', '5l'],
  'L': ['10', '1a', '50', '5b'],
  'M': ['10', '50', '5b'],
  'N': ['10', '50', '5r'],
  'O': ['10', '50', '5u'],
  'P': ['10', '1u', '50', '5a'],
  'Q': ['10', '1l', '50', '5a'],
  'R': ['10', '1a', '50', '5a'],
  'S': ['10', '1l', '50', '5b'],
  'T': ['10', '1r', '50', '50'],
  'U': ['10', '1b', '50', '5a'],
  'V': ['10', '1o', '50', '5a'],
  'W': ['10', '1u', '50'],
  'X': ['10', '1u', '50', '5a'],
  'Y': ['10', '1r', '50', '5a'],
  'Z': ['10', '1l', '50', '5b'],
};

Segments encodeFoyBreguet(String input,) {
  List<String> inputs = input.toUpperCase().split('');
  List<List<String>> result = [];

  String char = '';
  for (int i = 0; i < inputs.length; i++) {
    char = inputs[i];
    if (_CODEBOOK_FOYBREGUET[char] != null) {
      result.add(_CODEBOOK_FOYBREGUET[char]!);
    }
  }
  return Segments(displays: result);
}

SegmentsText decodeVisualFoyBreguet(List<String>? inputs,) {
  if (inputs == null || inputs.isEmpty) return SegmentsText(displays: [], text: '');

  var displays = <List<String>>[];
  var segment = <String>[];

  Map<List<String>, String> CODEBOOK = switchMapKeyValue(_CODEBOOK_FOYBREGUET);

  for (var element in inputs) {
    segment = _stringToSegment(element);
    displays.add(segment);
  }

  List<String> text = inputs.map((input) {
    var char = '';
    var charH = '';

    if (CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] == null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      charH = CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ?? '';
      char = char + charH;
    }

    return char;
  }).toList();
  return SegmentsText(displays: displays, text: text.join(' '));
}

List<String> _stringToSegment(String input) {
  if (input.length % 2 == 0) {
    List<String> result = [];
    int j = 0;
    for (int i = 0; i < input.length / 2; i++) {
      result.add(input[j] + input[j + 1]);
      j = j + 2;
    }
    return result;
  } else {
    return [];
  }
}

SegmentsText decodeTextFoyBreguetTelegraph(String inputs, ) {
  if (inputs.isEmpty) return SegmentsText(displays: [], text: '');

  var displays = <List<String>>[];
  String text = '';

  inputs.split(' ').forEach((element) {
    if (_CODEBOOK_FOYBREGUET[element] != null) {
      text += element;
      displays.add(_CODEBOOK_FOYBREGUET[element]!);
    } else {
      text += UNKNOWN_ELEMENT;
    }
  });
  return SegmentsText(displays: displays, text: text);
}
