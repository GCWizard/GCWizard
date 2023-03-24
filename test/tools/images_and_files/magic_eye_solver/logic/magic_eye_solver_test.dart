import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/images_and_files/magic_eye_solver/logic/magic_eye_solver.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/images_and_files/magic_eye_solver/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

void main() {

  group("magic_eye_solver.decodeImageAsync:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'atomium.jpg', 'expectedOutput' : 70},
      {'input' : 'dino.png', 'expectedOutput' : 120},
      {'input' : 'dino2.png', 'expectedOutput' : 120},
      {'input' : 'dolphins.jpg', 'expectedOutput' : 57},
      {'input' : 'planet.jpg', 'expectedOutput' : 57},
      {'input' : 'shark.jpg', 'expectedOutput' : 140},
      {'input' : 'thumbsup.jpg', 'expectedOutput' : 56},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _actual = await decodeImage(_getFileData(elem['input'] as String), null, null);
        expect(_actual?.item3, elem['expectedOutput']);
      });
    }
  });

}