//---------------------------------------------------------
// COW Programming language
// by BigZaphod sean@fifthace.com
// https://github.com/BigZaphod/COW
//
// Licencse: Public Domain
//
// Interpreter Marco F. atomK
// https://github.com/Atomk/C-COW-Interpreter/blob/master/cow-interpreter.c
// Licence: MIT -  https://github.com/Atomk/C-COW-Interpreter/blob/master/LICENSE
//
// Copyright (c) 2020 Marco Fras
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//
// Generator   Frank Buss
// https://frank-buss.de/cow.html
// permission to use the javascript-code received per E-mail on 23 May 2021 17:32
// and forwarded to geocache.wizard@gmail.com
//---------------------------------------------------------

import 'package:gc_wizard/utils/common_utils.dart';

final ERROR_COW_INVALIDCODE = 'common_programming_error_invalid_opcode';
final ERROR_COW_LOOPNOTOPEND = 'cow_error_nomatchingMOO';
final ERROR_COW_LOOPNOTCLOSED = 'cow_error_nomatchingmoo';
final ERROR_COW_MEMORYOUTOFBOUNDS = 'common_programming_error_memoryoutofbounds';
final ERROR_COW_INFINITELOOP = 'common_programming_error_infinite_loop';
final ERROR_COW_MAXITERATIONS = 'common_programming_error_maxiterations';

final commandsMooToInteger = {
  'moo': 0,
  'mOo': 1,
  'moO': 2,
  'mOO': 3,
  'Moo': 4,
  'MOo': 5,
  'MoO': 6,
  'MOO': 7,
  'OOO': 8,
  'MMM': 9,
  'OOM': 10,
  'oom': 11
};

final commandsIntegerToMoo = switchMapKeyValue(commandsMooToInteger);
final mnemonicList = {
  0: 'jump loop start',
  1: 'dec mem',
  2: 'inc mem',
  3: 'exec [mem]',
  4: '[mem]=0 ? input char [mem] : print [mem] as char',
  5: 'dec [mem]',
  6: 'inc [mem]',
  7: '[mem]=0 ? loop end : loop start',
  8: 'clr [mem]',
  9: 'reg=0 ? mov [mem] reg : mov reg [mem]; clr reg',
  10: 'print [mem] as int',
  11: 'input int [mem]'
};

final MEMORY_SIZE = 256;
final MAX_NUMBER_OF_INSTRUCTIONS = 512;
final MAX_ITERATIONS = 9999999;

class CowOutput {
  String output = '';
  String error = '';
  List<String> debug;

  CowOutput(this.output, this.error, this.debug);
}

List<int> memoryBlocksArray = List<int>.generate(MEMORY_SIZE, (int index) => 0);
List<String> debug = <String>[];
int currentBlockIndex = 0;
String error = '';
bool halt = false;
int reg = 0;
bool isRegisterInitialized = false;
int inputPointer = 0;
String STDOUT = '';

CowOutput interpretCow(String code, {String STDIN}) {
  if (code == null || code.length == 0) return CowOutput('', '', []);

  code = code.replaceAll(RegExp(r'\s'), '');
  List<int> opcodesArray = <int>[];
  int numberOfInstructions = 0;

  for (int i = 0; i < code.length ~/ 3; i++) {
    if (commandsMooToInteger[code.substring(i * 3, i * 3 + 3)] != null) {
      opcodesArray.add(commandsMooToInteger[code.substring(i * 3, i * 3 + 3)]);
      numberOfInstructions++;
    }
  }

  for (int i = 0; i < MEMORY_SIZE; i++) memoryBlocksArray[i] = 0;
  currentBlockIndex = 0;
  halt = false;
  reg = 0;
  isRegisterInitialized = false;
  inputPointer = 0;
  STDOUT = '';
  error = '';

  int iterations = 0;
  int prog_pos = 0;

  while (prog_pos < numberOfInstructions && !halt) {
    debug.add(mnemonicList[opcodesArray[prog_pos]]);
    prog_pos = _execCommand(opcodesArray[prog_pos], opcodesArray, prog_pos, numberOfInstructions, STDIN);
    iterations++;
    if (iterations > MAX_ITERATIONS) {
      error = ERROR_COW_MAXITERATIONS;
      halt = true;
    }
  }
  ;

  return CowOutput(STDOUT, error, debug);
}

