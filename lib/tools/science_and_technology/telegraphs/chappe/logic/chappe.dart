import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

enum ChappeCodebook { ALPHABET, CODEPOINTS, DIGITS, KULIBIN }

Map<ChappeCodebook, Map<String, String>> CHAPPE_CODEBOOK = {
  ChappeCodebook.DIGITS: {'title': 'telegraph_chappe_digits_title', 'subtitle': 'telegraph_chappe_digits_description'},
  ChappeCodebook.CODEPOINTS: {
    'title': 'telegraph_chappe_codepoints_title',
    'subtitle': 'telegraph_chappe_codepoints_description'
  },
  ChappeCodebook.ALPHABET: {
    'title': 'telegraph_chappe_alphabet_title',
    'subtitle': 'telegraph_chappe_alphabet_description'
  },
  ChappeCodebook.KULIBIN: {
    'title': 'telegraph_chappe_kulibin_title',
    'subtitle': 'telegraph_chappe_kulibin_description'
  },
};

final Map<String, List<String>> CODEBOOK_CHAPPE_DIGITS = {
  '1': ['30', '70'],
  '2': ['10', '50'],
  '3': ['30', '3r', '70'],
  '4': ['10', '50', '5r'],
  '5': ['30', '70', '7l'],
  '6': ['10', '1l', '50'],
  '7': ['30', '70', '7r'],
  '8': ['10', '1r', '50'],
  '9': ['30', '3l', '70'],
  '0': ['10', '50', '5l'],
};

final Map<String, List<String>> CODEBOOK_CHAPPE_ALPHABET = {
  'A': ['10', '1r', '50', '5l'],
  'B': ['20', '2r', '60', '6l'],
  'C': ['30', '3r', '70', '7l'],
  'D': ['40', '4r', '80', '8l'],
  'E': ['10', '1l', '50', '5r'],
  'F': ['20', '2l', '60', '6r'],
  'G': ['30', '3l', '70', '7r'],
  'H': ['40', '4l', '80', '8r'],
  'I': ['10', '1l', '50', '5l'],
  'K': ['20', '2l', '60', '6l'],
  'L': ['30', '3l', '70', '7l'],
  'M': ['40', '4l', '80', '8l'],
  'N': ['10', '1r', '50', '5r'],
  'O': ['20', '2r', '60', '6r'],
  'P': ['30', '3r', '70', '7r'],
  'Q': ['40', '4r', '80', '8r'],
  'R': ['10', '1r', '50'],
  'S': ['20', '2r', '60'],
  'T': ['30', '3r', '70'],
  'U': ['40', '4r', '80'],
  'V': ['10', '50', '5r'],
  'W': ['20', '60', '6r'],
  'X': ['30', '70', '7r'],
  'Y': ['40', '80', '8r'],
  'Z': ['10', '50', '5l'],
  '1': ['30', '70', '7l'],
  '2': ['40', '80', '8l'],
  '3': ['10', '1l', '50'],
  '4': ['20', '2l', '60'],
  '5': ['30', '3l', '70'],
  '6': ['40', '4l', '80'],
  '7': ['10', '50'],
  '8': ['20', '60'],
  '9': ['30', '70'],
  '0': ['40', '80'],
  '&': ['20', '60', '6l'],
};

