// Ressources
//   https://github.com/catseye/Befunge-93
//   https://de.wikipedia.org/wiki/Befunge
//   https://en.wikipedia.org/wiki/Befunge
//
// Online Interpreter
//   https://www.bedroomlan.org/tools/befunge-playground/#prog=hello,mode=run
//   https://www.tutorialspoint.com/compile_befunge_online.php
//   http://qiao.github.io/javascript-playground/visual-befunge93-interpreter/
//   https://befunge.flogisoft.com/
//   http://www.quirkster.com/iano/js/befunge.html
//
// Reference Implementation
//   https://github.com/catseye/Befunge-93/blob/master/src/bef.c
//   http://www.quirkster.com/iano/js/befunge.js

import 'dart:math';

import 'package:flutter/material.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge_classes.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge_const.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge_data.dart';

int _x = 0;
int _y = 0;
List<BigInt> _pg = [];

int _iterations = 0;

List<String> _BefungeStack = [];
List<String> _PC = [];
List<String> _Command = [];
List<String> _Mnemonic = [];

String _cur() {
  BigInt opCode = _pg[_y * _SCREENWIDTH + _x];
  if (BigInt.zero < opCode && opCode < BigInt.from(256)) {
    return String.fromCharCode(opCode.toInt());
  } else {
    return opCode.toString();
  }
}

void _addDebugInformation(bool stringMode) {
  _PC.add('(' + _y.toString().padLeft(2) + '|' + _x.toString().padLeft(2) + ')');
  _Command.add(_cur());

  if ((_cur() == '"' || _cur() == '”')) {
    _Mnemonic.add('stringmode');
  } else if (stringMode) {
    _Mnemonic.add('push ' + _cur().codeUnitAt(0).toString());
  }
}

bool _isDigit(String char) {
  return [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ].contains(char);
}

