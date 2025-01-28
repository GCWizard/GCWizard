import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';


void main() {

  group("file_utils.StringExportImport:", () {

    List<Map<String, Object>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'test', 'expectedOutput' : 'test'},
      {'input' : 'πTest', 'expectedOutput' : 'πTest'},
      {'input' : 'þ¥µþµ¥¥¥¥þµþ', 'expectedOutput' : 'þ¥µþµ¥¥¥¥þµþ'},
      {'input' : 'test1\ntest2', 'expectedOutput' : 'test1\ntest2'},
      {'input' : '길이', 'expectedOutput' : '길이'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = convertBytesToString(convertStringToBytes(elem['input'] as String));
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
