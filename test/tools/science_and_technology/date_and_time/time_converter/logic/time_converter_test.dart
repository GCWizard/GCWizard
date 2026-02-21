import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/time_converter/logic/time_converter.dart';

void main() {
  group("TimeConverter.convertTimes:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'weeks' : 0.0, 'days': 0.0, 'hours': 0.0, 'minutes': 0.0, 'seconds': 0.0,
        'expectedOutput' : ConvertTimesOutput(0.0, 0.0, 0.0, 0.0, 0.0)},
      {'weeks' : 0.0, 'days': 0.0, 'hours': 0.0, 'minutes': 0.0, 'seconds': 60.0,
        'expectedOutput' : ConvertTimesOutput(0.0000992063492063492, 0.0006944444444444445, 0.016666666666666666, 1.0, 60.0)},
      {'weeks' : 0.0, 'days': 0.0, 'hours': 0.0, 'minutes': 0.0, 'seconds': 0.0,
        'expectedOutput' : ConvertTimesOutput(0.0, 0.0, 0.0, 0.0, 0.0)},
      {'weeks' : 0.0, 'days': 0.0, 'hours': 12.0, 'minutes': 0.0, 'seconds': 0.0,
        'expectedOutput' : ConvertTimesOutput(0.07142857142857142, 0.5, 12.0, 720.0, 43200.0)},
      {'weeks' : 0.0, 'days': 0.0, 'hours': 3.0, 'minutes': 9.0, 'seconds': 22.5472,
        'expectedOutput' : ConvertTimesOutput(0.018787280423280425, 0.13151096296296297, 3.1562631111111115, 189.37578666666667, 11362.5472)},
    ];

    for (var elem in _inputsToExpected) {
      test('weeks: ${elem['weeks']}, days: ${elem['days']}, hours: ${elem['hours']}, minutes: ${elem['minutes']}, seconds: ${elem['seconds']}', () {
        var _actual = convertTimes(elem['weeks'] as double, elem['days'] as double, elem['hours'] as double, elem['minutes'] as double, elem['seconds'] as double);

        expect(_actual.weeks, (elem['expectedOutput'] as ConvertTimesOutput).weeks);
        expect(_actual.days, (elem['expectedOutput'] as ConvertTimesOutput).days);
        expect(_actual.hours, (elem['expectedOutput'] as ConvertTimesOutput).hours);
        expect(_actual.minutes, (elem['expectedOutput'] as ConvertTimesOutput).minutes);
        expect(_actual.seconds, (elem['expectedOutput'] as ConvertTimesOutput).seconds);
      });
    }
  });
}