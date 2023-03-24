// source: https://github.com/MatthewMooreZA/PietSharp

part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

class PietResult {
  final String output;
  final bool input_expected;
  final bool input_number_expected;
  final bool error;
  final String errorText;
  final bool finished;
  final _PietSession? state;

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
const _inputRequired = "input required";
const _maxOutputLength = 1000;

Future<PietResult> interpretPiet(List<List<int>> data, String? input,
    {int timeOut = 15000, bool multipleInputs = false, _PietSession? continueState}) async {
  var pietSession = continueState ?? _PietSession(data, timeOut: timeOut, multipleInputs: multipleInputs);
  if (input != null && !input.endsWith('\n')) input += '\n';
  pietSession.input = input;

  try {
    pietSession.run();

    return PietResult(
        output: pietSession._output, input_expected: _input_required, input_number_expected: _input_required_number);
  } on FormatException catch(err) {
    if (err.message == _inputRequired) {
      return PietResult(
          output: pietSession._output,
          input_expected: _input_required,
          input_number_expected: _input_required_number,
          finished: false);
    } else {
      return PietResult(
          output: pietSession._output,
          input_expected: _input_required,
          input_number_expected: _input_required_number,
          error: true,
          errorText: err.toString(),
          state: pietSession);
    }
  }
}

class _PietSession {
  late _PietBlock _currentBlock;
  late Map<_PietOps, Function> _actionMap;

  late List<List<int>> data;

  late _PietStack _stack;
  late _PietBlockOpResolver _opsResolver;
  late _PietBlockerBuilder _builder;
  late _PietNavigator _navigator;

  String? input;
  var _output = '';

  int _timeOut = 15000;
  bool _multipleInputs = false;

  _PietSession(List<List<int>> image, {int timeOut = 15000, bool multipleInputs = false}) {
    data = image;

    _builder = _PietBlockerBuilder(data);
    _navigator = _PietNavigator(data);
    _opsResolver = _PietBlockOpResolver();
    _stack = _PietStack();
    _timeOut = max(timeOut, 100);
    _multipleInputs = multipleInputs;

    _currentBlock = _builder._getBlockAt(0, 0);

    var ops = _BaseOperations(_stack, this, () => _currentBlock, (i) => _navigator.rotateDirectionPointer(i),
        (i) => _navigator.toggleCodelChooser(i));
    _actionMap = ops.getMap();
  }

  bool _running = false;
  bool get running => _running;

  void _step() {
    Point<int> result;
    var ret = _navigator.tryNavigate(_currentBlock);
    if (!ret.item1) _running = false;
    result = ret.item2;

    var newBlock = _builder._getBlockAt(result.x, result.y);
    var opCode = _opsResolver.resolve(_currentBlock, newBlock);

    if (_actionMap.containsKey(opCode)) _actionMap[opCode]!();

    _currentBlock = newBlock;
  }

  void run() {
    _running = true;

    var startTime = DateTime.now();

    while (running) {
      if ((DateTime.now().difference(startTime)).inMilliseconds > _timeOut) {
        throw const FormatException('common_programming_error_maxiterations');
      }

      _step();
    }
  }

  void output(String value) {
    _output += value;
    if (_output.length > _maxOutputLength) throw const FormatException('common_programming_error_maxiterations');
  }

  int? readInt() {
    if (_inputNeeded(true)) throw const FormatException(_inputRequired);

    if (input == null || input!.isEmpty) return null;
    var match = RegExp(r'^\d+').firstMatch(input!);
    String _input;
    if (match == null) {
      _input = '';
      input = input!.substring(1);
    } else {
      _input = match.group(0)!;
      input = input!.substring(_input.length);
    }
    _input_required = false;
    return int.tryParse(_input);
  }

  String? readChar() {
    if (_inputNeeded(false)) throw const FormatException(_inputRequired);

    if (input == null || input!.isEmpty) return null;
    var _input = input![0];
    input = input!.substring(1);
    _input_required = false;
    return _input;
  }

  bool _inputNeeded(bool numberInput) {
    _input_required = true;
    _input_required_number = numberInput;
    return (input == null || input!.isEmpty && _multipleInputs);
  }
}
