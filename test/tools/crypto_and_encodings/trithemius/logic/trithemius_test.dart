import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/logic/trithemius.dart';

void main() {
  group("Trithemius.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'aValue': 0, 'expectedOutput' : ''},
  
      {'input' : 'ABC', 'aValue': 0, 'expectedOutput' : 'ACE'},
      {'input' : 'AAA', 'aValue': 0, 'expectedOutput' : 'ABC'},
      {'input' : 'ABCDEF', 'aValue': 0, 'expectedOutput' : 'ACEGIK'},
      {'input' : 'AAAAAA', 'aValue': 0, 'expectedOutput' : 'ABCDEF'},

      {'input' : 'Abc', 'aValue': 0, 'expectedOutput' : 'Ace'},
      {'input' : 'AbCDeF', 'aValue': 0, 'expectedOutput' : 'AcEGiK'},
      {'input' : 'ABcdeF', 'aValue': 0, 'expectedOutput' : 'ACegiK'},

      {'input' : 'Ab12c', 'aValue': 0, 'expectedOutput' : 'Ac12e'},
      {'input' : ' A%67bC DeF_', 'aValue': 0, 'expectedOutput' : ' A%67cE GiK_'},
      {'input' : 'A Bcd23eF', 'aValue': 0, 'expectedOutput' : 'A Ceg23iK'},

      {'input' : 'AbCDeF', 'aValue': 1, 'expectedOutput' : 'BdFHjL'},
      {'input' : 'AbCDeF', 'aValue': 13, 'expectedOutput' : 'NpRTvX'},
      {'input' : 'AbCDeF', 'aValue': 26, 'expectedOutput' : 'AcEGiK'},
      {'input' : 'AbCDeF', 'aValue': 27, 'expectedOutput' : 'BdFHjL'},
      {'input' : 'AbCDeF', 'aValue': 52, 'expectedOutput' : 'AcEGiK'},
      {'input' : 'AbCDeF', 'aValue': -1, 'expectedOutput' : 'ZbDFhJ'},
      {'input' : 'AbCDeF', 'aValue': -13, 'expectedOutput' : 'NpRTvX'},
      {'input' : 'AbCDeF', 'aValue': -26, 'expectedOutput' : 'AcEGiK'},
      {'input' : 'AbCDeF', 'aValue': -27, 'expectedOutput' : 'ZbDFhJ'},
      {'input' : 'AbCDeF', 'aValue': -52, 'expectedOutput' : 'AcEGiK'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        if (elem['aValue'] == null) {
          var _actual = encryptTrithemius(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = encryptTrithemius(elem['input'] as String, aValue: elem['aValue'] as int);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("Trithemius.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'aValue': null, 'expectedOutput' : ''},
      {'input' : '', 'aValue': 0, 'expectedOutput' : ''},
  
      {'input' : 'ABC', 'aValue': 0, 'expectedOutput' : 'AAA'},
      {'input' : 'AAA', 'aValue': 0, 'expectedOutput' : 'AZY'},
      {'input' : 'ABCDEF', 'aValue': 0, 'expectedOutput' : 'AAAAAA'},
      {'input' : 'AAAAAA', 'aValue': 0, 'expectedOutput' : 'AZYXWV'},
  
      {'input' : 'Abc', 'aValue': 0, 'expectedOutput' : 'Aaa'},
      {'input' : 'AbCDeF', 'aValue': 0, 'expectedOutput' : 'AaAAaA'},
      {'input' : 'ABcdeF', 'aValue': 0, 'expectedOutput' : 'AAaaaA'},
  
      {'input' : 'Ab12c', 'aValue': 0, 'expectedOutput' : 'Aa12a'},
      {'input' : ' A%67bC DeF_', 'aValue': 0, 'expectedOutput' : ' A%67aA AaA_'},
      {'input' : 'A Bcd23eF', 'aValue': 0, 'expectedOutput' : 'A Aaa23aA'},
  
      {'input' : 'AbCDeF', 'aValue': 1, 'expectedOutput' : 'ZzZZzZ'},
      {'input' : 'AbCDeF', 'aValue': 13, 'expectedOutput' : 'NnNNnN'},
      {'input' : 'AbCDeF', 'aValue': 26, 'expectedOutput' : 'AaAAaA'},
      {'input' : 'AbCDeF', 'aValue': 27, 'expectedOutput' : 'ZzZZzZ'},
      {'input' : 'AbCDeF', 'aValue': 52, 'expectedOutput' : 'AaAAaA'},
      {'input' : 'AbCDeF', 'aValue': -1, 'expectedOutput' : 'BbBBbB'},
      {'input' : 'AbCDeF', 'aValue': -13, 'expectedOutput' : 'NnNNnN'},
      {'input' : 'AbCDeF', 'aValue': -26, 'expectedOutput' : 'AaAAaA'},
      {'input' : 'AbCDeF', 'aValue': -27, 'expectedOutput' : 'BbBBbB'},
      {'input' : 'AbCDeF', 'aValue': -52, 'expectedOutput' : 'AaAAaA'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}', () {
        if (elem['aValue'] == null) {
          var _actual = decryptTrithemius(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = decryptTrithemius(elem['input'] as String, aValue: elem['aValue'] as int);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });
}