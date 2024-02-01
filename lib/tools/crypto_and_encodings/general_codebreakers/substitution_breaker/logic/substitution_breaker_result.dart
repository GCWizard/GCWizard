import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_enums.dart';

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
