import 'package:diacritic/diacritic.dart';
import 'package:gc_wizard/utils/string_utils.dart';

final String _WORD_SEPARATORS = r'[^A-Za-z0-9\-ß\u1e9e]';

class ControlCharacter {
  final int asciiValue;
  final String unicode;
  final String name;
  final String abbreviation;
  final String escapeCode;
  final List<String> symbols;

  ControlCharacter(this.asciiValue, this.unicode, this.name, this.abbreviation, this.escapeCode, this.symbols);
}

final Map<String, ControlCharacter> WHITESPACE_CHARACTERS = {
  '\u0009': ControlCharacter(
      9, 'U+0009', 'textanalysis_whitespace_charactertabulation', 'TAB/HT', '\\t', ['\u21e5', '\u21b9', '\u2409']),
  '\u000A': ControlCharacter(10, 'U+000A', 'textanalysis_whitespace_linefeed', 'LF', '\\n',
      ['\u21B5', '\u23CE', '\u00B6', '\u240A', '\u2424']),
  '\u000B': ControlCharacter(11, 'U+000B', 'textanalysis_whitespace_linetabulation', 'VT', '\\v', ['\u240B']),
  '\u000C': ControlCharacter(12, 'U+000C', 'textanalysis_whitespace_formfeed', 'FF', '\\f', ['\u21A1', '\u240C']),
  '\u000D': ControlCharacter(
      13, 'U+000D', 'textanalysis_whitespace_carriagereturn', 'CR', '\\r', ['\u00B6', '\u21B5', '\u23CE', '\u240D']),
  '\u0020': ControlCharacter(32, 'U+0020', 'textanalysis_whitespace_space', 'SP', null, ['\u2423', '\u2420']),
  '\u0085':
      ControlCharacter(133, 'U+0085', 'textanalysis_whitespace_nextline', 'NEL', null, ['\u21B5', '\u23CE', '\u2424']),
};

final Map<String, ControlCharacter> CONTROL_CHARACTERS = {
  '\u0000': ControlCharacter(0, 'U+0000', 'textanalysis_control_null', 'NUL', '\\0', ['\u2400']),
  '\u0001': ControlCharacter(1, 'U+0001', 'textanalysis_control_startofheading', 'SOH', null, ['\u2401']),
  '\u0002': ControlCharacter(2, 'U+0002', 'textanalysis_control_startoftext', 'STX', null, ['\u2402']),
  '\u0003': ControlCharacter(3, 'U+0003', 'textanalysis_control_endoftext', 'ETX', null, ['\u2403']),
  '\u0004': ControlCharacter(4, 'U+0004', 'textanalysis_control_endoftransmission', 'EOT', null, ['\u2404']),
  '\u0005': ControlCharacter(5, 'U+0005', 'textanalysis_control_enquiry', 'ENQ', null, ['\u2405']),
  '\u0006': ControlCharacter(6, 'U+0006', 'textanalysis_control_acknowledge', 'ACK', null, ['\u2406']),
  '\u0007': ControlCharacter(7, 'U+0007', 'textanalysis_control_bell', 'BEL', '\\a', ['\u237E', '\u2407']),
  '\u0008': ControlCharacter(8, 'U+0008', 'textanalysis_control_backspace', 'BS', null, ['\u232B', '\u2408']),
  '\u000E': ControlCharacter(14, 'U+000E', 'textanalysis_control_shiftout', 'SO', null, ['\u240E']),
  '\u000F': ControlCharacter(15, 'U+000F', 'textanalysis_control_shiftin', 'SI', null, ['\u240F']),
  '\u0010': ControlCharacter(16, 'U+0010', 'textanalysis_control_datalinkescape', 'DEL', null, ['\u2410']),
  '\u0011': ControlCharacter(17, 'U+0011', 'textanalysis_control_devicecontrol1', 'DC1', null, ['\u2411']),
  '\u0012': ControlCharacter(18, 'U+0012', 'textanalysis_control_devicecontrol2', 'DC2', null, ['\u2412']),
  '\u0013': ControlCharacter(19, 'U+0013', 'textanalysis_control_devicecontrol3', 'DC3', null, ['\u2413']),
  '\u0014': ControlCharacter(20, 'U+0014', 'textanalysis_control_devicecontrol4', 'DC4', null, ['\u2414']),
  '\u0015': ControlCharacter(21, 'U+0015', 'textanalysis_control_negativeacknowledge', 'NAK', null, ['\u2415']),
  '\u0016': ControlCharacter(22, 'U+0016', 'textanalysis_control_synchronousidle', 'SYN', null, ['\u2416']),
  '\u0017': ControlCharacter(23, 'U+0017', 'textanalysis_control_endoftransmissionblock', 'ETB', null, ['\u2417']),
  '\u0018': ControlCharacter(24, 'U+0018', 'textanalysis_control_cancel', 'CAN', null, ['\u2418']),
  '\u0019': ControlCharacter(25, 'U+0019', 'textanalysis_control_endofmedium', 'EM', null, ['\u2419']),
  '\u001A': ControlCharacter(26, 'U+001A', 'textanalysis_control_substitute', 'SUB', null, ['\u241A']),
  '\u001B': ControlCharacter(27, 'U+001B', 'textanalysis_control_escape', 'ESC', '\\e', ['\u241B']),
  '\u001C': ControlCharacter(28, 'U+001C', 'textanalysis_control_fileseparator', 'FS', null, ['\u241C']),
  '\u001D': ControlCharacter(29, 'U+001D', 'textanalysis_control_groupseparator', 'GS', null, ['\u241D']),
  '\u001E': ControlCharacter(30, 'U+001E', 'textanalysis_control_recordseparator', 'RS', null, ['\u241E']),
  '\u001F': ControlCharacter(31, 'U+001F', 'textanalysis_control_unitseparator', 'US', null, ['\u241F']),
  '\u007F': ControlCharacter(127, 'U+007F', 'textanalysis_control_delete', 'DEL', null, ['\u232B', '\u2408']),
};

