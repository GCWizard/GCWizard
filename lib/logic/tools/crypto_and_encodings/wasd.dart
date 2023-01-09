// https://www.geocaching.com/geocache/GC8PJEQ
//
// ASSDWW.DSAWSSDW.WWDSSA.WWA.WDSASDW   => 08078
//
// SDWSS.AWDSSA.SAWDWAS.ASSDWA.DWWASS   => 49860
//
// ss dsasd dsadsa sdwawd asdsa ssdwwa ww sswaw dwawd asdsa sdwss wwa wasdsaw wwsaw ww awdwa awdwa ss sdsww asdsa dwadwass ss sawwds
// wdddsaasasdsdwwdss wdwaaaaaaaaaaaaaaaasssa

// https://www.geocaching.com/geocache/GC5QNK6_random-walk
// N: ESSNESWSENSSSENSSNESWSENESSWNNWSENSS
// E: ESSWNNSSWSESWESWESWESWSESSENWESSESSWNN
// ESS NESWSEN SS SENSS NESWSEN ESSWNN WSENSS SS WSESW ESWESW ESWSE SSENW ESS ESSWNN
// ESS NESWSEN SS SENSS NESWSEN ESSWNN WSENSS  => 7824809
// SS WSESW ESWESW ESWSE SSENW ESS ESSWNN      => 01532670

import 'dart:math';

import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

class Offset {
  final int xOffset;
  final int yOffset;
  final int leftBorder;
  Offset(this.xOffset, this.yOffset, this.leftBorder);
}

enum WASD_TYPE { CURSORS, WASD, IJMK, ESDF, ULDR, OLUR, VLZR, WQSE, ARROWS, NWSE, NWSO, CUSTOM }

enum WASD_DIRECTION { UP, DOWN, LEFT, RIGHT, START }

final _SEGMENT_LENGTH = 5;

Map<WASD_TYPE, String> KEYBOARD_CONTROLS = {
  WASD_TYPE.CURSORS: '↑←↓→',
  WASD_TYPE.NWSE: 'NWSE',
  WASD_TYPE.NWSO: 'NWSO',
  WASD_TYPE.ARROWS: '^<v>',
  WASD_TYPE.WASD: 'WASD',
  WASD_TYPE.ULDR: 'ULDR',
  WASD_TYPE.OLUR: 'OLUR',
  WASD_TYPE.ESDF: 'ESDF',
  WASD_TYPE.WQSE: 'WQSE',
  WASD_TYPE.IJMK: 'IJMK',
  WASD_TYPE.VLZR: 'VLZR',
  WASD_TYPE.CUSTOM: 'wasd_keyboard_custom',
};

final Map<String, List<String>> WASD_ENCODE = {
  '0': [
    '←↓↓→↑↑',
    '↓↓→↑↑←',
    '↓→↑↑←↓',
    '→↑↑←↓↓',
    '↑↑←↓↓→',
    '↑←↓↓→↑',
    '↑↑→↓↓←',
    '↑→↓↓←↑',
    '→↓↓←↑↑',
    '↓↓←↑↑→',
    '↓←↑↑→↓',
    '←↑↑→↓↓'
  ],
  '1': ['↑↑', '↓↓'],
  '2': ['→↓←↓→', '←↑→↑←'],
  '3': ['→↓←→↓←', '→↑←→↑←'],
  '4': ['↓→↑↓↓', '↓→↓↑↑', '↑↑↓←↑', '↓↓↑←↑'],
  '5': ['→↑←↑→', '←↓→↓←'],
  '6': ['←↓↓→↑←', '↓↓→↑←', '→↓←↑↑→', '→↓←↑↑', '←↓→↓←↑', '↓→↑←↑→', '↓→↑←↑', '↓→↓←↑'],
  '7': ['↑↑←', '→↓↓'],
  '8': [
    '↓→↓←↑→↑←',
    '→↓←↓→↑←↑',
    '↑→↓←↓→↑',
    '↓←↑→↑←↓',
    '↑←↓→↓←↑',
    '↓→↑←↑→↓',
    '←↓→↓←↑→↑',
    '↓←↓→↑←↑→',
    '↑→↑←↓→↓←',
    '→↑←↑→↓←↓',
    '←↑→↑←↓→↓',
    '↑←↑→↓←↓→',
    '↑↑→↓←→↓←',
    '→↑←→↑←↓↓',
    '↑↑←↓→←↓→',
    '←↑→←↑→↓↓',
    '↓↓→↑←→↑←',
    '→↓←→↓←↑↑',
    '↓↓←↑→←↑→',
    '←↓→←↓→↑↑',
    '→↓←↑↓↓→↑'
  ],
  '9': [
    '←↓→↓↑↑',
    '←↑→↓↓',
    '↑←↓→↓',
    '←↑→↓↓←',
    '↑←↓→↓←',
    '←↓→↓←→↑↑',
    '↑↑←↓→',
    '↑←↑→↓',
    '→↑↑←↓→',
    '→↑←↑→↓',
    '↓↓←→↑←↑→',
    '←↓→↑↓↓',
    '←↓→↑↓↓←'
  ],
  ' ': [' '],
  '.': ['.']
};

