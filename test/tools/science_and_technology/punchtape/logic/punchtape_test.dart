import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/logic/punchtape.dart';

void main() {
  group("Punchtape.encode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'order54321' : true, 'language' : TeletypewriterCodebook.BAUDOT_12345, 'expectedOutput' : Segments(displays: [])},

      {'input' : '123', 'order54321' : false, 'language' : TeletypewriterCodebook.BAUDOT_12345, 'expectedOutput' : Segments(displays: [])},
      {'input' : '1 2 3', 'order54321' : false, 'language' : TeletypewriterCodebook.BAUDOT_12345, 'expectedOutput' : Segments(displays: [])},

      {'input' : 'ABC', 'order54321' : true, 'language' : TeletypewriterCodebook.BAUDOT_12345, 'expectedOutput' : Segments(displays: [['5'], ['2', '3'], ['2', '3', '5']])},
      {'input' : 'ABC', 'order54321' : false, 'language' : TeletypewriterCodebook.BAUDOT_12345, 'expectedOutput' : Segments(displays: [['1'], ['3', '4'], ['1', '3', '4']])},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodePunchtape(elem['input'] as String, elem['language'] as TeletypewriterCodebook, elem['order54321'] as bool, );
        expect(_actual.displays, (elem['expectedOutput'] as Segments).displays);
      });
    }
  });

  group("Punchtape.decodeText", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'language' : TeletypewriterCodebook.BAUDOT_12345, 'numbersOnly' : true, 'expectedOutput' : PunchtapeOutput(displays: [], text54321: '', text54123: '', text12345: '')},

      {'input' : '00100 10001 11000', 'language' : TeletypewriterCodebook.BAUDOT_12345, 'numbersOnly' : true,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: '', text54123: '', text12345: '')},
      {'input' : '00100 10001 11000', 'language' : TeletypewriterCodebook.BAUDOT_12345, 'numbersOnly' : false,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: 'YṮ✲', text54123: 'YṮ✲', text12345: 'YṮÉ')},

      {'input' : '00100 10001 11000', 'language' : TeletypewriterCodebook.BAUDOT_54123, 'numbersOnly' : true,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: '4o', text54123: '1;✲', text12345: '3.✲')},
      {'input' : '00100 10001 11000', 'language' : TeletypewriterCodebook.BAUDOT_54123, 'numbersOnly' : false,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: ' UI', text54123: 'AS✲', text12345: 'YṮ✲')},

      {'input' : '00100 10001 11000', 'language' : TeletypewriterCodebook.MURRAY, 'numbersOnly' : true,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: ' ,9', text54123: ' ,9', text12345: ' ,')},
      {'input' : '00100 10001 11000', 'language' : TeletypewriterCodebook.MURRAY, 'numbersOnly' : false,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: ' ZO', text54123: ' ZO', text12345: ' ZA')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeTextPunchtape(elem['input'] as String, elem['language'] as TeletypewriterCodebook, elem['numbersOnly'] as bool, );
        expect(_actual.displays, (elem['expectedOutput'] as PunchtapeOutput).displays);
        expect(_actual.text54123, (elem['expectedOutput'] as PunchtapeOutput).text54123);
        expect(_actual.text12345, (elem['expectedOutput'] as PunchtapeOutput).text12345);
        expect(_actual.text54321, (elem['expectedOutput'] as PunchtapeOutput).text54321);
      });
    }
  });

  group("Punchtape.decodeVisual", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <List<String>>[], 'language' : TeletypewriterCodebook.BAUDOT_12345, 'numbersOnly' : true, 'expectedOutput' : PunchtapeOutput(displays: [], text54321: '', text54123: '', text12345: '')},

      {'input' : [['3'], ['1', '5'], ['1', '2']], 'language' : TeletypewriterCodebook.BAUDOT_12345, 'numbersOnly' : true,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: '', text54123: '', text12345: '')},
      {'input' : [['3'], ['1', '5'], ['1', '2']], 'language' : TeletypewriterCodebook.BAUDOT_12345, 'numbersOnly' : false,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: 'YṮ✲', text54123: '', text12345: 'YṮÉ')},

      {'input' : [['3'], ['1', '5'], ['1', '2']], 'language' : TeletypewriterCodebook.BAUDOT_54123, 'numbersOnly' : true,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: '4o', text54123: '1;✲', text12345: '3.✲')},
      {'input' : [['3'], ['1', '5'], ['1', '2']], 'language' : TeletypewriterCodebook.BAUDOT_54123, 'numbersOnly' : false,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: ' UI', text54123: 'AS✲', text12345: 'YṮ✲')},

      {'input' : [['3'], ['1', '5'], ['1', '2']], 'language' : TeletypewriterCodebook.MURRAY, 'numbersOnly' : true,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: ' ,9', text54123: '', text12345: ' ,')},
      {'input' : [['3'], ['1', '5'], ['1', '2']], 'language' : TeletypewriterCodebook.MURRAY, 'numbersOnly' : false,
        'expectedOutput' : PunchtapeOutput(displays: [['3'], ['1', '5'], ['1', '2']], text54321: ' ZO', text54123: '', text12345: ' ZA')},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeVisualPunchtape(elem['input'] as List<List<String>>, elem['language'] as TeletypewriterCodebook, elem['numbersOnly'] as bool, );
        expect(_actual.displays, (elem['expectedOutput'] as PunchtapeOutput).displays);
        expect(_actual.text54321, (elem['expectedOutput'] as PunchtapeOutput).text54321);
        expect(_actual.text12345, (elem['expectedOutput'] as PunchtapeOutput).text12345);
        expect(_actual.text54123, (elem['expectedOutput'] as PunchtapeOutput).text54123);
      });
    }
  });

}