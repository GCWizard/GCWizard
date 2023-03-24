import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/maya_numbers/logic/maya_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';

void main() {
  group("MayaNumbers.encodeMayaNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 0, 'expectedOutput' : [<String>[]]},
      {'input' : 1, 'expectedOutput' : [['d']]},
      {'input' : 5, 'expectedOutput' : [['c']]},
      {'input' : 19, 'expectedOutput' : [['a', 'b','c', 'd', 'e', 'f', 'g']]},

      {'input' : 20, 'expectedOutput' : [['d'], <String>[]]},
      {'input' : 39, 'expectedOutput' : [['d'], ['a', 'b','c', 'd', 'e', 'f', 'g']]},
      {'input' : 40, 'expectedOutput' : [['d', 'e'], <String>[]]},

      {'input' : 399, 'expectedOutput' : [['a', 'b','c', 'd', 'e', 'f', 'g'], ['a', 'b','c', 'd', 'e', 'f', 'g']]},
      {'input' : 400, 'expectedOutput' : [['d'], <String>[], <String>[]]},
      {'input' : 401, 'expectedOutput' : [['d'], <String>[], ['d']]},
      {'input' : 444, 'expectedOutput' : [['d'], ['d', 'e'], ['d', 'e', 'f', 'g']]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMayaNumbers(elem['input'] as int);
        expect(_actual.displays, elem['expectedOutput']);
      });
    }
  });

  group("MayaNumbers.decodeMayaNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : <String>[], 'expectedOutput' : SegmentsVigesimal( displays: [], numbers: [0], vigesimal: BigInt.from(0))},

      {'input' : <String>[''], 'expectedOutput' : SegmentsVigesimal( displays: [[]], numbers: [0], vigesimal: BigInt.from(0))},
      {'input' : <String>['d'], 'expectedOutput' : SegmentsVigesimal( displays: [['d']], numbers: [1], vigesimal: BigInt.from(1))},
      {'input' : <String>['e'], 'expectedOutput' : SegmentsVigesimal( displays: [['e']], numbers: [1], vigesimal: BigInt.from(1))},
      {'input' : <String>['f'], 'expectedOutput' : SegmentsVigesimal( displays: [['f']], numbers: [1], vigesimal: BigInt.from(1))},
      {'input' : <String>['g'], 'expectedOutput' : SegmentsVigesimal( displays: [['g']], numbers: [1], vigesimal: BigInt.from(1))},
      {'input' : <String>['de'], 'expectedOutput' : SegmentsVigesimal( displays: [['d', 'e']], numbers: [2], vigesimal: BigInt.from(2))},
      {'input' : <String>['fg'], 'expectedOutput' : SegmentsVigesimal( displays: [['f', 'g']], numbers: [2], vigesimal: BigInt.from(2))},
      {'input' : <String>['gd'], 'expectedOutput' : SegmentsVigesimal( displays: [['g', 'd']], numbers: [2], vigesimal: BigInt.from(2))},
      {'input' : <String>['c'], 'expectedOutput' : SegmentsVigesimal( displays: [['c']], numbers: [5], vigesimal: BigInt.from(5))},
      {'input' : <String>['b'], 'expectedOutput' : SegmentsVigesimal( displays: [['b']], numbers: [5], vigesimal: BigInt.from(5))},
      {'input' : <String>['a'], 'expectedOutput' : SegmentsVigesimal( displays: [['a']], numbers: [5], vigesimal: BigInt.from(5))},
      {'input' : <String>['cb'], 'expectedOutput' : SegmentsVigesimal( displays: [['c', 'b']], numbers: [10], vigesimal: BigInt.from(10))},
      {'input' : <String>['ac'], 'expectedOutput' : SegmentsVigesimal( displays: [['a', 'c']], numbers: [10], vigesimal: BigInt.from(10))},
      {'input' : <String>['adcg'], 'expectedOutput' : SegmentsVigesimal( displays: [['a', 'd', 'c', 'g']], numbers: [12], vigesimal: BigInt.from(12))},
      {'input' : <String>['bcde'], 'expectedOutput' : SegmentsVigesimal( displays: [['b', 'c', 'd', 'e']], numbers: [12], vigesimal: BigInt.from(12))},
      {'input' : <String>['abcdefg'], 'expectedOutput' : SegmentsVigesimal( displays: [['a', 'b', 'c', 'd', 'e', 'f', 'g']], numbers: [19], vigesimal: BigInt.from(19))},

      {'input' : <String>['cdgfabe'], 'expectedOutput' : SegmentsVigesimal( displays: [['c', 'd', 'g', 'f', 'a', 'b', 'e']], numbers: [19], vigesimal: BigInt.from(19))},

      {'input' : <String>['d', ''], 'expectedOutput' : SegmentsVigesimal( displays: [['d'], []], numbers: [1, 0], vigesimal: BigInt.from(20))},
      {'input' : <String>['d', 'cdgfabe'], 'expectedOutput' : SegmentsVigesimal( displays: [['d'], ['c', 'd', 'g', 'f', 'a', 'b', 'e']],numbers: [1, 19], vigesimal: BigInt.from(39))},
      {'input' : <String>['ed', ''], 'expectedOutput' : SegmentsVigesimal( displays: [['e', 'd'], []], numbers: [2, 0], vigesimal:BigInt.from (40))},

      {'input' : <String>['abcdefg', 'abcdefg'], 'expectedOutput' : SegmentsVigesimal( displays: [['a', 'b', 'c', 'd', 'e', 'f', 'g'], ['a', 'b', 'c', 'd', 'e', 'f', 'g']], numbers: [19, 19], vigesimal: BigInt.from(399))},
      {'input' : <String>['d', '', ''], 'expectedOutput' : SegmentsVigesimal( displays: [['d'], [], []], numbers: [1, 0, 0], vigesimal: BigInt.from(400))},
      {'input' : <String>['d', '', 'd'], 'expectedOutput' : SegmentsVigesimal( displays: [['d'], [], ['d']], numbers: [1, 0, 1], vigesimal: BigInt.from(401))},
      {'input' : <String>['d', 'ed', 'dfeg'], 'expectedOutput' : SegmentsVigesimal( displays: [['d'], ['e', 'd'], ['d', 'f', 'e', 'g']], numbers: [1, 2, 4], vigesimal: BigInt.from(444))},

      {'input' : <String>['d', 'z', 'dfzzeg'], 'expectedOutput' : SegmentsVigesimal( displays: [['d'], [], ['d', 'f', 'e', 'g']], numbers: [1, 0, 4], vigesimal: BigInt.from(404))},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMayaNumbers(elem['input'] as List<String>);
        var expected = elem['expectedOutput'] as SegmentsVigesimal;
        expect(_actual.displays, expected.displays);
        expect(_actual.numbers, expected.numbers);
        expect(_actual.vigesimal, expected.vigesimal);
      });
    }
  });

}