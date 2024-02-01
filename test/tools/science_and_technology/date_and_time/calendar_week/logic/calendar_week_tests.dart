import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar_week/logic/calendar_week.dart';

void main() {

  group("CalendarWeek.calendarWeek:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      /// Edge cases for ISO with ISO
      {'date' : DateTime(2003, 12, 28), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2003, 12, 29), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2004, 1, 1), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2004, 1, 4), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2004, 1, 5), 'iso':  true, 'expectedOutput' : 2},

      {'date' : DateTime(2006, 12, 31), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2007, 1, 1), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2007, 1, 7), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2007, 1, 8), 'iso':  true, 'expectedOutput' : 2},

      {'date' : DateTime(2015, 12, 31), 'iso':  true, 'expectedOutput' : 53},
      {'date' : DateTime(2016, 1, 3), 'iso':  true, 'expectedOutput' : 53},
      {'date' : DateTime(2016, 1, 4), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2016, 1, 10), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2016, 1, 11), 'iso':  true, 'expectedOutput' : 2},

      {'date' : DateTime(2016, 12, 26), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2016, 12, 31), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2017, 1, 1), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2017, 1, 2), 'iso':  true, 'expectedOutput' : 1},

      /// Edge cases for ISO with US
      {'date' : DateTime(2003, 12, 28), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2003, 12, 29), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2004, 1, 1), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2004, 1, 4), 'iso':  false, 'expectedOutput' : 2},
      {'date' : DateTime(2004, 1, 5), 'iso':  false, 'expectedOutput' : 2},

      {'date' : DateTime(2006, 12, 31), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2007, 1, 1), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2007, 1, 7), 'iso':  false, 'expectedOutput' : 2},
      {'date' : DateTime(2007, 1, 8), 'iso':  false, 'expectedOutput' : 2},

      {'date' : DateTime(2015, 12, 31), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2016, 1, 3), 'iso':  false, 'expectedOutput' : 2},
      {'date' : DateTime(2016, 1, 4), 'iso':  false, 'expectedOutput' : 2},
      {'date' : DateTime(2016, 1, 10), 'iso':  false, 'expectedOutput' : 3},
      {'date' : DateTime(2016, 1, 11), 'iso':  false, 'expectedOutput' : 3},

      {'date' : DateTime(2016, 12, 26), 'iso':  false, 'expectedOutput' : 53},
      {'date' : DateTime(2016, 12, 31), 'iso':  false, 'expectedOutput' : 53},
      {'date' : DateTime(2017, 1, 1), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2017, 1, 2), 'iso':  false, 'expectedOutput' : 1},

      // Edge cases for US with US
      {'date' : DateTime(2021, 12, 25), 'iso':  false, 'expectedOutput' : 52},
      {'date' : DateTime(2021, 12, 26), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2021, 12, 31), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2022, 1, 1), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2022, 1, 2), 'iso':  false, 'expectedOutput' : 2},

      {'date' : DateTime(2017, 12, 30), 'iso':  false, 'expectedOutput' : 52},
      {'date' : DateTime(2017, 12, 31), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2018, 1, 1), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2018, 1, 6), 'iso':  false, 'expectedOutput' : 1},
      {'date' : DateTime(2018, 1, 7), 'iso':  false, 'expectedOutput' : 2},

      /// Edge cases for US with ISO
      {'date' : DateTime(2021, 12, 25), 'iso':  true, 'expectedOutput' : 51},
      {'date' : DateTime(2021, 12, 26), 'iso':  true, 'expectedOutput' : 51},
      {'date' : DateTime(2021, 12, 31), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2022, 1, 1), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2022, 1, 2), 'iso':  true, 'expectedOutput' : 52},

      {'date' : DateTime(2017, 12, 30), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2017, 12, 31), 'iso':  true, 'expectedOutput' : 52},
      {'date' : DateTime(2018, 1, 1), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2018, 1, 6), 'iso':  true, 'expectedOutput' : 1},
      {'date' : DateTime(2018, 1, 7), 'iso':  true, 'expectedOutput' : 1},
    ];

    for (var elem in _inputsToExpected) {
      test('date: ${elem['date']}, iso: ${elem['iso']}', () {
        var _actual = calendarWeek(elem['date'] as DateTime, iso: elem['iso'] as bool);
        expect(_actual, (elem['expectedOutput'] as int));
      });
    }
  });

  group("CalendarWeek.calendarWeek:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      /// Edge cases for ISO with ISO
      {'date' : DateTime(2003, 12, 28), 'iso':  true, 'year': 2003, 'week' : 52},
      {'date' : DateTime(2003, 12, 29), 'iso':  true, 'year': 2004, 'week' : 1},
      {'date' : DateTime(2004, 1, 1), 'iso':  true, 'year': 2004, 'week' : 1},
      {'date' : DateTime(2004, 1, 4), 'iso':  true, 'year': 2004, 'week' : 1},
      {'date' : DateTime(2004, 1, 5), 'iso':  true, 'year': 2004, 'week' : 2},

      {'date' : DateTime(2006, 12, 31), 'iso':  true, 'year': 2006, 'week' : 52},
      {'date' : DateTime(2007, 1, 1), 'iso':  true, 'year': 2007, 'week' : 1},
      {'date' : DateTime(2007, 1, 7), 'iso':  true, 'year': 2007, 'week' : 1},
      {'date' : DateTime(2007, 1, 8), 'iso':  true, 'year': 2007, 'week' : 2},

      {'date' : DateTime(2015, 12, 31), 'iso':  true, 'year': 2015, 'week' : 53},
      {'date' : DateTime(2016, 1, 3), 'iso':  true, 'year': 2015, 'week' : 53},
      {'date' : DateTime(2016, 1, 4), 'iso':  true, 'year': 2016, 'week' : 1},
      {'date' : DateTime(2016, 1, 10), 'iso':  true, 'year': 2016, 'week' : 1},
      {'date' : DateTime(2016, 1, 11), 'iso':  true, 'year': 2016, 'week' : 2},

      {'date' : DateTime(2016, 12, 26), 'iso':  true, 'year': 2016, 'week' : 52},
      {'date' : DateTime(2016, 12, 31), 'iso':  true, 'year': 2016, 'week' : 52},
      {'date' : DateTime(2017, 1, 1), 'iso':  true, 'year': 2016, 'week' : 52},
      {'date' : DateTime(2017, 1, 2), 'iso':  true, 'year': 2017, 'week' : 1},

      /// Edge cases for ISO with US
      {'date' : DateTime(2003, 12, 28), 'iso':  false, 'year': 2004, 'week' : 1},
      {'date' : DateTime(2003, 12, 29), 'iso':  false, 'year': 2004, 'week' : 1},
      {'date' : DateTime(2004, 1, 1), 'iso':  false, 'year': 2004, 'week' : 1},
      {'date' : DateTime(2004, 1, 4), 'iso':  false, 'year': 2004, 'week' : 2},
      {'date' : DateTime(2004, 1, 5), 'iso':  false, 'year': 2004, 'week' : 2},

      {'date' : DateTime(2006, 12, 31), 'iso':  false, 'year': 2007, 'week' : 1},
      {'date' : DateTime(2007, 1, 1), 'iso':  false, 'year': 2007, 'week' : 1},
      {'date' : DateTime(2007, 1, 7), 'iso':  false, 'year': 2007, 'week' : 2},
      {'date' : DateTime(2007, 1, 8), 'iso':  false, 'year': 2007, 'week' : 2},

      {'date' : DateTime(2015, 12, 31), 'iso':  false, 'year': 2016, 'week' : 1},
      {'date' : DateTime(2016, 1, 3), 'iso':  false, 'year': 2016, 'week' : 2},
      {'date' : DateTime(2016, 1, 4), 'iso':  false, 'year': 2016, 'week' : 2},
      {'date' : DateTime(2016, 1, 10), 'iso':  false, 'year': 2016, 'week' : 3},
      {'date' : DateTime(2016, 1, 11), 'iso':  false, 'year': 2016, 'week' : 3},

      {'date' : DateTime(2016, 12, 26), 'iso':  false, 'year': 2016, 'week' : 53},
      {'date' : DateTime(2016, 12, 31), 'iso':  false, 'year': 2016, 'week' : 53},
      {'date' : DateTime(2017, 1, 1), 'iso':  false, 'year': 2017, 'week' : 1},
      {'date' : DateTime(2017, 1, 2), 'iso':  false, 'year': 2017, 'week' : 1},

      // Edge cases for US with US
      {'date' : DateTime(2021, 12, 25), 'iso':  false, 'year': 2021, 'week' : 52},
      {'date' : DateTime(2021, 12, 26), 'iso':  false, 'year': 2022, 'week' : 1},
      {'date' : DateTime(2021, 12, 31), 'iso':  false, 'year': 2022, 'week' : 1},
      {'date' : DateTime(2022, 1, 1), 'iso':  false, 'year': 2022, 'week' : 1},
      {'date' : DateTime(2022, 1, 2), 'iso':  false, 'year': 2022, 'week' : 2},

      {'date' : DateTime(2017, 12, 30), 'iso':  false, 'year': 2017, 'week' : 52},
      {'date' : DateTime(2017, 12, 31), 'iso':  false, 'year': 2018, 'week' : 1},
      {'date' : DateTime(2018, 1, 1), 'iso':  false, 'year': 2018, 'week' : 1},
      {'date' : DateTime(2018, 1, 6), 'iso':  false, 'year': 2018, 'week' : 1},
      {'date' : DateTime(2018, 1, 7), 'iso':  false, 'year': 2018, 'week' : 2},

      /// Edge cases for US with ISO
      {'date' : DateTime(2021, 12, 25), 'iso':  true, 'year': 2021, 'week' : 51},
      {'date' : DateTime(2021, 12, 26), 'iso':  true, 'year': 2021, 'week' : 51},
      {'date' : DateTime(2021, 12, 31), 'iso':  true, 'year': 2021, 'week' : 52},
      {'date' : DateTime(2022, 1, 1), 'iso':  true, 'year': 2021, 'week' : 52},
      {'date' : DateTime(2022, 1, 2), 'iso':  true, 'year': 2021, 'week' : 52},

      {'date' : DateTime(2017, 12, 30), 'iso':  true, 'year': 2017, 'week' : 52},
      {'date' : DateTime(2017, 12, 31), 'iso':  true, 'year': 2017, 'week' : 52},
      {'date' : DateTime(2018, 1, 1), 'iso':  true, 'year': 2018, 'week' : 1},
      {'date' : DateTime(2018, 1, 6), 'iso':  true, 'year': 2018, 'week' : 1},
      {'date' : DateTime(2018, 1, 7), 'iso':  true, 'year': 2018, 'week' : 1},

      {'date' : DateTime(2017, 2, 27), 'iso':  true, 'year': 2017, 'week' : 9},
      {'date' : DateTime(2017, 3, 5), 'iso':  true, 'year': 2017, 'week' : 9},
      {'date' : DateTime(2017, 3, 6), 'iso':  true, 'year': 2017, 'week' : 10},
      {'date' : DateTime(2017, 3, 12), 'iso':  true, 'year': 2017, 'week' : 10},

      {'date' : DateTime(2022, 2, 20), 'iso':  false, 'year': 2022, 'week' : 9},
      {'date' : DateTime(2022, 2, 26), 'iso':  false, 'year': 2022, 'week' : 9},
      {'date' : DateTime(2022, 2, 27), 'iso':  false, 'year': 2022, 'week' : 10},
      {'date' : DateTime(2022, 3, 5), 'iso':  false, 'year': 2022, 'week' : 10},
    ];

    for (var elem in _inputsToExpected) {
      var date = elem['date'] as DateTime;
      test('date: $date, year: ${elem['year'] as int}, week: ${elem['week']}, iso: ${elem['iso']}', () {
        var _actual = datesForCalendarWeek(elem['year'] as int, elem['week'] as int, iso: elem['iso'] as bool);
        expect(true, date.compareTo(_actual.item1) >= 0 && date.compareTo(_actual.item2) <= 0);
      });
    }
  });
}
