import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

/*
Helmar Fischer,
https://cms.sachsen.schule/typoecke2/typo-experimente/informationuebertragung-mit-dem-klappentelegraph/

John Buckledee, Chairman, Dunstable and District Local History Society on behalf of Mrs Omer Roucoux,
http://virtual-library.culturalservices.net/webingres/bedfordshire/vlib/0.digitised_resources/dunstable_article_signalling_station.htm
 */

enum MurrayCodebook {
  ROYALNAVY,
  GEOCACHING,
  FISCHER,
  ROUCOUX,
  GEOCACHINGTOOLBOX_1,
  GEOCACHINGTOOLBOX_2,
  GEOCACHINGTOOLBOX_3,
  MYGEOTOOLS
}

const Map<MurrayCodebook, CodebookConfig> MURRAY_CODEBOOK = {
  MurrayCodebook.ROYALNAVY:
      CodebookConfig(title: 'telegraph_murray_royalnavy_title', subtitle: 'telegraph_murray_royalnavy_description'),
  MurrayCodebook.GEOCACHING:
      CodebookConfig(title: 'telegraph_murray_geocaching_title', subtitle: 'telegraph_murray_geocaching_description'),
  MurrayCodebook.FISCHER:
      CodebookConfig(title: 'telegraph_murray_fischer_title', subtitle: 'telegraph_murray_fischer_description'),
  MurrayCodebook.ROUCOUX:
      CodebookConfig(title: 'telegraph_murray_roucoux_title', subtitle: 'telegraph_murray_roucoux_description'),
  MurrayCodebook.GEOCACHINGTOOLBOX_1: CodebookConfig(
      title: 'telegraph_murray_geocachingtoolbox_1_title',
      subtitle: 'telegraph_murray_geocachingtoolbox_1_description'),
  MurrayCodebook.GEOCACHINGTOOLBOX_2: CodebookConfig(
      title: 'telegraph_murray_geocachingtoolbox_2_title',
      subtitle: 'telegraph_murray_geocachingtoolbox_2_description'),
  MurrayCodebook.GEOCACHINGTOOLBOX_3: CodebookConfig(
      title: 'telegraph_murray_geocachingtoolbox_3_title',
      subtitle: 'telegraph_murray_geocachingtoolbox_3_description'),
  MurrayCodebook.MYGEOTOOLS:
      CodebookConfig(title: 'telegraph_murray_mygeotools_title', subtitle: 'telegraph_murray_mygeotools_description'),
};

const Map<String, List<String>> _CODEBOOK_ROYALNAVY = {
  // https://cms.sachsen.schule/fileadmin/_special/gruppen/592/klappentelegraph/download/klappentelegraphenalphabet_2016.pdf
  'A': ['2', '3', '4', '5', '6'],
  'B': ['1', '3', '4', '5', '6'],
  'C': ['1', '2', '4', '5', '6'],
  'D': ['1', '2', '3', '5', '6'],
  'E': ['1', '2', '3', '4', '6'],
  'F': ['1', '2', '3', '4', '5'],
  'G': ['1'],
  'H': ['2'],
  'I': ['3'],
  'K': ['4'],
  'L': ['5'],
  'M': ['6'],
  'N': ['1', '2', '4', '6'],
  'O': ['4', '6'],
  'P': ['3', '2', '4', '6'],
  'Q': ['2', '6'],
  'R': ['5', '2', '4', '6'],
  'S': ['2', '4'],
  'T': ['3', '5'],
  'V': ['1', '2', '3', '5'],
  'W': ['1', '3'],
  'X': ['1', '2', '3', '4'],
  'Y': ['1', '3'],
  'Z': ['1', '2', '3', '6'],
  '0': ['1', '2', '3', '4'],
  '1': ['1', '2', '5', '6'],
  '2': ['3', '4', '5', '6'],
  '3': ['2', '3', '4', '5'],
  '4': ['1', '3', '4', '6'],
  '5': ['2', '3', '5', '6'],
  '6': ['1', '2', '3'],
  '7': ['4', '5', '6'],
  '8': ['1', '2', '3', '6'],
  '9': ['1', '2', '4', '5'],
  '?': [],
  '!': ['1', '2', '3', '4', '5', '6'],
  ':': ['1', '6'],
  ';': ['2', '5'],
};

