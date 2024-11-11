// https://www.tippscout.de/excel-unix-timestamp-umwandeln.html
// https://learn.microsoft.com/de-de/office/troubleshoot/excel/wrongly-assumes-1900-is-leap-year

import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/logic/day_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/logic/epoch_time.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

class ExcelTimeOutput {
  final double ExcelTimeStamp;
  final DateTime GregorianDateTimeUTC;
  final String Error;

  ExcelTimeOutput({
    required this.ExcelTimeStamp,
    required this.GregorianDateTimeUTC,
    required this.Error,
  });
}

EpochTimeOutput DateTimeUTCToExcelTime(DateTime currentDateTimeUTC) {
  if (_invalidExcelDate(gregorianCalendarToJulianDate(currentDateTimeUTC))) {
    return EpochTimeOutput(error: 'dates_calendar_excel_error', timeStamp: 0, gregorianDateTimeUTC: currentDateTimeUTC);
  }

  int year = currentDateTimeUTC.year;
  int month = currentDateTimeUTC.month;
  int day = currentDateTimeUTC.day;
  int hour = currentDateTimeUTC.hour;
  int minute = currentDateTimeUTC.minute;
  int second = currentDateTimeUTC.second;

  double excelTimestampFrac = (hour * 60 * 60 + minute * 60 + second) / 86400;
  double excelTimestampInt = 0.0;

  if (year == 1900 && month == 2 && day == 29) {
    excelTimestampInt = 60.0;
  } else {
    excelTimestampInt = calculateDayDifferences(DateTime(1900, 1, 0), DateTime(year, month, day)).days.toDouble();
  }

  return EpochTimeOutput(
      timeStamp: excelTimestampInt + excelTimestampFrac, gregorianDateTimeUTC: currentDateTimeUTC, error: '');
}

EpochTimeOutput ExcelTimeToDateTimeUTC(Object excelTimestamp) {
  Duration difference;

  if ((excelTimestamp as double).truncate() == 60) {
    difference = Duration(seconds: (86400 * (excelTimestamp - excelTimestamp.truncate())).toInt());
    return EpochTimeOutput(
        gregorianDateTimeUTC: DateTime.utc(1900, 2, 29, 0, 0, 0).add(difference),
        timeStamp: excelTimestamp,
        error: 'EXCEL_BUG');
  } else if (excelTimestamp.truncate() < 60) {
    difference = Duration(days: excelTimestamp.truncate()) +
        Duration(seconds: (86400 * (excelTimestamp - excelTimestamp.truncate())).toInt());
  } else {
    difference = Duration(days: excelTimestamp.truncate()) -
        const Duration(days: 1) +
        Duration(seconds: (86400 * (excelTimestamp - excelTimestamp.truncate())).toInt());
  }
  return EpochTimeOutput(
      gregorianDateTimeUTC: DateTime.utc(1900, 1, 0, 0, 0, 0).add(difference), timeStamp: excelTimestamp, error: '');
}

bool _invalidExcelDate(double jd) {
  if (jd < JD_EXCEL_START) return true;
  return false;
}
