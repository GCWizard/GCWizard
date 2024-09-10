part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class GetNumberRangeJobData{
  final NumberSequencesMode sequence;
  final int start;
  final int stop;

  GetNumberRangeJobData({
    required this.sequence,
    required this.start,
    required this.stop,
  });
}

Future<List<BigInt>> calculateRangeAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! GetNumberRangeJobData) return [];

  var data = jobData!.parameters as GetNumberRangeJobData;
  var output = await calculateRange(data, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<List<BigInt>> calculateRange(GetNumberRangeJobData data,
    {SendPort? sendAsyncPort}) async {

  List<BigInt> numberList = [];
  List<String> sequenceList = <String>[];

  var numberSequenceFunction = _getNumberSequenceFunction(data.sequence);
  if (numberSequenceFunction != null) {
    for (int i = data.start; i <= data.stop; i++) {
      numberList.add(numberSequenceFunction(i));
    }
  } else if (data.sequence == NumberSequencesMode.FIBONACCI) {
    BigInt number;
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    int index = 0;
    while (index < data.stop + 1) {
      if (index == 0) {
        number = Zero;
      } else if (index == 1) {
        number = One;
      } else {
        number = pn0 + pn1;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= data.start) numberList.add(number);
      index = index + 1;
    }
  } else if (data.sequence == NumberSequencesMode.PELL) {
    BigInt number;
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    int index = 0;
    while (index <= data.stop) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = Two * pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= data.start) numberList.add(number);
      index = index + 1;
    }
  } else if (data.sequence == NumberSequencesMode.PELL_LUCAS) {
    BigInt number;
    BigInt pn0 = Two;
    BigInt pn1 = Two;
    int index = 0;
    while (index < data.stop + 1) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = Two * pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= data.start) numberList.add(number);
      index = index + 1;
    }
  } else if (data.sequence == NumberSequencesMode.LUCAS) {
    BigInt number;
    BigInt pn0 = Two;
    BigInt pn1 = One;
    int index = 0;
    while (index <= data.stop) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = pn0 + pn1;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= data.start) numberList.add(number);
      index = index + 1;
    }
  } else if (data.sequence == NumberSequencesMode.RECAMAN) {
    List<BigInt> recamanSequence = <BigInt>[];
    BigInt number;
    BigInt pn0 = Zero;
    BigInt index = Zero;
    recamanSequence.add(Zero);
    index = Zero;
    while (index < BigInt.from(data.stop) + One) {
      if (index == Zero) {
        number = pn0;
      } else if ((pn0 - index) > Zero && !recamanSequence.contains(pn0 - index)) {
        number = pn0 - index;
      } else {
        number = pn0 + index;
      }
      recamanSequence.add(number);
      pn0 = number;
      if (index >= BigInt.from(data.start)) numberList.add(number);
      index = index + One;
    }
  } else if (data.sequence == NumberSequencesMode.FACTORIAL) {
    var number = BigInt.zero;
    int index = 0;
    while (index < data.stop + 1) {
      if (index == 0) {
        number = One;
      } else if (index == 1) {
        number = One;
      } else {
        number = number * BigInt.from(index);
      }
      if (index >= data.start) numberList.add(number);
      index++;
    }
  } else if (data.sequence == NumberSequencesMode.BELL) {
    List<BigInt> bellList = <BigInt>[];
    var number = BigInt.zero;
    int index = 0;
    while (index <= data.stop) {
      if (index == 0) {
        number = One;
      } else {
        for (int k = 0; k <= index - 1; k++) {
          number = number + _getBinomialCoefficient(index - 1, k) * bellList[k];
        }
      }
      bellList.add(number);
      if (index >= data.start) numberList.add(number);
      index = index + 1;
    }
  } else {
    switch (data.sequence) {
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
        {}
    }
    for (int i = data.start; i <= data.stop; i++) {
      numberList.add(BigInt.parse(sequenceList[i]));
    }
  }

  return numberList;
}