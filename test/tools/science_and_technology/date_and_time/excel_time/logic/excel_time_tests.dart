import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/date_and_time/excel_time/logic/excel_time.dart';

void main() {

  group("DateToExcelTimeStamp:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'date' : DateTime(2023, 6, 22, 17, 40, 31), 'expectedOutput' :45099.73646990741},
      {'date' : DateTime(2021, 9, 5, 7, 47, 31), 'expectedOutput' : 44444.32466435185},
      {'date' : DateTime(1994, 2, 11, 0, 0, 0), 'expectedOutput' : 34376.0},
      {'date' : DateTime(1970, 1, 1, 1, 0, 0), 'expectedOutput' : 25569.041666666668},
      {'date' : DateTime(1970, 1, 16, 1, 11, 57), 'expectedOutput' : 25584.049965277776},
      {'date' : DateTime(1968, 4, 22, 19, 13, 0), 'expectedOutput' : 24950.800694444446},
      {'date' : DateTime(1900, 2, 29, 0, 0, 0), 'expectedOutput' : 61.0}, // DateTime converts the invalid Date 29.2.1900 to 1.3.1900
      {'date' : DateTime(1899, 12, 31, 0, 0, 0), 'expectedOutput' : 'dates_calendar_excel_error'},
    ];

    for (var elem in _inputsToExpected) {
      test('date: ${elem['date']}', () {
        var _actual = DateTimeToExcelTime(elem['date'] as DateTime);
        expect(_actual.Error == '' ? _actual.ExcelTimeStamp : _actual.Error, (elem['expectedOutput']));
      });
    }
  });

  group("ExcelTimeStampToDate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : DateTime.utc(2023, 6, 22, 17, 40, 31), 'ExcelTimeStamp' : 45099.73646990741},
      {'expectedOutput' : DateTime.utc(2021, 9, 5, 7, 47, 30), 'ExcelTimeStamp' : 44444.32466435185},
      {'expectedOutput' : DateTime.utc(1900, 2, 27, 0, 0, 0), 'ExcelTimeStamp' : 58.0},
      {'expectedOutput' : DateTime.utc(1900, 2, 28, 0, 0, 0), 'ExcelTimeStamp' : 59.0},
      {'expectedOutput' : DateTime.utc(1900, 2, 29, 0, 0, 0), 'ExcelTimeStamp' : 60.0},
      {'expectedOutput' : DateTime.utc(1900, 3, 1, 0, 0, 0), 'ExcelTimeStamp' : 61.0},
      {'expectedOutput' : DateTime.utc(1970, 1, 16, 1, 11, 56), 'ExcelTimeStamp' : 25584.049965277776},
      {'expectedOutput' : DateTime.utc(1970, 1, 1, 1, 0, 0), 'ExcelTimeStamp' : 25569.041666666668},
    ];

    for (var elem in _inputsToExpected) {
      test('expectedOutput: ${elem['expectedOutput']}', () {
        var _actual = ExcelTimeToDateTime(elem['ExcelTimeStamp'] as double);
        expect(_actual.GregorianDateTimeUTC, elem['expectedOutput']);
      });
    }
  });

}
