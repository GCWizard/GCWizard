import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

enum NotesCodebook {
  ALT,
  BASS,
  TREBLE,
}

const hashLabel = 'k';
const bLabel = 'b';
const trebleClef = 'o';
const altClef = 'p';
const bassClef = 'q';
const helpLine1 = 'c';
const helpLine2 = 'd';
const helpLine3 = 'e';
const helpLine4 = 'f';
const helpLine5 = 'g';
const helpLineN1 = 'w';
const helpLineN2 = 'x';
const helpLineN3 = 'y';
const helpLineN4 = 'z';

const notePosition = [
  '5h',
  '4hs',
  '4h',
  '3hs',
  '3h',
  '2hs',
  '2h',
  '1hs',
  '1h',
  '5s',
  '5',
  '4s',
  '4',
  '3s',
  '3',
  '2s',
  '2',
  '1s',
  '1',
  '-1hs',
  '-1h',
  '-2hs',
  '-2h',
  '-3hs',
  '-3h',
  '-4hs',
  '-4h',
  '-5hs'
];

final Map<String, List<String>> _CODEBOOK_MUSIC_NOTES_ALT = {
  '1': [notePosition[21]],
  '1_b': [notePosition[21], bLabel],
  '1_k': [notePosition[21], hashLabel],
  '2': [notePosition[20]],
  '2_b': [notePosition[20], bLabel],
  '2_k': [notePosition[20], hashLabel],
  '3': [notePosition[19]],
  '3_b': [notePosition[19], bLabel],
  '3_k': [notePosition[19], hashLabel],
  '4': [notePosition[18]],
  '4_b': [notePosition[18], bLabel],
  '4_k': [notePosition[18], hashLabel],
  '5': [notePosition[17]],
  '5_b': [notePosition[17], bLabel],
  '5_k': [notePosition[17], hashLabel],
  '6': [notePosition[16]],
  '6_b': [notePosition[16], bLabel],
  '6_k': [notePosition[16], hashLabel],
  '7': [notePosition[15]],
  '7_b': [notePosition[15], bLabel],
  '7_k': [notePosition[15], hashLabel],
  '8': [notePosition[14]],
  '8_b': [notePosition[14], bLabel],
  '8_k': [notePosition[14], hashLabel],
  '9': [notePosition[13]],
  '9_b': [notePosition[13], bLabel],
  '9_k': [notePosition[13], hashLabel],
  '10': [notePosition[12]],
  '10_b': [notePosition[12], bLabel],
  '10_k': [notePosition[12], hashLabel],
  '11': [notePosition[11]],
  '11_b': [notePosition[11], bLabel],
  '11_k': [notePosition[11], hashLabel],
  '12': [notePosition[10]],
  '12_b': [notePosition[10], bLabel],
  '12_k': [notePosition[10], hashLabel],
  '13': [notePosition[9]],
  '13_b': [notePosition[9], bLabel],
  '13_k': [notePosition[9], hashLabel],
  '14': [notePosition[8]],
  '14_b': [notePosition[8], bLabel],
  '14_k': [notePosition[8], hashLabel],
  '15': [notePosition[7]],
  '15_b': [notePosition[7], bLabel],
  '15_k': [notePosition[7], hashLabel],
  '16': [notePosition[6]],
  '16_b': [notePosition[6], bLabel],
  '16_k': [notePosition[6], hashLabel],
  '17': [notePosition[5]],
  '17_b': [notePosition[5], bLabel],
  '17_k': [notePosition[5], hashLabel],
  '18': [notePosition[4]],
  '18_b': [notePosition[4], bLabel],
  '18_k': [notePosition[4], hashLabel],
  '19': [notePosition[3]],
  '19_b': [notePosition[3], bLabel],
  '19_k': [notePosition[3], hashLabel],
  '20': [notePosition[2]],
  '20_b': [notePosition[2], bLabel],
  '20_k': [notePosition[2], hashLabel],
  '21': [notePosition[1]],
  '21_b': [notePosition[1], bLabel],
  '21_k': [notePosition[1], hashLabel],
  '22': [notePosition[0]],
  '22_b': [notePosition[0], bLabel],
  '22_k': [notePosition[0], hashLabel],
};

