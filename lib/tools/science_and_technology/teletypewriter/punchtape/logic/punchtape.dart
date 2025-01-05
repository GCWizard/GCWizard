import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

enum PUNCHTAPE_INTERPRETER_MODE { MODE_54321, MODE_12345, MODE_54123 }

class PunchtapeOutput extends Segments{
  final String text54321;
  final String text54123;
  final String text12345;

  PunchtapeOutput({required List<List<String>> displays, required this.text54321, required this.text54123, required this.text12345}) : super(displays: displays);
}

List<String> _decenary2segments(String decenary, bool order12345, TeletypewriterCodebook language) {
  // 0 ... 31 => 00000 ... 11111
  String? binary = convertBase(decenary, 10, 2).padLeft(BINARY_LENGTH[language]!, '0');
  List<String> result = [];
  if (!order12345) {
    binary = binary.split('').reversed.join('');
  }

  if (REVERSE_CODEBOOK.contains(language)) {
    binary = binary.split('').reversed.join('');
  }
  for (int i = 0; i < binary.length; i++) {
    if (binary[i] == '1') result.add((i + 1).toString());
  }
  return result;
}

List<String> _binary2segments(String binary, TeletypewriterCodebook language) {
  // 00000 ... 11111 => [1,2,3,4,5]
  binary = binary.padLeft(BINARY_LENGTH[language]!, '0');

  List<String> result = [];

  for (int i = 0; i < binary.length; i++) {
    if (binary[i] == '1') result.add((i + 1).toString());
  }
  return result;
}

String? _segments2decenary(List<String> segments, TeletypewriterCodebook language) {
  String result = '';

  for (int i = 1; i < 9; i++) {
    if (segments.contains(i.toString())) {
      result = result + '1';
    } else {
      result = result + '0';
    }
  }
  result = result.substring(0, BINARY_LENGTH[language]);

  return convertBase(result, 2, 10);
}

String _build54321FromBaudot(String DecodeInput) {
  List<String> result = [];
  for (var element in DecodeInput.split(' ')) {
    switch (element.length) {
      case 1:
        result.add(element[0]);
        break;
      case 2:
        result.add(element[1] + element[0]);
        break;
      case 3:
        result.add(element[2] + element[1] + element[0]);
        break;
      case 4:
        result.add(element[2] + element[3] + element[1] + element[0]);
        break;
      case 5:
        result.add(element[2] + element[3] + element[4] + element[1] + element[0]);
        break;
      default:
        result.add('');
    }
  }
  return result.join(' ');
}

String _mirrorListOfBinary(List<String> binaryList) {
  List<String> result = [];
  for (var element in binaryList) {
    result.add(element.split('').reversed.join(''));
  }
  return result.join(' ');
}

List<String> _buildBinaryListFromDecimalList(List<int> input) {
  List<String> result = [];
  for (int element in input) {
    result.add(convertBase(element.toString(), 10, 2).padLeft(5, '0'));
  }
  return result;
}

List<int> _buildIntListFromBinaryList(List<String> input) {
  List<int> result = [];
  for (String element in input) {
    if (int.tryParse(convertBase(element, 2, 10))!= null ) {
      result.add(int.parse(convertBase(element, 2, 10)));
    }
  }
  return result;
}

Segments encodePunchtape(String input, TeletypewriterCodebook language, bool order12345) {
  List<List<String>> result = [];
  List<String> code = [];
  code = encodeTeletypewriter(input, language).split(' ');
  for (var element in code) {
    if (int.tryParse(element) != null) result.add(_decenary2segments(element, order12345, language));
  }
  return Segments(displays: result);
}

String _decodeTextPunchtapeSingleMode(
    String inputs, TeletypewriterCodebook language, bool numbersOnly, PUNCHTAPE_INTERPRETER_MODE interpreterMode) {

  if (language == TeletypewriterCodebook.BAUDOT_54123) {
    switch (interpreterMode) {
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54321:
        inputs = _build54321FromBaudot(inputs);
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_12345:
        inputs = _build54321FromBaudot(inputs);
        inputs = _mirrorListOfBinary(inputs.split(' '));
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54123:
        break;
    }
  } else {
    switch (interpreterMode) {
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54321:
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_12345:
        inputs = _mirrorListOfBinary(inputs.split(' '));
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54123:
        break;
    }
  }

  List<int> intList = [];

  inputs.split(' ').forEach((element) {
    var val = int.tryParse(convertBase(element, 2, 10));
    if (val != null) {
      intList.add(val);
    }
  });

  return decodeTeletypewriter(intList, language, numbersOnly: numbersOnly);
}

