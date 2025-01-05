import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pollux/logic/pollux.dart';

void main() {
  group("Pollux.polluxEncrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'numChars': 0},

      {'input' : 'A', 'startsWith': '0458', 'endsWith': '2369', 'numChars': 2},
      {'input' : 'b', 'startsWith': '2369', 'endsWith': '0458', 'numChars': 4},
      {'input' : '0', 'startsWith': '2369', 'endsWith': '2369', 'numChars': 5},
      {'input' : '.', 'startsWith': '0458', 'endsWith': '2369', 'numChars': 7}, // 6 chars, but adding a space after 5th char
      {'input' : 'Ab 0.', 'startsWith': '0458', 'endsWith': '2369', 'numChars': 23} // 20 chars + 3 spaces
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = polluxEncrypt(elem['input'] as String, '.X--\u00B7.- .\u2012');
        expect(_actual.length, elem['numChars']);
        if (_actual.isNotEmpty) {
          expect((elem['startsWith'] as String).contains(_actual[0]), true);
          expect((elem['endsWith'] as String).contains(_actual.split('').last), true);
        }
      });
    }
  });

  group("Pollux.polluxDecrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput': ''},

      {'input' : '52', 'expectedOutput': 'A'},
      {'input' : '09', 'expectedOutput': 'A'},
      {'input' : '83', 'expectedOutput': 'A'},
      {'input' : '3548', 'expectedOutput': 'B'},
      {'input' : '9808', 'expectedOutput': 'B'},
      {'input' : '3048', 'expectedOutput': 'B'},
      {'input' : '99333', 'expectedOutput': '0'},
      {'input' : '96666', 'expectedOutput': '0'},
      {'input' : '39329', 'expectedOutput': '0'},
      {'input' : '42438 6', 'expectedOutput': '.'},
      {'input' : '43420 2', 'expectedOutput': '.'},
      {'input' : '06525 2', 'expectedOutput': '.'},
      {'input' : '82134 50732 32918 60683', 'expectedOutput': 'AB0.'},
      {'input' : '56738 48763 93318 60249', 'expectedOutput': 'AB0.'},
      {'input' : '53190 45792 32918 98309', 'expectedOutput': 'AB0.'},

      {'input' : '53190457923291898309', 'expectedOutput': 'AB0.'},
      {'input' : 'A531904579X2329b§1898309', 'expectedOutput': 'AB0.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = polluxDecrypt(elem['input'] as String, '.X--\u00B7.- .\u2012');
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}