import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/burrows_wheeler/logic/burrows_wheeler.dart';


// https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/bwt.pdf

void main() {

  group("bioinfo-lectures.encrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'banana#', 'index': '0', 'expectedOutput' : BWTOutput('annb#aa','5')},
      {'input' : 'appellee#', 'index': '0', 'expectedOutput' : BWTOutput('e#elplepa','2')},
      {'input' : 'dogwood#', 'index': '0', 'expectedOutput' : BWTOutput('do#oodwg','3')},
    ];

    for (var elem in _inputsToExpected) {
        test('input: ${elem['input']}, index: ${elem['index']}', () {
          BWTOutput _actual = encryptBurrowsWheeler(elem['input'] as String, elem['index'] as String);
          expect(_actual.text, (elem['expectedOutput'] as BWTOutput).text);
          expect(_actual.index, (elem['expectedOutput'] as BWTOutput).index);
        });
    }
  });

  group("wikipedia.encrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '^ANANAS^', 'index': '0', 'expectedOutput' : BWTOutput('^NNAAA^S','7')},
      {'input' : '^ANANAS^', 'index': '#', 'expectedOutput' : BWTOutput('^NNAAA#^S','#')},
      {'input' : 'Wikipedia!', 'index': '0', 'expectedOutput' : BWTOutput('a!iepdWkii','2')},
      {'input' : 'Wikipedia!', 'index': '#', 'expectedOutput' : BWTOutput('a#!iepdWkii','#')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, index: ${elem['index']}', () {
        BWTOutput _actual = encryptBurrowsWheeler(elem['input'] as String, elem['index'] as String);
        expect(_actual.text, (elem['expectedOutput'] as BWTOutput).text);
        expect(_actual.index, (elem['expectedOutput'] as BWTOutput).index);
      });
    }
  });

  group("BurrowsWheeler.encrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'index': '0', 'expectedOutput' : BWTOutput('','')},

      {'input' : 'helene', 'index': '0',    'expectedOutput' : BWTOutput('nhleee','4')},
      {'input' : 'helene', 'index': '',     'expectedOutput' : BWTOutput('burrowswheeler_error_no_index','')},
      {'input' : 'helene', 'index': 'h',    'expectedOutput' : BWTOutput('burrowswheeler_error_char_index','')},
      {'input' : 'helene', 'index': '#',    'expectedOutput' : BWTOutput('nhl#eee','#')},

      {'input' : 'helene', 'index': '0',    'expectedOutput' : BWTOutput('nhleee','4')},
      {'input' : 'helene', 'index': '',     'expectedOutput' : BWTOutput('burrowswheeler_error_no_index','')},
      {'input' : 'helene', 'index': 'h',    'expectedOutput' : BWTOutput('burrowswheeler_error_char_index','')},
      {'input' : 'helene', 'index': '#',    'expectedOutput' : BWTOutput('nhl#eee','#')},

      {'input' : 'Koordinaten N52.27.456 E13.08.123', 'index': '0',        'expectedOutput' : BWTOutput('6n3827..E51.12.N4520 3 nrtdeiKooa','22')},
      {'input' : 'Koordinaten N52.27.456 E13.08.123', 'index': '#',        'expectedOutput' : BWTOutput('6n3827..E51.12.N4520 #3 nrtdeiKooa','#')},

      {'input' : 'wenn-fliegen-hinter-fliegen-fliegen-fliegen-fliegen-fliegen-nach', 'index': '0',        'expectedOutput' : BWTOutput('rnnnnnnnnaiiiiiiggggggwt------eeeeee-cllllllhffffffeeeneee-eienh','64')},
      {'input' : 'wenn-fliegen-hinter-fliegen-fliegen-fliegen-fliegen-fliegen-nach', 'index': '#',        'expectedOutput' : BWTOutput('rnnnnnnnnaiiiiiiggggggwt------eeeeee-cllllllhffffffeeeneee-eien#h','#')},
    ];

    for (var elem in _inputsToExpected) {
      BWTOutput _actual;
      if ((elem['index'] as String).isEmpty || elem['index'] == null) {
        _actual = BWTOutput('burrowswheeler_error_no_index', '');
      } else if ((elem['input'] as String).contains(elem['index'] as String)) {
        _actual = BWTOutput('burrowswheeler_error_char_index', '');
      } else {
        test('input: ${elem['input']}, index: ${elem['index']}', () {
        _actual = encryptBurrowsWheeler(elem['input'] as String, elem['index'] as String);
          expect(_actual.text, (elem['expectedOutput'] as BWTOutput).text);
          expect(_actual.index, (elem['expectedOutput'] as BWTOutput).index);
      });
      }
    }
  });

  group("bioinfo-lectures.decrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'annb#aa', 'index': '5',  'expectedOutput' : BWTOutput('banana#','5')},
      {'input' : 'e#elplepa', 'index': '2','expectedOutput' : BWTOutput('appellee#','2')},
      {'input' : 'do#oodwg', 'index': '3', 'expectedOutput' : BWTOutput('dogwood#','3')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, index: ${elem['index']}', () {
        BWTOutput _actual = decryptBurrowsWheeler(elem['input'] as String, elem['index'] as String);
        expect(_actual.text, (elem['expectedOutput'] as BWTOutput).text);
        expect(_actual.index, (elem['expectedOutput'] as BWTOutput).index);
      });
    }
  });

  group("wikipedia.decrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '^NNAAA^S', 'index': '7', 'expectedOutput' : BWTOutput('^ANANAS^','7')},
      {'input' : '^NNAAA#^S', 'index': '#', 'expectedOutput' : BWTOutput('^ANANAS^','#')},
      {'input' : 'a!iepdWkii', 'index': '2', 'expectedOutput' : BWTOutput('Wikipedia!','2')},
      {'input' : 'a#!iepdWkii', 'index': '#', 'expectedOutput' : BWTOutput('Wikipedia!','#')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, index: ${elem['index']}', () {
        BWTOutput _actual = decryptBurrowsWheeler(elem['input'] as String, elem['index'] as String);
        expect(_actual.text, (elem['expectedOutput'] as BWTOutput).text);
        expect(_actual.index, (elem['expectedOutput'] as BWTOutput).index);
      });
    }
  });

  group("BurrowsWheeler.decrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'index': '0',  'compress': false, 'deu': true,
        'expectedOutput' : BWTOutput('','')},

      {'input' : 'nhleee',  'index': '4', 'expectedOutput' : BWTOutput('helene','4')},
      {'input' : 'nhleee',  'index': '',  'expectedOutput' : BWTOutput('burrowswheeler_error_no_index','')},
      {'input' : 'nhleee',  'index': 'h', 'expectedOutput' : BWTOutput('elele','h')},
      {'input' : 'nhl#eee', 'index': '#', 'expectedOutput' : BWTOutput('helene','#')},

      {'input' : '6n3827..E51.12.N4520 3 nrtdeiKooa', 'index': '22',        'expectedOutput' : BWTOutput('Koordinaten N52.27.456 E13.08.123','22')},
      {'input' : '6n3827..E51.12.N4520 #3 nrtdeiKooa', 'index': '#',        'expectedOutput' : BWTOutput('Koordinaten N52.27.456 E13.08.123','#')},

      {'input' : 'rnnnnnnnnaiiiiiiggggggwt------eeeeee-cllllllhffffffeeeneee-eienh', 'index': '64',        'expectedOutput' : BWTOutput('wenn-fliegen-hinter-fliegen-fliegen-fliegen-fliegen-fliegen-nach','64')},
      {'input' : 'rnnnnnnnnaiiiiiiggggggwt------eeeeee-cllllllhffffffeeeneee-eien#h', 'index': '#',        'expectedOutput' : BWTOutput('wenn-fliegen-hinter-fliegen-fliegen-fliegen-fliegen-fliegen-nach','#')},
    ];

    for (var elem in _inputsToExpected) {
      BWTOutput _actual;
      if (elem['index'] == '' || elem['index'] == null) {
        _actual = BWTOutput('burrowswheeler_error_no_index', '');
      } else {
        test('input: ${elem['input']}, index: ${elem['index']}', () {
          _actual = decryptBurrowsWheeler(elem['input'] as String, elem['index'] as String);
          expect(_actual.text, (elem['expectedOutput'] as BWTOutput).text);
          expect(_actual.index, (elem['expectedOutput'] as BWTOutput).index);
        });
      }
    }
  });

}