import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/images_and_files/animated_image_morse_code/logic/animated_image_morse_code.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/images_and_files/animated_image_morse_code/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

void main() {
  var signal1 = <({bool on, int duration})>[
      const (on: true, duration: 400),
      const (on: true, duration: 400),
      const (on: true, duration: 400),
      const (on: true, duration: 1000),
      const (on: true, duration: 1000),
      const (on: true, duration: 1000),
      const (on: false, duration: 400),
      const (on: false, duration: 400),
      const (on: false, duration: 400),
      const (on: false, duration: 1000),
      const (on: false, duration: 1000),
      const (on: false, duration: 1000),
      const (on: false, duration: 1000),
      const (on: false, duration: 1500),
      const (on: false, duration: 1500)];

  var signal2 = <({bool on, int duration})>[
      const (on: true, duration: 400),
      const (on: true, duration: 400),
      const (on: true, duration: 1000),
      const (on: true, duration: 400),
      const (on: true, duration: 1000),
      const (on: true, duration: 1000),
      const (on: false, duration: 1500),
      const (on: false, duration: 1500),
      const (on: false, duration: 400),
      const (on: false, duration: 400),
      const (on: false, duration: 1000),
      const (on: false, duration: 1000),
      const (on: false, duration: 400),
      const (on: false, duration: 1000),
      const (on: false, duration: 1000)];

  var signal3 = <({bool on, int duration})>[
      const (on: true, duration: 380),
      const (on: true, duration: 400),
      const (on: true, duration: 1050),
      const (on: true, duration: 420),
      const (on: true, duration: 950),
      const (on: true, duration: 1000),
      const (on: false, duration: 1500),
      const (on: false, duration: 1500),
      const (on: false, duration: 400),
      const (on: false, duration: 380),
      const (on: false, duration: 950),
      const (on: false, duration: 1020),
      const (on: false, duration: 420),
      const (on: false, duration: 1000),
      const (on: false, duration: 1000)];

  var signal4 = <({bool on, int duration})>[
      const (on: true, duration: 400),
      const (on: false, duration: 400)];

  var signal5 = <({bool on, int duration})>[
      const (on: true, duration: 400),
      const (on: false, duration: 400),
      const (on: false, duration: 600)];


  group("animated_image_morse_code.foundSignalTimes:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : signal1, 'expectedOutput' : const (ditLevel: 700, dahLevel: 700, spaceLevel: 1250 )},
      {'input' : signal2, 'expectedOutput' : const (ditLevel: 700, dahLevel: 700, spaceLevel: 1250 )},
      {'input' : signal3, 'expectedOutput' : const (ditLevel: 685, dahLevel: 685, spaceLevel: 1260 )},
      {'input' : signal4, 'expectedOutput' : const (ditLevel: 400, dahLevel: 400, spaceLevel: 400 )},
      {'input' : signal5, 'expectedOutput' : const (ditLevel: 400, dahLevel: 500, spaceLevel: 500 )},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = foundSignalTimes(elem['input'] as List<({bool on, int duration})>);
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
      {'input' : 'bibliothek.gif', 'secondMarked' : '12',
        'expectedOutputMorse' : ' | -... ..- . -.-. .... . .-. .-- ..- .-. -- ',
        'expectedOutputText' : ' BUECHERWURM'},
      {'input' : 'rudifettig.gif', 'secondMarked' : '1',
        'expectedOutputMorse' : ' -.-. . -- ..-. ----. - | ',
        'expectedOutputText' : 'CEMF9T '},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _outData = await analyseImageMorseCode(_getFileData(elem['input'] as String));
        var durations = _outData?.durations;
        var images = _outData?.images;
        var imagesFiltered = _outData?.imagesFiltered;

        var _marked =  List.filled(images!.length, false);

        if (elem['secondMarked'] != null) {
          if ((elem['secondMarked'] as String).contains('1')){
            for (var idx in imagesFiltered![1]) {
              _marked[idx] = true;
            }
          }
          if ((elem['secondMarked'] as String).contains('2')) {
            for (var idx in imagesFiltered![2]) {
              _marked[idx] = true;
            }
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