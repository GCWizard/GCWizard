// http://www.lscheffer.com/malbolge_spec.html
// http://www.lscheffer.com/malbolge_interp.html
//
// Generator for text printing Malbolge programs.
// 2012, 2015 Matthias Ernst.
// Please visit <http://www.matthias-ernst.eu/malbolge.html>
//
// To the extent possible under law, the author has dedicated all copyright
// and related and neighboring rights to this software to the public domain
// worldwide. This software is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/>.

class malbolgeOutput {
  final List<String> output;
  final List<String> assembler;
  final List<String> mnemonic;

  malbolgeOutput(this.output, this.assembler, this.mnemonic);
}

const _xlat1 = "+b(29e*j1VMEKLyC})8&m#~W>qxdRp0wkrUo[D7,XTcA\"lI.v%{gJh4G\\-=O@5`_3i<?Z';FNQuY]szf\$!BS/|t:Pn6^Ha";

const _xlat2 = "5z]&gqtyfr\$(we4{WP)H-Zn,[%\\3dL+Q;>U!pJS72FhOA1CB6v^=I_0/8|jsb9m<.TVac`uY*MK'X~xDl}REokN:#?G\"i@";

const _validInstructions = {'j', 'i', '*', 'p', '<', '/', 'v', 'o'};
const _opCodeList = {
  'i': 'jmp [d]',
  '4': 'i',
  '<': 'out a',
  '5': '<',
  '/': 'in a',
  '23': '/',
  '*': 'a = [d] = rotr [d]',
  '39': '*',
  'j': 'mov d, [d]',
  '40': 'j',
  'p': 'a = [d] = crz a, [d]]',
  '62': 'p',
  'v': 'end',
  '81': 'v',
  'o': 'nop',
  '68': 'o'
};

const _MB_OUT = 5;
const _MB_ROT = 39;
const _MB_OPR = 62;
const _MB_NOP = 68;
const _MB_HALT = 81;

const _p9 = [1, 9, 81, 729, 6561];

const _o = [
  [4, 3, 3, 1, 0, 0, 1, 0, 0],
  [4, 3, 5, 1, 0, 2, 1, 0, 2],
  [5, 5, 4, 2, 2, 1, 2, 2, 1],
  [4, 3, 3, 1, 0, 0, 7, 6, 6],
  [4, 3, 5, 1, 0, 2, 7, 6, 8],
  [5, 5, 4, 2, 2, 1, 8, 8, 7],
  [7, 6, 6, 7, 6, 6, 4, 3, 3],
  [7, 6, 8, 7, 6, 8, 4, 3, 5],
  [8, 8, 7, 8, 8, 7, 5, 5, 4],
];

int _opr(int x, int y) {
  int i = 0;
  for (int j = 0; j < 5; j++) {
    i = i + _o[(y ~/ _p9[j]) % 9][(x ~/ _p9[j]) % 9] * _p9[j];
  }
  return i;
}

int _rotateR(int n) {
  return (n ~/ 3 + (n % 3) * 19683);
}

String _format(int n) {
  String output = n.toString();
  for (int i = output.length; i < 6; i++) {
    output = ' ' + output;
  }
  return output;
}

bool _instructionListNormalized(String instructionList) {
  bool result = true;
  for (int i = 0; i < instructionList.length; i++) {
    if (!_validInstructions.contains(instructionList[i])) {
      result = false;
      break;
    }
  }
  return result;
}

String _normalize(String instructionList) {
  // Converts ASCII-representation to Malbolge-style instructions
  String returnString = '';
  String tempChar = '';
  for (int x = 0; x < instructionList.length; x++) {
    tempChar = _xlat1[((instructionList.codeUnitAt(x) + x - 33) % 94)];
    if (_validInstructions.contains(tempChar)) returnString = returnString + tempChar;
  }
  return returnString;
}

String _reverseNormalize(String instructionList) {
  // Converts from Malbolge-style instructions to actual ASCII-representation
  String returnString = '';
  String tempChar = '';
  for (int x = 0; x < instructionList.length; x++) {
    if (_validInstructions.contains(instructionList[x])) {
      // Checks to see if the instructions provided are valid
      tempChar = String.fromCharCode(((_index(_xlat1, instructionList[x]) - x) % 94) + 33);
      returnString = returnString + tempChar;
    } else {
      return "Invalid program string";
    }
  }
  return returnString;
}

int _index(String s, String c) {
  for (int i = 0; i < s.length; i++) {
    if (s[i] == c) return i;
  }
  return -1;
}

