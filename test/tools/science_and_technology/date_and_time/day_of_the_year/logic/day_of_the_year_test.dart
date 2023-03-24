import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_of_the_year/logic/day_of_the_year.dart';

void main() {
  group("DayOfTheYear.calculateDayInfos:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'year' : 2022, 'day': 60, 'expectedOutput' : DayOfTheYearOutput(DateTime(2022, 3, 1), 60, 2, 3, 9, 10)},
      {'year' : 2022, 'day': 59, 'expectedOutput' : DayOfTheYearOutput(DateTime(2022, 2, 28), 59, 1, 2, 9, 10)},
      {'year' : 2022, 'day': 58, 'expectedOutput' : DayOfTheYearOutput(DateTime(2022, 2, 27), 58, 7, 1, 8, 10)},
      {'year' : 2022, 'day': 57, 'expectedOutput' : DayOfTheYearOutput(DateTime(2022, 2, 26), 57, 6, 7, 8, 9)},
      {'year' : 2020, 'day': 1,   'expectedOutput' : DayOfTheYearOutput(DateTime(2020, 1, 1), 1, 3, 4, 1, 1)},
      {'year' : 2021, 'day': 1,   'expectedOutput' : DayOfTheYearOutput(DateTime(2021, 1, 1), 1, 5, 6, 53, 1)},
      {'year' : 2022, 'day': 1,   'expectedOutput' : DayOfTheYearOutput(DateTime(2022, 1, 1), 1, 6, 7, 52, 1)},

      {'year' : 2020, 'day': 366, 'expectedOutput' : DayOfTheYearOutput(DateTime(2020, 12, 31), 366, 4, 5, 53, 53)},
      {'year' : 2021, 'day': 365, 'expectedOutput' : DayOfTheYearOutput(DateTime(2021, 12, 31), 365, 5, 6, 52, 53)},
      {'year' : 2022, 'day': 365, 'expectedOutput' : DayOfTheYearOutput(DateTime(2022, 12, 31), 365, 6, 7, 52, 53)},

      {'year' : 2020, 'day': 367, 'expectedOutput' : DayOfTheYearOutput(DateTime(2021, 1, 1),  1, 5, 6, 53, 1)},
      {'year' : 2022, 'day': 0,   'expectedOutput' : DayOfTheYearOutput(DateTime(2021, 12, 31), 365, 5, 6, 52, 53)},
    ];

    for (var elem in _inputsToExpected) {
      test('year: ${elem['year']}, day: ${elem['day']}', () {
        var _actual = calculateDayInfos(elem['year'] as int, elem['day'] as int);

        expect(_actual.date, (elem['expectedOutput'] as DayOfTheYearOutput).date);
        expect(_actual.dayNumber, (elem['expectedOutput'] as DayOfTheYearOutput).dayNumber);
        expect(_actual.weekday, (elem['expectedOutput'] as DayOfTheYearOutput).weekday);
        expect(_actual.weekdayAlternate, (elem['expectedOutput'] as DayOfTheYearOutput).weekdayAlternate);
        expect(_actual.weekNumberIso, (elem['expectedOutput'] as DayOfTheYearOutput).weekNumberIso);
        expect(_actual.weekNumberAlternate, (elem['expectedOutput'] as DayOfTheYearOutput).weekNumberAlternate);
      });
    }
  });

  group("DayOfTheYear.isoWeekOfYear:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : DateTime(2020, 1, 1), 'expectedOutput' : 1},
      {'input' : DateTime(2021, 1, 1), 'expectedOutput' : 53},
      {'input' : DateTime(2022, 1, 1), 'expectedOutput' : 52},
      {'input' : DateTime(2020, 12, 31), 'expectedOutput' : 53},
      {'input' : DateTime(2021, 12, 31), 'expectedOutput' : 52},
      {'input' : DateTime(2022, 12, 31), 'expectedOutput' : 52},

      {'input' : DateTime(2022, 1, 3), 'expectedOutput' : 1},
      {'input' : DateTime(2018, 1, 7), 'expectedOutput' : 1},
      {'input' : DateTime(2018, 1, 8), 'expectedOutput' : 2},

      {'input' : DateTime(2022, 8, 31), 'expectedOutput' : 35},

      {'input' : DateTime(2020, 2, 29), 'expectedOutput' : 9},
      {'input' : DateTime(2021, 2, 29), 'expectedOutput' : 9},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = isoWeekOfYear(elem['input'] as DateTime);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}