final Map<String, List<String>> _CODEBOOK_MUSIC_NOTES_BASS = {
  '1': [notePosition[22]],
  '1_b': [notePosition[22], bLabel],
  '1_k': [notePosition[22], hashLabel],
  '2': [notePosition[21]],
  '2_b': [notePosition[21], bLabel],
  '2_k': [notePosition[21], hashLabel],
  '3': [notePosition[20]],
  '3_b': [notePosition[20], bLabel],
  '3_k': [notePosition[20], hashLabel],
  '4': [notePosition[19]],
  '4_b': [notePosition[19], bLabel],
  '4_k': [notePosition[19], hashLabel],
  '5': [notePosition[18]],
  '5_b': [notePosition[18], bLabel],
  '5_k': [notePosition[18], hashLabel],
  '6': [notePosition[17]],
  '6_b': [notePosition[17], bLabel],
  '6_k': [notePosition[17], hashLabel],
  '7': [notePosition[16]],
  '7_b': [notePosition[16], bLabel],
  '7_k': [notePosition[16], hashLabel],
  '8': [notePosition[15]],
  '8_b': [notePosition[15], bLabel],
  '8_k': [notePosition[15], hashLabel],
  '9': [notePosition[14]],
  '9_b': [notePosition[14], bLabel],
  '9_k': [notePosition[14], hashLabel],
  '10': [notePosition[13]],
  '10_b': [notePosition[13], bLabel],
  '10_k': [notePosition[13], hashLabel],
  '11': [notePosition[12]],
  '11_b': [notePosition[12], bLabel],
  '11_k': [notePosition[12], hashLabel],
  '12': [notePosition[11]],
  '12_b': [notePosition[11], bLabel],
  '12_k': [notePosition[11], hashLabel],
  '13': [notePosition[10]],
  '13_b': [notePosition[10], bLabel],
  '13_k': [notePosition[10], hashLabel],
  '14': [notePosition[9]],
  '14_b': [notePosition[9], bLabel],
  '14_k': [notePosition[9], hashLabel],
  '15': [notePosition[8]],
  '15_b': [notePosition[8], bLabel],
  '15_k': [notePosition[8], hashLabel],
  '16': [notePosition[7]],
  '16_b': [notePosition[7], bLabel],
  '16_k': [notePosition[7], hashLabel],
  '17': [notePosition[6]],
  '17_b': [notePosition[6], bLabel],
  '17_k': [notePosition[6], hashLabel],
  '18': [notePosition[5]],
  '18_b': [notePosition[5], bLabel],
  '18_k': [notePosition[5], hashLabel],
  '19': [notePosition[4]],
  '19_b': [notePosition[4], bLabel],
  '19_k': [notePosition[4], hashLabel],
  '20': [notePosition[3]],
  '20_b': [notePosition[3], bLabel],
  '20_k': [notePosition[3], hashLabel],
  '21': [notePosition[2]],
  '21_b': [notePosition[2], bLabel],
  '21_k': [notePosition[2], hashLabel],
  '22': [notePosition[1]],
  '22_b': [notePosition[1], bLabel],
  '22_k': [notePosition[1], hashLabel],
};