final Map<List<String>, String> WASD_DECODE = switchMapKeyValue(WASD_ENCODE);

String encodeWASD(String input, List<String> controlSet) {
  if (input == '' || input == null) return '';

  controlSet = _normalizeControlSet(controlSet);

  input = input.toUpperCase();
  Random rnd = Random();
  List<String> result = [];
  input.split('').forEach((element) {
    if (WASD_ENCODE[element] == null)
      result.add('');
    else
      result.add(WASD_ENCODE[element][rnd.nextInt(WASD_ENCODE[element].length)].toString());
  });

  return substitution(result.join(' '), {
    '↑': controlSet[0],
    '←': controlSet[1],
    '↓': controlSet[2],
    '→': controlSet[3],
  });
}

String _normalizeDecodingInput(String input, List<String> controlSet) {
  var pattern = '[^' + controlSet.join().toUpperCase() + ']';

  input = input.toUpperCase().replaceAll(RegExp(pattern), ' ');

  return substitution(input, {
    controlSet[0]: '↑',
    controlSet[1]: '←',
    controlSet[2]: '↓',
    controlSet[3]: '→',
  });
}

String decodeWASD(String input, List<String> controlSet) {
  if (input == '' || input == null) return '';

  controlSet = _normalizeControlSet(controlSet);

  List<String> resultDecode = [];
  bool found = false;
  String result;

  _normalizeDecodingInput(input, controlSet).split(' ').forEach((element) {
    if (element != '') {
      WASD_DECODE.forEach((key, value) {
        if (key.contains(element)) {
          found = true;
          result = value;
        }
      });
      if (found) {
        resultDecode.add(result);
        found = false;
      } else
        resultDecode.add(UNKNOWN_ELEMENT);
    }
  });
  return resultDecode.join('');
}

_normalizeControlSet(List<String> controlSet) {
  var normalized = List<String>.from(controlSet);
  while (normalized.length < 4) {
    normalized.add(null);
  }

  if (normalized[0] == null || normalized[0].isEmpty) normalized[0] = '↑';
  if (normalized[1] == null || normalized[1].isEmpty) normalized[1] = '←';
  if (normalized[2] == null || normalized[2].isEmpty) normalized[2] = '↓';
  if (normalized[3] == null || normalized[3].isEmpty) normalized[3] = '→';

  return normalized.map((e) => e.toUpperCase()).toList();
}

