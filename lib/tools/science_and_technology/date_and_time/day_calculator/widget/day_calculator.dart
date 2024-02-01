import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/logic/day_calculator.dart';

class DayCalculator extends StatefulWidget {
  const DayCalculator({Key? key}) : super(key: key);

  @override
  _DayCalculatorState createState() => _DayCalculatorState();
}

class _DayCalculatorState extends State<DayCalculator> {
  late DateTime _currentStartDate;
  late DateTime _currentEndDate;

  var _currentCountStart = true;
  var _currentCountEnd = true;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _currentStartDate = DateTime(now.year, now.month, now.day);
    _currentEndDate = DateTime(now.year, now.month, now.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'dates_daycalculator_startdate')),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.DATE},
          datetime: _currentStartDate,
          onChanged: (value) {
            setState(() {
              _currentStartDate = value.datetime;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'dates_daycalculator_enddate')),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.DATE},
          datetime: _currentEndDate,
          onChanged: (value) {
            setState(() {
              _currentEndDate = value.datetime;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'dates_daycalculator_countstart'),
          value: _currentCountStart,
          onChanged: (value) {
            setState(() {
              _currentCountStart = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'dates_daycalculator_countend'),
          value: _currentCountEnd,
          onChanged: (value) {
            setState(() {
              _currentCountEnd = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var outputData = calculateDayDifferences(_currentStartDate, _currentEndDate,
        countStart: _currentCountStart, countEnd: _currentCountEnd);

    var rows = [
      [i18n(context, 'dates_daycalculator_days'), outputData.days],
      [i18n(context, 'dates_daycalculator_hours'), outputData.hours],
      [i18n(context, 'dates_daycalculator_minutes'), outputData.minutes],
      [i18n(context, 'dates_daycalculator_seconds'), outputData.seconds]
    ];

    return GCWColumnedMultilineOutput(firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))], data: rows);
  }
}
