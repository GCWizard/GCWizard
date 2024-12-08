import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/logic/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/widget/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/unix_time/logic/unix_time.dart';
import 'package:gc_wizard/utils/constants.dart';

class UnixTime extends EpochTime {
  const UnixTime({Key? key})
      : super(
            key: key,
            min: 0,
            max: MAX_INT,
            epochType: EPOCH_TIMES.UNIX,
            timestampIsInt: true,
            epochToDate: UnixTimeToDateTimeUTC,
            dateToEpoch: DateTimeUTCToUnixTime);
}