final Map<String, List<String>> _CODEBOOK_MUSIC_NOTES_TREBLE = {
  '1': [notePosition[27]],
  '1_b': [notePosition[27], bLabel],
  '1_k': [notePosition[27], hashLabel],
  '2': [notePosition[26]],
  '2_b': [notePosition[26], bLabel],
  '2_k': [notePosition[26], hashLabel],
  '3': [notePosition[25]],
  '3_b': [notePosition[25], bLabel],
  '3_k': [notePosition[25], hashLabel],
  '4': [notePosition[24]],
  '4_b': [notePosition[24], bLabel],
  '4_k': [notePosition[24], hashLabel],
  '5': [notePosition[23]],
  '5_b': [notePosition[23], bLabel],
  '5_k': [notePosition[23], hashLabel],
  '6': [notePosition[22]],
  '6_b': [notePosition[22], bLabel],
  '6_k': [notePosition[22], hashLabel],
  '7': [notePosition[21]],
  '7_b': [notePosition[21], bLabel],
  '7_k': [notePosition[21], hashLabel],
  '8': [notePosition[20]],
  '8_b': [notePosition[20], bLabel],
  '8_k': [notePosition[20], hashLabel],
  '9': [notePosition[19]],
  '9_b': [notePosition[19], bLabel],
  '9_k': [notePosition[19], hashLabel],
  '10': [notePosition[18]],
  '10_b': [notePosition[18], bLabel],
  '10_k': [notePosition[18], hashLabel],
  '11': [notePosition[17]],
  '11_b': [notePosition[17], bLabel],
  '11_k': [notePosition[17], hashLabel],
  '12': [notePosition[16]],
  '12_b': [notePosition[16], bLabel],
  '12_k': [notePosition[16], hashLabel],
  '13': [notePosition[15]],
  '13_b': [notePosition[15], bLabel],
  '13_k': [notePosition[15], hashLabel],
  '14': [notePosition[14]],
  '14_b': [notePosition[14], bLabel],
  '14_k': [notePosition[14], hashLabel],
  '15': [notePosition[13]],
  '15_b': [notePosition[13], bLabel],
  '15_k': [notePosition[13], hashLabel],
  '16': [notePosition[12]],
  '16_b': [notePosition[12], bLabel],
  '16_k': [notePosition[12], hashLabel],
  '17': [notePosition[11]],
  '17_b': [notePosition[11], bLabel],
  '17_k': [notePosition[11], hashLabel],
  '18': [notePosition[10]],
  '18_b': [notePosition[10], bLabel],
  '18_k': [notePosition[10], hashLabel],
  '19': [notePosition[9]],
  '19_b': [notePosition[9], bLabel],
  '19_k': [notePosition[9], hashLabel],
  '20': [notePosition[8]],
  '20_b': [notePosition[8], bLabel],
  '20_k': [notePosition[8], hashLabel],
  '21': [notePosition[7]],
  '21_b': [notePosition[7], bLabel],
  '21_k': [notePosition[7], hashLabel],
  '22': [notePosition[6]],
  '22_b': [notePosition[6], bLabel],
  '22_k': [notePosition[6], hashLabel],
  '23': [notePosition[5]],
  '23_b': [notePosition[5], bLabel],
  '23_k': [notePosition[5], hashLabel],
  '24': [notePosition[4]],
  '24_b': [notePosition[4], bLabel],
  '24_k': [notePosition[4], hashLabel],
};

Segments encodeNotes(String input, NotesCodebook notes, Map<String, String> translationMap) {
  var mainEntrysStart = 0;
  var mainEntrysEnd = 99;
  List<List<String>> result = [];

  Map<String, List<String>> CODEBOOK;
  switch (notes) {
    case NotesCodebook.ALT:
      CODEBOOK = _CODEBOOK_MUSIC_NOTES_ALT;
      result.add([altClef]);
      mainEntrysStart = 8;
      mainEntrysEnd = 14;
      break;
    case NotesCodebook.BASS:
      CODEBOOK = _CODEBOOK_MUSIC_NOTES_BASS;
      result.add([bassClef]);
      mainEntrysStart = 8;
      mainEntrysEnd = 14;
      break;
    case NotesCodebook.TREBLE:
      CODEBOOK = _CODEBOOK_MUSIC_NOTES_TREBLE;
      result.add([trebleClef]);
      mainEntrysStart = 5;
      mainEntrysEnd = 14;
      break;
  }

  // sorted by length (longest first)
  var entries = translationMap.entries.toList();
  entries.sort((MapEntry<String, String> a, MapEntry<String, String> b) {
    if (b.value.length != a.value.length) {
      return b.value.length.compareTo(a.value.length);
    } else {
      var aKey = int.parse(a.key.split('_')[0]);
      var bKey = int.parse(b.key.split('_')[0]);
      var aMainEntry = (aKey >= mainEntrysStart) && (aKey <= mainEntrysEnd);
      var bMainEntry = (bKey >= mainEntrysStart) && (bKey <= mainEntrysEnd);
      if (aMainEntry && bMainEntry) {
        return bKey.compareTo(aKey);
      } else if (aMainEntry) {
        return -1;
      } else if (bMainEntry) {
        return 1;
      }
      return 0;
    }
  });
  translationMap = Map<String, String>.fromEntries(entries);

  input = input.toUpperCase();
  translationMap.forEach((key, value) {
    input = input.replaceAll(value.toUpperCase(), key);
  });

  List<String> inputs = input.split(RegExp(r'\s'));

  for (int i = 0; i < inputs.length; i++) {
    var value = CODEBOOK[inputs[i]];
    if (value != null) {
      result.add(value);
    }
  }

  return Segments(displays: result);
}

