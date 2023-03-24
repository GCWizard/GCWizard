import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

BigInt phi(BigInt p, BigInt q) {
  if (!isPrime(p)) throw Exception('rsa_error_p.not.prime');

  if (!isPrime(q)) throw Exception('rsa_error_q.not.prime');

  return (p - BigInt.one) * (q - BigInt.one);
}

BigInt N(BigInt p, BigInt q) {
  if (!isPrime(p)) throw Exception('rsa_error_p.not.prime');

  if (!isPrime(q)) throw Exception('rsa_error_q.not.prime');

  return p * q;
}

bool validateE(BigInt e, BigInt p, BigInt q) {
  return phi(p, q).gcd(e) == BigInt.one;
}

bool validateD(BigInt d, BigInt p, BigInt q) {
  return phi(p, q).gcd(d) == BigInt.one;
}

BigInt _encryptInteger(BigInt value, BigInt e, BigInt N) {
  return value.modPow(e, N);
}

List<BigInt>? encryptRSA(List<BigInt> input, BigInt e, BigInt p, BigInt q) {
  if (input.isEmpty) return null;

  var _N = N(p, q);

  if (!validateE(e, p, q)) throw Exception('rsa_error_phi.e.not.coprime');

  return input.map((number) => _encryptInteger(number, e, _N)).toList();
}

BigInt? calculateD(BigInt? e, BigInt? p, BigInt? q) {
  if (e == null || p == null || q == null) return null;

  if (p > BigInt.from(10000) || p > BigInt.from(10000)) throw Exception('rsa_error_primes.too.large');

  if (!validateE(e, p, q)) throw Exception('rsa_error_phi.e.not.coprime');

  var phiN = phi(p, q);
  var i = BigInt.one;
  while ((i < phiN) && (i * e) % phiN != BigInt.one) {
    i = i + BigInt.one;
  }

  if (i >= phiN) throw Exception('rsa_error_could.not.calc.d');

  return i;
}

BigInt _decryptInteger(BigInt value, BigInt d, BigInt N) {
  return value.modPow(d, N);
}

List<BigInt>? decryptRSA(List<BigInt> input, BigInt d, BigInt p, BigInt q) {
  if (input.isEmpty) return null;

  return input.map((number) {
    var _N = N(p, q);

    if (!validateD(d, p, q)) throw Exception('rsa_error_phi.d.not.coprime');

    return _decryptInteger(number, d, _N);
  }).toList();
}