BefungeOutput interpretBefunge(String program, {String input = ''}) {
  if (program.isEmpty) {
    return BefungeOutput(
        Output: '',
        Error: '',
        Iteration: '',
        curPosX: '',
        curPosY: '',
        BefungeStack: _BefungeStack,
        PC: _PC,
        Command: _Command,
        Mnemonic: _Mnemonic);
  }

  if (_correctBefungeProgramLength(program)) {
    Random random = Random();
    BefungeStack stack = BefungeStack([]);
    int dx = 1;
    int dy = 0;
    BigInt a;
    BigInt b;
    BigInt x;
    BigInt y;
    BigInt value;
    List<String> STDIN = input.split(' ');
    List<String> STDOUT = [];

    bool stringMode = false;
    bool endOfProgram = false;

    _pg = _fillProgram(program);
    _x = 0;
    _y = 0;
    _iterations = 0;

    _BefungeStack = [];
    _PC = [];
    _Command = [];
    _Mnemonic = [];

    while (!endOfProgram) {
      if (_infiniteLoop()) {
        _BefungeStack.add(stack.toString());
        return BefungeOutput(
            Output: STDOUT.join('').trim(),
            Error: _BEFUNGE_ERROR_INFINITE_LOOP,
            Iteration: _iterations.toString(),
            curPosX: _x.toString(),
            curPosY: _y.toString(),
            BefungeStack: _BefungeStack,
            PC: _PC,
            Command: _Command,
            Mnemonic: _Mnemonic);
      }

      if (_outOfBounds()) {
        _BefungeStack.add(stack.toString());
        return BefungeOutput(
            Output: STDOUT.join('').trim(),
            Error: _BEFUNGE_ERROR_NULL_COMMAND,
            Iteration: _iterations.toString(),
            curPosX: _x.toString(),
            curPosY: _y.toString(),
            BefungeStack: _BefungeStack,
            PC: _PC,
            Command: _Command,
            Mnemonic: _Mnemonic);
      }

      _addDebugInformation(stringMode);

      if (stringMode) {
        if (_cur() == '"' || _cur() == '”') {
          stringMode = false;
        } else {
          stack.push(BigInt.from(_cur().codeUnitAt(0)));
        }
      } else {
        if (_isDigit(_cur())) {
          stack.push(BigInt.from(int.parse(_cur())));
          _Mnemonic.add('push ' + _cur());
        } else {
          switch (_cur()) {
            case '@':
              endOfProgram = true;
              _Mnemonic.add('end');
              break;

            case '>': // move right
              dx = 1;
              dy = 0;
              _Mnemonic.add('move right');
              break;

            case '<': // move left
              dx = -1;
              dy = 0;
              _Mnemonic.add('move left');
              break;

            case '^': // move up
              dx = 0;
              dy = -1;
              _Mnemonic.add('move up');
              break;

            case 'v': // move down
              dx = 0;
              dy = 1;
              _Mnemonic.add('move down');
              break;

            case '_': // branch horizontal
              dy = 0;
              a = stack.pop();
              if (a == BigInt.zero) {
                dx = 1; // move right
                _Mnemonic.add('branch right');
              } else {
                dx = -1; // move left
                _Mnemonic.add('branch left');
              }
              break;

            case '|': // branch vertical
              dx = 0;
              a = stack.pop();
              if (a == BigInt.zero) {
                dy = 1; // move down
                _Mnemonic.add('branch down');
              } else {
                dy = -1; // move up
                _Mnemonic.add('branch up');
              }
              break;

            case '+': // add
              a = stack.pop();
              b = stack.pop();
              stack.push(a + b);
              _Mnemonic.add('add ' + a.toString() + ', ' + b.toString());
              break;

            case '-': // sub
              a = stack.pop();
              b = stack.pop();
              stack.push(b - a);
              _Mnemonic.add('sub ' + b.toString() + ', ' + a.toString());
              break;

            case '*': // mult
              a = stack.pop();
              b = stack.pop();
              stack.push(a * b);
              _Mnemonic.add('mult ' + a.toString() + ', ' + b.toString());
              break;

            case '/': // integer division
              a = stack.pop();
              b = stack.pop();
              if (a == BigInt.zero) {
                if (STDIN.isEmpty) {
                  _BefungeStack.add(stack.toString());
                  return BefungeOutput(
                      Output: STDOUT.join('').trim(),
                      Error: _BEFUNGE_ERROR_NO_INPUT,
                      Iteration: _iterations.toString(),
                      curPosX: _x.toString(),
                      curPosY: _y.toString(),
                      BefungeStack: _BefungeStack,
                      PC: _PC,
                      Command: _Command,
                      Mnemonic: _Mnemonic);
                }

                if (int.tryParse(STDIN.last) == null) {
                  _BefungeStack.add(stack.toString());
                  return BefungeOutput(
                      Output: STDOUT.join('').trim(),
                      Error: _BEFUNGE_ERROR_INVALID_INPUT,
                      Iteration: _iterations.toString(),
                      curPosX: _x.toString(),
                      curPosY: _y.toString(),
                      BefungeStack: _BefungeStack,
                      PC: _PC,
                      Command: _Command,
                      Mnemonic: _Mnemonic);
                }

                a = BigInt.from(int.parse(STDIN.last));
              }

              stack.push(b ~/ a);
              _Mnemonic.add('div ' + b.toString() + ', ' + a.toString());
              break;

            case '%': // modulo
              a = stack.pop();
              b = stack.pop();
              stack.push(b % a);
              _Mnemonic.add('mod ' + b.toString() + ', ' + a.toString());
              break;

            case '\\': // swap
              a = stack.pop();
              b = stack.pop();
              stack.push(a);
              stack.push(b);
              _Mnemonic.add('swap ' + a.toString() + ', ' + b.toString());
              break;

            case '.': // output decimal
              a = stack.pop();
              STDOUT.add(a.toString());
              STDOUT.add(' ');
              _Mnemonic.add('out int ' + a.toString());
              break;

            case ',': // output char
              a = stack.pop();
              STDOUT.add(String.fromCharCode(a.toInt()));
              _Mnemonic.add('out char ' + String.fromCharCode(a.toInt()));
              break;

            case '"': // string mode on/off
            case '”':
              stringMode = !stringMode;
              _Mnemonic.add('stringmode');
              break;

            case ':': // dublication
              a = stack.pop();
              stack.push(a);
              stack.push(a);
              _Mnemonic.add('dublicate ' + a.toString());
              break;

            case '!': //logical not
              a = stack.pop();
              if (a == BigInt.zero) {
                stack.push(BigInt.one);
              } else {
                stack.push(BigInt.zero);
              }
              _Mnemonic.add('not ' + a.toString());
              break;

            case '#': // skip - do nothing
              _x = _x + dx;
              _y = _y + dy;
              _Mnemonic.add('skip');
              break;

            case '\$': // pop and discard
              stack.pop();
              _Mnemonic.add('discard');
              break;

            case '?': // move random
              switch (random.nextInt(3)) {
                case 0:
                  dx = 1;
                  dy = 0;
                  break;
                case 1:
                  dx = -1;
                  dy = 0;
                  break;
                case 2:
                  dx = 0;
                  dy = -1;
                  break;
                case 3:
                  dx = 0;
                  dy = 1;
                  break;
              }
              _Mnemonic.add('move random');
              break;

            case '&': // input decimal
              if (STDIN.isEmpty || STDIN.join('').isEmpty) {
                _BefungeStack.add(stack.toString());
                return BefungeOutput(
                    Output: STDOUT.join('').trim(),
                    Error: _BEFUNGE_ERROR_NO_INPUT,
                    Iteration: _iterations.toString(),
                    curPosX: _x.toString(),
                    curPosY: _y.toString(),
                    BefungeStack: _BefungeStack,
                    PC: _PC,
                    Command: _Command,
                    Mnemonic: _Mnemonic);
              }

              if (int.tryParse(STDIN.last) == null) {
                _BefungeStack.add(stack.toString());
                return BefungeOutput(
                    Output: STDOUT.join('').trim(),
                    Error: _BEFUNGE_ERROR_INVALID_INPUT,
                    Iteration: _iterations.toString(),
                    curPosX: _x.toString(),
                    curPosY: _y.toString(),
                    BefungeStack: _BefungeStack,
                    PC: _PC,
                    Command: _Command,
                    Mnemonic: _Mnemonic);
              }

              stack.push(BigInt.from(int.parse(STDIN.last)));
              STDIN.removeLast();
              _Mnemonic.add('input int');
              break;

            case '~': // input char
              if (STDIN.isEmpty || STDIN.join('').isEmpty) {
                _BefungeStack.add(stack.toString());
                return BefungeOutput(
                    Output: STDOUT.join('').trim(),
                    Error: _BEFUNGE_ERROR_NO_INPUT,
                    Iteration: _iterations.toString(),
                    curPosX: _x.toString(),
                    curPosY: _y.toString(),
                    BefungeStack: _BefungeStack,
                    PC: _PC,
                    Command: _Command,
                    Mnemonic: _Mnemonic);
              }
              stack.push(BigInt.from(STDIN.last[0].codeUnitAt(0)));
              _Mnemonic.add('input char');
              break;

            case 'g': // self modify - get value from memory/torus and push to stack
              y = stack.pop();
              x = stack.pop();
              _Mnemonic.add('get ' '[' + x.toString().padLeft(2) + '|' + y.toString().padLeft(2) + ']');

              if (_outOfBoundsAccess(x: x, y: y)) {
                _BefungeStack.add(stack.toString());
                return BefungeOutput(
                    Output: STDOUT.join('').trim() +
                        '\n\nget(' +
                        x.toString().padLeft(2) +
                        '|' +
                        y.toString().padLeft(2) +
                        ')',
                    Error: _BEFUNGE_ERROR_OUT_OF_BOUNDS_ACCESS,
                    Iteration: _iterations.toString(),
                    curPosX: _x.toString(),
                    curPosY: _y.toString(),
                    BefungeStack: _BefungeStack,
                    PC: _PC,
                    Command: _Command,
                    Mnemonic: _Mnemonic);
              } else {
                stack.push(_pg[y.toInt() * _SCREENWIDTH + x.toInt()]);
              }
              break;

            case 'p': // self modify - put value from stack into memory/torus
              y = stack.pop();
              x = stack.pop();
              value = stack.pop();
              _Mnemonic.add('put ' +
                  value.toString() +
                  ' → ' +
                  '[' +
                  x.toString().padLeft(2) +
                  '|' +
                  y.toString().padLeft(2) +
                  ']');

              if (_outOfBoundsAccess(x: x, y: y)) {
                _BefungeStack.add(stack.toString());
                return BefungeOutput(
                    Output: STDOUT.join('').trim() +
                        '\n\nput(' +
                        x.toString().padLeft(2) +
                        '|' +
                        y.toString().padLeft(2) +
                        ')',
                    Error: _BEFUNGE_ERROR_OUT_OF_BOUNDS_ACCESS,
                    Iteration: _iterations.toString(),
                    curPosX: _x.toString(),
                    curPosY: _y.toString(),
                    BefungeStack: _BefungeStack,
                    PC: _PC,
                    Command: _Command,
                    Mnemonic: _Mnemonic);
              } else {
                _put(x: x, y: y, value: value);
              }
              break;

            case ' ':
              _Mnemonic.add('nop');
              break;

            case '\'': // greater than
            case '`':
              a = stack.pop();
              b = stack.pop();
              if (b > a) {
                stack.push(BigInt.one);
              } else {
                stack.push(BigInt.zero);
              }
              _Mnemonic.add('greater than');
              break;

            default:
              return BefungeOutput(
                  Output: '',
                  Error: _BEFUNGE_ERROR_INVALID_COMMAND,
                  Iteration: _iterations.toString(),
                  curPosX: _x.toString(),
                  curPosY: _y.toString(),
                  BefungeStack: [],
                  PC: [],
                  Command: [],
                  Mnemonic: []);
          } // switch cur
        }
      }

      _BefungeStack.add(stack.toString());

      _calculateNewX(dx);
      _calculateNewY(dy);
      _iterations++;
    } // while

    return BefungeOutput(
        Output: STDOUT.join('').trim(),
        Error: '',
        Iteration: '',
        curPosX: '',
        curPosY: '',
        BefungeStack: _BefungeStack,
        PC: _PC,
        Command: _Command,
        Mnemonic: _Mnemonic);
  } else {
    return BefungeOutput(
        Output: '',
        Error: _BEFUNGE_ERROR_INVALID_PROGRAM,
        Iteration: '',
        curPosX: '',
        curPosY: '',
        BefungeStack: [],
        PC: [],
        Command: [],
        Mnemonic: []);
  }
}

