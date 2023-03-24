import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';

void main() {
  group("substitution_breaker.compressQuadgrams:", () {
    final List<int> quadgrams = [0, 0, 0, 747, 0, 0, 0, 0, 0, 0, 11, 12, 13, 0, 0, 0, 17];

    List<Map<String, Object?>> _inputsToExpected = [
      {'input': quadgrams, 'errorCode': BreakerErrorCode.OK, 'expectedOutput': '{"3":[747],"10":[11,12,13,0,0,0,17]}'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _actual = Quadgrams.quadgramsMapToString(Quadgrams.compressQuadgrams(elem['input'] as List<int>));
        expect(_actual, elem['expectedOutput']);
      });
    }
  });


  group("substitution_breaker.decompressQuadgrams:", () {
    final List<int> quadgrams = [0, 0, 0, 747, 0, 0, 0, 0, 0, 0, 11, 12, 13, 0, 0, 0, 17];
    final Map<int, List<int>> quadgramsCpmpressed = {3: [747], 10: [11, 12, 13, 0, 0, 0, 17]};
    final Map<int, List<int>> quadgramsCpmpressed1 = {3: [747], 10: [11, 12, 13], 16: [17]};

    List<Map<String, Object?>> _inputsToExpected = [
      {'input': quadgramsCpmpressed, 'size': 17, 'errorCode': BreakerErrorCode.OK, 'expectedOutput': quadgrams},
      {'input': quadgramsCpmpressed1, 'size': 17, 'errorCode': BreakerErrorCode.OK, 'expectedOutput': quadgrams},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _actual = Quadgrams.decompressQuadgrams(elem['input'] as Map<int, List<int>>, elem['size'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}