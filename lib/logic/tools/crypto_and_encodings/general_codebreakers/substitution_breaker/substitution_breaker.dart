import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/guballa.de/breaker.dart'
    as guballa;
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/quadgrams/quadgrams.dart';

enum SubstitutionBreakerAlphabet { ENGLISH, GERMAN, DUTCH, SPANISH, POLISH, GREEK, FRENCH, RUSSIAN }

enum SubstitutionBreakerErrorCode {
  OK,
  MAX_ROUNDS_PARAMETER,
  CONSOLIDATE_PARAMETER,
  TEXT_TOO_SHORT,
  ALPHABET_TOO_LONG,
  WRONG_GENERATE_TEXT
}

class SubstitutionBreakerJobData {
  final String input;
  final Quadgrams quadgrams;

  SubstitutionBreakerJobData({this.input = '', this.quadgrams});
}

class SubstitutionBreakerResult {
  final String ciphertext;
  final String plaintext;
  final String key;
  final String alphabet;
  final SubstitutionBreakerErrorCode errorCode;

  SubstitutionBreakerResult(
      {this.ciphertext = '',
      this.plaintext = '',
      this.key = '',
      this.alphabet = '',
      this.errorCode = SubstitutionBreakerErrorCode.OK});
}

Future<SubstitutionBreakerResult> break_cipherAsync(dynamic jobData) async {
  if (jobData.parameters == null) return SubstitutionBreakerResult(errorCode: SubstitutionBreakerErrorCode.OK);

  var output = break_cipher(jobData.parameters.input, jobData.parameters.quadgrams);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

SubstitutionBreakerResult break_cipher(String input, Quadgrams quadgrams) {
  if (input == null || input == '' || quadgrams == null)
    return SubstitutionBreakerResult(errorCode: SubstitutionBreakerErrorCode.OK);

  return _convertBreakerResult(guballa.break_cipher(quadgrams, input));
}

SubstitutionBreakerResult _convertBreakerResult(guballa.BreakerResult breakerResult) {
  SubstitutionBreakerErrorCode errorCode;
  switch (breakerResult.errorCode) {
    case guballa.ErrorCode.OK:
      errorCode = SubstitutionBreakerErrorCode.OK;
      break;
    case guballa.ErrorCode.MAX_ROUNDS_PARAMETER:
      errorCode = SubstitutionBreakerErrorCode.MAX_ROUNDS_PARAMETER;
      break;
    case guballa.ErrorCode.CONSOLIDATE_PARAMETER:
      errorCode = SubstitutionBreakerErrorCode.CONSOLIDATE_PARAMETER;
      break;
    case guballa.ErrorCode.TEXT_TOO_SHORT:
      errorCode = SubstitutionBreakerErrorCode.TEXT_TOO_SHORT;
      break;
    case guballa.ErrorCode.ALPHABET_TOO_LONG:
      errorCode = SubstitutionBreakerErrorCode.ALPHABET_TOO_LONG;
      break;
    case guballa.ErrorCode.WRONG_GENERATE_TEXT:
      errorCode = SubstitutionBreakerErrorCode.WRONG_GENERATE_TEXT;
      break;
  }

  return SubstitutionBreakerResult(
    ciphertext: breakerResult.ciphertext,
    plaintext: breakerResult.plaintext,
    key: breakerResult.key,
    alphabet: breakerResult.alphabet,
    errorCode: errorCode,
  );
}