const Map<String, List<String>> _CODEBOOK_GEOCACHING = {
  // https://cms.sachsen.schule/fileadmin/_special/gruppen/592/klappentelegraph/download/klappentelegraphenalphabet_f_2007.pdf
  'A': [],
  'B': ['1', '3', '5'],
  'C': ['1', '2', '3', '4', '5', '6'],
  'D': ['2', '4', '6'],
  'E': ['1', '2', '3', '4'],
  'F': ['1', '2', '5', '6'],
  'G': ['3', '4', '5', '6'],
  'H': ['2', '3', '4', '5'],
  'I': ['1', '4', '6'],
  'J': ['1', '3', '4', '6'],
  'K': ['2', '3', '5'],
  'L': ['1', '4', '5', '6'],
  'M': ['1', '2', '3', '5'],
  'N': ['4', '5', '6'],
  'O': ['1', '2', '3', '6'],
  'P': ['1', '2', '4'],
  'Q': ['1', '6'],
  'R': ['2', '5'],
  'S': ['1', '4'],
  'T': ['2', '3'],
  'U': ['3', '6'],
  'V': ['4', '5'],
  'W': ['3', '4'],
  'X': ['1', '5'],
  'Y': ['2', '6'],
  'Z': ['1', '2'],
  'Ä': ['3', '4', '6'],
  'Ö': ['5', '6'],
  'Ü': ['1', '3'],
  '0': ['1'],
  '1': ['3'],
  '2': ['5'],
  '3': ['2'],
  '4': ['4'],
  '5': ['1', '2', '3', '4', '5'],
  '6': ['1', '3', '4', '5', '6'],
  '7': ['1', '2', '3', '5', '6'],
  '8': ['1', '2', '4', '5', '6'],
  '9': ['1', '2', '3', '4', '6'],
  '!': ['1', '2', '3', '4', '5', '6'],
  ',': ['4', '6'],
  '.': ['6'],
};

const Map<String, List<String>> _CODEBOOK_FISCHER = {
  // https://cms.sachsen.schule/fileadmin/_special/gruppen/592/klappentelegraph/download/klappentelegraphenalphabet_b_2007.pdf
  'A': [],
  'B': ['1', '3', '5'],
  'C': ['1', '2', '3', '4', '5', '6'],
  'D': ['2', '4', '6'],
  'E': ['1', '2', '3', '4'],
  'F': ['1', '2', '5', '6'],
  'G': ['3', '4', '5', '6'],
  'H': ['2', '3', '4', '5'],
  'I': ['1', '4', '6'],
  'J': ['1', '3', '4', '6'],
  'K': ['2', '3', '5'],
  'L': ['1', '4', '5', '6'],
  'M': ['1', '2', '3', '5'],
  'N': ['4', '5', '6'],
  'O': ['1', '2', '3', '6'],
  'P': ['1', '2', '4'],
  'Q': ['1', '6'],
  'R': ['2', '5'],
  'S': ['1', '4'],
  'T': ['2', '3'],
  'U': ['3', '6'],
  'V': ['4', '5'],
  'W': ['3', '4'],
  'X': ['1', '5'],
  'Y': ['2', '6'],
  'Z': ['1', '2'],
  'Ä': ['3', '4'],
  'Ö': ['5', '6'],
  'Ü': ['1', '3'],
  '0': ['1'],
  '1': ['3'],
  '2': ['5'],
  '3': ['2'],
  '4': ['4'],
  '5': ['1', '2', '3', '4', '5'],
  '6': ['1', '3', '4', '5', '6'],
  '7': ['1', '2', '3', '5', '6'],
  '8': ['1', '2', '4', '5', '6'],
  '9': ['1', '2', '3', '4', '6'],
  '!': ['1', '2', '3', '4', '5', '6'],
  ',': ['4', '6'],
  '.': ['6'],
};

const Map<String, List<String>> _CODEBOOK_ROUCOUX = {
  // http://virtual-library.culturalservices.net/webingres/bedfordshire/vlib/0.digitised_resources/dunstable_article_signalling_station_enlargement.htm
  'A': ['2', '3', '4', '5', '6'],
  'B': ['1', '3', '4', '5', '6'],
  'C': ['1', '2', '4', '5', '6'],
  'D': ['1', '2', '3', '5', '6'],
  'E': ['1', '2', '3', '4', '6'],
  'F': ['1', '2', '3', '4', '5'],
  'G': ['1'],
  'H': ['2'],
  'I': ['3'],
  'K': ['4'],
  'L': ['5'],
  'M': ['6'],
  'N': ['3', '5'],
  'O': ['1', '2', '3', '5'],
  'P': ['1', '5'],
  'Q': ['1', '3', '4', '5'],
  'R': ['1', '2'],
  'S': ['1', '3', '5', '6'],
  'T': ['1', '2', '4', '6'],
  'V': ['4', '6'],
  'W': ['2', '3', '4', '6'],
  'X': ['2', '6'],
  'Y': ['2', '4', '5', '6'],
  'Z': ['2', '4'],
};

const Map<String, List<String>> _CODEBOOK_MYGEOTOOLS = _CODEBOOK_GEOCACHING;

const Map<String, List<String>> _CODEBOOK_GEOCACHINGTOOLBOX_1 = _CODEBOOK_GEOCACHING;

