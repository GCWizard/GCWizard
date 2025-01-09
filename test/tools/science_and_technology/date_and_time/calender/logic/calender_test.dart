import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

void main() {

  group("DateTimeUtils.JulianDateToModifiedJulianDateTo:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 0.0, 'round':  true, 'expectedOutput' : -2400000.5},
      {'jd' : 2400000.5, 'round':  true, 'expectedOutput' : 0.0},
      {'jd' : 12345678901234.0, 'round':  true, 'expectedOutput' : 12345676501233.5},
      {'jd' : 99999999999999.0, 'round':  true, 'expectedOutput' : 99999997599998.5},
      {'jd' : -99999999999999.0, 'round':  true, 'expectedOutput' : -100000002399999.5},
    ];

    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = JulianDateToModifedJulianDate(elem['jd'] as double);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("DateTimeUtils.ModifedJulianDateToJulianDate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 0.0, 'round':  true, 'expectedOutput' : 2400000.5},
      {'jd' : -2400000.5, 'round':  true, 'expectedOutput' : 0.0},
      {'jd' : 12345678901234.0, 'round':  true, 'expectedOutput' : 12345681301234.5},
      {'jd' : 99999999999999.0, 'round':  true, 'expectedOutput' : 100000002399999.5},
      {'jd' : -99999999999999.0, 'round':  true, 'expectedOutput' : -99999997599998.5},
    ];

    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = ModifedJulianDateToJulianDate(elem['jd'] as double);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("DayCalculator.www.aoi.uzh.ch.JulianDateToPersianYazdegardCal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 2459363.0, 'expectedOutput' : DateTime(1390, 11, 16)},
      {'jd' : 12345678901234.0, 'expectedOutput' : null},
      {'jd' : 99999999999999.0, 'expectedOutput' : null},
      {'jd' : -99999999999999.0, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = JulianDateToPersianYazdegardCalendar(elem['jd'] as double);
        if (_actual == null) {
          expect(_actual, elem['expectedOutput']);
        } else {
          expect(_actual.day, (elem['expectedOutput'] as DateTime).day);
          expect(_actual.month, (elem['expectedOutput'] as DateTime).month);
          expect(_actual.year, (elem['expectedOutput'] as DateTime).year);
        }
      });
    }
  });

  group("DayCalculator.www.aoi.uzh.ch.JulianDateToHebrewCal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 2459363.0, 'expectedOutput' : DateTime(5781, 9, 17)},
      {'jd' : 12345678901234.0, 'expectedOutput' : null},
      {'jd' : 99999999999999.0, 'expectedOutput' : null},
      {'jd' : -99999999999999.0, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = JulianDateToHebrewCalendar(elem['jd'] as double);
        if (_actual == null) {
          expect(_actual, elem['expectedOutput']);
        } else {
          expect(_actual.day, (elem['expectedOutput'] as DateTime).day);
          expect(_actual.month, (elem['expectedOutput'] as DateTime).month);
          expect(_actual.year, (elem['expectedOutput'] as DateTime).year);
        }
      });
    }
  });

  group("DayCalculator.www.aoi.uzh.ch.JulianDateToIslamicCal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 2459363.0, 'expectedOutput' : DateTime(1442, 10, 16)},
      {'jd' : 12345678901234.0, 'expectedOutput' : null},
      {'jd' : 99999999999999.0, 'expectedOutput' : null},
      {'jd' : -99999999999999.0, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = JulianDateToIslamicCalendar(elem['jd'] as double);
        if (_actual == null) {
          expect(_actual, elem['expectedOutput']);
        } else {
          expect(_actual.day, (elem['expectedOutput'] as DateTime).day);
          expect(_actual.month, (elem['expectedOutput'] as DateTime).month);
          expect(_actual.year, (elem['expectedOutput'] as DateTime).year);
        }
      });
    }
  });

  group("DateTimeUtils.www.aoi.uzh.ch.JulianDateToCopticCal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'jd' : 2459363.0, 'expectedOutput' : DateTime(1737, 9, 20)},
      {'jd' : 12345678901234.0, 'expectedOutput' : null},
      {'jd' : 99999999999999.0, 'expectedOutput' : null},
      {'jd' : -99999999999999.0, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('jd: ${elem['jd']}', () {
        var _actual = JulianDateToCopticCalendar(elem['jd'] as double);
        if (_actual == null) {
          expect(_actual, elem['expectedOutput']);
        } else {
          expect(_actual.day, (elem['expectedOutput'] as DateTime).day);
          expect(_actual.month, (elem['expectedOutput'] as DateTime).month);
          expect(_actual.year, (elem['expectedOutput'] as DateTime).year);
        }
      });
    }
  });

}
