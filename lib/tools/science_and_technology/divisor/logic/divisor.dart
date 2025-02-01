import 'dart:math';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

List<int> _getDivisorsFromPrimeFactors(Map<int, int> primeFactors) {
  List<int> result = [];
  List<int> primes = primeFactors.keys.toList();
  List<List<int>> exponentsList = primes.map((prime) {
    int maxExp = primeFactors[prime]!;
    return List<int>.generate(maxExp + 1, (i) => i);
  }).toList();

  void generateDivisors(int index, int currentProduct) {
    if (index == primes.length) {
      result.add(currentProduct);
      return;
    }
    for (int exp in exponentsList[index]) {
      int newProduct = currentProduct * pow(primes[index], exp).toInt();
      generateDivisors(index + 1, newProduct);
    }
  }
  generateDivisors(0, 1);
  result = result.toSet().toList();
  result.sort();
  return result;
}

Map<int, int> _getPrimeFactorMap(List<BigInt> factors) {
  Map<int, int> factorCount = {};
  for (BigInt factor in factors) {
    int key = factor.toInt();
    factorCount[key] = (factorCount[key] ?? 0) + 1;
  }
  return factorCount;
}

List<int> divisors(int number) {
  if (number <= 0) return [0];

  var factors = integerFactorization(number);
  var primeFactors = _getPrimeFactorMap(factors);
  var divisors = _getDivisorsFromPrimeFactors(primeFactors);
  return divisors;
}
