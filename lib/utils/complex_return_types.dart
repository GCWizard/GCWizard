class DoubleText {
  String text;
  double value;

  DoubleText(this.text, this.value);

  @override
  String toString() {
    return 'Text: $text, Value: $value';
  }
}

class IntegerText {
  String text;
  int value;

  IntegerText(this.text, this.value);
}

class BoolText {
  String text;
  bool value;

  BoolText(this.text, this.value);
}

class IntegerListText {
  String text;
  List<int> value;

  IntegerListText(this.text, this.value);
}

class DateTimeDuration extends DateTimeTimezone{
  Duration duration;

  DateTimeDuration({required DateTime dateTime, required Duration timezone, required this.duration})
      : super(datetime: dateTime, timezone: timezone);
}

class DateTimeTimezone {
  DateTime datetime;
  Duration timezone;

  DateTimeTimezone({required this.datetime, required this.timezone});
}

class DateTimeDouble {
  DateTime datetime;
  double value;

  DateTimeDouble({required this.datetime, required this.value});
}