int _execCommand(
    int commandCode, List<int> instructionsArray, int instructionIndex, int numberOfInstructions, String STDIN) {
  int MOO_count = 0;
  int moo_count = 0;

  switch (commandCode) {
    case 0: // moo
      // This command is connected to the MOO command. When encountered during normal execution,
      // it searches the program code in reverse looking for a matching MOO command
      // and begins executing again starting from the found MOO command.
      // When searching, it skips the instruction that is immediately before it (see MOO).
      instructionIndex -= 2; // Skip previous instruction
      moo_count = 0;

      while (instructionIndex >= 0) {
        switch (instructionsArray[instructionIndex]) {
          case 0: //moo
            moo_count++;
            break;
          case 7: //MOO
            if (moo_count == 0)
              return instructionIndex;
            else
              moo_count--;
            break;
        }
        instructionIndex--;
      }
      error = ERROR_COW_LOOPNOTOPEND;
      halt = true;
      break;

    case 1: // mOo
      // Moves current memory position back one block
      if (currentBlockIndex > 0) {
        currentBlockIndex--;
      } else {
        error = ERROR_COW_MEMORYOUTOFBOUNDS;
        halt = true;
      }
      break;

    case 2: // moO
      // Moves current memory position forward one block
      if (currentBlockIndex < MEMORY_SIZE - 1) {
        currentBlockIndex++;
      } else {
        error = ERROR_COW_MEMORYOUTOFBOUNDS;
        halt = true;
      }
      break;

    case 3: // mOO
      // Execute value in current memory block as if it were an instruction.
      // The command executed is based on the instruction code value (see https://bigzaphod.github.io/COW/)
      // (for example, if the current memory block contains a 2, then the moO command is executed).
      // An invalid command exits the running program.
      // Cannot call itself, as it would cause an infinite loop.
      if (memoryBlocksArray[currentBlockIndex] == commandCode) {
        error = ERROR_COW_INFINITELOOP;
        halt = true;
      } else {
        if (memoryBlocksArray[currentBlockIndex] >= 0 && memoryBlocksArray[currentBlockIndex] <= 11) {
          _execCommand(
              memoryBlocksArray[currentBlockIndex], instructionsArray, instructionIndex, instructionIndex, STDIN);
        } else {
          error = ERROR_COW_INVALIDCODE;
          halt = true;
        }
      }
      break;

    case 4: // Moo
      // If current memory block has a 0 in it, read a single ASCII character from STDIN and store it in the current memory block.
      // If the current memory block is not 0, then print the ASCII character that corresponds to the value in the current memory block to STDOUT.
      if (memoryBlocksArray[currentBlockIndex] == 0) {
        memoryBlocksArray[currentBlockIndex] = STDIN.codeUnitAt(inputPointer);
        inputPointer++;
      } else {
        STDOUT = STDOUT + String.fromCharCode(memoryBlocksArray[currentBlockIndex] % 256);
      }
      break;

    case 5: // MOo
      // Decrement current block value by 1
      memoryBlocksArray[currentBlockIndex]--;
      break;

    case 6: // MoO
      // Increment current block value by 1
      memoryBlocksArray[currentBlockIndex]++;
      break;

    case 7: // MOO
      // If current memory block value is 0, skip next command and resume execution *after* the next matching moo command.
      // If current memory block value is not 0, then continue with next command.
      // Note that the fact that it skips the command immediately following it has interesting ramifications for where the matching moo command really is.
      // For example, the following will match the second and not the first moo: OOO MOO moo moo
      if (memoryBlocksArray[currentBlockIndex] == 0) {
        MOO_count = 0;
        instructionIndex += 2; // Skip next instruction

        while (instructionIndex < numberOfInstructions) {
          switch (instructionsArray[instructionIndex]) {
            case 0: // moo
              if (MOO_count == 0)
                return instructionIndex + 1;
              else
                MOO_count--;
              break;
            case 7: //MOO
              MOO_count++;
              break;
          }
          instructionIndex++;
        }
        error = ERROR_COW_LOOPNOTCLOSED;
        halt = true;
      }
      break;

    case 8: // OOO
      // Set current memory block value to zero
      memoryBlocksArray[currentBlockIndex] = 0;
      break;

    case 9: // MMM
      // If no current value in register, copy current memory block value.
      // If there is a value in the register, then paste that value into the current memory block and clear the register.
      if (!isRegisterInitialized)
        reg = memoryBlocksArray[currentBlockIndex];
      else
        memoryBlocksArray[currentBlockIndex] = reg;
      isRegisterInitialized = !isRegisterInitialized;
      break;

    case 10: // OOM - Print value of current memory block to STDOUT as an integer
      // Print value of current memory block to STDOUT as an integer

      // Added the newline (\n) because the 99bottles and Fibonacci examples assume this,
      // even though the language specification doesn't say anything about it
      STDOUT = STDOUT + memoryBlocksArray[currentBlockIndex].toString() + '\n';
      break;

    case 11: // oom
      // Read an integer from STDIN and put it into the current memory block
      String digit = '';
      while (int.tryParse(STDIN[inputPointer]) != null) {
        digit = digit + STDIN[inputPointer];
        inputPointer++;
      }
      memoryBlocksArray[currentBlockIndex] = int.parse(digit);
      break;

    default:
      error = ERROR_COW_INVALIDCODE;
      halt = true;
  }
  // If MOO or moo did not return, go to the next instruction
  return instructionIndex + 1;
}

String generateCow(String cowOut) {
  // initial program: store 8, 16, 32 and 64 in memory positions 1, 2, 3 and 4, current memory position is 5
  var program =
      'OOO MoO MoO MoO MoO MoO MoO MoO MoO MMM moO MMM MMM moO MMM MOO MOo mOo MoO moO moo mOo MMM moO MMM MMM moO MMM MOO MOo mOo MoO moO moo mOo MMM moO MMM MMM moO MMM MOO MOo mOo MoO moO moo';

  for (var i = 0; i < cowOut.length; i++) {
    // next character, ignore non-ASCII
    var c = cowOut.codeUnitAt(i);
    if (c > 127) continue;

    // clear position 5 and 6
    program += ' OOO moO OOO mOo';

    // add bits
    for (var j = 6; j > 3; j--) {
      var mask = 1 << j;
      if (c > mask) {
        switch (j) {
          case 6:
            // position 5 = 64
            program += ' mOo MMM moO MMM';
            break;
          case 5:
            // position 5 = 32
            program += ' mOo mOo MMM moO moO MMM';
            break;
          case 4:
            // position 5 = 16
            program += ' mOo mOo mOo MMM moO moO moO MMM';
            break;
        }
        // add position 5 and 6, result in position 6
        program += ' MOO MOo moO MoO mOo moo';
        c -= mask;
      }
    }

    // add rest to position 6 and print
    program += " moO";
    for (var j = 0; j < c; j++) {
      program += " MoO";
    }
    program += " Moo mOo";
  }

  return program;
}
