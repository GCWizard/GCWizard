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
  _PietStack _stack;
  Function _getExitedBlock;
  Function _toggleDirectionPointer;
  Function _toggleCodelChooser;
  _PietSession _session;

  _BaseOperations(_PietStack stack, _PietSession session, Function getExitedBlock, Function toggleDirectionPointer,
      Function toggleCodelChooser) {
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
    if (exitedBlock == null) return;

    _stack.push(exitedBlock.blockCount);
  }

  /// <summary>
  /// Pops the top value off the stack and discards it
  /// </summary>
  int pop() {
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
    _stack.mod();
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
    if (val != null && val.isNotEmpty)
      val.runes.forEach((char) {
        _stack.push(char);
      });
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
      _PietOps.Push: this.push,
      _PietOps.Pop: this.pop,
      _PietOps.Add: this.add,
      _PietOps.Subtract: this.subtract,
      _PietOps.Multiply: this.multiply,
      _PietOps.Divide: this.divide,
      _PietOps.Mod: this.mod,
      _PietOps.Not: this.not,
      _PietOps.Greater: this.greater,
      _PietOps.Pointer: this.pointer,
      _PietOps.Switch: this.switch_,
      _PietOps.Duplicate: this.duplicate,
      _PietOps.Roll: this.roll,
      _PietOps.InputChar: this.inChar,
      _PietOps.InputNumber: this.inNumber,
      _PietOps.OutputNumber: this.outNumeric,
      _PietOps.OutputChar: this.outChar
    };
  }
}
