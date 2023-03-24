// http://cliffle.com/esoterica/beatnik/
// https://en.wikipedia.org/wiki/Beatnik_(programming_language)#:~:text=Beatnik%20is%20a%20simple%20stack-oriented%20esoteric%20programming%20language,,of%20the%20score%20determines%20what%20function%20is%20performed.
// https://esolangs.org/wiki/beatnik
// Interpreter inspired by
// - http://search.cpan.org/~beatnik/Acme-Beatnik-0.02/Beatnik.pm
// - https://github.com/catseye/Beatnik

import 'dart:math';

import 'package:gc_wizard/tools/games/scrabble/scrabble/logic/scrabble.dart';

class BeatnikOutput {
  final List<String> output;
  final List<String> scrabble;
  final List<String> assembler;
  final List<String> mnemonic;
  final List<DebugOutput> debug;

  BeatnikOutput(this.output, this.scrabble, this.assembler, this.mnemonic, this.debug);
}

class DebugOutput {
  final String pc;
  final String command;
  final String stack;
  final String output;

  DebugOutput(this.pc, this.command, this.stack, this.output);
}

BeatnikOutput generateBeatnik(var ScrabbleVersion, String output) {
  var random = Random();
  int number = 0;
  int h = 0;
  int r = 0;
  int add = 0;
  List<int> assembler = <int>[];

  // reverse input - because we have to use a stack
  output = output.split('').reversed.join('');

  // get chars and put them on the stack
  for (int i = 0; i < output.length; i++) {
    number = output[i].codeUnitAt(0);
    assembler.add(5);
    if (number <= 23) {
      assembler.add(number);
    } else {
      // scrabble word > 23 are a challenge - so split them
      add = 0;
      while (number > 23) {
        // get a number by random in the ranges 1-20 (66%) 21-30 (24%) 31-40 (10%)
        r = random.nextInt(100) + 1;
        if (r > 90) {
          h = random.nextInt(10) + 31;
        } else if (r > 66) {
          h = random.nextInt(10) + 21;
        } else {
          h = random.nextInt(20) + 1;
        }
        if (h < number) {
          assembler.add(h);
          add++;
          number = number - h;
          if (add == 2) {
            assembler.add(7);
            add = 1;
          }
          if (number > 23) {
            assembler.add(5);
          }
        }
      } // while
      assembler.add(5);
      assembler.add(number);
      assembler.add(7);
    }
  }
  // add opCodes for output
  for (int i = 0; i < output.length; i++) {
    assembler.add(9);
  }
  // add opCode for halt
  assembler.add(17);

  List<String> assemblerProgramm = <String>[];
  List<String> mnemonicProgramm = <String>[];
  for (int i = 0; i < assembler.length; i++) {
    if (assembler[i] == 5 || assembler[i] == 13 || assembler[i] == 14 || assembler[i] == 15 || assembler[i] == 16) {
      assemblerProgramm.add(assembler[i].toString() + ' ' + assembler[i + 1].toString());
      mnemonicProgramm.add(_mnemonic(assembler[i]) + ' ' + assembler[i + 1].toString());
      i++;
    } else {
      assemblerProgramm.add(assembler[i].toString());
      mnemonicProgramm.add(_mnemonic(assembler[i]));
    }
  }

  return BeatnikOutput([assemblerProgramm.join(' ')], [''], assemblerProgramm, mnemonicProgramm, []);
}

class _BeatnikStack {
  final _stack =<int>[];

  _BeatnikStack();

  void push(int? c) {
    if (c != null) _stack.add(c);
  }

  int peek() {
    var c = _stack[_stack.length - 1];
    return c;
  }

  int pop() {
    if (_stack.isNotEmpty) {
      var c = _stack.removeAt(_stack.length - 1);
      return c;
    }
    throw const FormatException('common_programming_error_invalid_opcode');
  }

  int size() {
    return _stack.length;
  }

  void add() {
    var a = pop();
    var b = pop();

    push(a + b);
  }

  void sub() {
    var a = pop();
    var b = pop();

    push(b - a);
  }

  void swap() {
    var a = pop();
    var b = pop();

    push(a);
    push(b);
  }

