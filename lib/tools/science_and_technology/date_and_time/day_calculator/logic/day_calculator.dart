class DayCalculatorOutput {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  DayCalculatorOutput(this.days, this.hours, this.minutes, this.seconds);
}

DayCalculatorOutput calculateDayDifferences(DateTime start, DateTime end, {countStart: true, countEnd: true}) {
  if (start == null || end == null) return null;

  Duration difference;
  if (start.compareTo(end) == 0) {
    if (!countStart && !countEnd) return DayCalculatorOutput(0, 0, 0, 0);

    difference = Duration(days: 1);
    return DayCalculatorOutput(difference.inDays, difference.inHours, difference.inMinutes, difference.inSeconds);
  }

  if (start.isAfter(end)) {
    var temp = start;
    start = end;
    end = temp;
  }

  difference = end.difference(start);

  if (countStart != null && countStart == false) {
    var newDifference = difference - Duration(days: 1);
    if (newDifference.inHours >= -1) // -1 is valid on daylight saving time change days
      difference = newDifference;
  }

  if (countEnd != null && countEnd == true) difference += Duration(days: 1);

  var seconds = difference.inSeconds;
  var minutes = difference.inMinutes;
  var hours = difference.inHours;

  /*
    days = difference.inDays is not taken because of problems with daylight saving time days:

    e.g. 2019-03-31 to 2019-04-01 is only 23h because of daylight saving time change,
    therefore this is not counted as entire day in the DateTime engine
   */
  var days = (difference.inHours / 24.0).round();

  return DayCalculatorOutput(days, hours, minutes, seconds);
}
