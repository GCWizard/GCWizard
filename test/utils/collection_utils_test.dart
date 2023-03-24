// ignore_for_file: equal_keys_in_map

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/collection_utils.dart';

void main() {
  group("CollectionUtils.switchMapKeyValue:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'map' : null, 'expectedOutput': null},
      {'map' : {}, 'expectedOutput': {}},
      {'map' : <String, String>{}, 'expectedOutput': <String, String>{}},
      {'map' : <int, int>{}, 'expectedOutput': <int, int>{}},
      {'map' : <String, int>{}, 'expectedOutput': <int, String>{}},
      {'map' : <int, String>{}, 'expectedOutput': <String, int>{}},

      {'map' : {'A': 'B'}, 'expectedOutput': {'B': 'A'}},
      {'map' : {'A': 'B', 'C': 'D'}, 'expectedOutput': {'B': 'A', 'D': 'C'}},
      {'map' : {'A': 1}, 'expectedOutput': {1: 'A'}},
      {'map' : {'A': 1, 'C': 2}, 'expectedOutput': {1: 'A', 2: 'C'}},
      {'map' : {1: 'B'}, 'expectedOutput': {'B': 1}},
      {'map' : {1: 'B', 2: 'D'}, 'expectedOutput': {'B': 1, 'D': 2}},

      // {'map' : {'A': null}, 'expectedOutput': {null: 'A'}},
      {'map' : {'A': 'A'}, 'expectedOutput': {'A': 'A'}},
      // {'map' : {null: 'A'}, 'expectedOutput': {'A': null}},
      // {'map' : {null: null}, 'expectedOutput': {null: null}},
      {'map' : {'A': 1, 'B': 1}, 'expectedOutput': {1: 'B'}},
      {'map' : {'A': 1, 'B': 1}, 'keepFirstOccurence': true, 'expectedOutput': {1: 'A'}},
      {'map' : {1: 'A', 1: 'B'}, 'expectedOutput': {'B': 1}}, //input map will be reduced to {1: 'B'}
    ];

    for (var elem in _inputsToExpected) {
      test('map: ${elem['map']}, keepFirstOccurence: ${elem['keepFirstOccurence']}', () {
        Object _actual;
        if (elem['keepFirstOccurence'] == null) {
          _actual = switchMapKeyValue(elem['map'] as Map);
        } else {
          _actual = switchMapKeyValue(elem['map'] as Map, keepFirstOccurence: elem['keepFirstOccurence'] as bool);
        }
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CollectionUtils.textToBinaryList:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'text' : null, 'expectedOutput' : []},
      {'text' : '', 'expectedOutput' : []},
      {'text' : '234', 'expectedOutput' : []},
      {'text' : 'ASD', 'expectedOutput' : []},

      {'text' : '1', 'expectedOutput' : ['1']},
      {'text' : '01', 'expectedOutput' : ['01']},
      {'text' : '01 101', 'expectedOutput' : ['01', '101']},
      {'text' : '01 101 0', 'expectedOutput' : ['01', '101', '0']},

      {'text' : '1dasjk1123ssd12jd10ak', 'expectedOutput' : ['1', '11', '1', '10']},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = textToBinaryList(elem['text'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}