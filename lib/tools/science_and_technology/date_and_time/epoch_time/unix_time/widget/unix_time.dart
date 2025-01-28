import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/logic/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/widget/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/unix_time/logic/unix_time.dart';

class UnixTime extends EpochTime {
  const UnixTime({Key? key})
      : super(
            key: key,
            min: 0,
            max: 864000000000, //max days in seconds according to DateTime https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
            epochType: EPOCH_TIMES.UNIX,
            timestampIsInt: true,
            epochToDate: UnixTimeToDateTimeUTC,
            dateToEpoch: DateTimeUTCToUnixTime);
}