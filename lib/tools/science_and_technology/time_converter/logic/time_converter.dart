class ConvertTimesOutput {
  final double weeks;
  final double days;
  final double hours;
  final double minutes;
  final double seconds;

  ConvertTimesOutput(
      this.weeks, this.days, this.hours, this.minutes, this.seconds);
}

const _SECONDS_IN_MINUTE = 60;
const _SECONDS_IN_HOUR = 60 * _SECONDS_IN_MINUTE;
const _SECONDS_IN_DAY = 24 * _SECONDS_IN_HOUR;
const _SECONDS_IN_WEEK = 7 * _SECONDS_IN_DAY;

ConvertTimesOutput convertTimes(
    double weeks, double days, double hours, double minutes, double seconds) {
  int weeksInt = weeks.floor() * _SECONDS_IN_WEEK;
  int daysInt = days.floor() * _SECONDS_IN_DAY;
  int hoursInt = hours.floor() * _SECONDS_IN_HOUR;
  int minutesInt = minutes.floor() * _SECONDS_IN_MINUTE;
  int secondsInt = seconds.floor();

  double weeksFrac = (weeks - weeks.truncate()) * _SECONDS_IN_WEEK;
  double daysFrac = (days - days.truncate()) * _SECONDS_IN_DAY;
  double hoursFrac = (hours - hours.truncate()) * _SECONDS_IN_HOUR;
  double minutesFrac = (minutes - minutes.truncate()) * _SECONDS_IN_MINUTE;
  double secondsFrac = (seconds - seconds.truncate());

  seconds =
      (weeksInt + daysInt + hoursInt + minutesInt + secondsInt).toDouble() +
          secondsFrac +
          minutesFrac +
          hoursFrac +
          daysFrac +
          weeksFrac;
  minutes = seconds / _SECONDS_IN_MINUTE;
  hours = seconds / _SECONDS_IN_HOUR;
  days = seconds / _SECONDS_IN_DAY;
  weeks = seconds / _SECONDS_IN_WEEK;

  return ConvertTimesOutput(weeks, days, hours, minutes, seconds);
}