final Map<String, List<String>> CODEBOOK_CHAPPE_CODEPOINTS = {
  '1': ['30', '3o', '70'],
  '2': ['30', '3u', '70'],
  '3': ['30', '70', '7o'],
  '4': ['30', '70', '7u'],
  '5': ['30', '3r', '70'],
  '6': ['30', '3l', '70'],
  '7': ['30', '70', '7l'],
  '8': ['30', '70', '7r'],
  '9': ['30', '3b', '70'],
  '10': ['30', '3a', '70'],
  '11': ['30', '70', '7b'],
  '12': ['30', '70', '7a'],
  '13': ['30', '3o', '70', '7o'],
  '14': ['30', '3u', '70', '7u'],
  '15': ['30', '3o', '70', '7l'],
  '16': ['30', '3u', '70', '7r'],
  '17': ['30', '3o', '70', '7b'],
  '18': ['30', '3u', '70', '7a'],
  '19': ['30', '3o', '70', '7u'],
  '20': ['30', '3u', '70', '7o'],
  '21': ['30', '3o', '70', '7r'],
  '22': ['30', '3u', '70', '7l'],
  '23': ['30', '3o', '70', '7a'],
  '24': ['30', '3u', '70', '7b'],
  '25': ['30', '3b', '70', '7o'],
  '26': ['30', '3a', '70', '7u'],
  '27': ['30', '3b', '70', '7l'],
  '28': ['30', '3a', '70', '7r'],
  '29': ['30', '3b', '70', '7b'],
  '30': ['30', '3a', '70', '7a'],
  '31': ['30', '3b', '70', '7u'],
  '32': ['30', '3a', '70', '7o'],
  '33': ['30', '3b', '70', '7r'],
  '34': ['30', '3a', '70', '7l'],
  '35': ['30', '3b', '70', '7a'],
  '36': ['30', '3a', '70', '7b'],
  '37': ['30', '3r', '70', '7o'],
  '38': ['30', '3l', '70', '7u'],
  '39': ['30', '3r', '70', '7l'],
  '40': ['30', '3l', '70', '7r'],
  '41': ['30', '3r', '70', '7b'],
  '42': ['30', '3l', '70', '7a'],
  '43': ['30', '3r', '70', '7u'],
  '44': ['30', '3l', '70', '7o'],
  '45': ['30', '3r', '70', '7a'],
  '46': ['30', '3l', '70', '7b'],
  '47': ['10', '1o', '50'],
  '48': ['10', '1u', '50'],
  '49': ['10', '50', '5o'],
  '50': ['10', '50', '5u'],
  '51': ['10', '1r', '50'],
  '52': ['10', '1l', '50'],
  '53': ['10', '50', '5l'],
  '54': ['10', '50', '5r'],
  '55': ['10', '1a', '50'],
  '56': ['10', '1b', '50'],
  '57': ['10', '50', '5a'],
  '58': ['10', '50', '5b'],
  '59': ['10', '1o', '50', '5o'],
  '60': ['10', '1u', '50', '5u'],
  '61': ['10', '1o', '50', '5l'],
  '62': ['10', '1u', '50', '5r'],
  '63': ['10', '1o', '50', '5a'],
  '64': ['10', '1u', '50', '5b'],
  '65': ['10', '1o', '50', '5u'],
  '66': ['10', '1u', '50', '5o'],
  '67': ['10', '1o', '50', '5r'],
  '68': ['10', '1u', '50', '5l'],
  '69': ['10', '1o', '50', '5b'],
  '70': ['10', '1u', '50', '5a'],
  '71': ['10', '1a', '50', '5o'],
  '72': ['10', '1b', '50', '5u'],
  '73': ['10', '1a', '50', '5l'],
  '74': ['10', '1b', '50', '5r'],
  '75': ['10', '1a', '50', '5a'],
  '76': ['10', '1b', '50', '5b'],
  '77': ['10', '1a', '50', '5u'],
  '78': ['10', '1b', '50', '5o'],
  '79': ['10', '1a', '50', '5r'],
  '80': ['10', '1b', '50', '5l'],
  '81': ['10', '1a', '50', '5b'],
  '82': ['10', '1b', '50', '5a'],
  '83': ['10', '1r', '50', '5o'],
  '84': ['10', '1l', '50', '5u'],
  '85': ['10', '1r', '50', '5a'],
  '86': ['10', '1l', '50', '5b'],
  '87': ['10', '1r', '50', '5u'],
  '88': ['10', '1l', '50', '5o'],
  '89': ['10', '1r', '50', '5r'],
  '90': ['10', '1l', '50', '5l'],
  '91': ['10', '1r', '50', '5b'],
  '92': ['10', '1l', '50', '5a'],
};

final Map<String, List<String>> CODEBOOK_KULIBIN = {
  'A': ['10', '1r', '50', '5l'],
  'B': ['20', '2r', '60', '6l'],
  'C': ['30', '3r', '70', '7l'],
  'D': ['40', '4r', '80', '8l'],
  'E': ['10', '1l', '50', '5r'],
  'F': ['20', '2l', '60', '6r'],
  'G': ['30', '3l', '70', '7r'],
  'H': ['40', '4l', '80', '8r'],
  'I': ['10', '1l', '50', '5l'],
  'K': ['20', '2l', '60', '6l'],
  'L': ['30', '3l', '70', '7l'],
  'M': ['40', '4l', '80', '8l'],
  'N': ['10', '1r', '50', '5r'],
  'O': ['20', '2r', '60', '6r'],
  'P': ['30', '3r', '70', '7r'],
  'Q': ['40', '4r', '80', '8r'],
  'R': ['10', '1r', '50'],
  'S': ['20', '2r', '60'],
  'T': ['30', '3r', '70'],
  'U': ['40', '4r', '80'],
  'V': ['10', '50', '5r'],
  'W': ['20', '60', '6r'],
  'X': ['30', '70', '7r'],
  'Y': ['40', '80', '8r'],
  'Z': ['10', '50', '5l'],
  '1': ['30', '70', '7l'],
  '2': ['40', '80', '8l'],
  '3': ['10', '1l', '50'],
  '4': ['20', '2l', '60'],
  '5': ['30', '3l', '70'],
  '6': ['40', '4l', '80'],
  '7': ['10', '50'],
  '8': ['20', '60'],
  '9': ['30', '70'],
  '0': ['40', '80'],
  '&': ['20', '60', '6l'],
};