PunchtapeOutput decodeTextPunchtape(
    String inputs, TeletypewriterCodebook language, bool numbersOnly) {
  if (inputs.isEmpty) return PunchtapeOutput(displays: [], text54321: '', text54123: '', text12345: '');

  var displays = <List<String>>[];
  List<int> intList = [];

  inputs.split(' ').forEach((element) {
    var val = int.tryParse(convertBase(element, 2, 10));
    if (val != null) {
      intList.add(val);
    }
  });

  inputs.split(' ').forEach((element) {
    displays.add(_binary2segments(element, language));
  });

  return PunchtapeOutput(
      displays: displays,
      text54321: _decodeTextPunchtapeSingleMode(inputs, language, numbersOnly, PUNCHTAPE_INTERPRETER_MODE.MODE_54321),
      text54123: _decodeTextPunchtapeSingleMode(inputs, language, numbersOnly, PUNCHTAPE_INTERPRETER_MODE.MODE_54123),
      text12345: _decodeTextPunchtapeSingleMode(inputs, language, numbersOnly, PUNCHTAPE_INTERPRETER_MODE.MODE_12345));
}

String _decodeVisualPunchtapeSingleMode(List<List<String>> displays, TeletypewriterCodebook language, bool numbersOnly,
    PUNCHTAPE_INTERPRETER_MODE interpreterMode) {
  // convert list of displays to list of decimal using String segments2decenary(List<String> segments)
  List<int> intList = [];
  for (var element in displays) {
    var value = int.parse(_segments2decenary(element, language) ?? '');
    intList.add(value);
  }
  String text = '';

  if (language == TeletypewriterCodebook.BAUDOT_54123) {
    switch (interpreterMode) {
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54123:
        text = decodeTeletypewriter(intList, language, numbersOnly: numbersOnly);
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54321:
        List<String> binaryList = _buildBinaryListFromDecimalList(intList);
        String binaryInputToDecode = _build54321FromBaudot(binaryList.join(' '));
        intList = _buildIntListFromBinaryList(binaryInputToDecode.split(' '));
        text = decodeTeletypewriter(intList, language, numbersOnly: numbersOnly);
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_12345:
        List<String> binaryList = _buildBinaryListFromDecimalList(intList);
        String binaryInputToDecode = _build54321FromBaudot(binaryList.join(' '));
        binaryList = _mirrorListOfBinary(binaryInputToDecode.split(' ')).split(' ');
        intList = _buildIntListFromBinaryList(binaryList);
        text = decodeTeletypewriter(intList, language, numbersOnly: numbersOnly);
        break;
    }
  } else {
    switch (interpreterMode) {
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54321:
        text = decodeTeletypewriter(intList, language, numbersOnly: numbersOnly);
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_54123:
        break;
      case PUNCHTAPE_INTERPRETER_MODE.MODE_12345:
        List<String> binaryList = _buildBinaryListFromDecimalList(intList);
        binaryList = _mirrorListOfBinary(binaryList).split(' ');
        intList = _buildIntListFromBinaryList(binaryList);
        text = decodeTeletypewriter(intList, language, numbersOnly: numbersOnly);
        break;
    }
  }

  return text;
}

PunchtapeOutput decodeVisualPunchtape(List<List<String>> displays, TeletypewriterCodebook language, bool numbersOnly) {
  if (displays.isEmpty) return PunchtapeOutput(displays: [], text54321: '', text54123: '', text12345: '');

  return PunchtapeOutput(
      displays: displays,
      text54321: _decodeVisualPunchtapeSingleMode(displays, language, numbersOnly, PUNCHTAPE_INTERPRETER_MODE.MODE_54321),
      text54123: _decodeVisualPunchtapeSingleMode(displays, language, numbersOnly, PUNCHTAPE_INTERPRETER_MODE.MODE_54123),
      text12345: _decodeVisualPunchtapeSingleMode(displays, language, numbersOnly, PUNCHTAPE_INTERPRETER_MODE.MODE_12345));
}

