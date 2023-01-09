import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/date_utils.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/date_and_time/calendar.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/maya_calendar.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_date_picker.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_double_spinner.dart';

class Calendar extends StatefulWidget {
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarSystem _currentCalendarSystem = CalendarSystem.JULIANDATE;
  double _currentJulianDate = 0.0;
  DateTime _currentDate;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _currentDate = DateTime(now.year, now.month, now.day);
    _currentJulianDate = GregorianCalendarToJulianDate(_currentDate);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDownButton(
          value: _currentCalendarSystem,
          onChanged: (value) {
            setState(() {
              _currentCalendarSystem = value;
            });
          },
          items: CALENDAR_SYSTEM.entries.map((system) {
            return GCWDropDownMenuItem(
              value: system.key,
              child: i18n(context, system.value),
            );
          }).toList(),
        ),
        if (_currentCalendarSystem == CalendarSystem.JULIANDATE ||
            _currentCalendarSystem == CalendarSystem.MODIFIEDJULIANDATE)
          GCWDoubleSpinner(
              value: _currentJulianDate,
              numberDecimalDigits: 2,
              onChanged: (value) {
                setState(() {
                  _currentJulianDate = value;
                });
              }),
        if (_currentCalendarSystem == CalendarSystem.JULIANCALENDAR ||
            _currentCalendarSystem == CalendarSystem.GREGORIANCALENDAR ||
            _currentCalendarSystem == CalendarSystem.ISLAMICCALENDAR ||
            _currentCalendarSystem == CalendarSystem.COPTICCALENDAR ||
            _currentCalendarSystem == CalendarSystem.PERSIANYAZDEGARDCALENDAR ||
            _currentCalendarSystem == CalendarSystem.POTRZEBIECALENDAR ||
            _currentCalendarSystem == CalendarSystem.HEBREWCALENDAR)
          GCWDatePicker(
            date: _currentDate,
            type: _currentCalendarSystem,
            onChanged: (value) {
              setState(() {
                _currentDate = value;
              });
            },
          ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    double jd = 0.0;
    Map output = new Map();
    switch (_currentCalendarSystem) {
      case CalendarSystem.MODIFIEDJULIANDATE:
        jd = ModifedJulianDateToJulianDate(_currentJulianDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]);
        break;
      case CalendarSystem.JULIANDATE:
        jd = _currentJulianDate;
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]);
        break;
      case CalendarSystem.GREGORIANCALENDAR:
        jd = GregorianCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]);
        break;
      case CalendarSystem.JULIANCALENDAR:
        jd = JulianCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]);
        break;
      case CalendarSystem.ISLAMICCALENDAR:
        jd = IslamicCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = WEEKDAY_ISLAMIC[Weekday(jd)];
        break;
      case CalendarSystem.PERSIANYAZDEGARDCALENDAR:
        jd = PersianYazdegardCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = WEEKDAY_PERSIAN[Weekday(jd)];
        break;
      case CalendarSystem.HEBREWCALENDAR:
        jd = HebrewCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = WEEKDAY_HEBREW[Weekday(jd)];
        break;
      case CalendarSystem.COPTICCALENDAR:
        jd = CopticCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]);
        break;
      case CalendarSystem.POTRZEBIECALENDAR:
        jd = PotrzebieCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]);
        break;
    }

    output['dates_calendar_system_juliandate'] = (jd + 0.5).floor();

    output['dates_calendar_system_juliancalendar'] =
        _DateOutputToString(context, JulianDateToJulianCalendar(jd, true), CalendarSystem.JULIANCALENDAR);

    output['dates_calendar_system_modifiedjuliandate'] = JulianDateToModifedJulianDate(jd);

    output['dates_calendar_system_gregoriancalendar'] =
        _DateOutputToString(context, JulianDateToGregorianCalendar(jd, true), CalendarSystem.GREGORIANCALENDAR);

    output['dates_calendar_system_islamiccalendar'] =
        _DateOutputToString(context, JulianDateToIslamicCalendar(jd), CalendarSystem.ISLAMICCALENDAR);

    output['dates_calendar_system_hebrewcalendar'] = _HebrewDateToString(JulianDateToHebrewCalendar(jd), jd);

    output['dates_calendar_system_persiancalendar'] =
        _DateOutputToString(context, JulianDateToPersianYazdegardCalendar(jd), CalendarSystem.PERSIANYAZDEGARDCALENDAR);

    output['dates_calendar_system_copticcalendar'] =
        _DateOutputToString(context, JulianDateToCopticCalendar(jd), CalendarSystem.COPTICCALENDAR);

    output['dates_calendar_system_mayacalendar_daycount'] =
        _invalidMayaDate(jd) ? i18n(context, 'dates_calendar_error') : JulianDateToMayaDayCount(jd).toString();

    output['dates_calendar_system_mayacalendar_longcount'] =
        _invalidMayaDate(jd) ? i18n(context, 'dates_calendar_error') : JulianDateToMayaLongCount(jd).join('.');

    output['dates_calendar_system_mayacalendar_haab'] = _invalidMayaDate(jd)
        ? i18n(context, 'dates_calendar_error')
        : MayaLongCountToHaab(JulianDateToMayaLongCount(jd));

    output['dates_calendar_system_mayacalendar_tzolkin'] = _invalidMayaDate(jd)
        ? i18n(context, 'dates_calendar_error')
        : MayaLongCountToTzolkin(JulianDateToMayaLongCount(jd));

    output['dates_calendar_system_potrzebiecalendar'] =
        _DateOutputToString(context, JulianDateToPotrzebieCalendar(jd), CalendarSystem.POTRZEBIECALENDAR);

    return GCWDefaultOutput(
        child: GCWColumnedMultilineOutput(
            data: output.entries.map((entry) {
                    return [i18n(context, entry.key), entry.value];
                  }).toList(),
            flexValues: [1, 1]
          ),
    );
  }

  String _HebrewDateToString(DateOutput HebrewDate, double jd) {
    if (int.parse(HebrewDate.year) < 0) return i18n(context, 'dates_calendar_error');

    if (typeOfJewYear(JewishYearLength(jd)).contains('embolistic'))
      return HebrewDate.day +
          '. ' +
          MONTH_NAMES[CalendarSystem.HEBREWCALENDAR][int.parse(HebrewDate.month)].toString() +
          ' ' +
          HebrewDate.year;
    else {
      int month = int.parse(HebrewDate.month);
      if (month > 6) month = 1 + int.parse(HebrewDate.month);
      return HebrewDate.day + ' ' + MONTH_NAMES[CalendarSystem.HEBREWCALENDAR][month] + ' ' + HebrewDate.year;
    }
  }

  String _DateOutputToString(context, DateOutput date, CalendarSystem calendar) {
    final Locale appLocale = Localizations.localeOf(context);
    switch (calendar) {
      case CalendarSystem.ISLAMICCALENDAR:
      case CalendarSystem.PERSIANYAZDEGARDCALENDAR:
      case CalendarSystem.COPTICCALENDAR:
        if (int.parse(date.year) < 0) return i18n(context, 'dates_calendar_error');
        return date.day + '. ' + MONTH_NAMES[calendar][int.parse(date.month)].toString() + ' ' + date.year;
      case CalendarSystem.GREGORIANCALENDAR:
      case CalendarSystem.JULIANCALENDAR:
        switch (appLocale.languageCode) {
          case 'de':
            return date.day + '. ' + i18n(context, MONTH[int.parse(date.month)]) + ' ' + date.year;
          case 'fr':
            return date.day + ' ' + i18n(context, MONTH[int.parse(date.month)]).toLowerCase() + ' ' + date.year;
          default:
            return date.year + ' ' + i18n(context, MONTH[int.parse(date.month)]) + ' ' + date.day;
        }
        break;
      case CalendarSystem.POTRZEBIECALENDAR:
        return date.day + '. ' + MONTH_NAMES[calendar][int.parse(date.month)].toString() + ' ' + date.year;
    }
  }

  bool _invalidMayaDate(double jd) {
    return (JulianDateToMayaDayCount(jd) < 0);
  }
}
