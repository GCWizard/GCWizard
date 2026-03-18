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
  var output = calculateRange(data.sequence, data.start, data.stop);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<BigInt> calculateRange(NumberSequencesMode sequence, int start, int stop) {

  return NUMBERSEQUENCES[sequence]!.sequence.calculateRange(start, stop);
}