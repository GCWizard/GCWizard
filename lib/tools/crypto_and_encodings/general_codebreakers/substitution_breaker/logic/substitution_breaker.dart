import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_enums.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_result.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';

class SubstitutionBreakerJobData {
  final String input;
  final Quadgrams quadgrams;

  SubstitutionBreakerJobData({this.input = '', this.quadgrams});
}

Future<SubstitutionBreakerResult> break_cipherAsync(dynamic jobData) async {
  if (jobData.parameters == null) return SubstitutionBreakerResult(errorCode: SubstitutionBreakerErrorCode.OK);

  var output = _break_cipher(jobData.parameters.input, jobData.parameters.quadgrams);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

SubstitutionBreakerResult _break_cipher(String input, Quadgrams quadgrams) {
  if (input == null || input == '' || quadgrams == null)
    return SubstitutionBreakerResult(errorCode: SubstitutionBreakerErrorCode.OK);

  return _convertBreakerResult(break_cipher(quadgrams, input));
}

SubstitutionBreakerResult _convertBreakerResult(BreakerResult breakerResult) {
  SubstitutionBreakerErrorCode errorCode;
  switch (breakerResult.errorCode) {
    case BreakerErrorCode.OK:
      errorCode = SubstitutionBreakerErrorCode.OK;
      break;
    case BreakerErrorCode.MAX_ROUNDS_PARAMETER:
      errorCode = SubstitutionBreakerErrorCode.MAX_ROUNDS_PARAMETER;
      break;
    case BreakerErrorCode.CONSOLIDATE_PARAMETER:
      errorCode = SubstitutionBreakerErrorCode.CONSOLIDATE_PARAMETER;
      break;
    case BreakerErrorCode.TEXT_TOO_SHORT:
      errorCode = SubstitutionBreakerErrorCode.TEXT_TOO_SHORT;
      break;
    case BreakerErrorCode.ALPHABET_TOO_LONG:
      errorCode = SubstitutionBreakerErrorCode.ALPHABET_TOO_LONG;
      break;
    case BreakerErrorCode.WRONG_GENERATE_TEXT:
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

Quadgrams getQuadgrams(SubstitutionBreakerAlphabet alphabet) {
  switch (alphabet) {
    case SubstitutionBreakerAlphabet.ENGLISH:
      return EnglishQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.GERMAN:
      return GermanQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.DUTCH:
      return DutchQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.SPANISH:
      return SpanishQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.POLISH:
      return PolishQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.GREEK:
      return GreekQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.FRENCH:
      return FrenchQuadgrams();
      break;
    case SubstitutionBreakerAlphabet.RUSSIAN:
      return RussianQuadgrams();
      break;
    default:
      return null;
  }
}
