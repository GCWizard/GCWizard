part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

class _PietStack {
  final List<int> _stack = <int>[];
  int get length => _stack.length;
  bool get isNotEmpty => length > 0;

  void push(int? value) {
    if (value == null) return;
    _stack.add(value);
  }

  int? pop() {
    return tryPop().item2;
  }

  int add() {
    return _applyTernary((int s1, int s2) => s1 + s2);
  }

  int subtract() {
    return _applyTernary((int s1, int s2) => s2 - s1);
  }

  int multiply() {
    return _applyTernary((int s1, int s2) => s1 * s2);
  }

  int divide() {
    return _applyTernaryIf((int s1, int s2) => s2 ~/ s1, (_, int s2) => s2 != 0) ? 1 : 0;
  }

  int mod() {
    // per the spec take the second value mod the first
    return _applyTernaryIf((int s1, int s2) => m(s2, s1), (int s1, _) => s1 != 0) ? 1 : 0;
  }

  /// <summary>
  /// Computes a proper modulo rather than a remainder.
  /// </summary>
  /// <param name="a">the dividend</param>
  /// <param name="n">the divisor</param>
  /// <returns>the modulus</returns>
  int m(int a, int n) {
    // kudos to Erdal G of Stackoverflow - https://stackoverflow.com/a/61524484

    return (((a %= n) < 0) && n > 0) || (a > 0 && n < 0) ? a + n : a;
  }

  int not() {
    var ret = tryPop();
    var result = ret.item2;
    if (!ret.item1) return 0; //null;

    result = result == 0 ? 1 : 0;
    push(result);
    return result;
  }

  int greater() {
    return _applyTernary((int s1, int s2) => s2 > s1 ? 1 : 0);
  }

  void duplicate() {
    var ret = tryPop();
    var result = ret.item2;
    if (!ret.item1 || (result == null)) return;
    push(result);
    push(result);
  }

  int _applyTernary(int? Function(int, int) operatorFunc) {
    var ret = tryPop2();
    var stackResults = ret.item2;
    if (!ret.item1) return 0; //null

    var top = stackResults.item1;
    var second = stackResults.item2;
    if (top == null || second == null) return 0; //null

    var result = operatorFunc(top, second);
    push(result);
    if (result == null) return 0; //null

    return result;
  }

  bool _applyTernaryIf(int Function(int, int) operatorFunc, bool Function(int, int) conditionalFunc) {
    var ret = tryPop2();
    var stackResults = ret.item2;
    if (!ret.item1) return false;

    var top = stackResults.item1;
    var second = stackResults.item2;
    if (top == null || second == null) return false; //null

    if (!conditionalFunc(top, second)) return false;

    var result = operatorFunc(top, second);
    push(result);

    return true;
  }

  void roll() {
    var ret = tryPop2();
    var stackResults = ret.item2;
    if (!ret.item1) return;

    var numberOfRolls = stackResults.item1;
    var depthOfRoll = stackResults.item2;

    if (numberOfRolls == null || depthOfRoll == null) return;
    int absNumberOfRolls = numberOfRolls.abs();

    if (numberOfRolls > 0) {
      RotateRight(depthOfRoll, absNumberOfRolls);
    } else {
      RotateLeft(depthOfRoll, absNumberOfRolls);
    }
  }

  Tuple2<bool, int?> tryPop() {
    if (_stack.isEmpty) return const Tuple2<bool, int?>(false, null); //null

    var result = _stack.last;
    _stack.removeLast();

    return Tuple2<bool, int?>(true, result);
  }

  Tuple2<bool, Tuple2<int?, int?>> tryPop2() {
    if (_stack.length < 2) return const Tuple2<bool, Tuple2<int?, int?>>(false, Tuple2<int, int>(0, 0));

    return Tuple2<bool, Tuple2<int?, int?>>(true, Tuple2<int?, int?>(pop(), pop()));
  }

  bool RotateRight(int depth, int iterations) {
    if (depth > _stack.length) return false;
    // if we need to rotate 3 items 7 items, then we can skip the full cycles and just the the 1
    int absoluteIterations = iterations % depth;

    var stack1 = _PietStack();
    var stack2 = _PietStack();
    for (var i = 0; i < depth; i++) {
      if (i < absoluteIterations) {
        stack1.push(pop());
      } else {
        stack2.push(pop());
      }
    }

    while (stack1.isNotEmpty) {
      push(stack1.pop());
    }

    while (stack2.isNotEmpty) {
      push(stack2.pop());
    }

    return true;
  }

  bool RotateLeft(int depth, int iterations) {
    if (depth > _stack.length) return false;
    // if we need to rotate 3 items 7 items, then we can skip the full cycles and just the the 1
    int absoluteIterations = iterations % depth;

    var stack1 = _PietStack();
    var stack2 = _PietStack();
    for (var i = depth; i > 0; i--) {
      if (i <= absoluteIterations) {
        stack1.push(pop());
      } else {
        stack2.push(pop());
      }
    }

    while (stack2.isNotEmpty) {
      push(stack2.pop());
    }

    while (stack1.isNotEmpty) {
      push(stack1.pop());
    }

    return true;
  }
}
