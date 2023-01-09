import 'dart:math';

import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/base_operations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_block.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_blocker_builder.dart';
import 'package:tuple/tuple.dart';

enum HueColor { Red, Yellow, Green, Cyan, Blue, Magenta }

enum Darkness { Light, Normal, Dark }

class PietBlockOpResolver {
  /// <summary>
  /// Calculates the operation signified by the transition from block1 to block2
  /// </summary>
  /// <param name="block1">The egress block</param>
  /// <param name="block2">The ingress block</param>
  /// <returns>An operation</returns>
  PietOps resolve(PietBlock block1, PietBlock block2) {
    var ret1 = _tryResolveColor(block1.color);
    var ret2 = _tryResolveColor(block2.color);
    var color1 = ret1.item2;
    var color2 = ret2.item2;
    if (ret1.item1 && ret2.item1) {
      int lightShift = color2.item2.index - color1.item2.index;
      if (lightShift < 0) lightShift += 3;

      int colourShift = color2.item1.index - color1.item1.index;
      if (colourShift < 0) colourShift += 6;

      var comparePoint = Point<int>(colourShift, lightShift);
      if (comparePoint == Point<int>(0, 0))
        return PietOps.Noop;
      else if (comparePoint == Point<int>(0, 1))
        return PietOps.Push;
      else if (comparePoint == Point<int>(0, 2))
        return PietOps.Pop;
      else if (comparePoint == Point<int>(1, 0))
        return PietOps.Add;
      else if (comparePoint == Point<int>(1, 1))
        return PietOps.Subtract;
      else if (comparePoint == Point<int>(1, 2))
        return PietOps.Multiply;
      else if (comparePoint == Point<int>(2, 0))
        return PietOps.Divide;
      else if (comparePoint == Point<int>(2, 1))
        return PietOps.Mod;
      else if (comparePoint == Point<int>(2, 2))
        return PietOps.Not;
      else if (comparePoint == Point<int>(3, 0))
        return PietOps.Greater;
      else if (comparePoint == Point<int>(3, 1))
        return PietOps.Pointer;
      else if (comparePoint == Point<int>(3, 2))
        return PietOps.Switch;
      else if (comparePoint == Point<int>(4, 0))
        return PietOps.Duplicate;
      else if (comparePoint == Point<int>(4, 1))
        return PietOps.Roll;
      else if (comparePoint == Point<int>(4, 2))
        return PietOps.InputNumber;
      else if (comparePoint == Point<int>(5, 0))
        return PietOps.InputChar;
      else if (comparePoint == Point<int>(5, 1))
        return PietOps.OutputNumber;
      else if (comparePoint == Point<int>(5, 2))
        return PietOps.OutputChar;
      else
        throw new Exception('common_programming_error_invalid_opcode');
    }
    return PietOps.Noop;
  }

  Tuple2<bool, Tuple2<HueColor, Darkness>> _tryResolveColor(int color) {
    var index = knownColors.indexOf(color);
    if (index >= 0 && index < 18)
      return Tuple2<bool, Tuple2<HueColor, Darkness>>(
          true, Tuple2<HueColor, Darkness>(HueColor.values[index ~/ 3 % 6], Darkness.values[index % 3]));
    else
      return Tuple2<bool, Tuple2<HueColor, Darkness>>(
          false, Tuple2<HueColor, Darkness>(HueColor.Red, Darkness.Light)); // default
  }
}
