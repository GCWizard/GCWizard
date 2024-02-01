import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

const Map<String, List<String>> _CODEBOOK_PREDATOR = {
  'a': ['b', 'f', 'h'],
  'b': ['b', 'd', 'f', 'h'],
  'c': ['b'],
  'd': ['b', 'd', 'f'],
  'e': ['b', 'h', 'i', 'k'],
  'f': ['b', 'd', 'f', 'h', 'i', 'k'],
  'g': ['b', 'f', 'g', 'h', 'i', 'k'],
  'h': ['b', 'f', 'g', 'h', 'k'],
  'i': ['b', 'h', 'k'],
  'j': ['b', 'f', 'h', 'k'],
  'k': ['i', 'k'],
  'l': ['g', 'h', 'i', 'k'],
  'm': ['b', 'd', 'f', 'g', 'i', 'k'],
  'n': ['b', 'd', 'i', 'k'],
  'o': ['d', 'f', 'g', 'i'],
  'p': ['b', 'd', 'f', 'g', 'h', 'k'],
  'q': ['b', 'f', 'g', 'i', 'k'],
  'r': ['f', 'h', 'k'],
  's': ['d', 'f', 'g', 'h', 'i', 'k'],
  't': ['b', 'd', 'f', 'g', 'h'],
  'u': ['b', 'd', 'f', 'h', 'i'],
  'v': ['d', 'f', 'g', 'h', 'i'],
  'w': ['g', 'i'],
  'x': ['g', 'h'],
  'y': ['d', 'f', 'g', 'h', 'i', 'k'],
  'z': ['b', 'd', 'f', 'g', 'h', 'i', 'k'],
  'A': ['b', 'c', 'f', 'h', 'j'],
  'B': ['b', 'd', 'f'],
  'C': ['b', 'd', 'f', 'g', 'h'],
  'D': ['b', 'd', 'g', 'h'],
  'E': ['b', 'f', 'g', 'h', 'j'],
  'F': ['b', 'd', 'f', 'g', 'h', 'j'],
  'G': ['b', 'c'],
  'H': ['b', 'f', 'h', 'j'],
  'I': ['f', 'g', 'h', 'j'],
  'J': ['b', 'c', 'g', 'h', 'j'],
  'K': ['b', 'h'],
  'L': ['b', 'c', 'f', 'g', 'h', 'j'],
  'M': ['b', 'c', 'f'],
  'N': ['b', 'c', 'd', 'f'],
  'O': ['b', 'g', 'h', 'j'],
  'P': ['b', 'c', 'f', 'g', 'j'],
  'Q': ['b', 'c', 'd', 'f', 'g', 'h'],
  'R': ['b', 'c', 'd', 'f', 'j'],
  'S': ['c', 'd', 'f', 'g', 'h'],
  'T': ['d', 'f', 'g', 'j'],
  'U': ['b', 'd', 'j'],
  'V': ['b', 'c', 'd', 'f', 'j'],
  'W': ['b', 'c', 'f', 'g'],
  'X': ['g', 'j'],
  'Y': ['d', 'f', 'g', 'h'],
  'Z': ['b', 'c', 'd', 'f', 'g', 'h', 'j'],
  '0': ['a', 'b', 'd', 'e', 'f', 'g', 'h'],
  '1': ['a', 'b', 'd', 'e'],
  '2': ['a', 'b', 'd', 'e', 'f', 'g'],
  '3': ['d', 'g'],
  '4': ['d', 'e', 'f', 'g'],
  '5': ['a', 'b', 'e', 'g', 'h'],
  '6': ['e', 'f', 'g', 'h'],
  '7': ['a', 'b', 'e', 'h'],
  '8': ['a', 'b', 'd', 'g', 'h'],
  '9': ['b', 'e', 'f', 'g', 'h'],
};

Segments encodePredator(String input) {
  List<String> inputs = input.split('');
  List<List<String>> result = [];
  for (int i = 0; i < inputs.length; i++) {
    if (_CODEBOOK_PREDATOR[inputs[i]] != null) result.add(_CODEBOOK_PREDATOR[inputs[i]]!);
  }
  return Segments(displays: result);
}

SegmentsChars decodePredator(List<String>? inputs) {
  if (inputs == null || inputs.isEmpty) return SegmentsChars(displays: [], chars: []);

  var displays = <List<String>>[];
  var segment = <String>[];

  Map<List<String>, String> CODEBOOK = switchMapKeyValue(_CODEBOOK_PREDATOR);

  for (var element in inputs) {
    segment = _stringToSegment(element);
    displays.add(segment);
  }

  List<String> text = inputs.map((input) {
    var char = '';

    if (CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] == null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      var charH = CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()];
      char = char + (charH ?? '');
    }

    return char;
  }).toList();

  return SegmentsChars(displays: displays, chars: text);
}

List<String> _stringToSegment(String input) {
  List<String> result = [];
  for (int i = 0; i < input.length; i++) {
    result.add(input[i]);
  }
  return result;
}
