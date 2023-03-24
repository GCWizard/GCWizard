import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/logic/symbol_replacer.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/symbol_tables/symbol_replacer/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

void main() {

  group("symbol_replacer.replaceSymbols:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'dancing_man1.png', 'expectedOutput' : 4},
      {'input' : 'dancing_man2.png', 'expectedOutput' : 1},
    ];


    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () async {
        var _actual = await replaceSymbols(_getFileData(elem['input'] as String), 50, 80);
        expect(_actual?.symbols.length, elem['expectedOutput']);
      });
    });
  });

}