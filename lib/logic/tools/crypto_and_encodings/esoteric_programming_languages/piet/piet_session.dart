//source: https://github.com/MatthewMooreZA/PietSharp

import 'dart:math';

import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/base_operations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_block.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_block_op_resolver.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_blocker_builder.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_navigator.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/piet/piet_stack.dart';

class PietResult {
  final String output;
  final bool input_expected;
  final bool input_number_expected;
  final bool error;
  final String errorText;
  final bool finished;
  final PietSession state;

  PietResult(
      {this.output = '',
      this.input_expected = false,
      this.input_number_expected = false,
      this.error = false,
      this.errorText = '',
      this.finished = true,
      this.state});
}

var _input_required = false;
var _input_required_number = false;
final _inputRequired = "input required";
final maxOutputLength = 1000;

Future<PietResult> interpretPiet(List<List<int>> data, String input,
    {int timeOut = 15000, bool multipleInputs = false, PietSession continueState}) async {
  var pietSession = continueState ?? PietSession(data, timeOut: timeOut, multipleInputs: multipleInputs);
  if (input != null && !input.endsWith('\n')) input += '\n';
  pietSession.input = input;

  try {
    pietSession.run();

    return PietResult(
        output: pietSession._output, input_expected: _input_required, input_number_expected: _input_required_number);
  } catch (err) {
    if (err.message == _inputRequired) {
      return PietResult(
          output: pietSession._output,
          input_expected: _input_required,
          input_number_expected: _input_required_number,
          finished: false);
    } else
      return PietResult(
          output: pietSession._output,
          input_expected: _input_required,
          input_number_expected: _input_required_number,
          error: true,
          errorText: err.message ?? err.toString(),
          state: pietSession);
  }
}

class PietSession {
  PietBlock _currentBlock;
  Map<PietOps, Function> _actionMap;

  List<List<int>> data;

  PietStack _stack;
  PietBlockOpResolver _opsResolver;
  PietBlockerBuilder _builder;
  PietNavigator _navigator;

  String input;
  var _output = '';

  var _timeOut = 15000;
  var _multipleInputs = false;

  PietSession(List<List<int>> image, {int timeOut = 15000, bool multipleInputs = false}) {
    data = image;

    _builder = PietBlockerBuilder(data);
    _navigator = PietNavigator(data);
    _opsResolver = PietBlockOpResolver();
    _stack = PietStack();
    _timeOut = max(timeOut, 100);
    _multipleInputs = multipleInputs;

    _currentBlock = _builder.getBlockAt(0, 0);

    var ops = BaseOperations(_stack, this, () => _currentBlock, (i) => _navigator.rotateDirectionPointer(i),
        (i) => _navigator.toggleCodelChooser(i));
    _actionMap = ops.getMap();
  }

  bool _running = false;
  bool get running => _running;

  void _step() {
    Point result;
    var ret = _navigator.tryNavigate(_currentBlock);
    if (!ret.item1) _running = false;
    result = ret.item2;

    var newBlock = _builder.getBlockAt(result.x, result.y);
    var opCode = _opsResolver.resolve(_currentBlock, newBlock);

    if (_actionMap.containsKey(opCode)) _actionMap[opCode]();

    _currentBlock = newBlock;
  }

  void run() {
    _running = true;

    var startTime = DateTime.now();

    while (running) {
      if ((DateTime.now().difference(startTime)).inMilliseconds > _timeOut)
        throw Exception('common_programming_error_maxiterations');

      _step();
    }
  }

  void output(String value) {
    _output += value;
    if (_output.length > maxOutputLength) throw Exception('common_programming_error_maxiterations');
  }

  int readInt() {
    if (_inputNeeded(true)) throw Exception(_inputRequired);

    if (input.isEmpty) return null;
    var match = RegExp(r'^[0-9]+').firstMatch(input);
    String _input;
    if (match == null) {
      _input = '';
      input = input.substring(1);
    } else {
      _input = match.group(0);
      input = input.substring(_input.length);
    }
    _input_required = false;
    return int.tryParse(_input);
  }

  String readChar() {
    if (_inputNeeded(false)) throw Exception(_inputRequired);

    if (input.isEmpty) return null;
    var _input = input[0];
    input = input.substring(1);
    _input_required = false;
    return _input;
  }

  bool _inputNeeded(bool numberInput) {
    _input_required = true;
    _input_required_number = numberInput;
    return input == null || (input.isEmpty && _multipleInputs);
  }
}
