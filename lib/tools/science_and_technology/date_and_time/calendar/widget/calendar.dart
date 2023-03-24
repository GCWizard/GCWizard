import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_date_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/widget/calendar_i18n.dart';
import 'package:gc_wizard/tools/science_and_technology/maya_calendar/logic/maya_calendar.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarSystem _currentCalendarSystem = CalendarSystem.JULIANDATE;
  double _currentJulianDate = 0.0;
  late DateTime _currentDate;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _currentDate = DateTime(now.year, now.month, now.day);
    _currentJulianDate = gregorianCalendarToJulianDate(_currentDate);
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
        GCWDropDown<CalendarSystem>(
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
    var output = <String, Object?>{};
    switch (_currentCalendarSystem) {
      case CalendarSystem.MODIFIEDJULIANDATE:
        jd = ModifedJulianDateToJulianDate(_currentJulianDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]!);
        break;
      case CalendarSystem.JULIANDATE:
        jd = _currentJulianDate;
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]!);
        break;
      case CalendarSystem.GREGORIANCALENDAR:
        jd = gregorianCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]!);
        break;
      case CalendarSystem.JULIANCALENDAR:
        jd = julianCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]!);
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
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]!);
        break;
      case CalendarSystem.POTRZEBIECALENDAR:
        jd = PotrzebieCalendarToJulianDate(_currentDate);
        output['dates_weekday_title'] = i18n(context, WEEKDAY[Weekday(jd)]!);
        break;
      default:
        return Container();
    }

    output['dates_calendar_system_juliandate'] = (jd + 0.5).floor();

    output['dates_calendar_system_juliancalendar'] =
        _DateOutputToString(context, julianDateToJulianCalendar(jd), CalendarSystem.JULIANCALENDAR);

    output['dates_calendar_system_modifiedjuliandate'] = JulianDateToModifedJulianDate(jd);

    output['dates_calendar_system_gregoriancalendar'] =
        _DateOutputToString(context, julianDateToGregorianCalendar(jd), CalendarSystem.GREGORIANCALENDAR);

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

    output['dates_calendar_system_potrzebiecalendar'] = _PotrzebieToString(jd);

    return GCWDefaultOutput(
        child: GCWColumnedMultilineOutput(
            data: output.entries.map((entry) {
                    return [i18n(context, entry.key), entry.value];
                  }).toList(),
            flexValues: const [1, 1]
          ),
    );
  }

  String _PotrzebieToString(double jd) {
    PotrzebieCalendarOutput p = JulianDateToPotrzebieCalendar(jd);

    var locale = Localizations.localeOf(context).toString();
    var monthName = MONTH_NAMES[CalendarSystem.POTRZEBIECALENDAR]![p.date.month].toString();
    var dateStr = replaceMonthNameWithCustomString(p.date, 'yMMMMd', locale, monthName);

    return dateStr.replaceFirst(p.date.year.toString(), '${p.date.year} ${p.suffix}');
  }

  String _HebrewDateToString(DateTime hebrewDate, double jd) {
    if (hebrewDate.year < 0) return i18n(context, 'dates_calendar_error');

    var hebrewMonth =  MONTH_NAMES[CalendarSystem.HEBREWCALENDAR]![hebrewDate.month];

    if (! typeOfJewYear(JewishYearLength(jd)).contains('embolistic')) {
      if (hebrewDate.month > 6) {
        hebrewMonth =  MONTH_NAMES[CalendarSystem.HEBREWCALENDAR]![hebrewDate.month + 1];
      }
    }

    var locale = Localizations.localeOf(context).toString();
    return replaceMonthNameWithCustomString(hebrewDate, 'yMMMMd', locale, hebrewMonth);
  }

  String? _DateOutputToString(BuildContext context, DateTime date, CalendarSystem calendar) {
    var locale = Localizations.localeOf(context).toString();

    switch (calendar) {
      case CalendarSystem.ISLAMICCALENDAR:
      case CalendarSystem.PERSIANYAZDEGARDCALENDAR:
      case CalendarSystem.COPTICCALENDAR:
        if (date.year < 0) return i18n(context, 'dates_calendar_error');
        var monthName = MONTH_NAMES[calendar]![date.month];
        return replaceMonthNameWithCustomString(date, 'yMMMMd', locale, monthName);
      case CalendarSystem.GREGORIANCALENDAR:
      case CalendarSystem.JULIANCALENDAR:
        return DateFormat('yMMMMd', locale).format(date);
      default:
        return null;
    }
  }

  bool _invalidMayaDate(double jd) {
    return (JulianDateToMayaDayCount(jd) < 0);
  }
}
