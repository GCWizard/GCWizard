import 'package:gc_wizard/utils/data_type_utils/num_type_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';

enum EchoState {OK, ERROR_UNKNOWN_CHAR, ERROR_EVEN_KEY, ERROR_INPUT_TOO_SHORT}

class EchoOutput {
  String output;
  EchoState state;

  EchoOutput(this.output, this.state);
}

EchoOutput encryptEcho(String input, String key) {
  if (input.length < 2) {
    return EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT);
  }

  if (key.length % 2 == 0) {
    return EchoOutput('', EchoState.ERROR_EVEN_KEY);
  }

  var keyLength = key.length;
  var output = input[0];
  for (int i = 0; i < input.length - 1; i++) {
    var idx1 = key.indexOf(input[i]);
    var idx2 = key.indexOf(input[i + 1]);

    if (idx1 < 0 || idx2 < 0) {
      return EchoOutput('', EchoState.ERROR_UNKNOWN_CHAR);
    }

    var diff = idx1 - idx2;
    output += key[modulo(idx2 - diff, keyLength).toInt()];
  }

  return EchoOutput(output, EchoState.OK);
}

EchoOutput decryptEcho(String input, String key) {
  if (input.length < 2) {
    return EchoOutput('', EchoState.ERROR_INPUT_TOO_SHORT);
  }

  if (key.length % 2 == 0) {
    return EchoOutput('', EchoState.ERROR_EVEN_KEY);
  }

  var keyLength = key.length;
  var output = input[0];
  var lastChar = input[0];
  for (int i = 1; i < input.length; i++) {
    var idx1 = key.indexOf(input[i]);
    var idx2 = key.indexOf(lastChar);

    if (idx1 < 0 || idx2 < 0) {
      return EchoOutput('', EchoState.ERROR_UNKNOWN_CHAR);
    }

    var diff = idx1 - idx2;
    if (diff.abs() % 2 == 1) {
      diff = (keyLength - diff.abs()) * -1 * sign(diff);
    }
    lastChar = key[modulo(idx1 - diff / 2, keyLength).toInt()];
    output += lastChar;
  }

  return EchoOutput(output, EchoState.OK);
}