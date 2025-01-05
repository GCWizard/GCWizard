import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/tower_of_hanoi/logic/tower_of_hanoi.dart';

void main() {
  group("TowerOfHanoi.moves:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 0, 'expectedOutput' : '[]'},
      {'input' : 4, 'expectedOutput' :
  '[(  2     |     |\n'
    '  3     |     |\n'
    '  4     1     |, 1, 1, 2), (  3     |     |\n'
    '  4     1     2, 2, 1, 3), (  3     |     1\n'
    '  4     |     2, 1, 2, 3), (  |     |     1\n'
    '  4     3     2, 3, 1, 2), (  1     |     |\n'
    '  4     3     2, 1, 3, 1), (  1     2     |\n'
    '  4     3     |, 2, 3, 2), (  |     1     |\n'
    '  |     2     |\n'
    '  4     3     |, 1, 1, 2), (  |     1     |\n'
    '  |     2     |\n'
    '  |     3     4, 4, 1, 3), (  |     2     1\n'
    '  |     3     4, 1, 2, 3), (  |     |     1\n'
    '  2     3     4, 2, 2, 1), (  1     |     |\n'
    '  2     3     4, 1, 3, 1), (  1     |     3\n'
    '  2     |     4, 3, 2, 3), (  |     |     3\n'
    '  2     1     4, 1, 1, 2), (  |     |     2\n'
    '  |     |     3\n'
    '  |     1     4, 2, 1, 3), (  |     |     1\n'
    '  |     |     2\n'
    '  |     |     3\n'
    '  |     |     4, 1, 2, 3)]'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = moves(elem['input'] as int);
        expect(_actual.toString(), elem['expectedOutput']);
      });
    }
  });
}