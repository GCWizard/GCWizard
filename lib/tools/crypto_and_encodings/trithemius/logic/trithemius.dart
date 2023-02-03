import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/alphabets.dart';

final trithemiusKey = alphabet_AZ.entries.map((entry) => entry.key).join();

String encryptTrithemius(String input, {int aValue = 0}) {
  return encryptVigenere(input, trithemiusKey, false, aValue: aValue);
}

String decryptTrithemius(String input, {int aValue: 0}) {
  return decryptVigenere(input, trithemiusKey, false, aValue: aValue);
}
