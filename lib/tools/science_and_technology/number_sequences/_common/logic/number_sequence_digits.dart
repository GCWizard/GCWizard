part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

List<BigInt> numberSequencesGetNumbersWithNDigits(NumberSequencesMode sequence, int? digits) {
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
      case NumberSequencesMode.BUSY_BEAVER:
        sequenceList.addAll(busy_beaver_numbers);
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