List<List<String>> encodeChappe(String input, ChappeCodebook language) {
  if (input == null) return [];

  List<String> inputs = [];
  if (language == ChappeCodebook.CODEPOINTS)
    inputs = input.split(' ');
  else
    inputs = input.split('');
  List<List<String>> result = [];

  var CODEBOOK;
  switch (language) {
    case ChappeCodebook.ALPHABET:
      CODEBOOK = CODEBOOK_CHAPPE_ALPHABET;
      break;
    case ChappeCodebook.CODEPOINTS:
      CODEBOOK = CODEBOOK_CHAPPE_CODEPOINTS;
      break;
    case ChappeCodebook.DIGITS:
      CODEBOOK = CODEBOOK_CHAPPE_DIGITS;
      break;
    case ChappeCodebook.KULIBIN:
      CODEBOOK = CODEBOOK_KULIBIN;
      break;
  }

  for (int i = 0; i < inputs.length; i++) {
    if (CODEBOOK[inputs[i].toUpperCase()] != null) {
      result.add(CODEBOOK[inputs[i].toUpperCase()]);
    }
  }
  return result;
}

Map<String, dynamic> decodeVisualChappe(List<String> inputs, ChappeCodebook language) {
  if (inputs == null || inputs.length == 0)
    return {
      'displays': <List<String>>[],
      'chars': [0]
    };

  var displays = <List<String>>[];
  var segment = <String>[];

  Map<List<String>, String> CODEBOOK = Map<List<String>, String>();

  switch (language) {
    case ChappeCodebook.ALPHABET:
      CODEBOOK = switchMapKeyValue(CODEBOOK_CHAPPE_ALPHABET);
      break;
    case ChappeCodebook.CODEPOINTS:
      CODEBOOK = switchMapKeyValue(CODEBOOK_CHAPPE_CODEPOINTS);
      break;
    case ChappeCodebook.DIGITS:
      CODEBOOK = switchMapKeyValue(CODEBOOK_CHAPPE_DIGITS);
      break;
    case ChappeCodebook.KULIBIN:
      CODEBOOK = switchMapKeyValue(CODEBOOK_KULIBIN);
      break;
  }

  inputs.forEach((element) {
    segment = _stringToSegment(element);
    displays.add(segment);
  });

  List<String> text = inputs.where((input) => input != null).map((input) {
    var char = '';
    var charH = '';

    if (CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] == null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      charH = CODEBOOK.map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()];
      char = char + charH;
    }

    return char;
  }).toList();
  return {'displays': displays, 'chars': text.join(' ')};
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
  } else
    return [];
}

Map<String, dynamic> decodeTextChappeTelegraph(String inputs, ChappeCodebook language) {
  if (inputs == null || inputs.length == 0)
    return {
      'displays': <List<String>>[],
      'text': '',
    };

  var displays = <List<String>>[];
  String text = '';

  Map<String, List<String>> CODEBOOK = Map<String, List<String>>();

  switch (language) {
    case ChappeCodebook.ALPHABET:
      CODEBOOK = CODEBOOK_CHAPPE_ALPHABET;
      break;
    case ChappeCodebook.CODEPOINTS:
      CODEBOOK = CODEBOOK_CHAPPE_CODEPOINTS;
      break;
    case ChappeCodebook.DIGITS:
      CODEBOOK = CODEBOOK_CHAPPE_DIGITS;
      break;
    case ChappeCodebook.KULIBIN:
      CODEBOOK = CODEBOOK_KULIBIN;
      break;
  }

  inputs.split(' ').forEach((element) {
    if (CODEBOOK[element] != null) {
      text = text + element;
    } else {
      text = text + UNKNOWN_ELEMENT;
    }
    displays.add(CODEBOOK[element]);
  });
  return {'displays': displays, 'text': text};
}
