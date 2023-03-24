// https://en.wikisource.org/wiki/An_Introduction_to_the_Study_of_the_Maya_Hieroglyphs/Chapter_3#fig19
// https://en.wikipedia.org/wiki/Maya_calendar
// https://en.wikipedia.org/wiki/Haab%CA%BC
// https://en.wikipedia.org/wiki/Tzolk%CA%BCin
// https://www.hermetic.ch/cal_stud/maya/chap2g.htm
// https://rolfrost.de/maya.html
// Javascript sources Public Domain
// https://www.fourmilab.ch/documents/calendar/

import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:prefs/prefs.dart';

enum CORRELATION { THOMPSON, SMILEY, WEITZEL }

const THOMPSON_CORRELATION = 584283;
const SMILEY_CORRELATION = 482699;
const WEITZEL_CORRELATION = 774078;
const THOMPSON = 'Thompson';
const SMILEY = 'Smiley';
const WEITZEL = 'Weitzel';

const Map<String, int> _CORRELATION_NUMBER = {
  THOMPSON: THOMPSON_CORRELATION,
  SMILEY: SMILEY_CORRELATION,
  WEITZEL: WEITZEL_CORRELATION,
};

const Map<String, String> CORRELATION_SYSTEMS = {
  THOMPSON: 'Thompson (584283)',
  SMILEY: 'Smiley (482699)',
  WEITZEL: 'Weitzel (774078)',
};

const _maya_tzolkin = {
  1: 'Imix',
  2: 'Ik',
  3: 'Akbal',
  4: 'Kan',
  5: 'Chiccan',
  6: 'Cimi',
  7: 'Manik',
  8: 'Lamat',
  9: 'Muluc',
  10: 'Oc',
  11: 'Chuen',
  12: 'Eb',
  13: 'Ben',
  14: 'Ix',
  15: 'Men',
  16: 'Cib',
  17: 'Caban',
  18: 'Etznab',
  19: 'Cauac',
  20: 'Ahau',
};

const _maya_haab = {
  1: 'Pop',
  2: 'Uo',
  3: 'Zip',
  4: 'Zotz',
  5: 'Tzek',
  6: 'Xul',
  7: 'Yaxkin',
  8: 'Mol',
  9: 'Chen',
  10: 'Yax',
  11: 'Zac',
  12: 'Ceh',
  13: 'Mac',
  14: 'Kankin',
  15: 'Muan',
  16: 'Pax',
  17: 'Kayab',
  18: 'Cumhu',
  19: 'Uayeb'
};

const Map<int, List<String>> _numbersToSegments = {
  0: [],
  1: ['d'],
  2: ['d', 'e'],
  3: ['d', 'e', 'f'],
  4: ['d', 'e', 'f', 'g'],
  5: ['c'],
  6: ['c', 'd'],
  7: ['c', 'd', 'e'],
  8: ['c', 'd', 'e', 'f'],
  9: ['c', 'd', 'e', 'f', 'g'],
  10: ['b', 'c'],
  11: ['b', 'c', 'd'],
  12: ['b', 'c', 'd', 'e'],
  13: ['b', 'c', 'd', 'e', 'f'],
  14: ['b', 'c', 'd', 'e', 'f', 'g'],
  15: ['a', 'b', 'c'],
  16: ['a', 'b', 'c', 'd'],
  17: ['a', 'b', 'c', 'd', 'e'],
  18: ['a', 'b', 'c', 'd', 'e', 'f'],
  19: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
};

const _alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

List<int> mayaCalendarSystem = [1, 20, 360, 7200, 144000, 2880000, 57600000, 1152000000, 23040000000];

SegmentsVigesimal encodeMayaCalendar(int? input) {
  if (input == null) return SegmentsVigesimal(displays: [], numbers: [0], vigesimal: BigInt.zero);

  var vigesimal = convertDecToMayaCalendar(input.toString());

  var displays = <List<String>>[];
  vigesimal.split('').forEach((digit) {
    var list = _numbersToSegments[int.tryParse(convertBase(digit, 20, 10)) ?? ''];
    if (list != null) displays.add(list);
  });

  return SegmentsVigesimal(displays: displays, numbers: _longCountToList(input), vigesimal: BigInt.tryParse(vigesimal) ?? BigInt.zero);
}

List<int> _longCountToList(int numberDec) {
  if (numberDec == 0) return [0];

  List<int> result = <int>[];

  int start = 0;
  while (numberDec < mayaCalendarSystem[mayaCalendarSystem.length - 1 - start]) {
    start++;
  }
  for (int position = mayaCalendarSystem.length - start; position > 0; position--) {
    int value = 0;
    while (numberDec >= mayaCalendarSystem[position - 1]) {
      value++;
      numberDec = numberDec - mayaCalendarSystem[position - 1];
    }
    result.add(value);
  }
  return result;
}

