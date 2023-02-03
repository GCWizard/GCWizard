import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes_list.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/probably_prime.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

bool isPrime(BigInt x) {
  return isProbablePrime(x, 16);
}

BigInt _findPrimeFactor(BigInt n) {
  BigInt a, b, fac = n;
  var rnd = Random();

  while (!isProbablePrime(fac, 16)) {
    n = fac;
    a = BigInt.from((pow(2, 30) * rnd.nextDouble()).floor());
    b = a;
    fac = BigInt.one;
    while (fac.compareTo(BigInt.one) == 0) {
      for (int i = 0; i < 5; i++) {
        a = (a.pow(2) + (BigInt.one)).remainder(n);
        b = ((b.pow(2) + (BigInt.one)).remainder(n).pow(2) + (BigInt.one)).remainder(n);
        fac = fac * (b - a);
      }
      fac = fac.gcd(n);
    }
  }

  return fac;
}

List<BigInt> integerFactorization(int x) {
  if (x == null || x <= 1) return [BigInt.one];

  BigInt n = BigInt.from(x), fac;

  if (n < BigInt.one) return []; //TODO: Exception

  List<BigInt> out = [];

  for (BigInt prime in lowprimes) {
    while ((n > BigInt.one) && (n % prime == BigInt.zero)) {
      out.add(prime);
      n = n ~/ prime;
    }
  }

  while (n > BigInt.one) {
    fac = _findPrimeFactor(n);
    out.add(fac);
    n = n ~/ fac;
  }

  return out;
}

int getNthPrime(int n) {
  if (n == null || n <= 0 || n > 78499) return -1; //TODO: Exception

  return primes[n - 1];
}

int getPrimeIndex(int n) {
  if (n == null) return -1; //TODO: Exception

  var output = binarySearch(primes, n);
  return (output < 0) ? -1 : output + 1;
}

List<int> getNearestPrime(int n) {
  if (n == null || n > 1000000) return null; //TODO: Exception('Too big');

  if (n <= 2) return [2];

  if (getPrimeIndex(n) >= 0) return [n];

  var diff = 0;
  var valueBefore = -1;
  var valueAfter = -1;
  do {
    diff++;
    valueBefore = getPrimeIndex(n - diff);
    valueAfter = getPrimeIndex(n + diff);
  } while (valueBefore == -1 && valueAfter == -1);

  if (valueBefore >= 0) valueBefore = getNthPrime(valueBefore);

  if (valueAfter >= 0) valueAfter = getNthPrime(valueAfter);

  if (valueBefore >= 0 && valueAfter >= 0) return [valueBefore, valueAfter];

  return [max(valueBefore, valueAfter)];
}

int getNextPrime(int n) {
  if (n == null || n > 1000000) return null;

  if (isPrime(BigInt.from(n))) n++;

  while (!isPrime(BigInt.from(n))) n++;

  return n;
}

int getPreviousPrime(int n) {
  if (n == null || n <= 2) return null;

  if (isPrime(BigInt.from(n))) n--;

  while (!isPrime(BigInt.from(n))) n--;

  return n;
}