var _memory = List<int>.filled(59049, 0); // program
var _memory_runtime = List<int>.filled(59049, 0); // memory at runtime: with encrypted commands
int _last_A_val = 0; // last value of A register

malbolgeOutput interpretMalbolge(String program, String STDIN, bool strict) {
  if (program.length < 2) {
    return malbolgeOutput(
        ['common_programming_error_invalid_program', 'common_programming_error_program_to_short'], [], []);
  }

  if (_instructionListNormalized(program)) program = _reverseNormalize(program);

  // load program
  int charCode = 0;
  program = program.replaceAll(RegExp(r'\s'), '');
  int i = 0;
  while (i < program.length) {
    charCode = program.codeUnitAt(i);
    if (charCode < 127 && charCode > 32) {
      if (!_validInstructions.contains(_xlat1[(charCode - 33 + i) % 94])) {
        return malbolgeOutput([
          'common_programming_error_invalid_program',
          'common_programming_error_invalid_character',
          'Position ' + i.toString() + ': ' + _xlat1[(charCode - 33 + i) % 94]
        ], [], []);
      }
    }
    if (i == 59049) {
      return malbolgeOutput(
          ['common_programming_error_invalid_program', 'common_programming_error_program_to_big'], [], []);
    }
    _memory[i] = charCode;
    i++;
  }
  // fill memory with op(i-1, i-2)
  while (i < 59049) {
    _memory[i] = _opr(_memory[i - 1], _memory[i - 2]);
    i++;
  }
  // execute programm
  int a = 0;
  int c = 0;
  int d = 0;
  String opcode = '';
  bool halt = false;
  int input = 0;
  List<String> output = <String>[];
  List<String> assembler = <String>[];
  List<String> mnemonic = <String>[];
  String STDOUT = '';

  while (!halt) {
    if (strict) {
      if (_memory[c] < 33 || _memory[c] > 126) {
        output.addAll([
          STDOUT,
          '',
          'common_programming_error_runtime',
          'common_programming_error_invalid_opcode',
          'opCode: ' + _memory[c].toString() + ' ' + String.fromCharCode(_memory[c]),
          'common_programming_error_infinite_loop',
          '',
          'STACK TRACE ----------',
          'c = ' + c.toString(),
          'a = ' + a.toString(),
          'd = ' + d.toString(),
        ]);
        return malbolgeOutput(output, assembler, mnemonic);
      }
    }
    opcode = _xlat1[(_memory[c] - 33 + c) % 94];
    assembler.add(_format(c) + '   ' + opcode);
    if (_opCodeList[opcode] != null) {
      mnemonic.add(_opCodeList[opcode]!);
    }

    switch (opcode) {
      case 'j': //    40     mov d, [d]
        d = _memory[d];
        break;

      case 'i': //     4     c = [d]
        c = _memory[d];
        break;

      case '*': //    39     a = [d] = rotr [d]
        a = _memory[d] = _rotateR(_memory[d]);
        //a = memory[d];
        break;

      case 'p': //    62     a = [d] = crazy(a, [d])
        a = _memory[d] = _opr(a, _memory[d]);
        //a = memory[d];
        break;

      case '<': //   23     out a % 256
        STDOUT = STDOUT + String.fromCharCode(a % 256);
        break;

      case '/': //      5     in a
        if (input < STDIN.length) {
          a = STDIN.codeUnitAt(input);
          input++;
        } else {
          output.addAll([STDOUT, '', 'common_programming_error_runtime', 'common_programming_error_no_input']);
          return malbolgeOutput(output, assembler, mnemonic);
        }
        break;

      case 'o': //    68     NOP
        break;

      case 'v': //    81     end
        halt = true;
        break;
    }

    if (strict) {
      if (_memory[c] < 33 || _memory[c] > 126) {
        output.addAll([
          STDOUT,
          '',
          'common_programming_error_runtime',
          'common_programming_error_invalid_opcode',
          'opCode: ' + _memory[c].toString() + ' ' + String.fromCharCode(_memory[c]),
          (opcode == 'i') ? 'common_programming_error_illegal_jump' : 'common_programming_error_illegal_write',
          '',
          'STACK TRACE ----------',
          'c = ' + c.toString(),
          'a = ' + a.toString(),
          'd = ' + d.toString(),
        ]);
        return malbolgeOutput(output, assembler, mnemonic);
      }

      _memory[c] = _xlat2.codeUnitAt(_memory[c] - 33);
    } else {
      if (33 <= _memory[c] && _memory[c] <= 126) {
        _memory[c] = _xlat2.codeUnitAt(_memory[c] - 33);
      }
    }

    if (c == 59048) {
      c = 0;
    } else {
      c++;
    }
    if (d == 59048) {
      d = 0;
    } else {
      d++;
    }
  }
  output.add(STDOUT);
  return malbolgeOutput(output, assembler, mnemonic);
}