SegmentsChars decodeNotes(List<String>? inputs, NotesCodebook notes) {
  if (inputs == null || inputs.isEmpty) return SegmentsChars(displays: [], chars: []);

  var displays = <List<String>>[];

  Map<List<String>, String> CODEBOOK;
  switch (notes) {
    case NotesCodebook.ALT:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_MUSIC_NOTES_ALT);
      displays.add([altClef]);
      break;
    case NotesCodebook.BASS:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_MUSIC_NOTES_BASS);
      displays.add([bassClef]);
      break;
    case NotesCodebook.TREBLE:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_MUSIC_NOTES_TREBLE);
      displays.add([trebleClef]);
      break;
  }

  List<String> text = inputs.map((input) {
    var char = '';
    var charH = '';
    var display = <String>[];

    input = input.replaceAll(
        RegExp('$helpLine1|$helpLine2|$helpLine3|$helpLine4|$helpLine5|'
            '$helpLineN1|$helpLineN2|$helpLineN3|$helpLineN3|$helpLineN4|'
            '$altClef|$bassClef|$trebleClef'),
        '');

    if (input.contains(hashLabel)) {
      display.add(input.replaceAll(hashLabel, ''));
      display.add(hashLabel);
    } else if (input.contains(bLabel)) {
      display.add(input.replaceAll(bLabel, ''));
      display.add(bLabel);
    } else {
      display.add(input);
    }

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

Map<String, bool> filterVisibleHelpLines(Map<String, bool> displayedSegments) {
  if (!_containsNote([notePosition[0]], displayedSegments)) {
    displayedSegments[helpLine5] = false;
    if (!_containsNote([notePosition[1], notePosition[2]], displayedSegments)) {
      displayedSegments[helpLine4] = false;
      if (!_containsNote([notePosition[3], notePosition[4]], displayedSegments)) {
        displayedSegments[helpLine3] = false;
        if (!_containsNote([notePosition[5], notePosition[6]], displayedSegments)) {
          displayedSegments[helpLine2] = false;
          if (!_containsNote([notePosition[7], notePosition[8]], displayedSegments)) {
            displayedSegments[helpLine1] = false;
          }
        }
      }
    }
  }

  if (!_containsNote([notePosition[27], notePosition[26]], displayedSegments)) {
    displayedSegments[helpLineN4] = false;
    if (!_containsNote([notePosition[25], notePosition[24]], displayedSegments)) {
      displayedSegments[helpLineN3] = false;
      if (!_containsNote([notePosition[23], notePosition[22]], displayedSegments)) {
        displayedSegments[helpLineN2] = false;
        if (!_containsNote([notePosition[21], notePosition[20]], displayedSegments)) {
          displayedSegments[helpLineN1] = false;
        }
      }
    }
  }
  return displayedSegments;
}

bool _containsNote(List<String> notes, Map<String, bool> displayedSegments) {
  for (var note in notes) {
    if (displayedSegments[note] != null) return true;
  }
  return false;
}

List<String> possibleNoteKeys(NotesCodebook notes) {
  List<String> result = [];
  for (int i = 1; i <= 22; i++) {
    result.add(i.toString());
    result.add(i.toString() + '_b');
    result.add(i.toString() + '_k');
  }
  return result;
}