String decodeWASDGraphic(String input, List<String> controlSet) {
  if (input == '' || input == null) return '';

  controlSet = _normalizeControlSet(controlSet);

  int x = 0;
  int y = 0;
  int maxLetterX = 0;
  int maxLetterY = 0;
  int minLetterX = 0;
  int minLetterY = 0;
  int xOffset = 0;
  int yOffset = 0;
  int maxSentenceX = 0;
  int maxSentenceY = 0;
  int minSentenceX = 0;
  int minSentenceY = 0;

  Map<String, String> sentence = Map();

  var direction = WASD_DIRECTION.START;

  _normalizeDecodingInput(input, controlSet).split(' ').forEach((word) {
    // draw picture per letter
    // transform/normalize picture
    // align picture in world

    y = 0;
    x = 0;
    maxLetterX = 0;
    maxLetterY = 0;
    minLetterX = 0;
    minLetterY = 0;

    direction = WASD_DIRECTION.START;

    Map<String, String> letter = Map();

    word.split('').forEach((element) {
      switch (element) {
        case '↓': // back, down
          switch (direction) {
            case WASD_DIRECTION.UP:
              y++;
              break;
            case WASD_DIRECTION.DOWN:
              y--;
              break;
            case WASD_DIRECTION.LEFT:
              x--;
              break;
            case WASD_DIRECTION.RIGHT:
              x++;
              break;
          }
          for (int i = 0; i < _SEGMENT_LENGTH; i++) {
            y++;
            letter[x.toString() + '|' + (y).toString()] = '1';
          }
          direction = WASD_DIRECTION.UP;
          if (y < minLetterY) minLetterY = y;
          if (x < minLetterX) minLetterX = x;
          if (y > maxLetterY) maxLetterY = y;
          if (x > maxLetterX) maxLetterX = x;
          break;

        case '↑': // forward, up
          switch (direction) {
            case WASD_DIRECTION.UP:
              y++;
              break;
            case WASD_DIRECTION.DOWN:
              y--;
              break;
            case WASD_DIRECTION.LEFT:
              x--;
              break;
            case WASD_DIRECTION.RIGHT:
              x++;
              break;
          }
          for (int i = 0; i < _SEGMENT_LENGTH; i++) {
            y--;
            letter[x.toString() + '|' + (y).toString()] = '1';
          }
          direction = WASD_DIRECTION.DOWN;
          if (y < minLetterY) minLetterY = y - 1;
          if (x < minLetterX) minLetterX = x;
          if (y > maxLetterY) maxLetterY = y + 1;
          if (x > maxLetterX) maxLetterX = x;
          break;

        case '←': // left
          switch (direction) {
            case WASD_DIRECTION.UP:
              y++;
              break;
            case WASD_DIRECTION.DOWN:
              y--;
              break;
            case WASD_DIRECTION.LEFT:
              x--;
              break;
            case WASD_DIRECTION.RIGHT:
              x++;
              break;
          }
          for (int i = 0; i < _SEGMENT_LENGTH; i++) {
            x--;
            letter[x.toString() + '|' + (y).toString()] = '1';
          }
          direction = WASD_DIRECTION.LEFT;
          if (y < minLetterY) minLetterY = y;
          if (x < minLetterX) minLetterX = x;
          if (y > maxLetterY) maxLetterY = y;
          if (x > maxLetterX) maxLetterX = x;
          break;

        case '→': // right
          switch (direction) {
            case WASD_DIRECTION.UP:
              y++;
              break;
            case WASD_DIRECTION.DOWN:
              y--;
              break;
            case WASD_DIRECTION.LEFT:
              x--;
              break;
            case WASD_DIRECTION.RIGHT:
              x++;
              break;
          }
          for (int i = 0; i < _SEGMENT_LENGTH; i++) {
            x++;
            letter[x.toString() + '|' + (y).toString()] = '1';
          }
          direction = WASD_DIRECTION.RIGHT;
          if (y < minLetterY) minLetterY = y;
          if (x < minLetterX) minLetterX = x;
          if (y > maxLetterY) maxLetterY = y;
          if (x > maxLetterX) maxLetterX = x;
          break;
      }
      if (maxLetterY > maxSentenceY) maxSentenceY = maxLetterY;
      if (minLetterY < minSentenceY) minSentenceY = minLetterY;
    }); // for Each letter

    // transform/normalize letter
    xOffset = 0;
    yOffset = 0;
    if (minLetterY == -5) minLetterY = -6;
    if (minLetterY == -11) minLetterY = -12;
    if (minLetterY < 0) yOffset = -1 * minLetterY;

    if (minLetterX < 0) xOffset = -1 * minLetterX;

    Map<String, String> transformedLetter = Map();
    letter.forEach((key, value) {
      transformedLetter[(int.parse(key.split('|')[0]) + xOffset).toString() +
          '|' +
          (int.parse(key.split('|')[1]) + yOffset).toString()] = value;
    });

    // add letter to sentence
    transformedLetter.forEach((key, value) {
      sentence[(int.parse(key.split('|')[0]) + maxSentenceX).toString() +
          '|' +
          (int.parse(key.split('|')[1])).toString()] = value;
    });

    maxSentenceX = maxSentenceX + (maxLetterX - minLetterX) + 4;
  }); // forEach word

  // build bitmap
  var binaryWorld =
      List.generate(maxSentenceX + 3, (y) => []..length = maxSentenceY - minSentenceY + 3, growable: false);
  sentence.forEach((key, value) {
    x = int.parse(key.split('|')[0]);
    y = int.parse(key.split('|')[1]);
    binaryWorld[x][y] = value;
  });

  // build output
  String outputLine = '##';
  List<String> output = <String>[];
  output.add(outputLine.padRight(maxSentenceX + 1, '#'));
  for (y = 0; y < maxSentenceY - minSentenceY + 1; y++) {
    outputLine = '##';
    for (x = 0; x < maxSentenceX - minSentenceX + 1; x++) {
      if (binaryWorld[x][y] == null)
        outputLine = outputLine + '#';
      else
        outputLine = outputLine + binaryWorld[x][y];
    }
    output.add(outputLine);
  }

  return output.join('\n');
}
