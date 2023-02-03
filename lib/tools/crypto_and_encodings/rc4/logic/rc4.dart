import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

enum InputFormat { AUTO, TEXT, HEX, BINARY, ASCIIVALUES }

enum OutputFormat { TEXT, HEX, BINARY, ASCIIVALUES }

enum ErrorCode { OK, INPUT_FORMAT, KEY_FORMAT, MISSING_KEY }

class RC4Output {
  final String output;
  final ErrorCode errorCode;

  RC4Output(this.output, this.errorCode);
}

RC4Output cryptRC4(
    String input, InputFormat inputFormat, String key, InputFormat keyFormat, OutputFormat outputFormat) {
  if (input == null || input == '') return RC4Output('', ErrorCode.OK);

  var inputList = convertInputToIntList(input, inputFormat);
  if (inputList == null || inputList.length == 0) return RC4Output('', ErrorCode.INPUT_FORMAT);

  if (key == null || key == '') return RC4Output('', ErrorCode.MISSING_KEY);

  var keyList = convertInputToIntList(key, keyFormat);
  if (keyList == null || keyList.length == 0) return RC4Output('', ErrorCode.KEY_FORMAT);

  var outList = _rc4(inputList, keyList);
  var out = formatOutput(outList, outputFormat);

  return RC4Output(out, ErrorCode.OK);
}

List<int> _rc4(List<int> input, List<int> key) {
  var s = List<int>.filled(256, 0);
  var out = <int>[];
  var i;
  for (i = 0; i <= 255; ++i) s[i] = i;

  int temp, randomValue;
  int j = 0;
  for (i = 0; i <= 255; ++i) {
    j = (j + s[i] + key[i % key.length]) % 256;
    // flip s[i] with s[j]
    temp = s[i];
    s[i] = s[j];
    s[j] = temp;
  }

  i = 0;
  j = 0;
  for (int n = 0; n < input.length; ++n) {
    i = (i + 1) % 256;
    j = (j + s[i]) % 256;

    // flip s[i] with s[j]
    temp = s[i];
    s[i] = s[j];
    s[j] = temp;
    randomValue = s[(s[i] + s[j]) % 256];
    out.add(randomValue ^ input[n]);
  }

  return out;
}

List<int> convertInputToIntList(String input, InputFormat format) {
  var out = <int>[];

  if (input == null || input == '') return null;

  switch (format) {
    case InputFormat.AUTO:
      return convertInputToIntList(input, _autoType(input));
      break;
    case InputFormat.TEXT:
      return input.codeUnits;
      break;
    case InputFormat.HEX:
      out = _convertToIntList(input, 16);
      break;
    case InputFormat.BINARY:
      out = _convertToIntList(input, 2);
      break;
    case InputFormat.ASCIIVALUES:
      out = _convertToIntList(input, 10);
      break;
    default:
      break;
  }

  return out;
}

InputFormat _autoType(String input) {
  String bin = input.replaceAll(RegExp("[ 01]"), "");
  if (bin.length == 0) return InputFormat.BINARY;

  String hex = input.toUpperCase().replaceAll(RegExp("[0-9A-F]"), "").replaceAll(" ", "");
  if (hex.length == 0) return InputFormat.HEX;

  String ascii = input.replaceAll(RegExp("[ 0-9]"), "");
  bool ok = true;
  if (ascii.length == 0) {
    input.split(" ").forEach((text) {
      if (int.tryParse(text) > 255) {
        ok = false;
        return;
      }
    });

    if (ok) return InputFormat.ASCIIVALUES;
  }

  return InputFormat.TEXT;
}

List<int> _convertToIntList(String input, int base) {
  var out = <int>[];

  if (input.contains(' ')) {
    input.split(' ').forEach((text) {
      if (out != null) out = _addToIntList(text, base, out);
    });
  } else {
    out = _addToIntList(input, base, out);
  }

  // invalid input ??
  if (out == null) return <int>[];

  return out;
}

List<int> _addToIntList(String input, int base, List<int> list) {
  if (input == '') return list;
  var valueString = convertBase(input, base, 10);
  if ((valueString == null) || (valueString == ''))
    // invalid input
    return null;

  list.add(int.tryParse(valueString));

  return list;
}

String formatOutput(List<int> outList, OutputFormat outputFormat) {
  if (outList == null) return null;
  var out = '';

  outList.forEach((item) {
    switch (outputFormat) {
      case OutputFormat.TEXT:
        item = item % pow(2, 16);
        if (item < 33 || (item > 126 && item < 161))
          out += ".";
        else
          out += String.fromCharCode(item);
        break;
      case OutputFormat.HEX:
        if (out != '') out += ' ';

        out += convertBase(item.toString(), 10, 16).padLeft(2, '0');
        break;
      case OutputFormat.BINARY:
        if (out != '') out += ' ';

        out += convertBase(item.toString(), 10, 2).padLeft(8, '0');
        break;
      case OutputFormat.ASCIIVALUES:
        if (out != '') out += ' ';

        out += item.toString();
        break;
      default:
        break;
    }
  });
  return out;
}