void _calculateNewX(int dx) {
  _x = _x + dx;
  if (_x < 0) {
    _x = _SCREENWIDTH - 1;
  } else {
    if (_x == _SCREENWIDTH) _x = 0;
  }
}

void _calculateNewY(int dy) {
  _y = _y + dy;
  if (_y < 0) {
    _y = _SCREENHEIGHT - 1;
  } else {
    if (_y == _SCREENHEIGHT) _y = 0;
  }
}

bool _infiniteLoop() {
  return (_iterations > _MAX_ITERATIONS);
}

bool _outOfBounds() {
  return (_y > _SCREENHEIGHT || _x > _SCREENWIDTH);
}

bool _outOfBoundsAccess({required BigInt y, required BigInt x}) {
  return (y > BigInt.from(_SCREENHEIGHT) || y < BigInt.zero || x > BigInt.from(_SCREENWIDTH) || x < BigInt.zero);
}

void _put({required BigInt y, required BigInt x, required BigInt value}) {
  _pg[y.toInt() * _SCREENWIDTH + x.toInt()] = value;
}

List<BigInt> _fillProgram(String program) {
  List<BigInt> pg = [];

  program.split('\n').forEach((line) {
    line.padRight(_SCREENWIDTH, ' ').split('').forEach((element) {
      pg.add(BigInt.from(element.codeUnitAt(0)));
    });
  });

  while (pg.length < BEFUNGE_MAX_LENGTH_PROGRAM) {
    _BEFUNGE_EMPTY_LINE.split('').forEach((element) {
      pg.add(BigInt.from(element.codeUnitAt(0)));
    });
  }

  return pg;
}

