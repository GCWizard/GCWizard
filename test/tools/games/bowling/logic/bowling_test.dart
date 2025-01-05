import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/bowling/logic/bowling.dart';

void main() {
  group("bowling:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'frames' : [
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
      ], 'hdcp': 0, 'expectedOutput' : 0},
      {'frames' : [
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 0, two: 0, three: 0),
      ], 'hdcp': 30, 'expectedOutput' : 30},
      {'frames' : [
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 10, three: 10),
      ], 'hdcp': 0, 'expectedOutput' : 300},
      {'frames' : [
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 5, two: 5, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 7, two: 1, three: 0),
        BowlingFrame(one: 8, two: 2, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 6, two: 4, three: 0),
        BowlingFrame(one: 9, two: 1, three: 10),
      ], 'hdcp': 0, 'expectedOutput' : 201},
      {'frames' : [
        BowlingFrame(one: 6, two: 4, three: 0),
        BowlingFrame(one: 3, two: 7, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 4, two: 2, three: 0),
        BowlingFrame(one: 6, two: 4, three: 0),
        BowlingFrame(one: 3, two: 7, three: 0),
        BowlingFrame(one: 9, two: 1, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 10, three: 10),
      ], 'hdcp': 0, 'expectedOutput' : 191},
      {'frames' : [
        BowlingFrame(one: 0, two: 5, three: 0),
        BowlingFrame(one: 3, two: 0, three: 0),
        BowlingFrame(one: 4, two: 6, three: 0),
        BowlingFrame(one: 4, two: 6, three: 0),
        BowlingFrame(one: 3, two: 5, three: 0),
        BowlingFrame(one: 0, two: 2, three: 0),
        BowlingFrame(one: 5, two: 2, three: 0),
        BowlingFrame(one: 0, two: 4, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 5, two: 5, three: 10),
      ], 'hdcp': 10, 'expectedOutput' : 106},
      {'frames' : [
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 9, two: 1, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 9, two: 1, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 8, two: 2, three: 0),
        BowlingFrame(one: 10, two: 10, three: 10),
      ], 'hdcp': 0, 'expectedOutput' : 236},
      {'frames' : [
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 7, two: 3, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 10, two: 10, three: 10),
      ], 'hdcp': 0, 'expectedOutput' : 277},
      {'frames' : [
        BowlingFrame(one: 0, two: 0, three: 0),
        BowlingFrame(one: 2, two: 6, three: 0),
        BowlingFrame(one: 4, two: 2, three: 0),
        BowlingFrame(one: 0, two: 10, three: 0),
        BowlingFrame(one: 8, two: 1, three: 0),
        BowlingFrame(one: 0, two: 4, three: 0),
        BowlingFrame(one: 9, two: 0, three: 0),
        BowlingFrame(one: 10, two: 0, three: 0),
        BowlingFrame(one: 7, two: 3, three: 0),
        BowlingFrame(one: 1, two: 6, three: 0),
      ], 'hdcp': 30, 'expectedOutput' : 122},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = bowlingTotalAfterFrames(9, bowlingCalcFrameTotals(elem['frames'] as List<BowlingFrame>), HDCP: elem['hdcp'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}