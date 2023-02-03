import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/datetime_utils.dart';

void main() {
//   group("DayCalculator.JulianDateToGregorianCalendar:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 0.0, 'round':  false, 'expectedOutput' : DateOutput('24.5', '11', '-4713')},
//       {'jd' : 0.0, 'round':  true, 'expectedOutput' : DateOutput('24', '11', '-4713')},
//       {'jd' : 1507231.5, 'round':  true, 'expectedOutput' : DateOutput('24', '7', '-586')},  //30.7. -586
//       {'jd' : 1721419.5, 'round':  true, 'expectedOutput' : DateOutput('26', '12', '0')}, //28.12.0
//       {'jd' : 1721424.5, 'round':  true, 'expectedOutput' : DateOutput('31', '12', '0')}, // 2.1.1
//       {'jd' : 1741425.5, 'round':  true, 'expectedOutput' : DateOutput('5', '10', '55')}, //7.10.55
//       {'jd' : 2222443.5, 'round':  true, 'expectedOutput' : DateOutput('28', '9', '1372')}, //20.9.1372
//       {'jd' : 2299159.5, 'round':  true, 'expectedOutput' : DateOutput('14', '10', '1582')}, //
//       {'jd' : 2299160.5, 'round':  true, 'expectedOutput' : DateOutput('15', '10', '1582')}, //
//       {'jd' : 2399301.5, 'round':  true, 'expectedOutput' : DateOutput('18', '12', '1856')},
//       {'jd' : 2422443.5, 'round':  true, 'expectedOutput' : DateOutput('29', '4', '1920')},
//       {'jd' : 2400000.5, 'round':  true, 'expectedOutput' : DateOutput('17', '11', '1858')},
//       {'jd' : 2415019.5, 'round':  true, 'expectedOutput' : DateOutput('31', '12', '1899')},
//       {'jd' : 2451544.5, 'round':  true, 'expectedOutput' : DateOutput('1', '1', '2000')},
//       {'jd' : 2459346.5, 'round':  true, 'expectedOutput' : DateOutput('12', '5', '2021')},
//     ];
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}, round: ${elem['round']}', () {
//         var _actual = JulianDateToGregorianCalendar(elem['jd'], elem['round']);
//         if (_actual == null)
//           expect(_actual, elem['expectedOutput']);
//         else {
//           expect(_actual.day, elem['expectedOutput'].day);
//           expect(_actual.month, elem['expectedOutput'].month);
//           expect(_actual.year, elem['expectedOutput'].year);
//         }
//       });
//     });
//   });
//   group("DayCalculator.JulianDateToJulianCalendar:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 0.0, 'round':  true, 'expectedOutput' : DateOutput('1', '1', '-4712')},
//       {'jd' : -38.5, 'round':  true, 'expectedOutput' : DateOutput('24', '11', '-4713')},
//       {'jd' : 1507231.5, 'round':  true, 'expectedOutput' : DateOutput('30', '7', '-586')},  //30.7. -586
//       {'jd' : 1721419.5, 'round':  true, 'expectedOutput' : DateOutput('28', '12', '0')}, //28.12.0
//       {'jd' : 1721424.5, 'round':  true, 'expectedOutput' : DateOutput('2', '1', '1')}, // 2.1.1
//       {'jd' : 1741425.5, 'round':  true, 'expectedOutput' : DateOutput('7', '10', '55')}, //7.10.55
//       {'jd' : 2222443.5, 'round':  true, 'expectedOutput' : DateOutput('20', '9', '1372')}, //20.9.1372
//       {'jd' : 2299159.5, 'round':  true, 'expectedOutput' : DateOutput('4', '10', '1582')}, //
//       {'jd' : 2299160.5, 'round':  true, 'expectedOutput' : DateOutput('5', '10', '1582')}, //
//       {'jd' : 2299169.5, 'round':  true, 'expectedOutput' : DateOutput('14', '10', '1582')}, //
//       {'jd' : 2399301.5, 'round':  true, 'expectedOutput' : DateOutput('6', '12', '1856')},
//       {'jd' : 2422443.5, 'round':  true, 'expectedOutput' : DateOutput('16', '4', '1920')},
//       {'jd' : 2400000.5, 'round':  true, 'expectedOutput' : DateOutput('5', '11', '1858')},
//       {'jd' : 2415019.5, 'round':  true, 'expectedOutput' : DateOutput('19', '12', '1899')},
//       {'jd' : 2451544.5, 'round':  true, 'expectedOutput' : DateOutput('19', '12', '1999')},
//       {'jd' : 2459346.5, 'round':  true, 'expectedOutput' : DateOutput('29', '4', '2021')},
//     ];
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}, round: ${elem['round']}', () {
//         var _actual = JulianDateToJulianCalendar(elem['jd'], elem['round']);
//         if (_actual == null)
//           expect(_actual, elem['expectedOutput']);
//         else {
//           expect(_actual.day, elem['expectedOutput'].day);
//           expect(_actual.month, elem['expectedOutput'].month);
//           expect(_actual.year, elem['expectedOutput'].year);
//         }
//       });
//     });
//   });
//   group("DayCalculator.GregorianCalendarToJulianDate:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'expectedOutput' : -0.5, 'date' : DateTime(-4713, 11, 24)},
//       {'expectedOutput' : 1507231.5, 'date' : DateTime(-586, 7, 24)},  //30.7. -586
//       {'expectedOutput' : 1721419.5, 'date' : DateTime(0, 12, 26)}, //28.12.0
//       {'expectedOutput' : 1721424.5, 'date' : DateTime(0, 12, 31)}, // 2.1.1
//       {'expectedOutput' : 1741425.5, 'date' : DateTime(55, 10, 5)}, //7.10.55
//       {'expectedOutput' : 2222443.5, 'date' : DateTime(1372, 9, 28)}, //20.9.1372
//       {'expectedOutput' : 2299159.5, 'date' : DateTime(1582, 10, 14)}, //
//       {'expectedOutput' : 2299160.5, 'date' : DateTime(1582, 10, 15)}, //
//       {'expectedOutput' : 2399301.5, 'date' : DateTime(1856, 12, 18)},
//       {'expectedOutput' : 2422443.5, 'date' : DateTime(1920, 4, 29)},
// // wikipedia
//       {'expectedOutput' : 2400000.5, 'date' : DateTime(1858, 11, 17)},
//       {'expectedOutput' : 2415019.5, 'date' : DateTime(1899, 12, 31)},
//       {'expectedOutput' : 2451544.5,  'date' : DateTime(2000, 1, 1)},
//       {'expectedOutput' : 2459346.5, 'date' : DateTime(2021, 5, 12)},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('date: ${elem['date']}', () {
//         var _actual = GregorianCalendarToJulianDate(elem['date']);
//         expect(_actual, elem['expectedOutput']);
//       });
//     });
//   });
//   group("DayCalculator.JulianCalendarToJulianDate:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'date' : DateTime(-4712,1,1), 'expectedOutput' : -0.5},
//       {'date' : DateTime(-4713,11,24), 'expectedOutput' : -38.5},
//       {'date' : DateTime(-668,5,30), 'expectedOutput' : 1477220.5},
//       {'date' : DateTime(-586,7,24), 'expectedOutput' : 1507225.5},
//       {'date' : DateTime(0,12,28), 'expectedOutput' : 1721419.5},
//       {'date' : DateTime(1,1,2), 'expectedOutput' : 1721424.5},
//       {'date' : DateTime(55,10,7), 'expectedOutput' : 1741425.5},
//       {'date' : DateTime(763,9,14), 'expectedOutput' : 1999999.5},
//       {'date' : DateTime(1372,9,20), 'expectedOutput' : 2222443.5},
//       {'date' : DateTime(1582,10,4), 'expectedOutput' : 2299159.5},
//       {'date' : DateTime(1582,10,14), 'expectedOutput' : 2299169.5},
//       {'date' : DateTime(1582,10,15), 'expectedOutput' : 2299170.5},
//       {'date' : DateTime(1858,11,5), 'expectedOutput' : 2400000.5},
//       {'date' : DateTime(1899,12,19), 'expectedOutput' : 2415019.5},
//       {'date' : DateTime(1999,12,19), 'expectedOutput' : 2451544.5},
//       {'date' : DateTime(2021,4,29), 'expectedOutput' : 2459346.5},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('date: ${elem['date']}', () {
//         var _actual = JulianCalendarToJulianDate(elem['date']);
//         expect(_actual, elem['expectedOutput']);
//       });
//     });
//   });
//
//
//   group("DayCalculator.JulianDateToModifiedJulianDateTo:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 0.0, 'round':  true, 'expectedOutput' : -2400000.5},
//       {'jd' : 2400000.5, 'round':  true, 'expectedOutput' : 0.0},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}', () {
//         var _actual = JulianDateToModifedJulianDate(elem['jd']);
//         expect(_actual, elem['expectedOutput']);
//       });
//     });
//   });
//
//   group("DayCalculator.ModifedJulianDateToJulianDate:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 0.0, 'round':  true, 'expectedOutput' : 2400000.5},
//       {'jd' : -2400000.5, 'round':  true, 'expectedOutput' : 0.0},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}', () {
//         var _actual = ModifedJulianDateToJulianDate(elem['jd']);
//         expect(_actual, elem['expectedOutput']);
//       });
//     });
//   });
//
//   group("DayCalculator.www.aoi.uzh.ch.JulianDateToPersianYazdegardCal:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 2459363.0, 'expectedOutput' : DateOutput('16', '11', '1390')},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}', () {
//         var _actual = JulianDateToPersianYazdegardCalendar(elem['jd']);
//         expect(_actual.day, elem['expectedOutput'].day);
//         expect(_actual.month, elem['expectedOutput'].month);
//         expect(_actual.year, elem['expectedOutput'].year);
//       });
//     });
//   });
//
//   group("DayCalculator.www.aoi.uzh.ch.JulianDateToHebrewCal:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 2459363.0, 'expectedOutput' : DateOutput('17', '9', '5781')},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}', () {
//         var _actual = JulianDateToHebrewCalendar(elem['jd']);
//         expect(_actual.day, elem['expectedOutput'].day);
//         expect(_actual.month, elem['expectedOutput'].month);
//         expect(_actual.year, elem['expectedOutput'].year);
//       });
//     });
//   });
//
//   group("DayCalculator.www.aoi.uzh.ch.JulianDateToIslamicCal:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 2459363.0, 'expectedOutput' : DateOutput('16', '10', '1442')},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}', () {
//         var _actual = JulianDateToIslamicCalendar(elem['jd']);
//         expect(_actual.day, elem['expectedOutput'].day);
//         expect(_actual.month, elem['expectedOutput'].month);
//         expect(_actual.year, elem['expectedOutput'].year);
//       });
//     });
//   });
//
//   group("DayCalculator.www.aoi.uzh.ch.JulianDateToCopticCal:", () {
//     List<Map<String, dynamic>> _inputsToExpected = [
//       {'jd' : 2459363.0, 'expectedOutput' : DateOutput('20', '9', '1737')},
//     ];
//
//     _inputsToExpected.forEach((elem) {
//       test('jd: ${elem['jd']}', () {
//         var _actual = JulianDateToCopticCalendar(elem['jd']);
//         expect(_actual.day, elem['expectedOutput'].day);
//         expect(_actual.month, elem['expectedOutput'].month);
//         expect(_actual.year, elem['expectedOutput'].year);
//       });
//     });
//   });
//
  group("CommonUtils.formatDurationToHHmmss:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '1:10:00:33.000'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '1:10:00:33'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': false, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '10:00:33.000'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': false, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '10:00:33'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': false, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '34:00:33'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '1:10:00:33.000'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': true, 'limitHours': false, 'expectedOutput' : '1:10:00:33.000'},
      {'input' : Duration(days: 1, hours: 10, seconds: 33, milliseconds: 100), 'days': true, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '1:10:00:33'},

      {'input' : Duration(days: -1, hours: -33, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '-2:09:00:33'},
      {'input' : Duration(days: -1, hours: -33, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '-2:09:00:33'},
      {'input' : Duration(days: -1, hours: -33, seconds: -33, milliseconds: -100), 'days': false, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '-09:00:33'},
      {'input' : Duration(hours: -33, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '-1:09:00:33'},
      {'input' : Duration(hours: -10, seconds: -33, milliseconds: -100), 'days': true, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '-0:10:00:33'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, days: ${elem['days']}, milliseconds: ${elem['milliseconds']}, limitHours: ${elem['limitHours']}', () {
        var _actual = formatDurationToHHmmss(elem['input'], days: elem['days'], milliseconds: elem['milliseconds'], limitHours: elem['limitHours']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("CommonUtils.formatHoursToHHmmss:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : 1.23456789, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '01:14:04.444'},
      {'input' : 1.23456789, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '01:14:04'},
      {'input' : 1.23456789, 'milliseconds': true, 'limitHours': false, 'expectedOutput' : '01:14:04.444'},
      {'input' : 1.23456789, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '01:14:04'},

      {'input' : 99.23456789, 'milliseconds': true, 'limitHours': true, 'expectedOutput' : '03:14:04.444'},
      {'input' : 99.23456789, 'milliseconds': false, 'limitHours': true, 'expectedOutput' : '03:14:04'},
      {'input' : 99.23456789, 'milliseconds': true, 'limitHours': false, 'expectedOutput' : '99:14:04.444'},
      {'input' : 99.23456789, 'milliseconds': false, 'limitHours': false, 'expectedOutput' : '99:14:04'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, milliseconds: ${elem['milliseconds']}, limitHours: ${elem['limitHours']}', () {
        var _actual = formatHoursToHHmmss(elem['input'], milliseconds: elem['milliseconds'], limitHours: elem['limitHours']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}