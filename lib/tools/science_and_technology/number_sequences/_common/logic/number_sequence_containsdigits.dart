part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

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

PositionOfSequenceOutput numberSequencesGetFirstPositionOfSequence(
    NumberSequencesMode sequence, String? check, int maxIndex,
    {bool checkMode = false}) {
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

  if (checkMode) {
    expr = RegExp(r'(^' + check + '\$)');
  }

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
      case NumberSequencesMode.PRIMES:
        sequenceList.addAll(prime_numbers);
        break;
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
        {}
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
