import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';

class GCWDatePicker extends StatefulWidget {
  final void Function(DateTime) onChanged;
  final DateTime date;

  final TextEditingController? yearController;
  final TextEditingController? monthController;
  final TextEditingController? dayController;

  const GCWDatePicker({
    super.key,
    required this.onChanged,
    required this.date,
    this.yearController,
    this.monthController,
    this.dayController,
  });

  @override
  _GCWDatePickerState createState() => _GCWDatePickerState();
}

class _GCWDatePickerState extends State<GCWDatePicker> {
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
  void didUpdateWidget(GCWDatePicker oldWidget) {
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
            child: Padding(padding: const EdgeInsets.only(left: 2, right: 2), child: _buildMonthSpinner())),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: _buildDaySpinner(),
        ))
      ],
    );
  }

  Widget _buildDaySpinner() {
    return GCWIntegerSpinner(
      focusNode: _dayFocusNode,
      layout: SpinnerLayout.VERTICAL,
      controller: widget.dayController,
      value: _currentDay,
      min: 1,
      max: 31,
      onChanged: (value) {
        setState(() {

          _currentDay = value;
          _setCurrentValueAndEmitOnChange();
        });
      },
    );
  }

  Widget _buildMonthSpinner() {
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

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(DateTime(_currentYear, _currentMonth, _currentDay));
  }
}