bool _correctBefungeProgramLength(String program) {
  int i = 1;
  if (program.length > BEFUNGE_MAX_LENGTH_PROGRAM) {
    return false;
  } else {
    for (String line in program.split('\n')) {
      if (line.length > _SCREENWIDTH) return false;
    }
    i++;
  }
  if (i > _SCREENHEIGHT) return false;
  return true;
}

String generateBefunge(String OutputText) {
  if (OutputText.isEmpty) return '';

  String code = '';

  if (OutputText.length > _MAX_OUTPUT_LENGTH) return _BEFUNGE_ERROR_INVALID_PROGRAM;

  OutputText.split('').reversed.toList().forEach((char) {
    if (char.codeUnitAt(0) < 256 && _convertCharCode[char.codeUnitAt(0)] != null) {
      code = code + (_convertCharCode[char.codeUnitAt(0)] ?? '');
    }
  });

  code = code + 'v';

  // refactor program into the correct pg format - 80x25 torus
  int column = 0;
  String befungeLine = '>';
  List<String> befunge = [];
  bool oddRow = true;
  for (int i = 0; i < code.length; i++) {
    if (oddRow) {
      befungeLine = befungeLine + code[i];
      column++;
      if (column % (_SCREENWIDTH - 2) == 0) {
        befungeLine = befungeLine + 'v';
        oddRow = !oddRow;
        befunge.add(befungeLine);
        befungeLine = '<';
      }
    } else {
      befungeLine = code[i] + befungeLine;
      column++;
      if (column % (_SCREENWIDTH - 2) == 0) {
        befungeLine = 'v' + befungeLine;
        oddRow = !oddRow;
        befunge.add(befungeLine);
        befungeLine = '>';
      }
    }
  }
  if (oddRow) {
    befungeLine = befungeLine.padRight(_SCREENWIDTH, ' ');
  } else {
    befungeLine = befungeLine.padLeft(_SCREENWIDTH, ' ');
  }
  befunge.add(befungeLine);

  // add loop for output
  String digitHundred = OutputText.length.toString().padLeft(3, '0')[0];
  String digitTen = OutputText.length.toString().padLeft(3, '0')[1];
  String digitOne = OutputText.length.toString().padLeft(3, '0')[2];
  int spaces = befungeLine.indexOf('v');
  String loopLine = 'v';
  loopLine = loopLine.padRight(spaces, ' ');
  loopLine = loopLine + '>';
  befunge.add(loopLine);
  befunge.add('>52*52**' + digitHundred + '*52*' + digitTen + '*' + digitOne + '++1+>1-:v');
  befunge.add('                    ^,\u005C _@');

  return befunge.join('\n');
}
