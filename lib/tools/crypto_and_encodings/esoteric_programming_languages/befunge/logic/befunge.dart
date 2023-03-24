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

const _BEFUNGE_ERROR_INVALID_PROGRAM = 'befunge_error_syntax_invalidprogram';
const _BEFUNGE_ERROR_NO_INPUT = 'befunge_error_no_input';
const _BEFUNGE_ERROR_INVALID_INPUT = 'befunge_error_invalid_input';
const BEFUNGE_ERROR_INFINITE_LOOP = 'befunge_error_infinite_loop';
const _BEFUNGE_ERROR_NULL_COMMAND = 'befunge_error_null_command';
const _BEFUNGE_ERROR_OUT_OF_BOUNDS_ACCESS = 'befunge_error_access_out_of_bounds';

const _BEFUNGE_EMPTY_LINE = '                                                                                ';

const MAX_LENGTH_PROGRAM = 80 * 25;
const _LINEWIDTH = 80;
const _PAGEHEIGHT = 25;
const _SCREENWIDTH = _LINEWIDTH - 1;
const _SCREENHEIGHT = _PAGEHEIGHT - 1;

const _MAX_ITERATIONS = 9999;
const _MAX_OUTPUT_LENGTH = 160;

class BefungeOutput {
  String Output = '';
  String Error = '';
  List<String> BefungeStack;
  List<String> PC;
  List<String> Command;
  List<String> Mnemonic;

  BefungeOutput({
    required this.Output,
    required this.Error,
    required this.BefungeStack,
    required this.PC,
    required this.Command,
    required this.Mnemonic});
}

class Stack {
  List<BigInt> content;

  void push(BigInt element) {
    content.add(element);
  }

  BigInt pop() {
    if (isEmpty()) {
      return BigInt.zero;
    } else {
      BigInt element = content[content.length - 1];
      content.removeAt(content.length - 1);
      return element;
    }
  }

  bool isEmpty() {
    return (content.isEmpty);
  }

  @override
  String toString() {
    return content.join(' ');
  }

  Stack(this.content);
}

int _x = 0;
int _y = 0;
List<BigInt> _pg = [];

int _iterations = 0;

List<String> _BefungeStack = [];
List<String> _PC = [];
List<String> _Command = [];
List<String> _Mnemonic = [];

String _cur() {
  BigInt opCode = _pg[_y * _LINEWIDTH + _x];
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
        Output: '', Error: '', BefungeStack: _BefungeStack, PC: _PC, Command: _Command, Mnemonic: _Mnemonic);
  }

  if (_correctBefungeProgramLength(program)) {
    Random random = Random();
    Stack stack = Stack([]);
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
            Output: STDOUT.join(''),
            Error: BEFUNGE_ERROR_INFINITE_LOOP,
            BefungeStack: _BefungeStack,
            PC: _PC,
            Command: _Command,
            Mnemonic: _Mnemonic);
      }

      if (_outOfBounds()) {
        _BefungeStack.add(stack.toString());
        return BefungeOutput(
            Output: STDOUT.join(''),
            Error: _BEFUNGE_ERROR_NULL_COMMAND,
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
                      Output: STDOUT.join(''),
                      Error: _BEFUNGE_ERROR_NO_INPUT,
                      BefungeStack: _BefungeStack,
                      PC: _PC,
                      Command: _Command,
                      Mnemonic: _Mnemonic);
                }

                if (int.tryParse(STDIN.last) == null) {
                  _BefungeStack.add(stack.toString());
                  return BefungeOutput(
                      Output: STDOUT.join(''),
                      Error: _BEFUNGE_ERROR_INVALID_INPUT,
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

            case '! ': //logical not
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
                    Output: STDOUT.join(''),
                    Error: _BEFUNGE_ERROR_NO_INPUT,
                    BefungeStack: _BefungeStack,
                    PC: _PC,
                    Command: _Command,
                    Mnemonic: _Mnemonic);
              }

              if (int.tryParse(STDIN.last) == null) {
                _BefungeStack.add(stack.toString());
                return BefungeOutput(
                    Output: STDOUT.join(''),
                    Error: _BEFUNGE_ERROR_INVALID_INPUT,
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
                    Output: STDOUT.join(''),
                    Error: _BEFUNGE_ERROR_NO_INPUT,
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
                    Output:
                        STDOUT.join('') + '\n\nget(' + x.toString().padLeft(2) + '|' + y.toString().padLeft(2) + ')',
                    Error: _BEFUNGE_ERROR_OUT_OF_BOUNDS_ACCESS,
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
                    Output:
                        STDOUT.join('') + '\n\nput(' + x.toString().padLeft(2) + '|' + y.toString().padLeft(2) + ')',
                    Error: _BEFUNGE_ERROR_OUT_OF_BOUNDS_ACCESS,
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
          } // switch cur
        }
      }

      _BefungeStack.add(stack.toString());

      _x = _x + dx;
      if (_x < 0) _x = _SCREENWIDTH;
      if (_x == _LINEWIDTH) _x = 0;
      _y = _y + dy;
      if (_y < 0) _y = _SCREENHEIGHT;
      if (_y == _PAGEHEIGHT) _y = 0;
      _iterations++;
    } // while

    return BefungeOutput(
        Output: STDOUT.join(''),
        Error: '',
        BefungeStack: _BefungeStack,
        PC: _PC,
        Command: _Command,
        Mnemonic: _Mnemonic);
  } else {
    return BefungeOutput(
        Output: '', Error: _BEFUNGE_ERROR_INVALID_PROGRAM, BefungeStack: [], PC: [], Command: [], Mnemonic: []);
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
    line.padRight(_LINEWIDTH, ' ').split('').forEach((element) {
      pg.add(BigInt.from(element.codeUnitAt(0)));
    });
  });

  while (pg.length < MAX_LENGTH_PROGRAM) {
    _BEFUNGE_EMPTY_LINE.split('').forEach((element) {
      pg.add(BigInt.from(element.codeUnitAt(0)));
    });
  }

  return pg;
}

