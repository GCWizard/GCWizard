import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/logic/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/widget/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/excel_time/logic/excel_time.dart';

class ExcelTime extends EpochTime {
  const ExcelTime({Key? key})
      : super(
      key: key,
      min: 0,
      max: 100000000, //max days according to DateTime https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
      epochType: EPOCH_TIMES.EXCEL1900,
      timestampIsInt: false,
      epochToDate: ExcelTimeToDateTimeUTC,
      dateToEpoch: DateTimeUTCToExcelTime);
}
