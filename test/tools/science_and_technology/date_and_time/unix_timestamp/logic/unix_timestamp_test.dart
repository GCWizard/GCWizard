import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/unix_time/logic/unix_time.dart';

void main() {

  group("DateToUnixTimeStamp:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'date' : DateTime(2023, 6, 22, 17, 40, 31), 'expectedOutput' : 1687455631},
      {'date' : DateTime(1994, 2, 11, 0, 0, 0), 'expectedOutput' : 760924800},
      {'date' : DateTime(1970, 1, 1, 1, 0, 0), 'expectedOutput' : 3600},
      {'date' : DateTime(1970, 1, 16, 1, 11, 57), 'expectedOutput' : 1300317},
      {'date' : DateTime(1968, 4, 22, 19, 13, 0), 'expectedOutput' : 'dates_calendar_unix_error'},
    ];

    for (var elem in _inputsToExpected) {
      test('date: ${elem['date']}', () {
        var _actual = DateTimeUTCToUnixTime(elem['date'] as DateTime);
        expect(_actual.error == '' ? _actual.timeStamp : _actual.error, elem['expectedOutput']);
      });
    }
  });

  group("UnixTimeStampToDate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : DateTime.utc(2023, 6, 22, 17, 40, 31), 'UnixTimeStamp' : 1687455631},
      {'expectedOutput' : DateTime.utc(1994, 2, 11, 0, 0, 0), 'UnixTimeStamp' : 760924800},
      {'expectedOutput' : DateTime.utc(1970, 1, 16, 1, 11, 57), 'UnixTimeStamp' : 1300317},
      {'expectedOutput' : DateTime.utc(1970, 1, 1, 0, 0, 0), 'UnixTimeStamp' : 0},
      {'expectedOutput' : DateTime.utc(8319, 09, 05, 12, 48, 39, 689, 664), 'UnixTimeStamp' : 99999999999999999},
      {'expectedOutput' : DateTime.utc(-4380, 04, 28, 11, 11, 20, 310, 336), 'UnixTimeStamp' : -99999999999999999},
    ];

    for (var elem in _inputsToExpected) {
      test('date: ${elem['UnixTimeStamp']}', () {
        var _actual = UnixTimeToDateTimeUTC(elem['UnixTimeStamp'] as int);
        expect(_actual.gregorianDateTimeUTC, elem['expectedOutput']);
      });
    }
  });

}
