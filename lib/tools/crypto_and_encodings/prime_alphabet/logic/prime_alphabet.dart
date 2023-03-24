import 'package:gc_wizard/tools/crypto_and_encodings/homophone/logic/homophone.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/constants.dart';

String decryptPrimeAlphabet(List<int?> input, {int firstRecognizedPrime = 2}) {
  if (input.isEmpty) return '';

  int? _firstRecognizedPrime = firstRecognizedPrime;
  if (!isPrime(BigInt.from(_firstRecognizedPrime))) {
    _firstRecognizedPrime = getNextPrime(_firstRecognizedPrime);
  }

  if (_firstRecognizedPrime == null) return '';
  var firstIndex = getPrimeIndex(_firstRecognizedPrime);

  return input.map((number) {
    if (_firstRecognizedPrime == null || number == null ||
        number < _firstRecognizedPrime || !isPrime(BigInt.from(number))) return UNKNOWN_ELEMENT;

    var index = (getPrimeIndex(number) - firstIndex) % 26;
    return alphabet_AZIndexes[index + 1];
  }).join();
}

List<int?> encryptPrimeAlphabet(String input, {int firstRecognizedPrime = 2, int lastRecognizedPrime = 101}) {
  input = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  if (input.isEmpty) return [];

  while (!isPrime(BigInt.from(firstRecognizedPrime))) {
    firstRecognizedPrime++;
  }

  while (!isPrime(BigInt.from(lastRecognizedPrime))) {
    lastRecognizedPrime--;
  }

  if (firstRecognizedPrime > lastRecognizedPrime) return [];

  var startIndex = getPrimeIndex(firstRecognizedPrime);
  var endIndex = getPrimeIndex(lastRecognizedPrime);

  Map<String, List<int>> homophoneMap = alphabet_AZ.map((key, value) => MapEntry(key, []));

  var alphabetIndex = 1;
  for (int i = startIndex; i <= endIndex; i++) {
    homophoneMap[alphabet_AZIndexes[alphabetIndex]]?.add(getNthPrime(i));
    alphabetIndex++;
    if (alphabetIndex > 26) alphabetIndex = 1;
  }

  var result = encryptHomophoneWithKeyMap(input, homophoneMap).output;
  var outList = result.split(' ').map((value) {
    var x = int.tryParse(value);
    return (x != null && x >= 0) ? x : null;
  }).toList();

  return outList;
}
