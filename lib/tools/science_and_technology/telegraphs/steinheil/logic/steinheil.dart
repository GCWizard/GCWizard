import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

// https://de.wikisource.org/wiki/C._A._Steinheil_und_der_erste_Schreibtelegraph
// https://www.jmcvey.net/cable/elements/letters1.htm
// https://web.archive.org/web/20240817181952/https://www.jmcvey.net/cable/elements/letters1.htm
// https://archive.org/details/telegraphmanualc00shafrich/page/302/mode/2up
// https://books.google.de/books/about/The_Telegraph_Manual.html?id=2q5LAAAAYAAJ&redir_esc=y
// Page 178

const Map<String, List<String>> _CODEBOOK_STEINHEIL_V3 = {
  'E': ['h'],
  'I': ['d'],
  'J': ['d'],
};
const Map<String, List<String>> _CODEBOOK_STEINHEIL_V2 = {
  'D': ['c', 'h', ],
  'E': ['g'],
  'I': ['c'],
  'J': ['c'],
  'N': ['c', 'd'],
  'R': ['g', 'h'],
  'T': ['d', 'g'],
};
const Map<String, List<String>> _CODEBOOK_STEINHEIL_V1 = {
  'A': ['c', 'f', 'h', ],
  'C': ['d', 'f', 'g'],
  'D': ['b', 'g', ],
  'E': ['f'],
  'F': ['c', 'd', 'f',],
  'G': ['b', 'c', 'h'],
  'I': ['b'],
  'J': ['b'],
  'K': ['d', 'f', 'g'],
  'L': ['b', 'g', 'h'],
  'M': ['b', 'c', 'd'],
  'N': ['b', 'c'],
  'O': ['f', 'g', 'h'],
  'R': ['f', 'g'],
  'T': ['c', 'f'],
  'U': ['b', 'd', 'g'],
  'V': ['b', 'd', 'g'],
  '0': ['f', 'g', 'h'],
  '9': ['b', 'c', 'h'],
};

Map<String, List<String>> _CODEBOOK_STEINHEIL = {
  'A': ['b', 'e', 'g', ],
  'B': ['b', 'c', 'e', 'h'],
  'C': ['c', 'e', 'f'],
  'CH': ['e', 'f', 'g', 'h'],
  'D': ['a', 'f', ],
  'E': ['e'],
  'F': ['b', 'c', 'e',],
  'G': ['a', 'b', 'g'],
  'H': ['a', 'b', 'c', 'd'],
  'I': ['a'],
  'J': ['a'],
  'K': ['c', 'e', 'f'],
  'L': ['a', 'f', 'g'],
  'M': ['a', 'b', 'c'],
  'N': ['a', 'b',],
  'O': ['e', 'f', 'g'],
  'P': ['a', 'd', 'f', 'g'],
  'R': ['e', 'f',],
  'S': ['c', 'd', 'e', 'f'],
  'SCH': ['b', 'd', 'e', 'g'],
  'T': ['b', 'e'],
  'U': ['a', 'c', 'f'],
  'V': ['a', 'c', 'f'],
  'W': ['a', 'c', 'f', 'h'],
  'Z': ['a', 'b', 'g', 'h'],
  '0': ['e', 'f', 'g'],
  '1': ['b', 'c', 'd', 'e'],
  '2': ['a', 'c', 'd', 'f'],
  '3': ['a', 'b', 'd', 'g'],
  '4': ['a', 'b', 'c', 'h'],
  '5': ['a', 'f', 'g', 'h'],
  '6': ['b', 'e', 'g', 'h'],
  '7': ['c', 'd', 'e', 'f'],
  '8': ['d', 'e', 'f', 'g'],
  '9': ['a', 'b', 'g'],
};

Segments encodeSteinheil(String input) {
  List<String> inputs = input.toUpperCase().replaceAll('SCH', '#').replaceAll('CH', '§').split('');
  List<List<String>> result = [];

  _CODEBOOK_STEINHEIL['#'] = ['b', 'd', 'e', 'g']; // SCH
  _CODEBOOK_STEINHEIL['§'] = ['e', 'f', 'g', 'h']; // CH
  for (int i = 0; i < inputs.length; i++) {
    if (_CODEBOOK_STEINHEIL[inputs[i]] != null) {
      result.add(_CODEBOOK_STEINHEIL[inputs[i].toUpperCase()]!);
    }
  }
  return Segments(displays: result);
}

SegmentsChars decodeSteinheil(List<String> inputs) {
  if (inputs.isEmpty) return  SegmentsChars(displays: <List<String>>[], chars: []);

  var displays = <List<String>>[];

  Map<List<String>, String> CODEBOOK = switchMapKeyValue(_CODEBOOK_STEINHEIL);
  CODEBOOK.addAll(switchMapKeyValue(_CODEBOOK_STEINHEIL_V1));
  CODEBOOK.addAll(switchMapKeyValue(_CODEBOOK_STEINHEIL_V2));
  CODEBOOK.addAll(switchMapKeyValue(_CODEBOOK_STEINHEIL_V3));

  List<String> text = inputs.map((input) {
    var char = '';
    var charH = '';
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });

    if (CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] == null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      charH = CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ?? '';
      char = char + charH;
    }

    displays.add(display);

    return char;
  }).toList();

  return SegmentsChars(displays: displays, chars: text);
}
