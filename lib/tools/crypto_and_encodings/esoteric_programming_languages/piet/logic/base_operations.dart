part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

enum _PietOps {
  Noop,
  Push,
  Pop,
  Add,
  Subtract,
  Multiply,
  Divide,
  Mod,
  Not,
  Greater,
  Pointer,
  Switch,
  Duplicate,
  Roll,
  InputNumber,
  InputChar,
  OutputNumber,
  OutputChar
}

class _BaseOperations {
  late _PietStack _stack;
  late _PietBlock Function() _getExitedBlock;
  late void Function(int) _toggleDirectionPointer;
  late void Function(int) _toggleCodelChooser;
  late _PietSession _session;

  _BaseOperations(_PietStack stack, _PietSession session, _PietBlock Function() getExitedBlock, void Function(int) toggleDirectionPointer,
      void Function(int) toggleCodelChooser) {
    _stack = stack;
    _session = session;
    _getExitedBlock = getExitedBlock;
    _toggleDirectionPointer = toggleDirectionPointer;
    _toggleCodelChooser = toggleCodelChooser;
  }

  /// <summary>
  /// Pushes the value of the color block just exited on to the stack
  /// </summary>
  void push() {
    _PietBlock exitedBlock = _getExitedBlock();

    _stack.push(exitedBlock.blockCount);
  }

  /// <summary>
  /// Pops the top value off the stack and discards it
  /// </summary>
  int? pop() {
    return _stack.pop();
  }

  int add() {
    return _stack.add();
  }

  int subtract() {
    return _stack.subtract();
  }

  int multiply() {
    return _stack.multiply();
  }

  int divide() {
    return _stack.divide();
  }

  int mod() {
    return _stack.mod();
  }

  int not() {
    return _stack.not();
  }

  int greater() {
    return _stack.greater();
  }

  void pointer() {
    var result = _stack.pop();
    if (result != null) _toggleDirectionPointer(result);
  }

  void switch_() {
    var result = _stack.pop();
    if (result != null) _toggleCodelChooser(result);
  }

  void duplicate() {
    _stack.duplicate();
  }

  void roll() {
    _stack.roll();
  }

  void inNumber() {
    var val = _session.readInt();
    if (val != null) _stack.push(val);
  }

  void inChar() {
    var val = _session.readChar();
    if (val != null && val.isNotEmpty) {
      for (var char in val.runes) {
        _stack.push(char);
      }
    }
  }

  void outNumeric() {
    var result = _stack.pop();
    if (result != null) _session.output(result.toString());
  }

  void outChar() {
    var result = _stack.pop();
    if (result != null) _session.output(String.fromCharCode(result));
  }

  Map<_PietOps, void Function()> getMap() {
    return {
      _PietOps.Push: push,
      _PietOps.Pop: pop,
      _PietOps.Add: add,
      _PietOps.Subtract: subtract,
      _PietOps.Multiply: multiply,
      _PietOps.Divide: divide,
      _PietOps.Mod: mod,
      _PietOps.Not: not,
      _PietOps.Greater: greater,
      _PietOps.Pointer: pointer,
      _PietOps.Switch: switch_,
      _PietOps.Duplicate: duplicate,
      _PietOps.Roll: roll,
      _PietOps.InputChar: inChar,
      _PietOps.InputNumber: inNumber,
      _PietOps.OutputNumber: outNumeric,
      _PietOps.OutputChar: outChar
    };
  }
}