const Map<String, List<String>> _CODEBOOK_GEOCACHINGTOOLBOX_2 = {
  'A': ['2', '3', '4', '5', '6'],
  'B': ['1', '3', '4', '5', '6'],
  'C': ['1', '2', '4', '5', '6'],
  'D': ['1', '2', '3', '5', '6'],
  'E': ['1', '2', '3', '4', '6'],
  'F': ['1', '2', '3', '4', '5'],
  'G': ['1', '2', '3', '5'],
  'H': ['1', '3', '4', '5'],
  'I': ['3', '3', '5', '6'],
  'J': ['1', '2', '4', '6'],
  'K': ['2', '3', '4', '6'],
  'L': ['2', '4', '5', '6'],
  'M': ['1', '3', '5'],
  'N': ['1', '3', '6'],
  'O': ['2', '4', '6'],
  'P': ['2', '4', '5'],
  'Q': ['1', '4', '6'],
  'R': ['1', '3'],
  'S': ['3', '5'],
  'T': ['2', '4'],
  'U': ['4', '6'],
  'V': ['1', '2'],
  'W': ['3', '4'],
  'X': ['5', '6'],
  'Y': ['1', '6'],
  'Z': ['2', '5'],
  ' ': [],
  'END': ['6'],
};

const Map<String, List<String>> _CODEBOOK_GEOCACHINGTOOLBOX_3 = {
  // https://lewiswalpole.files.wordpress.com/2011/12/lwlpr25106.jpg
  'A': ['2', '3', '4', '5', '6'],
  'B': ['1', '3', '4', '5', '6'],
  'C': ['1', '2', '4', '5', '6'],
  'D': ['1', '2', '3', '5', '6'],
  'E': ['1', '2', '3', '4', '6'],
  'F': ['1', '2', '3', '4', '5'],
  'G': ['1'],
  'H': ['2'],
  'I': ['3'],
  'K': ['4'],
  'L': ['5'],
  'M': ['6'],
  'N': ['3', '5'],
  'O': ['1', '2', '3', '5'],
  'P': ['1', '5'],
  'Q': ['1', '3', '4', '5'],
  'R': ['1', '2'],
  'S': ['1', '3', '5', '6'],
  'T': ['1', '2', '4', '6'],
  'V': ['4', '6'],
  'W': ['2', '3', '4', '6'],
  'X': ['2', '6'],
  'Y': ['2', '4', '5', '6'],
  'Z': ['2', '4'],
  'NORTH': ['1', '2', '3'],
  'EAST': ['4', '5', '6'],
  'SOUTH': ['1', '2', '3', '6'],
  'WEST': ['1', '2', '4', '5'],
};

Segments encodeMurray(String input, MurrayCodebook language) {
  Map<String, List<String>> CODEBOOK = <String, List<String>>{};
  switch (language) {
    case MurrayCodebook.GEOCACHING:
      CODEBOOK = _CODEBOOK_GEOCACHING;
      break;
    case MurrayCodebook.ROYALNAVY:
      CODEBOOK = _CODEBOOK_ROYALNAVY;
      break;
    case MurrayCodebook.FISCHER:
      CODEBOOK = _CODEBOOK_FISCHER;
      break;
    case MurrayCodebook.ROUCOUX:
      CODEBOOK = _CODEBOOK_ROUCOUX;
      break;
    case MurrayCodebook.GEOCACHINGTOOLBOX_1:
      CODEBOOK = _CODEBOOK_GEOCACHINGTOOLBOX_1;
      break;
    case MurrayCodebook.GEOCACHINGTOOLBOX_2:
      CODEBOOK = _CODEBOOK_GEOCACHINGTOOLBOX_2;
      break;
    case MurrayCodebook.GEOCACHINGTOOLBOX_3:
      CODEBOOK = _CODEBOOK_GEOCACHINGTOOLBOX_3;
      break;
    case MurrayCodebook.MYGEOTOOLS:
      CODEBOOK = _CODEBOOK_MYGEOTOOLS;
      break;
  }

  List<String> inputs = input.split('');
  List<List<String>> result = [];

  for (int i = 0; i < inputs.length; i++) {
    if (CODEBOOK[inputs[i].toUpperCase()] != null) result.add(CODEBOOK[inputs[i].toUpperCase()]!);
  }
  return Segments(displays: result);
}

SegmentsChars decodeMurray(List<String> inputs, MurrayCodebook language) {
  if (inputs.isEmpty) return SegmentsChars(displays: <List<String>>[], chars: []);

  var displays = <List<String>>[];

  Map<List<String>, String> CODEBOOK = <List<String>, String>{};
  switch (language) {
    case MurrayCodebook.GEOCACHING:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_GEOCACHING);
      break;
    case MurrayCodebook.ROYALNAVY:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_ROYALNAVY);
      break;
    case MurrayCodebook.FISCHER:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_FISCHER);
      break;
    case MurrayCodebook.ROUCOUX:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_ROUCOUX);
      break;
    case MurrayCodebook.GEOCACHINGTOOLBOX_1:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_GEOCACHINGTOOLBOX_1);
      break;
    case MurrayCodebook.GEOCACHINGTOOLBOX_2:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_GEOCACHINGTOOLBOX_2);
      break;
    case MurrayCodebook.GEOCACHINGTOOLBOX_3:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_GEOCACHINGTOOLBOX_3);
      break;
    case MurrayCodebook.MYGEOTOOLS:
      CODEBOOK = switchMapKeyValue(_CODEBOOK_MYGEOTOOLS);
      break;
  }

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
