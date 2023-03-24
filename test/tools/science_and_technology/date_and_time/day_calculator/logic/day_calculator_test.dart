import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/logic/day_calculator.dart';

void main() {
  group("DayCalculator.calculateDayDifference:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 16), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 16), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 16), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 16), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(0, 0, 0, 0)},

      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 17), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(2, 48, 2880, 172800)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 17), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 17), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 17), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(0, 0, 0, 0)},

      {'start' : DateTime(2020, 10, 17), 'end': DateTime(2020, 10, 16), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(2, 48, 2880, 172800)},
      {'start' : DateTime(2020, 10, 17), 'end': DateTime(2020, 10, 16), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 17), 'end': DateTime(2020, 10, 16), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},
      {'start' : DateTime(2020, 10, 17), 'end': DateTime(2020, 10, 16), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(0, 0, 0, 0)},

      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 18), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(3, 72, 4320, 259200)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 18), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(2, 48, 2880, 172800)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 18), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(2, 48, 2880, 172800)},
      {'start' : DateTime(2020, 10, 16), 'end': DateTime(2020, 10, 18), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},

      {'start' : DateTime(2020, 10, 18), 'end': DateTime(2020, 10, 16), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(3, 72, 4320, 259200)},
      {'start' : DateTime(2020, 10, 18), 'end': DateTime(2020, 10, 16), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(2, 48, 2880, 172800)},
      {'start' : DateTime(2020, 10, 18), 'end': DateTime(2020, 10, 16), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(2, 48, 2880, 172800)},
      {'start' : DateTime(2020, 10, 18), 'end': DateTime(2020, 10, 16), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 24, 1440, 86400)},

      //daylight change days
      {'start' : DateTime(2019, 03, 31), 'end': DateTime(2019, 04, 01), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(2, 47, 2820, 169200)},
      {'start' : DateTime(2019, 03, 31), 'end': DateTime(2019, 04, 01), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(1, 23, 1380, 82800)},
      {'start' : DateTime(2019, 03, 31), 'end': DateTime(2019, 04, 01), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 23, 1380, 82800)},
      {'start' : DateTime(2019, 03, 31), 'end': DateTime(2019, 04, 01), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(0, -1, -60, -3600)},

      {'start' : DateTime(2019, 03, 30), 'end': DateTime(2019, 04, 02), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(4, 95, 5700, 342000)},
      {'start' : DateTime(2019, 03, 30), 'end': DateTime(2019, 04, 02), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(3, 71, 4260, 255600)},
      {'start' : DateTime(2019, 03, 30), 'end': DateTime(2019, 04, 02), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(3, 71, 4260, 255600)},
      {'start' : DateTime(2019, 03, 30), 'end': DateTime(2019, 04, 02), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(2, 47, 2820, 169200)},

      {'start' : DateTime(2019, 10, 27), 'end': DateTime(2019, 10, 28), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(2, 49, 2940, 176400)},
      {'start' : DateTime(2019, 10, 27), 'end': DateTime(2019, 10, 28), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(1, 25, 1500, 90000)},
      {'start' : DateTime(2019, 10, 27), 'end': DateTime(2019, 10, 28), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(1, 25, 1500, 90000)},
      {'start' : DateTime(2019, 10, 27), 'end': DateTime(2019, 10, 28), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(0, 1, 60, 3600)},

      {'start' : DateTime(2019, 10, 26), 'end': DateTime(2019, 10, 29), 'countStart': true, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(4, 97, 5820, 349200)},
      {'start' : DateTime(2019, 10, 26), 'end': DateTime(2019, 10, 29), 'countStart': false, 'countEnd': true, 'expectedOutput' : DayCalculatorOutput(3, 73, 4380, 262800)},
      {'start' : DateTime(2019, 10, 26), 'end': DateTime(2019, 10, 29), 'countStart': true, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(3, 73, 4380, 262800)},
      {'start' : DateTime(2019, 10, 26), 'end': DateTime(2019, 10, 29), 'countStart': false, 'countEnd': false, 'expectedOutput' : DayCalculatorOutput(2, 49, 2940, 176400)},
    ];

    for (var elem in _inputsToExpected) {
      test('start: ${elem['start']}, end: ${elem['end']}, countStart: ${elem['countStart']}, countEnd: ${elem['countEnd']}', () {
        var _actual = calculateDayDifferences(elem['start'] as DateTime, elem['end'] as DateTime, countStart: elem['countStart'] as bool, countEnd: elem['countEnd'] as bool);

        expect(_actual.days, (elem['expectedOutput'] as DayCalculatorOutput).days);
        expect(_actual.hours, (elem['expectedOutput'] as DayCalculatorOutput).hours);
        expect(_actual.minutes, (elem['expectedOutput'] as DayCalculatorOutput).minutes);
        expect(_actual.seconds, (elem['expectedOutput'] as DayCalculatorOutput).seconds);
      });
    }
  });
}