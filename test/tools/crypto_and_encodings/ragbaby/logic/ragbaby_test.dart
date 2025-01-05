import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/ragbaby/logic/ragbaby.dart';

void main() {
  group("Ragbaby: encryptRagbaby:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'option': RagbabyType.NoJX, 'pw': '', 'expectedOutput': ''},
      {
        'input': 'The quick brown fox jumps.',
        'option': RagbabyType.NoJX,
        'pw': 'secretword',
        'expectedOutput': 'Wkt vzndu hdggs kgg pczcb.'
      },
      {
        'input': 'The quick brown fox jumps!',
        'option': RagbabyType.AZ,
        'pw': 'secretword',
        'expectedOutput': 'Wjt vymdu hdggz jgr peyeb!'
      },
      {
        'input': '34 quick brown foxes?',
        'option': RagbabyType.AZ09,
        'pw': 'secretword',
        'expectedOutput': '46 vymdu hdggz jg3aa?'
      },
      {
        'input': 'BEI GRABTHARS HAMMER',
        'option': RagbabyType.NoJX,
        'pw': '',
        'expectedOutput': 'CGM IUEGAPIBD LERSMA'
      },
      {
        'input': 'du wirst gerächt werden',
        'option': RagbabyType.AZ,
        'pw': 'grabtharä',
        'expectedOutput': 'ew ylhyi bkcäkkk gldmoy'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encryptRagbaby(
            elem['input'] as String, elem['pw'] as String,
            type: elem['option'] as RagbabyType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Ragbaby: decryptRagbaby:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': '', 'option': RagbabyType.NoJX, 'pw': '', 'input': ''},

      {
        'expectedOutput': 'The quick brown fou.',
        'option': RagbabyType.NoJX,
        'pw': 'secretword',
        'input': 'Wkt vzndu hdggs kgc.'
      },
      {
        'expectedOutput': 'The quick brown fox jumps!',
        'option': RagbabyType.AZ,
        'pw': 'secretword',
        'input': 'Wjt vymdu hdggz jgr peyeb!'
      },
      {
        'expectedOutput': '34 quick brown foXes?',
        'option': RagbabyType.AZ09,
        'pw': 'secretword',
        'input': '46 vymdu hdggz jg3aa?'
      },
      {
        'expectedOutput' : 'BEI GRABTHARS HAMMER',
        'option': RagbabyType.NoJX,
        'pw': '',
        'input' :'CGM IUEGAPIBD LERSMA'
      },
      {
        'expectedOutput' : 'DU WIRST GERÄCHT WERDEN.',
        'option': RagbabyType.AZ,
        'pw': 'fedcba',
        'input' : 'CW YLVXZ JAWÄJOE FGXJJW.'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decryptRagbaby(
            elem['input'] as String, elem['pw'] as String,
            type: elem['option'] as RagbabyType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
