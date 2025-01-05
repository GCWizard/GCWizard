import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system.dart';

void main() {
  group("Major System: decryptMajorSystem:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'nounMode': false, 'currentLanguage': MajorSystemLanguage.DE, 'expectedOutput': ''},
      {
        'input': 'geocaching',
        'nounMode': false,
        'currentLanguage': MajorSystemLanguage.DE,
        'expectedOutput': '77627'
      },
      {
        'input': 'geocaching',
        'nounMode': false,
        'currentLanguage': MajorSystemLanguage.EN,
        'expectedOutput': '77727'
      },
      {
        'input': 'Lepszy wróbel w garści niż gołąb na dachu.',
        'nounMode': false,
        'currentLanguage': MajorSystemLanguage.PL,
        'expectedOutput': '5900 8495 8 740 20 759 2 1'
      },
      {
        'input': 'Où est les Champs-Élysées, s\'il vous plaît ?',
        'nounMode': true,
        'currentLanguage': MajorSystemLanguage.FR,
        'expectedOutput': '7390 500'
      },
      {
        'input': 'abcd DEFG 1234 Sträußchen',
        'nounMode': true,
        'currentLanguage': MajorSystemLanguage.DE,
        'expectedOutput': '187 01462'
      }];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual =
        MajorSystemLogic(text: elem['input'] as String,
            nounMode: elem['nounMode'] as bool,
            currentLanguage: elem['currentLanguage'] as MajorSystemLanguage
            ).decrypt();
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
