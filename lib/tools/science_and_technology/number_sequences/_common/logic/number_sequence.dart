// https://de.wikipedia.org/wiki/Lucas-Folge
// could build not recursive
// https://oeis.org/A000225   Mersenne
// https://oeis.org/A000051   Mersenne-like with Fermat-numbers
// https://oeis.org/A000251   Fermat
// https://oeis.org/A000108   Catalan
// https://oeis.org/A001045   Jacobsthal
// https://oeis.org/A014551   Jacobsthal-Lucas
// https://oeis.org/A084175   Jacobsthal-Oblong
// should be build recursive
// https://oeis.org/A000032   Lucas
// https://oeis.org/A000045   Fibonacci
// https://oeis.org/A000129   Pell
// https://oeis.org/A002203   Pell-Lucas
//
// recursive sequences
// https://oeis.org/A005132   Recamán
// https://oeis.org/A000142   Factorial
// https://oeis.org/A000110   Bell                B(n) = summe von (n-1 über k)*B8k) für k = 0 bis n-1
//
// https://oeis.org/A081357   Sublime numbers
// https://oeis.org/A000396   Perfect numbers
// https://oeis.org/A019279   Superperfect numbers
// https://oeis.org/A054377   Pseudoperfect numbers
// https://oeis.org/A006037   Weird numbers
// https://oeis.org/A000668   Mersenne primes
// https://oeis.org/A000043   Mersenne exponents
// https://oeis.org/A023108   Lychrel numbers
//
// suggestions - https://en.wikipedia.org/wiki/List_of_integer_sequences
// https://oeis.org/A008336   RecamánII           a(n+1) = a(n)/n if n|a(n) else a(n)*n, a(1) = 1.
// https://oeis.org/A000058   Sylvester           a(n) = 1 + a(0)*a(1)*...*a(n-1)

import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/happy_numbers/logic/list_happy_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lucky_numbers/logic/list_lucky_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lychrel/logic/list_lychrel_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_exponents/logic/list_mersenne_exponents.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_primes/logic/list_mersenne_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/perfect_numbers/logic/list_perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/permutable_primes/logic/list_permutable_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primarypseudoperfect_numbers/logic/list_primary_pseudo_perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sublime_numbers/logic/list_sublime_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/superperfect_numbers/logic/list_super_perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/weird_numbers/logic/list_weird_numbers.dart';

class PositionOfSequenceOutput {
  final String number;
  final int positionSequence;
  final int positionDigits;
  PositionOfSequenceOutput(this.number, this.positionSequence, this.positionDigits);
}

enum NumberSequencesMode {
  LUCAS,
  FIBONACCI,
  MERSENNE,
  MERSENNE_FERMAT,
  FERMAT,
  JACOBSTAHL,
  JACOBSTHAL_LUCAS,
  JACOBSTHAL_OBLONG,
  PELL,
  PELL_LUCAS,
  CATALAN,
  RECAMAN,
  BELL,
  FACTORIAL,
  MERSENNE_PRIMES,
  MERSENNE_EXPONENTS,
  PERFECT_NUMBERS,
  SUPERPERFECT_NUMBERS,
  PRIMARY_PSEUDOPERFECT_NUMBERS,
  WEIRD_NUMBERS,
  SUBLIME_NUMBERS,
  LYCHREL,
  PERMUTABLE_PRIMES,
  LUCKY_NUMBERS,
  HAPPY_NUMBERS,
}

final Zero = BigInt.zero;
final One = BigInt.one;
final Two = BigInt.two;
final Three = BigInt.from(3);
final sqrt5 = sqrt(5);
final sqrt2 = sqrt(2);

BigInt _getMersenneFermat(int n) {
  return Two.pow(n) + One;
}

BigInt _getFermat(int n) {
  return Two.pow(pow(2, n) as int) + One;
}

BigInt _getMersenne(int n) {
  return Two.pow(n) - One;
}

BigInt _getCatalan(int n) {
  if (n == 0) return BigInt.one;

  try {
    return _getBinomialCoefficient(2 * n, n) ~/ (BigInt.from(n) + One);
  } catch (e) {
    return BigInt.from(-1);
  }
}

BigInt _getJacobsthal(int n) {
  return (Two.pow(n) - BigInt.from(-1).pow(n)) ~/ Three;
}

BigInt _getJacobsthalLucas(int n) {
  return Two.pow(n) + BigInt.from(-1).pow(n);
}

BigInt _getJacobsthalOblong(int n) {
  return _getJacobsthal(n) * _getJacobsthal(n + 1);
}

