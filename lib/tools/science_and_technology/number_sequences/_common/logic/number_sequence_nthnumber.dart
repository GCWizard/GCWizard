part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class GetNumberAtJobData {
  final NumberSequencesMode sequence;
  final int n;

  GetNumberAtJobData({
    required this.sequence,
    required this.n,
  });
}

  Future<BigInt> calculateNumberAtAsync(GCWAsyncExecuterParameters? jobData) async {
    if (jobData?.parameters is! GetNumberAtJobData) return BigInt.from(-1);

    var data = jobData!.parameters as GetNumberAtJobData;
    var output = await _calculateNumberAt(data.sequence, data.n, sendAsyncPort: jobData.sendAsyncPort);

    jobData.sendAsyncPort?.send(output);

    return output;
  }

  Future<BigInt> _calculateNumberAt(NumberSequencesMode sequence, int n,
      {SendPort? sendAsyncPort}) async {

    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));

   return result[0];
  }

