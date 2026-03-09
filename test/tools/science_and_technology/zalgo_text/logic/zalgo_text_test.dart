import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/zalgo_text/logic/zalgo_text.dart';

void main() {
  group("ZalgoText.decodeZalgoText:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'H̵̛͕̞̦̰̜͍̰̥̟͆̏͂̌͑ͅä̷͔̟͓̬̯̟͍̭͉͈̮͙̣̯̬͚̞̭̍̀̾͠m̴̡̧̛̝̯̹̗̹̤̲̺̟̥̈̏͊̔̑̍͆̌̀̚͝͝b̴̢̢̫̝̠̗̼̬̻̮̺̭͔̘͑̆̎̚ư̵̧̡̥̙̭̿̈̀̒̐̊͒͑r̷̡̡̲̼̖͎̫̮̜͇̬͌͘g̷̹͍͎̬͕͓͕̐̃̈́̓̆̚͝ẻ̵̡̼̬̥̹͇̭͔̯̉͛̈́̕r̸̮̖̻̮̣̗͚͖̝̂͌̾̓̀̿̔̀͋̈́͌̈́̋͜', 'expectedOutput' : 'Hämbưrgẻr'},
      {'input' : 'Ţ̸̲̘̹̌̈́̈́̐̌̽͒͗͗͂̎̕͜͝͝͝ë̸̛̺̤̗̲̜̭̠̖͙̠͎̜͖̖̪̘́̈́̇͗͌̚ͅs̶̨̧͓̝͚̦͇̬̟͈̳̝͓̜̠̣̉̒͒̕̚t̸̛̛͈̘̣͖͈̹̹͉͋̅͆̆̾͌̉̏̃̎͘̕̚', 'expectedOutput' : 'Test'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeZalgoText(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}