BigInt _getfactorial(int n) {
  if (n > 0) {
    return n <= 1 ? One : BigInt.from(n) * _getfactorial(n - 1);
  } else {
    return One;
  }
}

BigInt _getBinomialCoefficient(int n, int k) {
  if (n == k) {
    return Zero;
  } else {
    return _getfactorial(n) ~/ _getfactorial(k) ~/ _getfactorial(n - k);
  }
}

BigInt Function(int)? _getNumberSequenceFunction(NumberSequencesMode mode) {
  switch (mode) {
    case NumberSequencesMode.FERMAT:
      return _getFermat;
    case NumberSequencesMode.MERSENNE:
      return _getMersenne;
    case NumberSequencesMode.MERSENNE_FERMAT:
      return _getMersenneFermat;
    case NumberSequencesMode.CATALAN:
      return _getCatalan;
    case NumberSequencesMode.JACOBSTAHL:
      return _getJacobsthal;
    case NumberSequencesMode.JACOBSTHAL_LUCAS:
      return _getJacobsthalLucas;
    case NumberSequencesMode.JACOBSTHAL_OBLONG:
      return _getJacobsthalOblong;
    default:
      return null;
  }
}

BigInt getNumberAt(NumberSequencesMode sequence, int? n) {
  if (n == null) {
    return Zero;
  } else {
    return getNumbersInRange(sequence, n, n)[0];
  }
}

List<BigInt> getNumbersInRange(NumberSequencesMode sequence, int? start, int? stop) {
  if (start == null || stop == null) return [BigInt.from(-1)];

  List<BigInt> numberList = [];
  List<String> sequenceList = <String>[];

  var numberSequenceFunction = _getNumberSequenceFunction(sequence);
  if (numberSequenceFunction != null) {
    for (int i = start; i <= stop; i++) {
      numberList.add(numberSequenceFunction(i));
    }
  } else if (sequence == NumberSequencesMode.FIBONACCI) {
    BigInt number;
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    int index = 0;
    while (index < stop + 1) {
      if (index == 0) {
        number = Zero;
      } else if (index == 1) {
        number = One;
      } else {
        number = pn0 + pn1;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= start) numberList.add(number);
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.PELL) {
    BigInt number;
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    int index = 0;
    while (index <= stop) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = Two * pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= start) numberList.add(number);
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.PELL_LUCAS) {
    BigInt number;
    BigInt pn0 = Two;
    BigInt pn1 = Two;
    int index = 0;
    while (index < stop + 1) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = Two * pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= start) numberList.add(number);
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.LUCAS) {
    BigInt number;
    BigInt pn0 = Two;
    BigInt pn1 = One;
    int index = 0;
    while (index <= stop) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = pn0 + pn1;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= start) numberList.add(number);
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.RECAMAN) {
    List<BigInt> recamanSequence = <BigInt>[];
    BigInt number;
    BigInt pn0 = Zero;
    BigInt index = Zero;
    recamanSequence.add(Zero);
    index = Zero;
    while (index < BigInt.from(stop) + One) {
      if (index == Zero) {
        number = pn0;
      } else if ((pn0 - index) > Zero && !recamanSequence.contains(pn0 - index)) {
        number = pn0 - index;
      } else {
        number = pn0 + index;
      }
      recamanSequence.add(number);
      pn0 = number;
      if (index >= BigInt.from(start)) numberList.add(number);
      index = index + One;
    }
  } else if (sequence == NumberSequencesMode.FACTORIAL) {
    var number = BigInt.zero;
    int index = 0;
    while (index < stop + 1) {
      if (index == 0) {
        number = One;
      } else if (index == 1) {
        number = One;
      } else {
        number = number * BigInt.from(index);
      }
      if (index >= start) numberList.add(number);
      index++;
    }
  } else if (sequence == NumberSequencesMode.BELL) {
    List<BigInt> bellList = <BigInt>[];
    var number = BigInt.zero;
    int index = 0;
    while (index <= stop) {
      if (index == 0) {
        number = One;
      } else {
        for (int k = 0; k <= index - 1; k++) {
          number = number + _getBinomialCoefficient(index - 1, k) * bellList[k];
        }
      }
      bellList.add(number);
      if (index >= start) numberList.add(number);
      index = index + 1;
    }
  } else {
    switch (sequence) {
      case NumberSequencesMode.MERSENNE_PRIMES:
        sequenceList.addAll(mersenne_primes);
        break;
      case NumberSequencesMode.MERSENNE_EXPONENTS:
        sequenceList.addAll(mersenne_exponents);
        break;
      case NumberSequencesMode.PERFECT_NUMBERS:
        sequenceList.addAll(perfect_numbers);
        break;
      case NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS:
        sequenceList.addAll(primary_pseudo_perfect_numbers);
        break;
      case NumberSequencesMode.SUPERPERFECT_NUMBERS:
        sequenceList.addAll(superperfect_numbers);
        break;
      case NumberSequencesMode.SUBLIME_NUMBERS:
        sequenceList.addAll(sublime_number);
        break;
      case NumberSequencesMode.WEIRD_NUMBERS:
        sequenceList.addAll(weird_numbers);
        break;
      case NumberSequencesMode.LYCHREL:
        sequenceList.addAll(lychrel_numbers);
        break;
      case NumberSequencesMode.PERMUTABLE_PRIMES:
        sequenceList.addAll(permutable_primes);
        break;
      case NumberSequencesMode.LUCKY_NUMBERS:
        sequenceList.addAll(lucky_numbers);
        break;
      case NumberSequencesMode.HAPPY_NUMBERS:
        sequenceList.addAll(happy_numbers);
        break;
      default: {}
    }
    for (int i = start; i <= stop; i++) {
      numberList.add(BigInt.parse(sequenceList[i]));
    }
  }

  return numberList;
}