bool _correctBefungeProgramLength(String program) {
  int i = 1;
  if (program.length > MAX_LENGTH_PROGRAM) {
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
      if (column % (_SCREENWIDTH - 1) == 0) {
        befungeLine = befungeLine + 'v';
        oddRow = !oddRow;
        befunge.add(befungeLine);
        befungeLine = '<';
      }
    } else {
      befungeLine = code[i] + befungeLine;
      column++;
      if (column % (_SCREENWIDTH - 1) == 0) {
        befungeLine = 'v' + befungeLine;
        oddRow = !oddRow;
        befunge.add(befungeLine);
        befungeLine = '>';
      }
    }
  }
  if (oddRow) {
    befungeLine = befungeLine.padRight(_LINEWIDTH, ' ');
  } else {
    befungeLine = befungeLine.padLeft(_LINEWIDTH, ' ');
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

const Map<int, String> _convertCharCode = {
// https://www.thepcmanwebsite.com/ascii-chart.shtml
// https://www.torsten-horn.de/techdocs/ascii.htm
// !“#$%&‘()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_‘abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ
// ‘’“”•–—˜™š›œžŸ/¡¢£¤¥¦§¨©ª«¬/®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øúúûüýþÿ
// “‘‘ƒ„                    …†‡   ˆ‰Š‹ŒŽ‘  ’“”•–—˜™š›
// does not work with the emulator €
  0: '0', // NUL
  1: '1', // SOH
  2: '2', // STX
  3: '3', // ETX
  4: '4', // EOT
  5: '5', // ENQ
  6: '6', // ACK
  7: '7', // BEL
  8: '8', // BS
  9: '9', // Horizontal TAB
  10: '52*', // LF
  11: '3:*2+', // Vertical TAB
  12: '34*', // FF
  13: '35*2-', // CR
  14: '72*', // SO
  15: '35*', // SI
  16: '4:*', // DLE
  17: '14:*+', // DC1
  18: '23:**', // DC2
  19: '123:**+', // DC3
  20: '4:*5*', // DC4
  21: '37*', // NAK
  22: '256+*', // SYN
  23: '57+2*1-', // ETB
  24: '2:*6*', // CAN
  25: '55*', // EM
  26: '155*+', // SUB
  27: '3::**', // ESC
  28: '355*+', // FS
  29: '23*5*1-', // GS
  30: '23*5*', // RS
  31: '4:*2*1-', // US
  32: '4:*2*', //  space
  33: '47+3*', // !
  34: '298+*', // “
  35: '57*', // #
  36: '94*4+', // $
  37: '6:*1+', // %
  38: '357*+', // &
  39: '376+*', // ‘
  40: '58*', // (
  41: '294+3*+', // )
  42: '67*', // *
  43: '358*+', // +
  44: '4:7+*', // ,
  45: '3:*5*', // -
  46: '24:7+*+', // .
  47: '23:*5*+', // /
  48: '86*', // 0
  49: '7:*', // 1
  50: '5:+5*', // 2
  51: '98+3*', // 3
  52: '94+2*2*', // 4
  53: '68*5+', // 5
  54: '69*', // 6
  55: '83+5*', // 7
  56: '87*', // 8
  57: '43*7+3*', // 9
  58: '287*+', // :
  59: '569*+', // ;
  60: '8:*4-', // <
  61: '37*3*2-', // =
  62: '8:*2-', // >
  63: '37*3*', // ?
  64: '8:*', // @
  65: '67+5*', // A
  66: '43*7+3*9+', // B
  67: '67+5*2+', // C
  68: '8:*4+', // D
  69: '64*1-3*', // E
  70: '75*2*', // F
  71: '64*1-3*2+', // G
  72: '38*3*', // H
  73: '375*2*+', // I
  74: '75*2*4+', // J
  75: '35:**', // K
  76: '47+7*1-', // L
  77: '7:4+*', // M
  78: '9:*3-', // N
  79: '35:**4+', // O
  80: '54:**', // P
  81: '9:*', // Q
  82: '254*4*+', // R
  83: '5:3**9+1-', // S
  84: '9535**+', // T
  85: '9:*4+', // U
  86: '672**2+', // V
  87: '23*9:*+', // W
  88: '83+8*', // X
  89: '653**1-', // Y
  90: '253:***', // Z
  91: '383+8*+', // [
  92: '653**1-3+', // \
  93: '35*9:*+3-', // ]
  94: '83+8*6+', // ^
  95: '6653**1-+', // _
  96: '35*9:*+', // ‘
  97: '253:***7+', // a
  98: '483+8*6++', // b
  99: '35*9:*+4+1-', // c
  100: '35*9:*+4+', // d
  101: '135*9:*+4++', // e
  102: '3:+5+25**8-', // f
  103: '335*9:*+4++', // g
  104: '3:+5+25**6-', // h
  105: '535*9:*+4++', // i
  106: '3:+5+25**4-', // j
  107: '735*9:*+4++', // k
  108: '3:+5+25**2-', // l
  109: '935*9:*+4++', // m
  110: '3:+5+25**', // n
  111: '13:+5+25**+', // o
  112: '62:**5*8-', // p
  113: '33:+5+25**+', // q
  114: '62:**5*6-', // r
  115: '53:+5+25**+', // s
  116: '62:**5*4-', // t
  117: '73:+5+25**+', // u
  118: '62:**5*2-', // v
  119: '93:+5+25**+', // w
  120: '62:**5*', // x
  121: '162:**5*+', // y
  122: '52*85+*8-', // z
  123: '362:**5*+', // {
  124: '52*85+*6-', // |
  125: '562:**5*+', // }
  126: '52*85+*4-', // ~
  127: '762:**5*+', // del
  128: '52*85+*2-', // €
  129: '962:**5*+', // 
  130: '52*85+*', // ‚
  131: '152*85+*+', // ƒ
  132: '2:7**5*8-', // „
  133: '352*85+*+', // …
  134: '2:7**5*6-', // †
  135: '552*85+*+', // ‡
  136: '2:7**5*5-', // ˆ
  137: '752*85+*+', // ‰
  138: '2:7**5*2-', // Š
  139: '952*85+*+', // ‹
  140: '2:7**5*', // Œ
  141: '12:7**5*+', // 
  142: '235:***8-', // Ž
  143: '32:7**5*+', // 
  144: '235:***6-', // 
  145: '52:7**5*+', // ‘
  146: '235:***4-', // ’
  147: '72:7**5*+', // “
  148: '235:***2-', // ”
  149: '92:7**5*+', // •
  150: '235:***', // –
  151: '4:*25**9-', // —
  152: '4:*25**8-', // ˜
  153: '4:*25**7-', // ™
  154: '4:*25**6-', // š
  155: '4:*25**5-', // ›
  156: '4:*25**4-', // œ
  157: '4:*25**3-', // 
  158: '4:*25**2-', // ž
  159: '4:*25**1-', // Ÿ
  160: '4:*25**', //
  161: '14:*25**+', // ¡
  162: '24:*25**+', // ¢
  163: '34:*25**+', // £
  164: '44:*25**+', // ¤
  165: '54:*25**+', // ¥
  166: '64:*25**+', // ¦
  167: '74:*25**+', // §
  168: '84:*25**+', // ¨
  169: '94:*25**+', // ©
  170: '94:*25**+25*+', // ª
  171: '2:3:**5**9-', // «
  172: '2:3:**5**8-', // ¬
  173: '2:3:**5**7-', //
  174: '2:3:**5**6-', // ®
  175: '2:3:**5**5-', // ¯
  176: '2:3:**5**4-', // °
  177: '2:3:**5**3-', // ±
  178: '2:3:**5**2-', // ²
  179: '2:3:**5**1-', // ³
  180: '2:3:**5**', // ´
  181: '12:3:**5**+', // µ
  182: '22:3:**5**+', // ¶
  183: '32:3:**5**+', // ·
  184: '42:3:**5**+', // ¸
  185: '52:3:**5**+', // ¹
  186: '62:3:**5**+', // º
  187: '72:3:**5**+', // »
  188: '82:3:**5**+', // ¼
  189: '92:3:**5**+', // ½
  190: '2:3:**5**25*+', // ¾
  191: '85:**9-', // ¿
  192: '85:**8-', // À
  193: '85:**7-', // Á
  194: '85:**6-', // Â
  195: '85:**5-', // Ã
  196: '85:**4-', // Ä
  197: '85:**3-', // Å
  198: '85:**2-', // Æ
  199: '85:**1-', // Ç
  200: '85:**', // È
  201: '185:**+', // É
  202: '85:**2+', // Ê
  203: '385:**+', // Ë
  204: '85:**4+', // Ì
  205: '585:**+', // Í
  206: '85:**6+', // Î
  207: '785:**+', // Ï
  208: '85:**8+', // Ð
  209: '985:**+', // Ñ
  210: '37*25**', // Ò
  211: '137*25**+', // Ó
  212: '56+4*5*8-', // Ô
  213: '37*25**3+', // Õ
  214: '56+4*5*6-', // Ö
  215: '537*25**+', // ×
  216: '56+4*5*4-', // Ø
  217: '37*25**7+', // Ù
  218: '56+4*5*2-', // Ú
  219: '937*25**+', // Û
  220: '56+4*5*', // Ü
  221: '56+4*5*1+', // Ý
  222: '29*5+52**8-', // Þ
  223: '356+4*5*+', // ß
  224: '29*5+52**6-', // à
  225: '56+4*5*5+', // á
  226: '29*5+52**4-', // â
  227: '756+4*5*+', // ã
  228: '29*5+52**2-', // ä
  229: '56+4*5*9+', // å
  230: '29*5+52**', // æ
  231: '129*5+52**+', // ç
  232: '38*25**8-', // è
  233: '329*5+52**+', // é
  234: '38*25**6-', // ê
  235: '529*5+52**+', // ë
  236: '38*25**4-', // ì
  237: '729*5+52**+', // í
  238: '38*25**2-', // î
  239: '929*5+52**+', // ï
  240: '38*25**', // ð
  241: '55*5*2*9-', // ñ
  242: '238*25**+', // ò
  243: '55*5*2*7-', // ó
  244: '38*25**4+', // ô
  245: '55*5*2*5-', // õ
  246: '638*25**+', // ö
  247: '55*5*2*3-', // ÷
  248: '38*25**8+', // ø
  249: '55*5*2*1-', // ú
  250: '55*5*2*', // ú
  251: '155*5*2*+', // û
  252: '55*5*2*2+', // ü
  253: '355*5*2*+', // ý
  254: '55*5*2*4+', // þ
  255: '2:::::::*******1-', // ÿ
};
