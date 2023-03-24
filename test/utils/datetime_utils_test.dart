import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/datetime_utils.dart';

void main() {
  group("Calender.JulianDateToGregorianCalendar:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 0.0, 'expectedOutput' : DateTime(-4713, 11, 24, 12)},
      {'jd' : 0.0, 'expectedOutput' : DateTime(-4713, 11, 24)},
      {'jd' : 1507231.5, 'expectedOutput' : DateTime(-586, 7, 24)},  //30.7. -586
      {'jd' : 1721419.5, 'expectedOutput' : DateTime(0, 12, 26)}, //28.12.0
      {'jd' : 1721424.5, 'expectedOutput' : DateTime(0, 12, 31)}, // 2.1.1
      {'jd' : 1741425.5, 'expectedOutput' : DateTime(55, 10, 5)}, //7.10.55
      {'jd' : 2222443.5, 'expectedOutput' : DateTime(1372, 9, 28)}, //20.9.1372
      {'jd' : 2299159.5, 'expectedOutput' : DateTime(1582, 10, 14)}, //
      {'jd' : 2299160.5, 'expectedOutput' : DateTime(1582, 10, 15)}, //
      {'jd' : 2399301.5, 'expectedOutput' : DateTime(1856, 12, 18)},
      {'jd' : 2422443.5, 'expectedOutput' : DateTime(1920, 4, 29)},
      {'jd' : 2400000.5, 'expectedOutput' : DateTime(1858, 11, 17)},
      {'jd' : 2415019.5, 'expectedOutput' : DateTime(1899, 12, 31)},
      {'jd' : 2451544.5, 'expectedOutput' : DateTime(2000, 1, 1)},
      {'jd' : 2459346.5, 'expectedOutput' : DateTime(2021, 5, 12)},
    ];
    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = julianDateToGregorianCalendar(elem['jd'] as double);

        expect(_actual.day, (elem['expectedOutput'] as DateTime).day);
        expect(_actual.month, (elem['expectedOutput'] as DateTime).month);
        expect(_actual.year, (elem['expectedOutput'] as DateTime).year);

      });
    }
  });

  group("Calender.JulianDateToJulianCalendar:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 0.0, 'expectedOutput' : DateTime(-4712, 1, 1)},
      {'jd' : -38.5, 'expectedOutput' : DateTime(-4713, 11, 24)},
      {'jd' : 1507231.5, 'expectedOutput' : DateTime(-586, 7, 30)},  //30.7. -586
      {'jd' : 1721419.5, 'expectedOutput' : DateTime(0, 12, 28)}, //28.12.0
      {'jd' : 1721424.5, 'expectedOutput' : DateTime(1, 1, 2)}, // 2.1.1
      {'jd' : 1741425.5, 'expectedOutput' : DateTime(55, 10, 7)}, //7.10.55
      {'jd' : 2222443.5, 'expectedOutput' : DateTime(1372, 9, 20)}, //20.9.1372
      {'jd' : 2299159.5, 'expectedOutput' : DateTime(1582, 10, 4)}, //
      {'jd' : 2299160.5, 'expectedOutput' : DateTime(1582, 10, 5)}, //
      {'jd' : 2299169.5, 'expectedOutput' : DateTime(1582, 10, 14)}, //
      {'jd' : 2399301.5, 'expectedOutput' : DateTime(1856, 12, 6)},
      {'jd' : 2422443.5, 'expectedOutput' : DateTime(1920, 4, 16)},
      {'jd' : 2400000.5, 'expectedOutput' : DateTime(1858, 11, 5)},
      {'jd' : 2415019.5, 'expectedOutput' : DateTime(1899, 12, 19)},
      {'jd' : 2451544.5, 'expectedOutput' : DateTime(1999, 12, 19)},
      {'jd' : 2459346.5, 'expectedOutput' : DateTime(2021, 4, 29)},
    ];
    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = julianDateToJulianCalendar(elem['jd'] as double);

        expect(_actual.day, (elem['expectedOutput'] as DateTime).day);
        expect(_actual.month, (elem['expectedOutput'] as DateTime).month);
        expect(_actual.year, (elem['expectedOutput'] as DateTime).year);
      });
    }
  });

  group("Calender.GregorianCalendarToJulianDate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : -0.5, 'date' : DateTime(-4713, 11, 24)},
      {'expectedOutput' : 1507231.5, 'date' : DateTime(-586, 7, 24)},  //30.7. -586
      {'expectedOutput' : 1721419.5, 'date' : DateTime(0, 12, 26)}, //28.12.0
      {'expectedOutput' : 1721424.5, 'date' : DateTime(0, 12, 31)}, // 2.1.1
      {'expectedOutput' : 1741425.5, 'date' : DateTime(55, 10, 5)}, //7.10.55
      {'expectedOutput' : 2222443.5, 'date' : DateTime(1372, 9, 28)}, //20.9.1372
      {'expectedOutput' : 2299159.5, 'date' : DateTime(1582, 10, 14)}, //
      {'expectedOutput' : 2299160.5, 'date' : DateTime(1582, 10, 15)}, //
      {'expectedOutput' : 2399301.5, 'date' : DateTime(1856, 12, 18)},
      {'expectedOutput' : 2422443.5, 'date' : DateTime(1920, 4, 29)},
// wikipedia
      {'expectedOutput' : 2400000.5, 'date' : DateTime(1858, 11, 17)},
      {'expectedOutput' : 2415019.5, 'date' : DateTime(1899, 12, 31)},
      {'expectedOutput' : 2451544.5,  'date' : DateTime(2000, 1, 1)},
      {'expectedOutput' : 2459346.5, 'date' : DateTime(2021, 5, 12)},
    ];

    for (var elem in _inputsToExpected) {
      test('date: ${elem['date']}', () {
        var _actual = gregorianCalendarToJulianDate(elem['date'] as DateTime);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Calender.JulianCalendarToJulianDate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'date' : DateTime(-4712,1,1), 'expectedOutput' : -0.5},
      {'date' : DateTime(-4713,11,24), 'expectedOutput' : -38.5},
      {'date' : DateTime(-668,5,30), 'expectedOutput' : 1477220.5},
      {'date' : DateTime(-586,7,24), 'expectedOutput' : 1507225.5},
      {'date' : DateTime(0,12,28), 'expectedOutput' : 1721419.5},
      {'date' : DateTime(1,1,2), 'expectedOutput' : 1721424.5},
      {'date' : DateTime(55,10,7), 'expectedOutput' : 1741425.5},
      {'date' : DateTime(763,9,14), 'expectedOutput' : 1999999.5},
      {'date' : DateTime(1372,9,20), 'expectedOutput' : 2222443.5},
      {'date' : DateTime(1582,10,4), 'expectedOutput' : 2299159.5},
      {'date' : DateTime(1582,10,14), 'expectedOutput' : 2299169.5},
      {'date' : DateTime(1582,10,15), 'expectedOutput' : 2299170.5},
      {'date' : DateTime(1858,11,5), 'expectedOutput' : 2400000.5},
      {'date' : DateTime(1899,12,19), 'expectedOutput' : 2415019.5},
      {'date' : DateTime(1999,12,19), 'expectedOutput' : 2451544.5},
      {'date' : DateTime(2021,4,29), 'expectedOutput' : 2459346.5},
    ];

    for (var elem in _inputsToExpected) {
      test('date: ${elem['date']}', () {
        var _actual = julianCalendarToJulianDate(elem['date'] as DateTime);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Calender.formatDurationToHHmmss:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '1:10:00:33.000'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '1:10:00:33'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': false, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '10:00:33.000'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': false, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '10:00:33'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': false, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '34:00:33'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '1:10:00:33.000'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': true, 'limitHours': false, 'expectedOutput' : '1:10:00:33.000'},
      {'input' : const Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '1:10:00:33'},

      {'input' : const Duration(days: -1, hours: -33, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '-2:09:00:33'},
      {'input' : const Duration(days: -1, hours: -33, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '-2:09:00:33'},
      {'input' : const Duration(days: -1, hours: -33, seconds: -33, milliseconds: -100), 'days': false, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '-09:00:33'},
      {'input' : const Duration(hours: -33, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '-1:09:00:33'},
      {'input' : const Duration(hours: -10, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '-0:10:00:33'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, days: ${elem['days']}, milliseconds: ${elem['milliseconds']}, limitHours: ${elem['limitHours']}', () {
        var _actual = formatDurationToHHmmss(elem['input'] as Duration, days: elem['days'] as bool, milliseconds: elem['milliseconds'] as bool, limitHours: elem['limitHours'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Calender.formatHoursToHHmmss:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'input' : null, 'expectedOutput' : null},
      {'input' : 1.23456789, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '01:14:04.444'},
      {'input' : 1.23456789, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '01:14:04'},
      {'input' : 1.23456789, 'milliseconds': true, 'limitHours': false, 'expectedOutput' : '01:14:04.444'},
      {'input' : 1.23456789, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '01:14:04'},

      {'input' : 99.23456789, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '03:14:04.444'},
      {'input' : 99.23456789, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '03:14:04'},
      {'input' : 99.23456789, 'milliseconds': true, 'limitHours': false, 'expectedOutput' : '99:14:04.444'},
      {'input' : 99.23456789, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '99:14:04'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, milliseconds: ${elem['milliseconds']}, limitHours: ${elem['limitHours']}', () {
        var _actual = formatHoursToHHmmss(elem['input'] as double, milliseconds: elem['milliseconds'] as bool, limitHours: elem['limitHours'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}