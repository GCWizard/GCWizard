import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_image_reader.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/crypto_and_encodings/piet/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

void main() {

  group("piet.interpretPiet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'image' : 'hw1-11.gif', 'input' : null, 'expectedOutput' : 'Hello, world!\n'},
      {'image' : 'Piet_hello_big.png', 'input' : null, 'expectedOutput' : 'Hello world!'},
      {'image' : 'hanoibig.gif', 'input' : null, 'expectedOutput' : '-52-6 0'},
      {'image' : 'primetest2big.png', 'input' : '5', 'expectedOutput' : '5is\x13\x14\x19prime'},
      {'image' : 'primetest2big.png', 'input' : '20', 'expectedOutput' : '20is"#(prime'},
    ];

    for (var elem in _inputsToExpected) {
      test('image: ${elem['image']} input: ${elem['input']}', () async {
        var imageReader = PietImageReader();
        var _pietPixels =  imageReader.readImage(_getFileData(elem['image'] as String));
        var _actual = await interpretPiet(_pietPixels!, elem['input'] as String?);

        expect(_actual.output, elem['expectedOutput'] as String?);
      });
    }
  });
}