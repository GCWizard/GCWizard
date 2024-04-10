import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/list_utils.dart';

void main() {
  group("ListUtils.isSublist:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : <String>[], 'sublist': <String>[], 'expectedOutput' : true},
      {'list' : <String>[], 'sublist': <String>['a'], 'expectedOutput' : false},
      {'list' : <String>['a'], 'sublist': <String>[], 'expectedOutput' : true},

      {'list' : ['a'], 'sublist': ['a'], 'expectedOutput' : true},
      {'list' : ['a'], 'sublist': ['a', 'a'], 'expectedOutput' : false},
      {'list' : ['a', 'a'], 'sublist': ['a', 'a'], 'expectedOutput' : true},
      {'list' : ['a', 'a'], 'sublist': ['a'], 'expectedOutput' : true},
      {'list' : ['b', 'a'], 'sublist': ['a'], 'expectedOutput' : true},
      {'list' : ['b', 'a'], 'sublist': ['a', 'b'], 'expectedOutput' : true},
      {'list' : ['a', 'b', 'a'], 'sublist': ['a', 'a'], 'expectedOutput' : true},
      {'list' : ['a', 'b', 'a'], 'sublist': ['a', 'b'], 'expectedOutput' : true},
      {'list' : ['a', 'b', 'a'], 'sublist': ['b', 'a', 'b'], 'expectedOutput' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}, sublist: ${elem['sublist']}', () {
        var _actual = isSublist<String>(elem['list'] as List<String>, elem['sublist'] as List<String>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}