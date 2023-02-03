// Gregorian Easter: Jean Meeus, Astronomical Algorithms, p. 67

DateTime gregorianEasterDate(int year) {
  var a = year % 19;
  var b = (year / 100).floor();
  var c = year % 100.0;
  var d = (b / 4).floor();
  var e = b % 4;
  var f = ((b + 8) / 25).floor();
  var g = ((b - f + 1) / 3).floor();
  var h = (19 * a + b - d - g + 15) % 30;
  var i = (c / 4).floor();
  var k = c % 4;
  var l = (32 + 2 * e + 2 * i - h - k) % 7;
  var m = ((a + 11 * h + 22 * l) / 451).floor();
  var n = ((h + l - 7 * m + 114) / 31).floor();
  var p = (h + l - 7 * m + 114) % 31;
  p = p + 1;

  return DateTime(year, n, p.floor());
}

List<int> gregorianEasterYears(int theMonth, int theDay) {
  var year1 = 1583;
  var year2 = 3042;

  var years = <int>[];
  for (int y = year1; y <= year2; y++) {
    var easterDate = gregorianEasterDate(y);
    if (easterDate.month == theMonth && easterDate.day == theDay) years.add(easterDate.year);
  }

  return years;
}
