import "package:flutter_test/flutter_test.dart";
import "package:gc_wizard/tools/crypto_and_encodings/echo/logic/echo.dart";

void main() {
  group("Echo.encodeEcho:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'expectedOutput' : EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT)},
      {'input' : '1', 'key': '', 'expectedOutput' : EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT)},
      {'input' : '1', 'key': '1', 'expectedOutput' : EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT)},
      {'input' : '12', 'key': '', 'expectedOutput' : EchoOutput('', EchoState.ERROR_EVEN_KEY)},
      {'input' : '12', 'key': '1', 'expectedOutput' : EchoOutput('', EchoState.ERROR_UNKNOWN_CHAR)},

      {'input' : '11', 'key': '1', 'expectedOutput' : EchoOutput('11', EchoState.OK)},
      {'input' : '131', 'key': '123AB', 'expectedOutput' : EchoOutput('1BA', EchoState.OK)},
      {'input' : '2125.125.48..5.9546.465.88', 'key': '0123456789.', 'expectedOutput' : EchoOutput('203843384911.0481383984468', EchoState.OK)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = encryptEcho(elem['input'] as String, elem['key'] as String);
        expect(_actual.output, (elem['expectedOutput'] as EchoOutput).output);
        expect(_actual.state, (elem['expectedOutput'] as EchoOutput).state);
      });
    }
  });

  group("Echo.decodeEcho:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'expectedOutput' : EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT)},
      {'input' : '1', 'key': '', 'expectedOutput' : EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT)},
      {'input' : '1', 'key': '1', 'expectedOutput' : EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT)},
      {'input' : '12', 'key': '', 'expectedOutput' : EchoOutput('', EchoState.ERROR_EVEN_KEY)},
      {'input' : '12', 'key': '1', 'expectedOutput' : EchoOutput('', EchoState.ERROR_UNKNOWN_CHAR)},

      {'input' : '11', 'key': '1', 'expectedOutput' : EchoOutput('11', EchoState.OK)},
      {'input' : '1BA', 'key': '123AB', 'expectedOutput' : EchoOutput('131', EchoState.OK)},
      {'input' : '203843384911.0481383984468', 'key': '0123456789.', 'expectedOutput' : EchoOutput('2125.125.48..5.9546.465.88', EchoState.OK)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = decryptEcho(elem['input'] as String, elem['key'] as String);
        expect(_actual.output, (elem['expectedOutput'] as EchoOutput).output);
        expect(_actual.state, (elem['expectedOutput'] as EchoOutput).state);
      });
    }
  });
}