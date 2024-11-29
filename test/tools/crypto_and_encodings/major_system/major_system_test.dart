import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system.dart';

void main() {
  group("Major System: decryptMajorSystem:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'nounMode': false, 'expectedOutput': ''},
      {
        'input': 'geocaching',
        'nounMode': false,
        'expectedOutput': '77627'
      },
      {
        'input': 'The quick brown fox jumps over!',
        'nounMode': false,
        'expectedOutput': '1 7 9482 8 6390 84'
      },
      {
        'input': 'abcd DEFG 1234 Sträußchen',
        'nounMode': true,
        'expectedOutput': '187 01462'
      }];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decryptMajorSystem(
            elem['input'] as String, nounMode: elem['nounMode'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