malbolgeOutput generateMalbolge(String out_s) {
  String malbolgeProgram = '';
  int C = 0; // current size of Malbolge program. respectively the value of the C register in Malbolge
  int i;

  // first character: b -> cause a jump to address 98 which will be encrypted first
  _memory_runtime[0] = _memory[0] = 98;
  // fill skipped memory cells with NOPs
  for (i = 1; i < 99; i++) {
    _create_malbolge_command(_MB_NOP, i);
  }
  // Malbolge program execution continues with data pointer at 1 and program counter at 99
  C = 99;
  // The data pointer is always D = C-98, so we needn't store its value.

  // Malbolge program execution continues with data pointer at 1 and program counter at 99
  // The data pointer is always D = C-98, so we needn't store its value.

  int index = 0; // current char of out_s
  while (index < out_s.length) {
    int command_length = 0;

    do {
      // load character to A register
      command_length = _generate_character(C, out_s[index]);
      index++;
    } while (command_length < 0 && index < out_s.length);

    if (command_length == -1) break;

    C += command_length;
    if (C > 59047) {
      C = 59047;
      break;
    } else {
      // print A register
      _create_malbolge_command(_MB_OUT, C);
      C++;
    }
  } // while

  if (C > 59047) {
    C = 59047;
  }
  // halt
  _create_malbolge_command(_MB_HALT, C);
  C++;

  for (i = 0; i < C; i++) {
    // create output
    malbolgeProgram += String.fromCharCode(_memory[i]);
  }
  return malbolgeOutput([malbolgeProgram], [_normalize(malbolgeProgram)], []);
}

int _generate_character(int C, String goal) {
  // Current size of the search window.
  int window_size = 1;
  int i;

  if (goal.codeUnitAt(0) >= 154 && goal.codeUnitAt(0) <= 208) {
    // These characters cannot be generated by our method. Return -1 (no success).
    return -1;
  }

  if (String.fromCharCode(_last_A_val) == goal) {
    // goal's value is in the A register already.
    return 0;
  }

  // search for instructions of format
  // NOP* ROT? NOP* OPR? NOP* OPR
  // or
  // NOP* ROT
  // that generate goal's value in the A register
  // within the search window.
  while (window_size <= 700 && window_size + C < 59049) {
    int rotPos = -1;
    do {
      int inner_opr_pos = rotPos + 1;
      do {
        int cur_A_val = _last_A_val;

        for (i = C; i < C + rotPos; i++) {
          _create_malbolge_command(_MB_NOP, i);
        }

        if (rotPos >= 0) {
          _create_malbolge_command(_MB_ROT, C + rotPos);
          cur_A_val = _rotateR(_memory_runtime[C + rotPos - 98]);
        }

        for (i = C + rotPos + 1; i < C + inner_opr_pos; i++) {
          _create_malbolge_command(_MB_NOP, i);
        }

        if (inner_opr_pos < window_size - 1) {
          _create_malbolge_command(_MB_OPR, C + inner_opr_pos);
          cur_A_val = _opr(cur_A_val, _memory_runtime[C + inner_opr_pos - 98]);
          for (i = C + inner_opr_pos + 1; i < C + window_size; i++) {
            _create_malbolge_command(_MB_NOP, i);
          }
        }

        if (rotPos < window_size - 1) {
          _create_malbolge_command(_MB_OPR, C + window_size - 1);
          cur_A_val = _opr(cur_A_val, _memory_runtime[C + window_size - 1 - 98]);
        }

        if (String.fromCharCode(cur_A_val % 256) == goal) {
          // Success.
          // Update last_A_val and return length of Malbolge code sequence.
          _last_A_val = cur_A_val;
          return window_size;
        }

        inner_opr_pos++;
      } while (inner_opr_pos < window_size);
      rotPos++;
    } while (rotPos < window_size);
    window_size++; // increase size of search window
  } // while(window_size <= 700 && window_size + C < 59049)

  // Malbolge program size or search space exceeded. Return -1 (no success).
  return -1;
}

void _create_malbolge_command(int command, int position) {
  command = (command - (position) % 94 + 94) % 94;
  if (command < 33) {
    command += 94;
  }
  _memory[position] = command;
  if (position >= 98) {
    _memory_runtime[position] = _xlat2[_memory[position] - 33].codeUnitAt(0);
  } else {
    _memory_runtime[position] = _memory[position];
  }
}
