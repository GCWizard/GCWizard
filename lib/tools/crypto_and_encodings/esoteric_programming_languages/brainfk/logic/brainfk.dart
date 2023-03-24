import 'dart:math';

const _ERROR_BRAINFK_LOOPNOTCLOSED = 'common_programming_error_loopnotclosed';
const _ERROR_BRAINFK_LOOPNOTOPENED = 'common_programming_error_loopnotopened';

const _MAX_MEMORY = 32768;

String interpretBrainfk(String code, {String? input}) {
  if (code.isEmpty) return '';

  var instructions = code.split('');

  var pointer = 0;
  var data = List<int>.generate(_MAX_MEMORY, (index) => 0);
  var out = '';

  var inputPointer = 0;

  List<int> loopStack = [];

  int i = 0;
  while (i < instructions.length) {
    switch (instructions[i]) {
      case '>':
        pointer++;
        if (pointer >= data.length) pointer = 0;
        break;
      case '<':
        pointer--;
        if (pointer < 0) {
          pointer = data.length - 1;
        }
        break;
      case '+':
        data[pointer] = (data[pointer] + 1) % 256;
        break;
      case '-':
        data[pointer] = (data[pointer] - 1 + 256) % 256;
        break;
      case '.':
        out += String.fromCharCode(data[pointer]);
        break;
      case ',':
        if (input == null || inputPointer >= input.length) return out;

        data[pointer] = input.codeUnitAt(inputPointer++);
        break;
      case '[':
        if (data[pointer] == 0) {
          var nestedLoopCount = 1;
          while (nestedLoopCount > 0) {
            i++;
            if (i >= instructions.length) throw const FormatException(_ERROR_BRAINFK_LOOPNOTCLOSED);

            switch (instructions[i]) {
              case '[':
                nestedLoopCount++;
                break;
              case ']':
                nestedLoopCount--;
                break;
            }
          }

          i++;
          continue;
        } else {
          loopStack.add(i);
        }
        break;
      case ']':
        if (loopStack.isEmpty) throw const FormatException(_ERROR_BRAINFK_LOOPNOTOPENED);

        i = loopStack.removeLast();
        continue;
    }

    i++;
  }

  return out.replaceAll('\x00', '');
}

// Dart port/fork of https://github.com/anars/BrainJuck/blob/master/source/com/anars/brainjuck/Generator.java
/*
 * BrainJuck - Rapid Application Development with only 3 bits!
 *
 * Generator - Brainf**k Code Generator
 *
 * Copyright (c) 2016 Anar Software LLC. < http://anars.com >
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see < http://www.gnu.org/licenses/ >
 *
 */
String generateBrainfk(String text) {
  var output = '';
  int prevCharacter = 0;
  for (int i = 0; i < text.length; i++) {
    int character = 0xFF & text.codeUnitAt(i);
    int difference = prevCharacter - character;

    String instruction = (difference < 0 ? '+' : '-');
    difference = difference.abs();

    if (difference > 0 && difference < 8) {
      output += instruction * difference;
    } else if (difference >= 8) {
      int loopCount = sqrt(difference).floor();
      int multiplier = loopCount;

      while (loopCount * (multiplier + 1) <= difference) {
        multiplier++;
      }

      int remainder = difference - (loopCount * multiplier);

      output += '>';
      output += '+' * loopCount;
      output += '[';
      output += '<';
      output += instruction * multiplier;
      output += '>';
      output += '-';
      output += ']';
      output += '<';

      if (remainder > 0) {
        output += instruction * remainder;
      }
    }

    output += '.';
    prevCharacter = character;
  }

  return output;
}
