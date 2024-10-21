enum EPOCH_TIMES {EXCEL1900, EXCEL1904, UNIX}

class EpochTimeOutput {
  final double timeStamp;
  final DateTime gregorianDateTimeUTC;
  final String error;

  EpochTimeOutput({
    required this.timeStamp,
    required this.gregorianDateTimeUTC,
    required this.error,
  });
}