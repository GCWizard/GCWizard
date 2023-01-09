import 'dart:math';

import 'package:gc_wizard/utils/constants.dart';

final _baseSegmentsCistercianSegment = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u'
];

final Map<String, List<String>> _AZToSegmentCistercian = {
  '0': ['k'],
  '1': ['b', 'k'],
  '2': ['j', 'k'],
  '3': ['h', 'k'],
  '4': ['g', 'k'],
  '5': ['b', 'g', 'k'],
  '6': ['d', 'k'],
  '7': ['b', 'd', 'k'],
  '8': ['d', 'j', 'k'],
  '9': ['b', 'd', 'j', 'k'],
  '10': ['a', 'k'],
  '20': ['i', 'k'],
  '30': ['e', 'k'],
  '40': ['f', 'k'],
  '50': ['a', 'f', 'k'],
  '60': ['c', 'k'],
  '70': ['a', 'c', 'k'],
  '80': ['c', 'i', 'k'],
  '90': ['a', 'c', 'i', 'k'],
  '100': ['k', 'u'],
  '200': ['k', 'm'],
  '300': ['k', 'r'],
  '400': ['k', 's'],
  '500': ['k', 's', 'u'],
  '600': ['k', 'o'],
  '700': ['k', 'o', 'u'],
  '800': ['k', 'm', 'o'],
  '900': ['k', 'm', 'o', 'u'],
  '1000': ['k', 't'],
  '2000': ['k', 'l'],
  '3000': ['k', 'q'],
  '4000': ['k', 'p'],
  '5000': ['k', 'p', 't'],
  '6000': ['k', 'n'],
  '7000': ['k', 'n', 't'],
  '8000': ['k', 'l', 'n'],
  '9000': ['k', 'l', 'n', 't'],
};

List<List<String>> encodeCistercian(String input) {
  if (input == null || input == '') return [];

  List<String> inputCharacters = input.split(RegExp(r'[^1234567890]')).toList();
  var output = <List<String>>[];
  var digit = 0;
  var segmentList;

  for (String character in inputCharacters) {
    if (character == '0') {
      output.add(_AZToSegmentCistercian['0']);
      continue;
    }

    int encodeNumber = int.tryParse(character);
    var encodeString = encodeNumber.toString();
    if (encodeNumber != null && encodeNumber < 10000) {
      var display = Set<String>();
      for (int i = 0; i < encodeString.length; i++) {
        digit = int.parse(encodeString[i]) * pow(10, encodeString.length - i - 1);
        if (digit != 0) {
          segmentList = _AZToSegmentCistercian[digit.toString()];
          display.addAll(segmentList);
        }
      }
      var displayList = display.toList();
      displayList.sort();
      output.add(displayList);
    }
  }
  return output;
}