  void double() {
    var a = pop();

    push(a);
    push(a);
  }

  String getContent() {
    return '[' + _stack.join(', ') + ']';
  }
}

final mnemonicTable = {
  0: 'noop',
  1: 'noop',
  2: 'noop',
  3: 'noop',
  4: 'noop',
  5: 'push',
  6: 'pop',
  7: 'add',
  8: 'input',
  9: 'output',
  10: 'sub',
  11: 'swap',
  12: 'double',
  13: 'jmpz+',
  14: 'jmpnz+',
  15: 'jmpz-',
  16: 'jmpnz-',
  17: 'exit',
  18: 'noop',
  19: 'noop',
  20: 'noop',
  21: 'noop',
  22: 'noop',
  23: 'noop'
};

String _mnemonic(int command) {
  if (command >= 5 && command <= 17) {
    return mnemonicTable[command]!;
  } else {
    return ' ';
  }
}

String _formatNumber(int number) {
  if (number < 10) {
    return '  ' + number.toString();
  } else if (number < 100) {
    return ' ' + number.toString();
  } else {
    return number.toString();
  }
}

bool _checkNormalize(List<String> instructions) {
  bool result = true;
  for (int i = 0; i < instructions.length; i++) {
    if (int.tryParse(instructions[i]) == null) {
      result = false;
      i = instructions.length;
    }
  }
  return result;
}

