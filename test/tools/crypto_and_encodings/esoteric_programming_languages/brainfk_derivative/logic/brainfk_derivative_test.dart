import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk_derivative.dart';

void main() {
  group("Ook.interpretOok:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'code' : null, 'expectedOutput' : ''},
      {'code' : '', 'expectedOutput' : ''},

      {'code' : '.', 'input': 'ABC123', 'expectedOutput' : ''}, // error case: no fitting subsitution
      //Input copy
      {'code' : 'Ook. Ook! Ook! Ook? Ook! Ook. Ook. Ook! Ook? Ook!', 'input': 'ABC123', 'expectedOutput' : 'ABC123'},
      {'code' : 'ook.Ook!Ook!OOK? Ook!Ook. Ook. ook!pok? Ook!', 'input': 'ABC123', 'expectedOutput' : 'ABC123'},
      {'code' : 'Ook. Ook! Ook! Ook? Ook! Ook. Ook. Ook! Ook?', 'input': 'ABC123', 'expectedOutput' : 'A'}, // error case: no fitting subsitution

      {'code' : 'Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip? Yip. Yip? Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip! Yip. Yip? Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip? Yip. Yip? Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip.'
          ' Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip? Yip. Yip? Yip! Yip. Yip? Yip! Yip!'
          ' Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip! Yip. Yip? Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip?'
          ' Yip! Yip! Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip!'
          ' Yip! Yip! Yip! Yip! Yip! Yip? Yip. Yip? Yip! Yip. Yip? Yip! Yip! Yip! Yip!'
          ' Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip?'
          ' Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip? Yip. Yip? Yip! Yip. Yip? Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip!'
          ' Yip? Yip! Yip! Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip? Yip. Yip? Yip!'
          ' Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip! Yip! Yip! Yip! Yip!'
          ' Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip! Yip! Yip!'
          ' Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip? Yip.'
          ' Yip? Yip! Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip!'
          ' Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip? Yip. Yip? Yip!'
          ' Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
          ' Yip. Yip. Yip. Yip. Yip! Yip. Yip. Yip. Yip. Yip. Yip! Yip. Yip! Yip! Yip!'
          ' Yip! Yip! Yip! Yip! Yip. Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip!'
          'Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip? Yip.', 'input': '', 'expectedOutput' : 'free the prof'},

        {'code': 'Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook. Ook! Ook! Ook? Ook! Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook! Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook. Ook? Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook? Ook. Ook! Ook! Ook? Ook! Ook. Ook? Ook! Ook! Ook! Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook! Ook.',
          'input': '', 'expectedOutput': 'abc123'}
    ];

    _inputsToExpected.forEach((elem) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = BRAINFKDERIVATIVE_SHORTOOK.interpretBrainfkDerivatives(elem['code'], input: elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Ook.generateOok:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text' : null, 'expectedOutput' : ''},
      {'text' : '', 'expectedOutput' : ''},

      //Input copy
      {'text' : 'Verrückt!', 'expectedOutput' : 'Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook. Ook. Ook! Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook.'},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = BRAINFKDERIVATIVE_OOK.generateBrainfkDerivative(elem['text']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("BrainfkDerivat.interpretDetailedFk:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'code' : "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER", 'input': '', 'expectedOutput' : 'hello world'},
    ];

    _inputsToExpected.forEach((elem) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = BRAINFKDERIVATIVE_DETAILEDFK.interpretBrainfkDerivatives(elem['code'], input: elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}