int checkNumber(NumberSequencesMode sequence, BigInt? checkNumber, int maxIndex) {
  if (checkNumber == null) {
    return -1;
  } else if (getFirstPositionOfSequence(sequence, checkNumber.toString(), maxIndex).positionSequence == -1) {
    return -1;
  } else if (getFirstPositionOfSequence(sequence, checkNumber.toString(), maxIndex).positionDigits == 1) {
    return getFirstPositionOfSequence(sequence, checkNumber.toString(), maxIndex).positionSequence;
  } else {
    return -1;
  }
}

PositionOfSequenceOutput getFirstPositionOfSequence(NumberSequencesMode sequence, String? check, int maxIndex) {
  if (check == null || check.isEmpty) {
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  BigInt number = Zero;

  BigInt pn0 = Zero;
  BigInt pn1 = One;
  int index = 0;
  String numberString = '';
  List<String> sequenceList = <String>[];

  RegExp expr = RegExp(r'(' + check + ')');

  var numberSequenceFunction = _getNumberSequenceFunction(sequence);
  if (numberSequenceFunction != null) {
    while (index <= maxIndex) {
      number = numberSequenceFunction(index);
      numberString = number.toString();
      if (numberString.contains(check)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index, (j + 1));
      }
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.FIBONACCI) {
    pn0 = Zero;
    pn1 = One;
    number = pn1;
    if (check == Zero.toString()) {
      return PositionOfSequenceOutput('0', 0, 1);
    } else if (check == One.toString()) {
      return PositionOfSequenceOutput('1', 1, 1);
    } else {
      index = 2;
      while (index <= maxIndex) {
        number = pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
        numberString = number.toString();
        if (expr.hasMatch(numberString)) {
          int j = 0;
          while (!numberString.substring(j).startsWith(check)) {
            j++;
          }
          return PositionOfSequenceOutput(numberString, index, j + 1);
        }
        index = index + 1;
      }
    }
  } else if (sequence == NumberSequencesMode.PELL) {
    pn0 = Zero;
    pn1 = One;
    number = pn1;
    if (check == Zero.toString()) {
      return PositionOfSequenceOutput('0', 0, 1);
    } else if (check == One.toString()) {
      return PositionOfSequenceOutput('1', 1, 1);
    } else {
      index = 2;
      while (index <= maxIndex) {
        number = Two * pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
        numberString = number.toString();
        if (expr.hasMatch(numberString)) {
          int j = 0;
          while (!numberString.substring(j).startsWith(check)) {
            j++;
          }
          return PositionOfSequenceOutput(numberString, index, j + 1);
        }
        index = index + 1;
      }
    }
  } else if (sequence == NumberSequencesMode.PELL_LUCAS) {
    if (check == Two.toString()) {
      return PositionOfSequenceOutput('2', 0, 1);
    }
    pn0 = Two;
    pn1 = Two;
    number = pn1;
    index = 2;
    while (index <= maxIndex) {
      number = Two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      numberString = number.toString();
      if (expr.hasMatch(numberString)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index, j + 1);
      }
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.LUCAS) {
    pn0 = Two;
    pn1 = One;
    if (check == Two.toString()) {
      return PositionOfSequenceOutput('2', 0, 1);
    } else if ((check == One.toString())) {
      return PositionOfSequenceOutput('1', 1, 1);
    } else {
      index = 1;
      number = Three;
      while (index <= maxIndex) {
        numberString = number.toString();
        if (expr.hasMatch(numberString)) {
          int j = 0;
          while (!numberString.substring(j).startsWith(check)) {
            j++;
          }
          return PositionOfSequenceOutput(numberString, index, j + 1);
        }
        index = index + 1;
        number = pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
      }
    }
  } else if (sequence == NumberSequencesMode.RECAMAN) {
    List<int> recamanSequence = <int>[];
    int index = 0;
    int maxIndex = 111111;
    int pn0 = 0;
    int number = 0;
    recamanSequence.add(0);
    while (index <= maxIndex) {
      if (index == 0) {
        number = 0;
      } else if ((pn0 - index) > 0 && !recamanSequence.contains(pn0 - index)) {
        number = pn0 - index;
      } else {
        number = pn0 + index;
      }
      recamanSequence.add(number);
      pn0 = number;
      numberString = number.toString();
      if (expr.hasMatch(numberString)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index, j + 1);
      }
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.FACTORIAL) {
    number = One;
    if (check == Zero.toString()) {
      return PositionOfSequenceOutput('0', 0, 1);
    } else if (check == One.toString()) {
      return PositionOfSequenceOutput('1', 1, 1);
    } else {
      index = 2;
      while (index <= maxIndex) {
        number = number * BigInt.from(index);
        numberString = number.toString();
        if (expr.hasMatch(numberString)) {
          int j = 0;
          while (!numberString.substring(j).startsWith(check)) {
            j++;
          }
          return PositionOfSequenceOutput(numberString, index, j + 1);
        }
        index = index + 1;
      }
    }
  } else if (sequence == NumberSequencesMode.BELL) {
    List<BigInt> bellList = <BigInt>[];
    while (index <= maxIndex) {
      if (index == 0) {
        number = One;
      } else {
        for (int k = 0; k <= index - 1; k++) {
          number = number + _getBinomialCoefficient(index - 1, k) * bellList[k];
        }
      }
      bellList.add(number);
      numberString = number.toString();
      if (expr.hasMatch(numberString)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index, j + 1);
      }
      index = index + 1;
    }
  } else {
    switch (sequence) {
      case NumberSequencesMode.MERSENNE_PRIMES:
        sequenceList.addAll(mersenne_primes);
        break;
      case NumberSequencesMode.MERSENNE_EXPONENTS:
        sequenceList.addAll(mersenne_exponents);
        break;
      case NumberSequencesMode.PERFECT_NUMBERS:
        sequenceList.addAll(perfect_numbers);
        break;
      case NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS:
        sequenceList.addAll(primary_pseudo_perfect_numbers);
        break;
      case NumberSequencesMode.SUPERPERFECT_NUMBERS:
        sequenceList.addAll(superperfect_numbers);
        break;
      case NumberSequencesMode.SUBLIME_NUMBERS:
        sequenceList.addAll(sublime_number);
        break;
      case NumberSequencesMode.WEIRD_NUMBERS:
        sequenceList.addAll(weird_numbers);
        break;
      case NumberSequencesMode.LYCHREL:
        sequenceList.addAll(lychrel_numbers);
        break;
      case NumberSequencesMode.PERMUTABLE_PRIMES:
        sequenceList.addAll(permutable_primes);
        break;
      case NumberSequencesMode.LUCKY_NUMBERS:
        sequenceList.addAll(lucky_numbers);
        break;
      case NumberSequencesMode.HAPPY_NUMBERS:
        sequenceList.addAll(happy_numbers);
        break;
      default: {}
    }
    for (int i = 0; i < sequenceList.length; i++) {
      if (expr.hasMatch(sequenceList[i])) {
        int j = 0;
        while (!sequenceList[i].substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(sequenceList[i], i, j + 1);
      }
    }
  }

  return PositionOfSequenceOutput('-1', 0, 0);
}

List<BigInt> getNumbersWithNDigits(NumberSequencesMode sequence, int? digits) {
  if (digits == null) return [];

  BigInt number;

  var numberList = <BigInt>[];
  var sequenceList = <String>[];

  var numberSequenceFunction = _getNumberSequenceFunction(sequence);
  if (numberSequenceFunction != null) {
    int index = 0;
    number = Two;
    while (number.toString().length < digits + 1) {
      number = numberSequenceFunction(index);
      if (number.toString().length == digits) numberList.add(number);
      index = index + 1;
    }
  } else if (sequence == NumberSequencesMode.FIBONACCI) {
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    if (digits == 1) {
      numberList.add(pn0);
      numberList.add(pn1);
    }
    number = pn1;
    while (number.toString().length < digits + 1) {
      number = pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
  } else if (sequence == NumberSequencesMode.PELL) {
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    if (digits == 1) {
      numberList.add(pn0);
      numberList.add(pn1);
    }
    number = pn1;
    while (number.toString().length < digits + 1) {
      number = Two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
  } else if (sequence == NumberSequencesMode.PELL_LUCAS) {
    BigInt pn0 = Two;
    BigInt pn1 = Two;
    if (digits == 1) {
      numberList.add(pn0);
      numberList.add(pn1);
    }
    number = pn1;
    while (number.toString().length < digits + 1) {
      number = Two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
  } else if (sequence == NumberSequencesMode.LUCAS) {
    BigInt pn0 = Two;
    BigInt pn1 = One;
    if (digits == 1) {
      numberList.add(pn0);
      numberList.add(pn1);
    }
    number = pn1;
    while (number.toString().length < digits + 1) {
      number = pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
  } else if (sequence == NumberSequencesMode.RECAMAN) {
    BigInt pn0 = Zero;
    List<BigInt> recamanSequence = <BigInt>[];
    for (int index = 0; index < 11111; index++) {
      if (index == 0) {
        number = Zero;
      } else if ((pn0 - BigInt.from(index)) > Zero && !recamanSequence.contains(pn0 - BigInt.from(index))) {
        number = pn0 - BigInt.from(index);
      } else {
        number = pn0 + BigInt.from(index);
      }
      recamanSequence.add(number);
      pn0 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
  } else if (sequence == NumberSequencesMode.FACTORIAL) {
    BigInt index = BigInt.from(4);
    if (digits == 1) {
      numberList.add(One);
      numberList.add(Two);
      numberList.add(BigInt.from(6));
    }
    number = BigInt.from(6);
    while (number.toString().length < digits + 1) {
      number = number * index;
      if (number.toString().length == digits) numberList.add(number);
      index = index + One;
    }
  } else if (sequence == NumberSequencesMode.BELL) {
    List<BigInt> bellList = <BigInt>[];
    BigInt number = One;
    int index = 0;
    while (number.toString().length < digits + 1) {
      if (index == 0) {
        number = One;
      } else {
        for (int k = 0; k <= index - 1; k++) {
          number = number + _getBinomialCoefficient(index - 1, k) * bellList[k];
        }
      }
      bellList.add(number);
      if (number.toString().length == digits) numberList.add(number);
      index = index + 1;
    }
  } else {
    switch (sequence) {
      case NumberSequencesMode.MERSENNE_PRIMES:
        sequenceList.addAll(mersenne_primes);
        break;
      case NumberSequencesMode.MERSENNE_EXPONENTS:
        sequenceList.addAll(mersenne_exponents);
        break;
      case NumberSequencesMode.PERFECT_NUMBERS:
        sequenceList.addAll(perfect_numbers);
        break;
      case NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS:
        sequenceList.addAll(primary_pseudo_perfect_numbers);
        break;
      case NumberSequencesMode.SUPERPERFECT_NUMBERS:
        sequenceList.addAll(superperfect_numbers);
        break;
      case NumberSequencesMode.SUBLIME_NUMBERS:
        sequenceList.addAll(sublime_number);
        break;
      case NumberSequencesMode.WEIRD_NUMBERS:
        sequenceList.addAll(weird_numbers);
        break;
      case NumberSequencesMode.LYCHREL:
        sequenceList.addAll(lychrel_numbers);
        break;
      case NumberSequencesMode.PERMUTABLE_PRIMES:
        sequenceList.addAll(permutable_primes);
        break;
      case NumberSequencesMode.LUCKY_NUMBERS:
        sequenceList.addAll(lucky_numbers);
        break;
      case NumberSequencesMode.HAPPY_NUMBERS:
        sequenceList.addAll(happy_numbers);
        break;
      default:
        return numberList;
    }
    for (int i = 0; i < sequenceList.length; i++) {
      if (sequenceList[i].length == digits) {
        var value = BigInt.tryParse(sequenceList[i]);
        if (value != null) numberList.add(value);
      }
    }
  }

  return numberList;
}
