import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/number_sequences/look_and_say/logic/look_and_say.dart';

void main() {
  group("look_and_say.lookAndSayReverse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : []},
      {'input' : 'aa', 'expectedOutput' : null},
      {'input' : '4a3bcc', 'expectedOutput' : null},

      {'input' : '1211', 'expectedOutput' : ['21', '11', '1']},
      {'input' : '1211 ', 'expectedOutput' : ['21', '11', '1']},
      {'input' : '111321', 'expectedOutput' : ['1311', '31', '111']},
      {'input' : '1412211512', 'expectedOutput' : ['421152', '2222122222']},
      {'input' : '22', 'expectedOutput' : []},
      {'input' : '1113122113121113222112311311222113', 'expectedOutput' : ['132113213221121113122113', '311311222112132113', '11131221123113', '1321121113', '311213', '11123']},
      {'input' : '3a', 'expectedOutput' : ['aaa']},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _actual = lookAndSayReverse(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}