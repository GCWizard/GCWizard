import 'package:week_of_year/week_of_year.dart';

class DayOfTheYearOutput {
  final DateTime date;
  final int dayNumber;
  final int weekday;
  final int weekNumberIso;
  final int weekdayAlternate;
  final int weekNumberAlternate;

  DayOfTheYearOutput(
      this.date, this.dayNumber, this.weekday, this.weekdayAlternate, this.weekNumberIso, this.weekNumberAlternate);
}

DayOfTheYearOutput calculateDayInfos(int year, int day) {
  var date = DateTime(year, 1, day);

  return calculateDateInfos(date);
}

DayOfTheYearOutput calculateDateInfos(DateTime date) {
  return DayOfTheYearOutput(date, dayNumber(date), date.weekday, _weekdayAlternate(date.weekday), isoWeekOfYear(date),
      alternateWeekOfYear(date));
}

int _weekdayAlternate(int weekday) {
  weekday = (weekday + 1) % 7;
  return weekday == 0 ? 7 : weekday;
}

int isoWeekOfYear(DateTime date) {
  return date.weekOfYear;
}

int alternateWeekOfYear(DateTime date) {
  // Get the monday of week 1
  final DateTime mondayWeek1 = _alternateWeek1Monday(date);

  // If this date is before the first week of the year, it is the same week as the last week of the previous year.
  if (date.isBefore(mondayWeek1)) {
    return alternateWeekOfYear(DateTime(date.year - 1, 12, 31));
  }

  final int ordinalWeek1Monday = _ordinalDate(mondayWeek1);
  final int ordinal = _ordinalDate(date);

  // Calculate number of days after monday week 1
  int diffInDays = ordinal - ordinalWeek1Monday;

  // If the monday occurs on the previous year, we'll need to add a year to the diff
  if (date.year > mondayWeek1.year) {
    diffInDays += 365;
    // If it's a leap year and the leap day is before the date checked, add an extra day
    if (_isLeapYear(date) && DateTime(date.year, 2, 29).isBefore(date)) {
      diffInDays += 1;
    }
  }

  // Divide the difference by 7 to get the number of weeks
  int week = (diffInDays ~/ 7) + 1;

  // On Sunday add 1.
  if (date.weekday == 7) {
    return week + 1;
  }
  return week;
}

/// Calculates the ordinal date
/// The ordinal date is the number of days since December 31st the previous year.
/// January 1st has the ordinal date 1
/// December 31st has the ordinal date 365, or 366 in leap years
int _ordinalDate(DateTime date) {
  return date.ordinalDate;
}

/// Check if this date is on a leap year
bool _isLeapYear(DateTime date) {
  return date.isLeapYear;
}

/// Gets the date of the monday of Alternate week 1 this year
DateTime _alternateWeek1Monday(DateTime date) {
  final jan1 = DateTime(date.year, 1, 1); // Jan 1 is always in week 1

  return DateTime(
    jan1.year,
    jan1.month,
    jan1.day - jan1.weekday + 1,
  );
}

/// calc day in the year
int dayNumber(DateTime date) {
  return date.difference(DateTime(date.year)).inDays + 1;
}
