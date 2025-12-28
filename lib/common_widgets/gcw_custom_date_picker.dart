import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';

import 'package:gc_wizard/application/theme/theme.dart';

class GCWCustomDatePicker extends StatefulWidget {
  final void Function(DateTime) onChanged;
  final DateTime date;
  final List<String>? months;
  final int? maxDays;

  final TextEditingController? yearController;
  final TextEditingController? monthController;
  final TextEditingController? dayController;

  const GCWCustomDatePicker({
    super.key,
    required this.onChanged,
    required this.date,
    this.yearController,
    this.monthController,
    this.dayController,
    this.months,
    this.maxDays,
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
                child: _buildMonthSpinner(widget.months))),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: _buildDaySpinner(widget.maxDays),
        ))
      ],
    );
  }

  Widget _buildDaySpinner(int? maxDays) {
    return GCWIntegerSpinner(
      focusNode: _dayFocusNode,
      layout: SpinnerLayout.VERTICAL,
      controller: widget.dayController,
      value: _currentDay,
      min: 1,
      max: maxDays ?? 31,
      onChanged: (value) {
        setState(() {
          _currentDay = value;
          _setCurrentValueAndEmitOnChange();
        });
      },
    );
  }

  Widget _buildMonthSpinner(List<String>? months) {
    if (months != null) {
      return GCWDropDownSpinner(
        index: _currentMonth,
        layout: SpinnerLayout.VERTICAL,
        //       onChanged: (value) {
        //         setState(() {
        //           _currentValue = value;
        //           widget.onChanged(_currentValue! + 1);
        //         });
        //       },
        //
        items: months.map((entry) {
          var text = entry;
          return Text(
            text,
            style: gcwTextStyle(),
          );
          //return GCWDropDownMenuItem(value: entry.key, child: entry.value);
        }).toList(),
        onChanged: (value) {
          setState(() {
            print(value);
            _currentMonth = value % months.length;
            _setCurrentValueAndEmitOnChange();
            if (_currentMonth.toString().length == 2) {
              FocusScope.of(context).requestFocus(_dayFocusNode);
            }
          });
        },
      );
    } else {
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
    }
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(DateTime(_currentYear, _currentMonth, _currentDay));
  }
}
