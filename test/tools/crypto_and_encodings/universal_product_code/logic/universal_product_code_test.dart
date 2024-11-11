import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/universal_product_code/logic/universal_product_code.dart';

void main() {
  group("UPC.encodeUPC_A:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '640509040147', 'expectedOutput': {
        'pure': '111411323211123132113112321111323211222111321312',
        'correct': '9111111411323211123132113112111113211113232112221113213121119',
        'correct_bin': '00000000010101011110100011000110101100010001101000101101010111001010111001110010110011010111001000100101000000000'
      }}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeUPC_A(elem['input'] as String);
        expect(_actual.pureNumbers, (elem['expectedOutput']! as Map<String, String>)['pure']);
        expect(_actual.correctEncoding, (elem['expectedOutput']! as Map<String, String>)['correct']);
        expect(_actual.barcodeBinaryCorrectEncoding, (elem['expectedOutput']! as Map<String, String>)['correct_bin']);
      });
    }
  });

  group("UPC.decodeUPC_A:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput': ''},

      {'input' : '111411323211123132113112321111323211222111321312', 'expectedOutput': '640509040147'}, //pure
      {'input' : '9111111411323211123132113112111113211113232112221113213121119', 'expectedOutput': '640509040147'}, //correct
      {'input' : '00000000010101011110100011000110101100010001101000101101010111001010111001110010110011010111001000100101000000000', 'expectedOutput': '640509040147'}, //correct_bin

      {'input' : '10101011110100011000110101100010001101000101101010111001010111001110010110011010111001000100101', 'expectedOutput': '640509040147'},
      {'input' : '[2-1-2-2][1-4-1-1][3-1-1-2]', 'expectedOutput': '239'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeUPC_A(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}