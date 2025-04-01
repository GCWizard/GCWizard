import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

//https://fakoo.de/fakoo/9-punkt-decoder.html
const Map<String, List<String>> _CharsToSegmentsLetters = {
  ' ': [],
  'a': ['2','3','5','6','9'],
  'b': ['1','2','6','8'],
  'c': ['2','6','9'],
  'd': ['2','3','4','5','6'],
  'e': ['2','3','6'],
  'f': ['1','2','3','4'],
  'g': ['1','3','4','5'],
  'h': ['1','2','3','5','8','9'],
  'i': ['3','4'],
  'j': ['3','6','7'],
  'k': ['2','3','5','7','9'],
  'l': ['1','2','3','6'],
  'm': ['2','3','5','8','9'],
  'n': ['2','3','5','9'],
  'o': ['3','5','9'],
  'p': ['1','2','3','4','5'],
  'q': ['1','2','4','5','6'],
  'r': ['2','3','5'],
  's': ['3','5','6','8'],
  't': ['2','4','5','6','9'],
  'u': ['2','6','8','9'],
  'v': ['2','6','8'],
  'w': ['2','3','6','8','9'],
  'x': ['1','3','4','6'],
  'y': ['3','4','5','7'],
  'z': ['2','5','6','9'],
  'A': ['2','3','4','5','8','9'],
  'B': ['1','3','4','5','6','7','8','9'],
  'C': ['2','4','6','7','9'],
  'D': ['1','2','3','4','6','8'],
  'E': ['1','2','3','4','5','6','7','9'],
  'F': ['1','2','3','4','5','7'],
  'G': ['2','4','6','7','8','9'],
  'H': ['1','2','3','5','7','8','9'],
  'I': ['3','4','5','6','9'],
  'J': ['3','6','7','8'],
  'K': ['1','2','3','5','7','9'],
  'L': ['1','2','3','6','9'],
  'M': ['1','2','3','4','5','7','8','9'],
  'N': ['1','2','3','4','7','8','9'],
  'O': ['2','4','6','8'],
  'P': ['1','2','3','4','5','8'],
  'Q': ['2','4','6','8','9'],
  'R': ['1','2','3','4','5','7','9'],
  'S': ['3','4','5','6','7'],
  'T': ['1','4','5','6','7'],
  'U': ['1','2','3','6','7','8','9'],
  'V': ['1','2','6','7','8'],
  'W': ['1','2','3','5','6','7','8','9'],
  'X': ['1','3','5','7','9'],
  'Y': ['1','5','6','7'],
  'Z': ['1','3','4','5','6','7','9'],
  'Ä': ['2','3','4','5','7','8','9'],
  'Ö': ['2','4','6','7','8'],
  'Ü': ['1','2','3','6','7','9'],
  'ä': ['2','3','5','6','7'],
  'ö': ['3','5','7','9'],
  'ü': ['1','3','6','7'],
  '1': ['5','7','8','9'],
  '2': ['1','3','4','5','9'],
  '3': ['1','3','4','5','6','8'],
  '4': ['1','2','5','6','8'],
  '5': ['1','2','4','5','6','7'],
  '6': ['1','2','3','5','6','8','9'],
  '7': ['1','4','6','7','8'],
  '8': ['1','2','4','5','6','8','9'],
  '9': ['1','2','4','5','7','8','9'],
  '0': ['1','2','3','4','6','7','8','9'],
//Satzzeichen
  '.': ['6'],
  ',': ['35'],
  ':': ['46'],
  ';': ['345'],
  '-': ['258'],
  '+': ['24568'],
  '?': ['145678'],
  '!': ['1467'],
  '*': ['3459'],
  '#': ['1379'],
  '&': ['2345679'],
  '@': ['13489'],
  '/': ['357'],
  '|': ['456'],
  r'\': ['159'],
  '_': ['369'],
  '<': ['579'],
  '=': ['134679'],
  '>': ['135'],
  '(': ['567'],
  ')': ['156'],
  '[': ['12346'],
 ']': ['46789'],
  '{': ['23457'],
  '}': ['14589'],
  '‚': ['56'],
  '\'': ['45'],
  '„': ['5689'],
  '"': ['1245'],
  '”': ['4578'],
  '%': ['49'],
  '‰': ['169'],
  '[du]': ['235689'],
  '§': ['234567'],
  '~': ['23578'],
  '°': ['478'],
  '¿': ['234569'],
  '¡': ['3469'],
//Akzente
  '´': ['24'],
  '`': ['15'],
  '^': ['248'],
  '¨': ['14'],
  '¯': ['147'],
  '˜': ['247'],
  '[ht]': ['157'],
  '¸': ['356'],
  '[ku]': ['125'],
  '[og]': ['36'],
  '[po]': ['1'],
//Mathematik
  '·': ['5'],
  '±': ['2345689'],
  '≠': ['1245678'],
  '²': ['1458'],
  '³': ['2457'],
  '[wu]': ['24567'],
  '[we]': ['1478'],
  '[in]': ['12348'],
  '[ie]': ['26789'],
  '[ll]': ['123789'],
  '[np]': ['1234568'],

  '[wi]': ['123569'],
  '[sp]': ['35679'],
  '[dr]': ['379'],
  '[qu]': ['123456789'],
  '[bo]': ['2347'],
  '[kr]': ['234678'],
  'ø': ['2345678'],
  '[su]': ['1234679'],
  '[me]': ['23489'],
  '[er]': ['13468'],
  // Umschaltzeichen
  '[ho]': ['257'],
  '[nh]': ['158'],
  '[ti]': ['259'],
  '[nt]': ['358'],
  '[ha]': ['2579'],
  '[he]': ['1358'],
  '¬': ['589'],
  '[mk]': ['2589'],
  '[ke]': ['3689'],
//Symbole
  '[ml]': ['1345789'],
  '[wl]': ['135679'],
  '[bh]': ['34589'],
  '[sm]': ['135789'],
  '[tf]': ['134579'],
  '[bf]': ['1346789'],
  '[ok]': ['12357'],
  '©': ['2456789'],
 //Pfeile
  '[no]': ['2458'],
  '[nr]': ['4568'],
  '[nu]': ['2568'],
  '[or]': ['3478'],
  '[ur]': ['1689'],
  '[ol]': ['1249'],
  '[ul]': ['2367'],
//griechisch
  '[al]': ['235679'],
  'ß': ['345678'],
  '[gm]': ['156789'],
  '[de]': ['34579'],
  'µ': ['34578'],
  '¶': ['1456789'],
  '[oh]': ['234689'],
//Währung
  '€': ['245679'],
  '¢': ['2469'],
  r'$': ['3456789'],
  '£': ['234679'],
  '¥': ['15679'],
//Tageszeiten
  '[uh]': ['3458'],
  '[u1]': ['2567'],
  '[u2]': ['2459'],
  '[uh]': ['3458'],
  '[u4]': ['1568'],
 //Karten-Symbole
  '[hz]': ['124678'],
  '#': ['1379'],
  '+': ['24568'],
  '±': ['2345689'],
  //Leserichtung
  '[lr]': ['138'],
  '[ac]': ['349'],
  '[vo]': ['167'],
  '[lv]': ['279'],
};


