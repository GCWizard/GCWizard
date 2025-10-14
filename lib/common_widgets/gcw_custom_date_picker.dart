import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';

class GCWCustomDatePicker extends StatefulWidget {
  final void Function(CustomCalendarDate) onChanged;
  final CustomCalendarDate date;
  final CalendarSystem type;

  final TextEditingController? yearController;
  final TextEditingController? monthController;
  final TextEditingController? dayController;

  const GCWCustomDatePicker({
    super.key,
    required this.onChanged,
    required this.date,
    this.type = CalendarSystem.GREGORIANCALENDAR,
    this.yearController,
    this.monthController,
    this.dayController,
  });

  @override
  _GCWCustomDatePickerState createState() => _GCWCustomDatePickerState();
}

class _GCWCustomDatePickerState extends State<GCWCustomDatePicker> {
  late int _currentYear;
  late int _currentMonth;
  late int _currentDay;

  final _monthFocusNode = FocusNode();
  final _dayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    initValues();
  }

  @override
  void didUpdateWidget(GCWCustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    initValues();
  }

  void initValues() {
    CustomCalendarDate date = widget.date;
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
                controller: widget.yearController,
                value: _currentYear,
                min: -5000,
                max: 9000,
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
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: _buildMonthSpinner(widget.type)
            )),
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
      controller: widget.dayController,
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
    switch (type) {
      case CalendarSystem.ISLAMICCALENDAR:
      case CalendarSystem.PERSIANYAZDEGARDCALENDAR:
      case CalendarSystem.HEBREWCALENDAR:
      case CalendarSystem.POTRZEBIECALENDAR:
      case CalendarSystem.COPTICCALENDAR:
      return GCWDropDownSpinner(
        index: _currentMonth,
        layout: SpinnerLayout.VERTICAL,
        items: MONTH_NAMES[type]!.entries.map((entry) {
          return GCWDropDownMenuItem(value: entry.key, child: entry.value);
        }).toList(),
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
      case CalendarSystem.JULIANCALENDAR:
      case CalendarSystem.GREGORIANCALENDAR:
      return GCWIntegerSpinner(
        focusNode: _monthFocusNode,
        layout: SpinnerLayout.VERTICAL,
        controller: widget.monthController,
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
      default: return Container();
    }
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(CustomCalendarDate(
        year: _currentYear, month: _currentMonth, day: _currentDay));
  }
}
