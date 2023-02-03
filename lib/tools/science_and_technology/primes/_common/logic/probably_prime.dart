/*
 * This is an extract of https://github.com/AKushWarrior/steel_crypt/blob/master/lib/PointyCastleN/key_generators/rsa_key_generator.dart
 * (Point Castle project, dually licensed under LGPL 3 and MPL 2.0)
 *
 * which uses the isProbablyPrime() algorithm from https://github.com/dartist/dart-bignum/blob/master/lib/src/big_integer_dartvm.dart
 * License:
 *
 * Copyright (c) 2003-2005  Tom Wu
 * Copyright (c) 2012 Adam Singer (adam@solvr.io)
 * All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY
 * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
 *
 * IN NO EVENT SHALL TOM WU BE LIABLE FOR ANY SPECIAL, INCIDENTAL,
 * INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND, OR ANY DAMAGES WHATSOEVER
 * RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER OR NOT ADVISED OF
 * THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF LIABILITY, ARISING OUT
 * OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * In addition, the following condition applies:
 *
 * All redistributions must retain an intact copy of this copyright notice
 * and disclaimer.
 */

/// [List] of low primes */
final List<BigInt> lowprimes = [
  BigInt.from(2),
  BigInt.from(3),
  BigInt.from(5),
  BigInt.from(7),
  BigInt.from(11),
  BigInt.from(13),
  BigInt.from(17),
  BigInt.from(19),
  BigInt.from(23),
  BigInt.from(29),
  BigInt.from(31),
  BigInt.from(37),
  BigInt.from(41),
  BigInt.from(43),
  BigInt.from(47),
  BigInt.from(53),
  BigInt.from(59),
  BigInt.from(61),
  BigInt.from(67),
  BigInt.from(71),
  BigInt.from(73),
  BigInt.from(79),
  BigInt.from(83),
  BigInt.from(89),
  BigInt.from(97),
  BigInt.from(101),
  BigInt.from(103),
  BigInt.from(107),
  BigInt.from(109),
  BigInt.from(113),
  BigInt.from(127),
  BigInt.from(131),
  BigInt.from(137),
  BigInt.from(139),
  BigInt.from(149),
  BigInt.from(151),
  BigInt.from(157),
  BigInt.from(163),
  BigInt.from(167),
  BigInt.from(173),
  BigInt.from(179),
  BigInt.from(181),
  BigInt.from(191),
  BigInt.from(193),
  BigInt.from(197),
  BigInt.from(199),
  BigInt.from(211),
  BigInt.from(223),
  BigInt.from(227),
  BigInt.from(229),
  BigInt.from(233),
  BigInt.from(239),
  BigInt.from(241),
  BigInt.from(251),
  BigInt.from(257),
  BigInt.from(263),
  BigInt.from(269),
  BigInt.from(271),
  BigInt.from(277),
  BigInt.from(281),
  BigInt.from(283),
  BigInt.from(293),
  BigInt.from(307),
  BigInt.from(311),
  BigInt.from(313),
  BigInt.from(317),
  BigInt.from(331),
  BigInt.from(337),
  BigInt.from(347),
  BigInt.from(349),
  BigInt.from(353),
  BigInt.from(359),
  BigInt.from(367),
  BigInt.from(373),
  BigInt.from(379),
  BigInt.from(383),
  BigInt.from(389),
  BigInt.from(397),
  BigInt.from(401),
  BigInt.from(409),
  BigInt.from(419),
  BigInt.from(421),
  BigInt.from(431),
  BigInt.from(433),
  BigInt.from(439),
  BigInt.from(443),
  BigInt.from(449),
  BigInt.from(457),
  BigInt.from(461),
  BigInt.from(463),
  BigInt.from(467),
  BigInt.from(479),
  BigInt.from(487),
  BigInt.from(491),
  BigInt.from(499),
  BigInt.from(503),
  BigInt.from(509)
];

final BigInt _lplim = (BigInt.one << 26) ~/ lowprimes.last;
final BigInt _bigTwo = BigInt.from(2);

/// return index of lowest 1-bit in x, x < 2^31
int _lbit(BigInt x) {
  // Implementation borrowed from bignum.BigIntegerDartvm.
  if (x == BigInt.zero) return -1;
  int r = 0;
  while ((x & BigInt.from(0xffffffff)) == BigInt.zero) {
    x >>= 32;
    r += 32;
  }
  if ((x & BigInt.from(0xffff)) == BigInt.zero) {
    x >>= 16;
    r += 16;
  }
  if ((x & BigInt.from(0xff)) == BigInt.zero) {
    x >>= 8;
    r += 8;
  }
  if ((x & BigInt.from(0xf)) == BigInt.zero) {
    x >>= 4;
    r += 4;
  }
  if ((x & BigInt.from(3)) == BigInt.zero) {
    x >>= 2;
    r += 2;
  }
  if ((x & BigInt.one) == BigInt.zero) ++r;
  return r;
}

/// true if probably prime (HAC 4.24, Miller-Rabin)
bool _millerRabin(BigInt b, int t) {
  // Implementation borrowed from bignum.BigIntegerDartvm.
  var n1 = b - BigInt.one;
  var k = _lbit(n1);
  if (k <= 0) return false;
  var r = n1 >> k;
  t = (t + 1) >> 1;
  if (t > lowprimes.length) t = lowprimes.length;
  BigInt a;
  for (var i = 0; i < t; ++i) {
    a = lowprimes[i];
    var y = a.modPow(r, b);
    if (y.compareTo(BigInt.one) != 0 && y.compareTo(n1) != 0) {
      var j = 1;
      while (j++ < k && y.compareTo(n1) != 0) {
        y = y.modPow(_bigTwo, b);
        if (y.compareTo(BigInt.one) == 0) return false;
      }
      if (y.compareTo(n1) != 0) return false;
    }
  }
  return true;
}

/// test primality with certainty >= 1-.5^t
bool isProbablePrime(BigInt b, int t) {
  // Implementation borrowed from bignum.BigIntegerDartvm.
  var i, x = b.abs();
  if (b <= lowprimes.last) {
    for (i = 0; i < lowprimes.length; ++i) {
      if (b == lowprimes[i]) {
        return true;
      }
    }
    return false;
  }
  if (x.isEven) return false;
  i = 1;
  while (i < lowprimes.length) {
    var m = lowprimes[i], j = i + 1;
    while (j < lowprimes.length && m < _lplim) {
      m *= lowprimes[j++];
    }
    m = x % m;
    while (i < j) {
      if ((m % lowprimes[i++]).toInt() == 0) {
        return false;
      }
    }
  }
  return _millerRabin(x, t);
}
