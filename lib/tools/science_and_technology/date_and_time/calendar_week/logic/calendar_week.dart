import 'package:tuple/tuple.dart';
import 'package:week_of_year/week_of_year.dart';

int _isoWeek(DateTime date) {
  return date.weekOfYear;
}

//inspired by and mainly ported from https://stackoverflow.com/a/34370689/3984221
int _getUSweekNumber(DateTime date) {
  var y = date.year;

  //January 1st this year
  var beginOfThisYear = DateTime(y, 1, 1);
  var dayOfWeek = beginOfThisYear.weekday % 7;

  //January 1st next year
  var beginOfNextYear = DateTime(y + 1, 1, 1);
  var dayOfWeekNextYear = beginOfNextYear.weekday % 7;

  //Provided date
  var currentDay = date;
  var oneDay = Duration.millisecondsPerDay;
  var numberOfDays = 1 + (currentDay.millisecondsSinceEpoch - beginOfThisYear.millisecondsSinceEpoch) ~/ oneDay;

  int weekNr;

  if (currentDay.millisecondsSinceEpoch >= (beginOfNextYear.millisecondsSinceEpoch - (oneDay * dayOfWeekNextYear))) {
    //First week of next year
    weekNr = 1;
  } else {
    //Shift week so 1-7 are week 1, then get week number
    weekNr = ((numberOfDays + dayOfWeek) / 7).ceil();
  }
  return weekNr;
}

int calendarWeek(DateTime date, {bool iso = true}) {
  if (iso) {
    return _isoWeek(date);
  } else {
    return _getUSweekNumber(date);
  }
}

Tuple2<DateTime, DateTime> datesForCalendarWeek(int year, int calendarWeek, {bool iso = true}) {
  DateTime? start;
  DateTime? end;
  DateTime _dateToCheck = DateTime(year, calendarWeek < 10 ? 1 : 2, 1);
  DateTime _lastDateToCheck = DateTime(year + 1, 1, 10);
  int week = 0;
  while (end == null || week == calendarWeek) {
    if (iso) {
      week = _isoWeek(_dateToCheck);
    } else {
      week = _getUSweekNumber(_dateToCheck);
    }

    if (week == calendarWeek) {
      end = _dateToCheck;
    }

    _dateToCheck = _dateToCheck.add(const Duration(days: 1));
    if (_dateToCheck.compareTo(_lastDateToCheck) >= 0) {
      throw Exception('dates_calendarweek_error_invalidweek');
    }
  }

  start = end.add(const Duration(days: -6));

  return Tuple2(start, end);
}