SegmentsVigesimal decodeMayaCalendar(List<String?>? inputs) {
  if (inputs == null || inputs.isEmpty) return SegmentsVigesimal(displays: [], numbers: [0], vigesimal: BigInt.zero);

  var oneCharacters = ['d', 'e', 'f', 'g'];
  var fiveCharacters = ['a', 'b', 'c'];

  var displays = <List<String>>[];

  List<int> numbers = inputs.where((input) => input != null).map((input) {
    var number = 0;
    var display = <String>[];
    input!.toLowerCase().split('').forEach((segment) {
      if (oneCharacters.contains(segment)) {
        number += 1;
        display.add(segment);
      } else if (fiveCharacters.contains(segment)) {
        number += 5;
        display.add(segment);
      }
      return;
    });

    displays.add(display);

    return number;
  }).toList();

  String total;
  total = '0';
  bool invalid = false;
  for (int i = 0; i < numbers.length; i++) {
    if ((i == numbers.length - 2) && (mayaCalendarSystem[numbers.length - i - 1] == 20) && (numbers[i] > 17)) {
      invalid = true;
    } else {
      total = (int.parse(total) + numbers[i] * mayaCalendarSystem[numbers.length - i - 1]).toString();
    }
  }
  if (invalid) total = '-1';

  return SegmentsVigesimal(displays: displays, numbers: numbers, vigesimal: BigInt.tryParse(total) ?? BigInt.zero);
}

String convertDecToMayaCalendar(String input) {
  if (input.isEmpty) return '';

  int numberDec = int.parse(input);
  if (numberDec == 0) return '0';

  String result = '';
  int start = 0;
  while (numberDec < (mayaCalendarSystem[mayaCalendarSystem.length - 1 - start])) {
    start++;
  }
  for (int position = mayaCalendarSystem.length - start; position > 0; position--) {
    int value = 0;
    while (numberDec >= (mayaCalendarSystem[position - 1])) {
      value++;
      numberDec = numberDec - (mayaCalendarSystem[position - 1]);
    }
    result = result + _alphabet[value];
  }
  return result;
}

String MayaLongCountToTzolkin(List<int> longCount) {
  int dayCount = MayaLongCountToMayaDayCount(longCount);
  if (dayCount == 0) return '4 Ahau';

  dayCount = dayCount + 159;
  dayCount = 1 + dayCount % 260;
  return (1 + (dayCount - 1) % 13).toString() + ' ' + (_maya_tzolkin[1 + (dayCount - 1) % 20] ?? '');
}

String MayaLongCountToHaab(List<int> longCount) {
  int dayCount = MayaLongCountToMayaDayCount(longCount);
  if (dayCount == 0) return '8 Cumhu';

  dayCount = dayCount + 347;
  dayCount = 1 + dayCount % 365;
  return (1 + (dayCount - 1) % 20).toString() + ' ' + (_maya_haab[1 + (dayCount - 1) ~/ 20] ?? '');
}

String MayaLongCount(List<int> longCount) {
  if (MayaLongCountToMayaDayCount(longCount) == 0) return [0, 0, 0, 0, 13, 0, 0, 0, 0].join('.');

  List<int> result = <int>[];
  for (int i = longCount.length; i < 9; i++) {
    result.add(0);
  }
  for (int i = 0; i < longCount.length; i++) {
    result.add(longCount[i]);
  }
  if (result[4] == 0 && result[3] != 0) result[4] = 13;
  return result.join('.');
}

int MayaLongCountToMayaDayCount(List<int> longCount) {
  int dayCount = 0;
  longCount = longCount.reversed.toList();
  for (int i = 0; i < longCount.length; i++) {
    dayCount = dayCount + longCount[i] * mayaCalendarSystem[i];
  }
  return dayCount;
}

DateTime MayaDayCountToJulianCalendar(int mayaDayCount) {
  return julianDateToJulianCalendar(MayaDayCountToJulianDate(mayaDayCount) * 1.0);
}

DateTime MayaDayCountToGregorianCalendar(int mayaDayCount) {
  return julianDateToGregorianCalendar(MayaDayCountToJulianDate(mayaDayCount) * 1.0);
}

int MayaDayCountToJulianDate(int mayaDayCount) {
  var correlation = Prefs.getString(PREFERENCE_MAYACALENDAR_CORRELATION);
  if (correlation.isEmpty) {
    return (mayaDayCount + _CORRELATION_NUMBER[THOMPSON]!);
  } else {
    return (mayaDayCount + (_CORRELATION_NUMBER[correlation] ?? 0));
  }
}

int JulianDateToMayaDayCount(double jd) {
  var correlation = Prefs.getString(PREFERENCE_MAYACALENDAR_CORRELATION);
  if (correlation.isEmpty) {
    jd = (jd - _CORRELATION_NUMBER[THOMPSON]!);
  } else {
    jd = (jd - (_CORRELATION_NUMBER[correlation] ?? 0));
  }
  return jd.round();
}

List<int> JulianDateToMayaLongCount(double jd) {
  List<int> MayaLongCount = [];

  int mayaDayCount = JulianDateToMayaDayCount(jd);

  for (int i = mayaCalendarSystem.length; i > 0; i--) {
    MayaLongCount.add((mayaDayCount / mayaCalendarSystem[i - 1]).floor());
    mayaDayCount = mayaDayCount % mayaCalendarSystem[i - 1];
  }

  return MayaLongCount;
}

List<int?> MayaDayCountToMayaLongCount(int MayaDayCount) {
  String longCount = convertDecToMayaCalendar(MayaDayCount.toString());
  List<int?> result = [];
  for (int i = longCount.length; i > 0; i--) {
    result.add(_toNumber(longCount[i - 1]));
  }
  for (int i = longCount.length; i < 9; i++) {
    result.add(0);
  }

  return result.reversed.toList();
}

int? _toNumber(String digit) {
  const Map<String, int> NUMBER = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'A': 10,
    'B': 11,
    'C': 12,
    'D': 13,
    'E': 14,
    'F': 15,
    'G': 16,
    'H': 17,
    'I': 18,
    'J': 19,
  };
  return NUMBER[digit];
}
