part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

enum _HueColor { Red, Yellow, Green, Cyan, Blue, Magenta }

enum _Darkness { Light, Normal, Dark }

class _PietBlockOpResolver {
  /// <summary>
  /// Calculates the operation signified by the transition from block1 to block2
  /// </summary>
  /// <param name="block1">The egress block</param>
  /// <param name="block2">The ingress block</param>
  /// <returns>An operation</returns>
  _PietOps resolve(_PietBlock block1, _PietBlock block2) {
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
      if (comparePoint == const Point<int>(0, 0)) {
        return _PietOps.Noop;
      } else if (comparePoint == const Point<int>(0, 1)) {
        return _PietOps.Push;
      } else if (comparePoint == const Point<int>(0, 2)) {
        return _PietOps.Pop;
      } else if (comparePoint == const Point<int>(1, 0)) {
        return _PietOps.Add;
      } else if (comparePoint == const Point<int>(1, 1)) {
        return _PietOps.Subtract;
      } else if (comparePoint == const Point<int>(1, 2)) {
        return _PietOps.Multiply;
      } else if (comparePoint == const Point<int>(2, 0)) {
        return _PietOps.Divide;
      } else if (comparePoint == const Point<int>(2, 1)) {
        return _PietOps.Mod;
      } else if (comparePoint == const Point<int>(2, 2)) {
        return _PietOps.Not;
      } else if (comparePoint == const Point<int>(3, 0)) {
        return _PietOps.Greater;
      } else if (comparePoint == const Point<int>(3, 1)) {
        return _PietOps.Pointer;
      } else if (comparePoint == const Point<int>(3, 2)) {
        return _PietOps.Switch;
      } else if (comparePoint == const Point<int>(4, 0)) {
        return _PietOps.Duplicate;
      } else if (comparePoint == const Point<int>(4, 1)) {
        return _PietOps.Roll;
      } else if (comparePoint == const Point<int>(4, 2)) {
        return _PietOps.InputNumber;
      } else if (comparePoint == const Point<int>(5, 0)) {
        return _PietOps.InputChar;
      } else if (comparePoint == const Point<int>(5, 1)) {
        return _PietOps.OutputNumber;
      } else if (comparePoint == const Point<int>(5, 2)) {
        return _PietOps.OutputChar;
      } else {
        throw const FormatException('common_programming_error_invalid_opcode');
      }
    }
    return _PietOps.Noop;
  }

  Tuple2<bool, Tuple2<_HueColor, _Darkness>> _tryResolveColor(int color) {
    var index = _knownColors.indexOf(color);
    if (index >= 0 && index < 18) {
      return Tuple2<bool, Tuple2<_HueColor, _Darkness>>(
          true, Tuple2<_HueColor, _Darkness>(_HueColor.values[index ~/ 3 % 6], _Darkness.values[index % 3]));
    } else {
      return const Tuple2<bool, Tuple2<_HueColor, _Darkness>>(
          false, Tuple2<_HueColor, _Darkness>(_HueColor.Red, _Darkness.Light)); // default
    }
  }
}