Map<String, dynamic> decodeCistercian(String input) {
  if (input == null || input == '') return {'displays': <List<String>>[], 'text': ''};

  var baseSegments = _baseSegmentsCistercianSegment;

  input = input.toLowerCase();
  var displays = <List<String>>[];
  List<String> currentDisplay;

  for (int i = 0; i < input.length; i++) {
    var segment = input[i];

    if (!baseSegments.contains(segment)) {
      if (currentDisplay != null) {
        currentDisplay.sort();
        displays.add(currentDisplay.toSet().toList());
      }

      currentDisplay = null;
      continue;
    }

    if (currentDisplay == null) currentDisplay = [];

    currentDisplay.add(segment);
  }

  if (currentDisplay != null) {
    currentDisplay.sort();
    displays.add(currentDisplay.toSet().toList());
  }

  String out = '';
  bool unknownToken = true;
  int digit = 0;
  List<String> tokens = input.split(' ');
  for (int i = 0; i < tokens.length; i++) {
    unknownToken = true;
    digit = 0;
    // segments contains all segments - these have to split into numbers
    //   1000 - 9000    k   l n p q t
    //    100 -  900    k   u m r s o
    //     10 -   90    k   a i e f c
    //      1 -    9    k   b j h g d
    // to return number.toString()
    // or return UNKNOWN_ELEMENT

    if (tokens[i].contains('k')) {
      tokens[i] = tokens[i].replaceAll('k', '');
      // check numbers 100 - 900
      if (tokens[i].contains('u') && tokens[i].contains('m') && tokens[i].contains('o')) {
        // 900
        digit = digit + 900;
        tokens[i] = tokens[i].replaceAll('u', '');
        tokens[i] = tokens[i].replaceAll('m', '');
        tokens[i] = tokens[i].replaceAll('o', '');
      } else if (tokens[i].contains('m') && tokens[i].contains('o')) {
        // 800
        digit = digit + 800;
        tokens[i] = tokens[i].replaceAll('m', '');
        tokens[i] = tokens[i].replaceAll('o', '');
      } else if (tokens[i].contains('u') && tokens[i].contains('o')) {
        // 700
        digit = digit + 700;
        tokens[i] = tokens[i].replaceAll('u', '');
        tokens[i] = tokens[i].replaceAll('o', '');
      } else if (tokens[i].contains('u') && tokens[i].contains('s')) {
        // 500
        digit = digit + 500;
        tokens[i] = tokens[i].replaceAll('u', '');
        tokens[i] = tokens[i].replaceAll('s', '');
      } else if (tokens[i].contains('o')) {
        // 600
        digit = digit + 600;
        tokens[i] = tokens[i].replaceAll('o', '');
      } else if (tokens[i].contains('s')) {
        // 400
        digit = digit + 400;
        tokens[i] = tokens[i].replaceAll('s', '');
      } else if (tokens[i].contains('r')) {
        // 300
        digit = digit + 300;
        tokens[i] = tokens[i].replaceAll('r', '');
      } else if (tokens[i].contains('m')) {
        // 200
        digit = digit + 200;
        tokens[i] = tokens[i].replaceAll('m', '');
      } else if (tokens[i].contains('u')) {
        // 100
        digit = digit + 100;
        tokens[i] = tokens[i].replaceAll('u', '');
      }

      // check numbers 1000 - 9000
      if (tokens[i].contains('t') && tokens[i].contains('n') && tokens[i].contains('l')) {
        // 9000
        digit = digit + 9000;
        tokens[i] = tokens[i].replaceAll('t', '');
        tokens[i] = tokens[i].replaceAll('n', '');
        tokens[i] = tokens[i].replaceAll('l', '');
      } else if (tokens[i].contains('n') && tokens[i].contains('l')) {
        // 8000
        digit = digit + 8000;
        tokens[i] = tokens[i].replaceAll('n', '');
        tokens[i] = tokens[i].replaceAll('l', '');
      } else if (tokens[i].contains('t') && tokens[i].contains('n')) {
        // 7000
        digit = digit + 7000;
        tokens[i] = tokens[i].replaceAll('t', '');
        tokens[i] = tokens[i].replaceAll('n', '');
      } else if (tokens[i].contains('t') && tokens[i].contains('p')) {
        // 5000
        digit = digit + 5000;
        tokens[i] = tokens[i].replaceAll('t', '');
        tokens[i] = tokens[i].replaceAll('p', '');
      } else if (tokens[i].contains('n')) {
        // 6000
        digit = digit + 6000;
        tokens[i] = tokens[i].replaceAll('n', '');
      } else if (tokens[i].contains('p')) {
        // 4000
        digit = digit + 4000;
        tokens[i] = tokens[i].replaceAll('p', '');
      } else if (tokens[i].contains('q')) {
        // 3000
        digit = digit + 3000;
        tokens[i] = tokens[i].replaceAll('q', '');
      } else if (tokens[i].contains('l')) {
        // 2000
        digit = digit + 2000;
        tokens[i] = tokens[i].replaceAll('l', '');
      } else if (tokens[i].contains('t')) {
        // 1000
        digit = digit + 1000;
        tokens[i] = tokens[i].replaceAll('t', '');
      }

      // check numbers 1 - 10
      if (tokens[i].contains('j') && tokens[i].contains('b') && tokens[i].contains('d')) {
        // 9
        digit = digit + 9;
        tokens[i] = tokens[i].replaceAll('j', '');
        tokens[i] = tokens[i].replaceAll('b', '');
        tokens[i] = tokens[i].replaceAll('d', '');
      } else if (tokens[i].contains('j') && tokens[i].contains('d')) {
        // 8
        digit = digit + 8;
        tokens[i] = tokens[i].replaceAll('j', '');
        tokens[i] = tokens[i].replaceAll('d', '');
      } else if (tokens[i].contains('b') && tokens[i].contains('d')) {
        // 7
        digit = digit + 7;
        tokens[i] = tokens[i].replaceAll('b', '');
        tokens[i] = tokens[i].replaceAll('d', '');
      } else if (tokens[i].contains('b') && tokens[i].contains('g')) {
        // 5
        digit = digit + 5;
        tokens[i] = tokens[i].replaceAll('b', '');
        tokens[i] = tokens[i].replaceAll('g', '');
      } else if (tokens[i].contains('d')) {
        // 6
        digit = digit + 6;
        tokens[i] = tokens[i].replaceAll('d', '');
      } else if (tokens[i].contains('g')) {
        // 4
        digit = digit + 4;
        tokens[i] = tokens[i].replaceAll('g', '');
      } else if (tokens[i].contains('h')) {
        // 3
        digit = digit + 3;
        tokens[i] = tokens[i].replaceAll('h', '');
      } else if (tokens[i].contains('j')) {
        // 2
        digit = digit + 2;
        tokens[i] = tokens[i].replaceAll('j', '');
      } else if (tokens[i].contains('b')) {
        // 1
        digit = digit + 1;
        tokens[i] = tokens[i].replaceAll('b', '');
      }

      // check numbers 10 - 90
      if (tokens[i].contains('a') && tokens[i].contains('c') && tokens[i].contains('i')) {
        // 90
        digit = digit + 90;
        tokens[i] = tokens[i].replaceAll('a', '');
        tokens[i] = tokens[i].replaceAll('c', '');
        tokens[i] = tokens[i].replaceAll('i', '');
      } else if (tokens[i].contains('c') && tokens[i].contains('i')) {
        // 80
        digit = digit + 80;
        tokens[i] = tokens[i].replaceAll('c', '');
        tokens[i] = tokens[i].replaceAll('i', '');
      } else if (tokens[i].contains('a') && tokens[i].contains('c')) {
        // 70
        digit = digit + 70;
        tokens[i] = tokens[i].replaceAll('a', '');
        tokens[i] = tokens[i].replaceAll('c', '');
      } else if (tokens[i].contains('a') && tokens[i].contains('f')) {
        // 50
        digit = digit + 50;
        tokens[i] = tokens[i].replaceAll('a', '');
        tokens[i] = tokens[i].replaceAll('f', '');
      } else if (tokens[i].contains('c')) {
        // 60
        digit = digit + 60;
        tokens[i] = tokens[i].replaceAll('c', '');
      } else if (tokens[i].contains('f')) {
        // 40
        digit = digit + 40;
        tokens[i] = tokens[i].replaceAll('f', '');
      } else if (tokens[i].contains('e')) {
        // 30
        digit = digit + 30;
        tokens[i] = tokens[i].replaceAll('e', '');
      } else if (tokens[i].contains('i')) {
        // 20
        digit = digit + 20;
        tokens[i] = tokens[i].replaceAll('i', '');
      } else if (tokens[i].contains('a')) {
        // 10
        digit = digit + 10;
        tokens[i] = tokens[i].replaceAll('a', '');
      }

      if (tokens[i] == '') unknownToken = false;
    }

    if (unknownToken)
      out = out + ' ' + UNKNOWN_ELEMENT;
    else
      out = out + ' ' + digit.toString();
  }

  return {'displays': displays, 'text': out};
}
