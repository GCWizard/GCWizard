import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/stack.dart';

void main() {
  group("Stack.commands:", () {
    var stack = Stack<int>();

    List<Map<String, Object?>> _inputsToExpected = [

      {'command' : 'peek', 'value': 0, 'expectedOutput' : '[]', 'expectedCommandOutput' : 'Bad state: No element'},
      {'command' : 'pop', 'value': 0, 'expectedOutput' : '[]', 'expectedCommandOutput' : 'RangeError (length): Invalid value: Valid value range is empty: -1'},
      {'command' : 'push', 'value': 0, 'expectedOutput' : '[0]', 'expectedCommandOutput' : null},
      {'command' : 'push', 'value': 1, 'expectedOutput' : '[0, 1]', 'expectedCommandOutput' : null},
      {'command' : 'push', 'value': 2, 'expectedOutput' : '[0, 1, 2]', 'expectedCommandOutput' : null},
      {'command' : 'peek', 'value': 0, 'expectedOutput' : '[0, 1, 2]', 'expectedCommandOutput' : '2'},
      {'command' : 'pop', 'value': 0, 'expectedOutput' : '[0, 1]', 'expectedCommandOutput' : '2'},
      {'command' : 'pop', 'value': 0, 'expectedOutput' : '[0]', 'expectedCommandOutput' : '1'},
    ];

    for (var elem in _inputsToExpected) {
      test('command: ${elem['command']}, value: ${elem['value']}', () {
        String? _actual;
        switch (elem['command'] as String) {
          case 'peek':
            try {
              _actual = stack.peek.toString();
            } catch (e) {
              _actual = e.toString();
            }
          case 'pop':
            try {
              _actual = stack.pop().toString();
            } catch (e) {
              _actual = e.toString();
            }
          case 'push':
            stack.push(elem['value'] as int);
        }

        expect(_actual, elem['expectedCommandOutput']);
        expect(stack.toString(), elem['expectedOutput']);
      });
    }
  });
}