Segments _encodeFakoo(String input) {
  List<String> inputs = input.split('');
  var result = Segments.Empty();

  bool numberFollows = false;

  Map<String, List<String>> _charsToSegments = <String, List<String>>{};
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.STD] ?? {});
  _charsToSegments.addAll(_charsToSegmentsDigits);

  for (int i = 0; i < inputs.length; i++) {
    if (_isNumber(inputs[i])) {
      if (!numberFollows) {
        result.addSegment(_SWITCH_NUMBERFOLLOWS);
        numberFollows = true;
      }
    } else {
      if (_isNumberLetter(inputs[i]) && numberFollows) result.addSegment(_SWITCH_LETTERFOLLOWS);
      numberFollows = false;
    }
    if (_charsToSegments[inputs[i].toLowerCase()] != null) result.addSegment(_charsToSegments[inputs[i].toLowerCase()]);
  }
  return result;
}

SegmentsChars decodeFakoo(List<String> inputs) {
  var displays = <List<String>>[];

  var antoineMap = Map<String, List<String>>.from(_charsToSegmentsLettersAntoine);
  antoineMap.remove('NUMBERFOLLOWS');

  var _segmentsToCharsBASICBraille = switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD] ?? {});
  _segmentsToCharsBASICBraille.addAll(switchMapKeyValue(antoineMap));

  List<String> text = inputs.map((input) {
    var char = '';
    var charH = '';
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });

    if (_segmentsToCharsBASICBraille
            .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ==
        null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      charH = _segmentsToCharsBASICBraille
              .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ??
          '';
      if (letters) {
        char = char + charH;
      } else // digits
      if ((_LetterToDigit[charH] == null) && (_AntoineToDigit[charH] == null)) {
        char = char + UNKNOWN_ELEMENT;
      } else if (_LetterToDigit[charH] == null) {
        char = char + (_AntoineToDigit[charH] ?? '');
      } else {
        char = char + (_LetterToDigit[charH] ?? '');
      }
    }

    displays.add(display);

    return char;
  }).toList();

  return SegmentsChars(displays: displays, chars: text);
}

List<String> _sanitizeDecodeInput(List<String> input) {
  var pattern = language == BrailleLanguage.EUR ? RegExp(r'[^1-8]') : RegExp(r'[^1-6]');

  return input.map((code) {
    var chars = code.replaceAll(pattern, '').split('').toList();
    chars.sort();
    return chars.join();
  }).toList();
}

SegmentsChars decodeFakoo(List<String>? input) {
  if (input == null || input.isEmpty) return SegmentsChars(displays: [], chars: []);



  switch (language) {
    case BrailleLanguage.BASIC:
      return _decodeFakoo(input, letters);
    case BrailleLanguage.SIMPLE:
      return _decodeBrailleSIMPLE(input);
    case BrailleLanguage.DEU:
      return _decodeBrailleDEU(input);
    case BrailleLanguage.ENG:
      return _decodeBrailleENG(input);
    case BrailleLanguage.FRA:
      return _decodeBrailleFRA(input);
    case BrailleLanguage.EUR:
      return _decodeBrailleEUR(input);
    default:
      return SegmentsChars(displays: [], chars: []);
  }
}
