import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/gray/logic/gray.dart';

void main() {

  group("Gray.encodeGray", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput([], [])},
      {'input' : '', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput([], [])},

      {'input' : '99', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['82'], ['1010010'])},
      {'input' : '4', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['6'], ['110'])},
      {'input' : '1100011', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['82'], ['1010010'])},
      {'input' : '100', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['6'], ['110'])},

      {'input' : '0', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['0'], ['0'])},
      {'input' : '0', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['0'], ['0'])},
      {'input' : '-1', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['1'], ['1'])}, // minus is an invalid character and will be ignored
      {'input' : '-1', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['1'], ['1'])},
      {'input' : '4564891150054051545016854805445018545108480', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['4035923437030429023638392334595790158671104'], ['1011100101010010000011010101000001000000101000010101111111100010111100010110001101000100000100000010100111001000010010100111111010110100000000'])},

      {'input' : '10001010101110001010110110010011111001011001110100001001010100100100100100111110101011', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['14988227676521837608478316277386046116394959561813392321799058226949780185844470068250'], ['1111011011100011100010111001000111001111011101001001111010100001110101010001110001100010100111001100111000001000111010110001100111100110011110000111101110111110011010010011011101011100010100011001011111000000111101010011010011010010110111011011101011100110111011000010011010000011010'])},
      {'input' : '10001010101110001010110110010011111001011001110100001001010100100100100100111110101011', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['62832245210708569130494078'], ['11001111111001001111101101011010000101110101001110001101111110110110110110100001111110'])},

      {'input' : '4 10 11 78912 2312 1238912', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['6', '15', '14', '110176', '3468', '1807424'], ['110','1111','1110','11010111001100000','110110001100','110111001010001000000'])},
      {'input' : '4 10 11 78912 2312 1238912', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['3', '2', '1', '1', '1', '1'], ['11', '10', '1', '1', '1', '1'])},
      {'input' : '10 11001 1001 11001 0111101 1001 1110 1 01 0 111', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['3', '21', '13', '21', '35', '13', '9', '1', '1', '0', '4'], ['11', '10101', '1101', '10101', '100011', '1101', '1001', '1', '1', '0', '100'])},
      {'input' : '10 11001 1001 11001 0111101 1001 1110 1 01 0 111', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['15', '16261', '541', '16261', '92419', '541', '1661', '1', '1', '0', '88'], ['1111','11111110000101','1000011101','11111110000101','10110100100000011','1000011101','11001111101','1','1','0','1011000'])},

      {'input' : 'a/12310&/((AbBa91AN 17812 /!"89 8. -7', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['10269', '118', '26462', '117', '12', '4'], ['10100000011101', '1110110', '110011101011110', '1110101', '1100', '100'])},
      {'input' : 'a/12310&/((AbBa91AN 17812 /!"89 8. -7', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['1', '3', '1', '1', '1'], ['1', '11', '1', '1', '1'])},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = encodeGray(elem['input'], mode: elem['mode']);
        expect(_actual.decimalOutput, elem['expectedOutput'].decimalOutput);
        expect(_actual.binaryOutput, elem['expectedOutput'].binaryOutput);
      });
    });
  });

  group("Gray.decodeGray:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput([], [])},
      {'input' : '', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput([], [])},

      {'input' : '82', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['99'], ['1100011'])},
      {'input' : '1010010', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['99'], ['1100011'])},
      {'input' : '6', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['4'], ['100'])},
      {'input' : '110', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['4'], ['100'])},

      {'input' : '0', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['0'], ['0'])},
      {'input' : '0', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['0'], ['0'])},
      {'input' : '-1', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['1'], ['1'])}, // minus is an invalid character and will be ignored
      {'input' : '-1', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['1'], ['1'])},
      {'input' : '4035923437030429023638392334595790158671104', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['4564891150054051545016854805445018545108480'], ['1101000110011100000010011001111110000000110000011001010101000011010111100100001001111000000111111100111010001111100011000101010011011000000000'])},
      {'input' : '1011100101010010000011010101000001000000101000010101111111100010111100010110001101000100000100000010100111001000010010100111111010110100000000', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['4564891150054051545016854805445018545108480'], ['1101000110011100000010011001111110000000110000011001010101000011010111100100001001111000000111111100111010001111100011000101010011011000000000'])},

      {'input' : '14988227676521837608478316277386046116394959561813392321799058226949780185844470068250', 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput(['10001010101110001010110110010011111001011001110100001001010100100100100100111110101011'], ['1010010010111101000011010001111010001010010110001110101100111110100110011110100001000011000101110111010000001111010011011110111010111011101011111010110100101011101100011101101001101000011000010001101010000000101001100010011101100011011010010010110010111011010010000011101100000010011'])},
      {'input' : '11001111111001001111101101011010000101110101001110001101111110110110110110100001111110', 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput(['41925970120872087296036779'], ['10001010101110001010110110010011111001011001110100001001010100100100100100111110101011'])},

      {'input' : ['6', '15', '14', '110176', '3468', '1807424'].join(' '), 'mode': GrayMode.DECIMAL,'expectedOutput' : GrayOutput('4 10 11 78912 2312 1238912'.split(' '), ['100','1010','1011','10011010001000000','100100001000','100101110011110000000'])},
      {'input' : ['110','1111','1110','11010111001100000','110110001100','110111001010001000000'].join(' '), 'mode': GrayMode.BINARY,'expectedOutput' : GrayOutput('4 10 11 78912 2312 1238912'.split(' '), ['100','1010','1011','10011010001000000','100100001000','100101110011110000000'])},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = decodeGray(elem['input'], mode: elem['mode']);
        expect(_actual.decimalOutput, elem['expectedOutput'].decimalOutput);
        expect(_actual.binaryOutput, elem['expectedOutput'].binaryOutput);
      });
    });
  }); // group
}