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

List<BigInt> calculateRange(int start, int stop) {

  return NUMBERSEQUENCES[data.sequence]!.sequence.calculateRange(data.start, data. );

  List<BigInt> numberList = [];
  List<String> sequenceList = <String>[];

  var numberSequenceFunction = _getNumberSequenceFunction(data.sequence);
  if (numberSequenceFunction != null) {
    for (int i = data.start; i <= data.stop; i++) {
      numberList.add(numberSequenceFunction(i));
    }
  } else if (data.sequence == NumberSequencesMode.FIBONACCI) {

  } else if (data.sequence == NumberSequencesMode.PELL) {

  } else if (data.sequence == NumberSequencesMode.PELL_LUCAS) {

  } else if (data.sequence == NumberSequencesMode.LUCAS) {

  } else if (data.sequence == NumberSequencesMode.RECAMAN) {

  } else if (data.sequence == NumberSequencesMode.FACTORIAL) {

  } else if (data.sequence == NumberSequencesMode.LOOK_AND_SAY) {

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
      case NumberSequencesMode.MEMORABLE_PRIMES:
        sequenceList.addAll(memorable_primes);
        break;
      case NumberSequencesMode.MEMORABLE_PRIMES_INDEXES:
        sequenceList.addAll(memorable_primes_indexes);
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
      case NumberSequencesMode.CARMICHAEL:
        sequenceList.addAll(carmichael_numbers);
        break;
      case NumberSequencesMode.HARSHAD:
        sequenceList.addAll(harshad_numbers);
        break;
      case NumberSequencesMode.TAXICAB:
        sequenceList.addAll(taxicab_numbers);
        break;
      case NumberSequencesMode.SPHENIC:
        sequenceList.addAll(sphenic_numbers);
        break;
      case NumberSequencesMode.BELL:
        sequenceList.addAll(bell_numbers);
        break;
      case NumberSequencesMode.LONELY:
        sequenceList.addAll(lonely_numbers);
        break;
      case NumberSequencesMode.PALINDROME_PRIMES:
        sequenceList.addAll(palindrome_primes);
        break;
      case NumberSequencesMode.SUITABLE_NUMBERS:
        sequenceList.addAll(suitable_numbers);
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