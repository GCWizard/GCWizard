import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';

class GCWDatePicker extends StatefulWidget {
  final void Function (DateTime) onChanged;
  final DateTime date;
  final CalendarSystem type;

  const GCWDatePicker({Key? key, required this.onChanged, required this.date, this.type = CalendarSystem.GREGORIANCALENDAR})
      : super(key: key);

  @override
  GCWDatePickerState createState() => GCWDatePickerState();
}

class GCWDatePickerState extends State<GCWDatePicker> {
  late int _currentYear;
  late int _currentMonth;
  late int _currentDay;

  final _monthFocusNode = FocusNode();
  final _dayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    DateTime date = widget.date;
    _currentYear = date.year;
    _currentMonth = date.month;
    _currentDay = date.day;
  }

  @override
  void dispose() {
    _monthFocusNode.dispose();
    _dayFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //  mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: GCWIntegerSpinner(
                layout: SpinnerLayout.VERTICAL,
                value: _currentYear,
                min: -5000,
                max: 5000,
                onChanged: (value) {
                  setState(() {
                    _currentYear = value;
                    _setCurrentValueAndEmitOnChange();

                    if (_currentYear.toString().length == 5) {
                      FocusScope.of(context).requestFocus(_monthFocusNode);
                    }
                  });
                },
              )),
        ),
        Expanded(child: Padding(padding: const EdgeInsets.only(left: 2, right: 2), child: _buildMonthSpinner(widget.type))),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: _buildDaySpinner(widget.type),
        ))
      ],
    );
  }

  Widget _buildDaySpinner(CalendarSystem type) {
    int maxDays = 31;
    if (type == CalendarSystem.POTRZEBIECALENDAR) maxDays = 10;

    return GCWIntegerSpinner(
      focusNode: _dayFocusNode,
      layout: SpinnerLayout.VERTICAL,
      value: _currentDay,
      min: 1,
      max: maxDays,
      onChanged: (value) {
        setState(() {
          _currentDay = value;
          _setCurrentValueAndEmitOnChange();
        });
      },
    );
  }

  Widget _buildMonthSpinner(CalendarSystem type) {
    if (type == CalendarSystem.ISLAMICCALENDAR ||
        type == CalendarSystem.PERSIANYAZDEGARDCALENDAR ||
        type == CalendarSystem.HEBREWCALENDAR ||
        type == CalendarSystem.POTRZEBIECALENDAR ||
        type == CalendarSystem.COPTICCALENDAR) {
      return GCWDropDownSpinner(
        index: _currentMonth,
        layout: SpinnerLayout.VERTICAL,
        items: MONTH_NAMES[type]!.entries.map((entry) {
          return GCWDropDownMenuItem(value: entry.key - 1, child: entry.value);
        }).toList(),
        onChanged: (value) {
          setState(() {
            _currentMonth = value;
            _setCurrentNamedCalendarValueAndEmitOnChange();
            if (_currentMonth.toString().length == 2) {
              FocusScope.of(context).requestFocus(_dayFocusNode);
            }
          });
        },
      );
    } else if (type == CalendarSystem.JULIANCALENDAR || type == CalendarSystem.GREGORIANCALENDAR) {
      return GCWIntegerSpinner(
        focusNode: _monthFocusNode,
        layout: SpinnerLayout.VERTICAL,
        value: _currentMonth,
        min: 1,
        max: 12,
        onChanged: (value) {
          setState(() {
            _currentMonth = value;
            _setCurrentValueAndEmitOnChange();

            if (_currentMonth.toString().length == 2) {
              FocusScope.of(context).requestFocus(_dayFocusNode);
            }
          });
        },
      );
    } else {
      return Container();
    }
  }

  void _setCurrentNamedCalendarValueAndEmitOnChange() {
    widget.onChanged(DateTime(_currentYear, _currentMonth + 1, _currentDay));
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(DateTime(_currentYear, _currentMonth, _currentDay));
  }
}
