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
    return tryPop().value;
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

  /// Computes a proper modulo rather than a remainder.
  /// <param name="a">the dividend</param>
  /// <param name="n">the divisor</param>
  /// Returns the modulus
  int m(int a, int n) {
    // kudos to Erdal G of Stackoverflow - https://stackoverflow.com/a/61524484

    return (((a %= n) < 0) && n > 0) || (a > 0 && n < 0) ? a + n : a;
  }

  int not() {
    var ret = tryPop();
    var result = ret.value;
    if (!ret.valid) return 0; //null;

    result = result == 0 ? 1 : 0;
    push(result);
    return result;
  }

  int greater() {
    return _applyTernary((int s1, int s2) => s2 > s1 ? 1 : 0);
  }

  void duplicate() {
    var ret = tryPop();
    if (!ret.valid || (ret.value == null)) return;
    push(ret.value);
    push(ret.value);
  }

  int _applyTernary(int? Function(int, int) operatorFunc) {
    var ret = tryPop2();
    if (!ret.valid) return 0; //null

    var top = ret.value1;
    var second = ret.value2;
    if (top == null || second == null) return 0; //null

    var result = operatorFunc(top, second);
    push(result);
    if (result == null) return 0; //null

    return result;
  }

  bool _applyTernaryIf(int Function(int, int) operatorFunc, bool Function(int, int) conditionalFunc) {
    var ret = tryPop2();
    if (!ret.valid) return false;

    var top = ret.value1;
    var second = ret.value2;
    if (top == null || second == null) return false; //null

    if (!conditionalFunc(top, second)) return false;

    var result = operatorFunc(top, second);
    push(result);

    return true;
  }

  void roll() {
    var ret = tryPop2();
    if (!ret.valid) return;

    var numberOfRolls = ret.value1;
    var depthOfRoll = ret.value2;

    if (numberOfRolls == null || depthOfRoll == null) return;
    int absNumberOfRolls = numberOfRolls.abs();

    if (numberOfRolls > 0) {
      RotateRight(depthOfRoll, absNumberOfRolls);
    } else {
      RotateLeft(depthOfRoll, absNumberOfRolls);
    }
  }

  ({bool valid, int? value}) tryPop() {
    if (_stack.isEmpty) return const (valid: false, value: null); //null

    var result = _stack.last;
    _stack.removeLast();

    return (valid: true, value: result);
  }

  ({bool valid, int? value1, int? value2}) tryPop2() {
    if (_stack.length < 2) return const (valid: false, value1: 0, value2: 0);

    return (valid: true, value1: pop(), value2: pop());
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
