import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/images_and_files/animated_image_morse_code/logic/animated_image_morse_code.dart';
import 'package:path/path.dart' as path;
import 'package:tuple/tuple.dart';

var testDirPath = 'test/tools/images_and_files/animated_image_morse_code/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

void main() {
  var signal1 = <Tuple2<bool, int>>[
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1500),
      const Tuple2<bool, int>(false, 1500)];

  var signal2 = <Tuple2<bool, int>>[
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(false, 1500),
      const Tuple2<bool, int>(false, 1500),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1000)];

  var signal3 = <Tuple2<bool, int>>[
      const Tuple2<bool, int>(true, 380),
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(true, 1050),
      const Tuple2<bool, int>(true, 420),
      const Tuple2<bool, int>(true, 950),
      const Tuple2<bool, int>(true, 1000),
      const Tuple2<bool, int>(false, 1500),
      const Tuple2<bool, int>(false, 1500),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 380),
      const Tuple2<bool, int>(false, 950),
      const Tuple2<bool, int>(false, 1020),
      const Tuple2<bool, int>(false, 420),
      const Tuple2<bool, int>(false, 1000),
      const Tuple2<bool, int>(false, 1000)];

  var signal4 = <Tuple2<bool, int>>[
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(false, 400)];

  var signal5 = <Tuple2<bool, int>>[
      const Tuple2<bool, int>(true, 400),
      const Tuple2<bool, int>(false, 400),
      const Tuple2<bool, int>(false, 600)];


  group("animated_image_morse_code.foundSignalTimes:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : signal1, 'expectedOutput' : const Tuple3<int, int, int>(700, 700, 1250 )},
      {'input' : signal2, 'expectedOutput' : const Tuple3<int, int, int>(700, 700, 1250 )},
      {'input' : signal3, 'expectedOutput' : const Tuple3<int, int, int>(685, 685, 1260 )},
      {'input' : signal4, 'expectedOutput' : const Tuple3<int, int, int>(400, 400, 400 )},
      {'input' : signal5, 'expectedOutput' : const Tuple3<int, int, int>(400, 500, 500 )},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = foundSignalTimes(elem['input'] as List<Tuple2<bool, int>>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("animated_image_morse_code.analyseImageMorseCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'Der kleine Preuße.gif', ''
          'expectedOutputMorse' : ' | ..-. ..- . -. ..-. -.. .-. . .. -.. .-. . .. .- -.-. .... - -. . ..- -. -. ..- .-.. .-.. -. . ..- -. | -. ..- .-.. -. ..- .-.. .-.. .- -.-. .... - --.. .-- . .. -. . ..- -. ... . -.-. .... ... -. . .. | -. ...- .. . .-. ',
          'expectedOutputText' : ' FUENFDREIDREIACHTNEUNNULLNEUN NULNULLACHTZWEINEUNSECHSNEI NVIER'},
      {'input' : 'LEUCHTTURM.gif',
          'expectedOutputMorse' : ' | -.-.- -. ..... ----- ..... --... .-.-.- .---- .---- -.... . ----- .---- .---- .---- ---.. .---- ---.. ....- | -.-. ',
          'expectedOutputText' : ' N5057.116E01118184 C'},
      {'input' : 'bibliothek.gif', 'secondMarked' : true,
        'expectedOutputMorse' : ' | -... ..- . -.-. .... . .-. .-- ..- .-. -- ',
        'expectedOutputText' : ' BUECHERWURM'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _outData = await analyseImageMorseCode(_getFileData(elem['input'] as String));
        var durations = _outData?.durations;
        var images = _outData?.images;
        var imagesFiltered = _outData?.imagesFiltered;

        var _marked =  List.filled(images!.length, false);

        if (elem['secondMarked'] != null) {
          for (var idx in imagesFiltered![1]) {
            _marked[idx] = true;
          }
          for (var idx in imagesFiltered[2]) {
            _marked[idx] = true;
          }
        } else {
          for (var idx in imagesFiltered![0]) {
            _marked[idx] = true;
          }
        }


        var _actual = decodeMorseCode(durations!, _marked);
        expect(_actual!.morseCode, elem['expectedOutputMorse']);
        expect(_actual.text, elem['expectedOutputText']);
      });
    }
  });

}