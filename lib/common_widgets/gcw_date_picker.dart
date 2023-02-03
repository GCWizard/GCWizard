import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';

class GCWDatePicker extends StatefulWidget {
  final Function onChanged;
  final date;
  final CalendarSystem type;

  const GCWDatePicker({Key key, this.onChanged, this.date, this.type: CalendarSystem.GREGORIANCALENDAR})
      : super(key: key);

  @override
  GCWDatePickerState createState() => GCWDatePickerState();
}

class GCWDatePickerState extends State<GCWDatePicker> {
  var _currentYear;
  var _currentMonth;
  var _currentDay;

  var _monthFocusNode;
  var _dayFocusNode;

  @override
  void initState() {
    super.initState();

    DateTime date = widget.date ?? DateTime.now();
    _currentYear = date.year;
    _currentMonth = date.month;
    _currentDay = date.day;

    _monthFocusNode = FocusNode();
    _dayFocusNode = FocusNode();
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
              ),
              padding: EdgeInsets.only(right: 2)),
        ),
        Expanded(child: Padding(child: _buildMonthSpinner(widget.type), padding: EdgeInsets.only(left: 2, right: 2))),
        Expanded(
            child: Padding(
          child: _buildDaySpinner(widget.type),
          padding: EdgeInsets.only(left: 2),
        ))
      ],
    );
  }

  Widget _buildDaySpinner(var type) {
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

  Widget _buildMonthSpinner(var type) {
    if (type == CalendarSystem.ISLAMICCALENDAR ||
        type == CalendarSystem.PERSIANYAZDEGARDCALENDAR ||
        type == CalendarSystem.HEBREWCALENDAR ||
        type == CalendarSystem.POTRZEBIECALENDAR ||
        type == CalendarSystem.COPTICCALENDAR)
      return GCWDropDownSpinner(
        index: _currentMonth ?? (widget.date != null ? widget.date.month - 1 : null) ?? 0,
        layout: SpinnerLayout.VERTICAL,
        items: MONTH_NAMES[type].entries.map((entry) {
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
    if (type == CalendarSystem.JULIANCALENDAR || type == CalendarSystem.GREGORIANCALENDAR)
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
  }

  _setCurrentNamedCalendarValueAndEmitOnChange() {
    widget.onChanged(DateTime(_currentYear, _currentMonth + 1, _currentDay));
  }

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged(DateTime(_currentYear, _currentMonth, _currentDay));
  }
}
