import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

class BifidOutput {
  final String state;
  final String output;
  final String? grid;

  BifidOutput(this.state, this.output, this.grid);
}

BifidOutput encryptBifid(String input, String key,
    {PolybiosMode mode = PolybiosMode.AZ09,
    String? alphabet,
    AlphabetModificationMode alphabetMode = AlphabetModificationMode.J_TO_I}) {
  int dim = key.length;
  if (dim != 5 && dim != 6) {
    return BifidOutput('ERROR', 'bifid_error_wrong_griddimension', null);
  }

  var polybiosOutput = encryptPolybios(input, key, mode: mode, fillAlphabet: alphabet, modificationMode: alphabetMode);

  if (polybiosOutput == null) {
    return BifidOutput('ERROR', 'bifid_error_no_output', null);
  }

  var polybiosEncoded = polybiosOutput.output.replaceAll(' ', '');

  /// split output into two rows und build a new string with digits
  /// use this string as input for the decrypt-routine
  String row1 = '';
  String row2 = '';
  String helpInput = '';

  for (var i = 0; i < polybiosEncoded.length; i = i + 2) {
    row1 = row1 + polybiosEncoded.substring(i, i + 1);
    row2 = row2 + polybiosEncoded.substring(i + 1, i + 2);
  }
  helpInput = row1 + row2;

  polybiosOutput = decryptPolybios(helpInput, key, mode: mode, fillAlphabet: alphabet, modificationMode: alphabetMode);
  if (polybiosOutput != null) {
    return BifidOutput('OK', polybiosOutput.output, polybiosOutput.grid);
  } else {
    return BifidOutput('ERROR', 'bifid_error_no_output', null);
  }
}

BifidOutput decryptBifid(String input, String key,
    {PolybiosMode mode = PolybiosMode.AZ09,
    String? alphabet,
    AlphabetModificationMode alphabetMode = AlphabetModificationMode.J_TO_I}) {
  int dim = key.length;
  if (dim != 5 && dim != 6) {
    return BifidOutput('ERROR', 'bifid_error_wrong_griddimension', null);
  }

  var polybiosOutput = encryptPolybios(input, key, mode: mode, fillAlphabet: alphabet, modificationMode: alphabetMode);

  if (polybiosOutput == null) {
    return BifidOutput('ERROR', 'bifid_error_no_output', null);
  }

  var polybiosEncoded = polybiosOutput.output.replaceAll(' ', '');

  /// split output into two rows und build a new string with digits
  /// use this string as input for the decrypt-routine
  String row1 = '';
  String row2 = '';
  String helpInput = '';

  row1 = polybiosEncoded.substring(0, polybiosEncoded.length ~/ 2);
  row2 = polybiosEncoded.substring(polybiosEncoded.length ~/ 2, polybiosEncoded.length);

  for (var i = 0; i < polybiosEncoded.length / 2; i = i + 1) {
    helpInput = helpInput + row1.substring(i, i + 1) + row2.substring(i, i + 1);
  }

  polybiosOutput = decryptPolybios(helpInput, key, mode: mode, fillAlphabet: alphabet, modificationMode: alphabetMode);

  if (polybiosOutput != null) {
    return BifidOutput('OK', polybiosOutput.output, polybiosOutput.grid);
  } else {
    return BifidOutput('ERROR', 'bifid_error_no_output', null);
  }
}