class TextAnalysisCharacterCounts {
  Map<String, int> letters;
  Map<String, int> numbers;
  Map<String, int> specialChars;
  Map<String, int> whiteSpaces;
  Map<String, int> controlChars;

  TextAnalysisCharacterCounts([this.letters, this.numbers, this.specialChars, this.whiteSpaces, this.controlChars]);
}

int countWords(String text) {
  if (text == null || text.isEmpty) return 0;

  return removeDiacritics(text)
      .split(RegExp(_WORD_SEPARATORS))
      .where((word) => word != null && word.isNotEmpty)
      .toList()
      .length;
}

Map<String, int> _addOrIncreaseCount(Map<String, int> map, String character) {
  if (map.containsKey(character)) {
    map[character]++;
  } else {
    map.putIfAbsent(character, () => 1);
  }

  return map;
}

Map<String, int> _analyzeLetters(String text, bool caseSensitive) {
  if (!caseSensitive) {
    text = text.toUpperCase().replaceAll('ß', '\u1e9e');
  }

  var letters = Map<String, int>();
  text.split('').forEach((character) {
    if (!isOnlyLetters(character)) return;

    _addOrIncreaseCount(letters, character);
  });

  return letters;
}

Map<String, int> _analyzeNumbers(String text) {
  text = text.replaceAll(RegExp(r'[^0-9]'), '');

  var numbers = Map<String, int>();
  text.split('').forEach((character) {
    _addOrIncreaseCount(numbers, character);
  });

  return numbers;
}

Map<String, int> _analyzeWhitespaces(String text) {
  var whiteSpaces = Map<String, int>();
  text.split('').forEach((character) {
    if (WHITESPACE_CHARACTERS.containsKey(character)) _addOrIncreaseCount(whiteSpaces, character);
  });

  return whiteSpaces;
}

Map<String, int> _analyzeControlChars(String text, {bool includingWhitespaceCharacter: true}) {
  var controls = Map<String, int>();

  var characters = Map.from(CONTROL_CHARACTERS);
  if (includingWhitespaceCharacter) {
    characters.addAll(WHITESPACE_CHARACTERS);
  }

  text.split('').forEach((character) {
    if (characters.containsKey(character)) _addOrIncreaseCount(controls, character);
  });

  return controls;
}

Map<String, int> _analyzeSpecialChars(String text) {
  text = removeAccents(text).toUpperCase().replaceAll(RegExp(r'[A-Z0-9ß\u1e9e]'), '');

  var controlsAndWhiteSpaces = WHITESPACE_CHARACTERS.keys.toList();
  controlsAndWhiteSpaces.addAll(CONTROL_CHARACTERS.keys.toList());

  var specialChars = Map<String, int>();
  text.split('').forEach((character) {
    if (controlsAndWhiteSpaces.contains(character)) return;

    _addOrIncreaseCount(specialChars, character);
  });

  return specialChars;
}

TextAnalysisCharacterCounts analyzeText(String text, {bool caseSensitive: true}) {
  if (text == null) return null;

  var out = TextAnalysisCharacterCounts();

  out.letters = _analyzeLetters(text, caseSensitive);
  out.numbers = _analyzeNumbers(text);
  out.specialChars = _analyzeSpecialChars(text);
  out.whiteSpaces = _analyzeWhitespaces(text);
  out.controlChars = _analyzeControlChars(text, includingWhitespaceCharacter: false);

  return out;
}