BeatnikOutput interpretBeatnik(String ScrabbleVersion, String sourcecode, String input) {
  if (sourcecode.isEmpty) {
    return BeatnikOutput([''], [''], [''], [''], [DebugOutput('', '', '', '')]);
  }

  var _currentValues = <int>[];
  int value = 0;

  List<int> assembler = <int>[];
  List<String> scrabbleProgram = <String>[];
  bool normalized = _checkNormalize(sourcecode.split(' '));
  List<String> program = <String>[];

  if (normalized) {
    program = sourcecode.split(' ');
  } else {
    program = sourcecode
        .toUpperCase()
        .replaceAll(RegExp(r'(\s|\n|\t|\f\|\r)'), '#')
        .replaceAll(RegExp(r'[^A-ZÄÖÜ]'), '#')
        .replaceAll(RegExp(r'#+'), '#')
        .split('#');
  }

  for (int i = 0; i < program.length; i++) {
    if (!normalized) {
      _currentValues = scrabbleTextToLetterValues(program[i], ScrabbleVersion);
      value = 0;
      for (int j = 0; j < _currentValues.length; j++) {
        value = value + _currentValues[j];
      }
    } else {
      value = int.tryParse(program[i]) ?? 0;
    }
    if (value > 0) {
      assembler.add(value);
      scrabbleProgram.add(_formatNumber(value) + ' ' + program[i]);
    }
  }

  List<DebugOutput> debugProgram = <DebugOutput>[];
  List<String> assemblerProgram = <String>[];
  List<String> mnemonicProgram = <String>[];
  String space = '';
  String output = '';
  bool exit = false;
  int pc = 0;
  int inputindex = 0;
  List<String> inputlist = input.split('');
  _BeatnikStack stack = _BeatnikStack();

  try {
    for (int i = 0; i < assembler.length; i++) {
      if (assembler[i] < 10) {
        space = ' ';
      } else {
        space = '';
      }
      if (assembler[i] == 5 || assembler[i] == 13 || assembler[i] == 14 || assembler[i] == 15 || assembler[i] == 16) {
        assemblerProgram.add(space + assembler[i].toString() + ' ' + assembler[i + 1].toString());
        mnemonicProgram.add(_mnemonic(assembler[i]) + ' ' + assembler[i + 1].toString());
        i++;
      } else {
        assemblerProgram.add(space + assembler[i].toString());
        mnemonicProgram.add(_mnemonic(assembler[i]));
      }
    }

    while (!exit && pc < assembler.length) {
      if (assembler[pc] == 5 ||
          assembler[pc] == 13 ||
          assembler[pc] == 14 ||
          assembler[pc] == 15 ||
          assembler[pc] == 16) {
        debugProgram.add(DebugOutput(pc.toString(), _mnemonic(assembler[pc]) + ' ' + _formatNumber(assembler[pc + 1]),
            stack.getContent(), output));
      } else {
        debugProgram.add(DebugOutput(pc.toString(), _mnemonic(assembler[pc]), stack.getContent(), output));
      }
      switch (assembler[pc]) {
        case 5: // push n
          if (pc + 1 < assembler.length - 1) {
            pc++;
            stack.push(assembler[pc]);
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_pc',
              'beatnik_error_runtime_push',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 6: // pop
          if (stack.size() >= 1) {
            stack.pop();
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_pop',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 7: // add
          if (stack.size() >= 2) {
            stack.add();
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_add',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 8: // push input
          if (inputindex < inputlist.length) {
            stack.push(inputlist[inputindex].codeUnitAt(0));
            inputindex++;
          } else {
            return BeatnikOutput(
                ['common_programming_error_runtime', 'common_programming_error_no_input', 'Step ' + pc.toString()],
                scrabbleProgram,
                assemblerProgram,
                mnemonicProgram,
                debugProgram);
          }
          break;
        case 9: // pop output
          if (stack.size() >= 1) {
            output = output + String.fromCharCode(stack.pop());
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_pop_output',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 10: // sub
          if (stack.size() >= 2) {
            stack.sub();
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_sub',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 11: //swap
          if (stack.size() >= 2) {
            stack.swap();
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_swap',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 12: //double
          if (stack.size() >= 1) {
            stack.double();
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_double',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 13: // jump z +
          if (stack.size() >= 1) {
            if (stack.pop() == 0) {
              if (pc + 1 <= assembler.length - 1) {
                pc++;
                pc = pc + assembler[pc];
              } else {
                return BeatnikOutput([
                  'common_programming_error_runtime',
                  'beatnik_error_runtime_pc',
                  'beatnik_error_runtime_jmpz_f',
                  'Step ' + pc.toString()
                ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
              }
            } else {
              pc++;
            }
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_jmpz_f',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 14: // jump nz +
          if (stack.size() >= 1) {
            if (stack.pop() != 0) {
              if (pc + 1 <= assembler.length - 1) {
                pc++;
                pc = pc + assembler[pc];
              } else {
                return BeatnikOutput([
                  'common_programming_error_runtime',
                  'beatnik_error_runtime_pc',
                  'beatnik_error_runtime_jmpnz_f',
                  'Step ' + pc.toString()
                ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
              }
            } else {
              pc++;
            }
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_jmpnz_f',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 15: // jump z -
          if (stack.size() >= 1) {
            if (stack.pop() == 0) {
              if (pc + 1 <= assembler.length - 1) {
                pc = pc - assembler[pc + 1];
              } else {
                return BeatnikOutput([
                  'common_programming_error_runtime',
                  'beatnik_error_runtime_pc',
                  'beatnik_error_runtime_jmpz_b',
                  'Step ' + pc.toString()
                ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
              }
            } else {
              pc++;
            }
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_jmpz_b',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 16: // jump nz -
          if (stack.size() >= 1) {
            if (stack.pop() != 0) {
              if (pc + 1 <= assembler.length - 1) {
                pc = pc - assembler[pc + 1];
              } else {
                return BeatnikOutput([
                  'common_programming_error_runtime',
                  'beatnik_error_runtime_pc' 'beatnik_error_runtime_jmpnz_b',
                  'Step ' + pc.toString()
                ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
              }
            } else {
              pc++;
            }
          } else {
            return BeatnikOutput([
              'common_programming_error_runtime',
              'beatnik_error_runtime_stack',
              'beatnik_error_runtime_jmpnz_b',
              'Step ' + pc.toString()
            ], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
          }
          break;
        case 17: // exit
          exit = true;
          break;
      }
      pc++;
      if (pc < 0) {
        return BeatnikOutput(['common_programming_error_runtime', 'beatnik_error_runtime_pc', 'Step ' + pc.toString()],
            scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
      }
    }
    return BeatnikOutput([output], scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
  } catch (e) {
    return BeatnikOutput(['common_programming_error_runtime', 'beatnik_error_runtime_pc', 'Step ' + pc.toString()],
        scrabbleProgram, assemblerProgram, mnemonicProgram, debugProgram);
  }
}
