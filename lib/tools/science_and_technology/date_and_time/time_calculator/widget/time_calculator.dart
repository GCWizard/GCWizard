import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

// enabling int value to get passed as reference
class _WrapperForInt {
  int value;
  _WrapperForInt(this.value);
}

class TimeCalculator extends StatefulWidget {
  @override
  TimeCalculatorState createState() => TimeCalculatorState();
}

class TimeCalculatorState extends State<TimeCalculator> {
  var _currentMode = GCWSwitchPosition.left;
  Duration _currentStartTime;
  Duration _currentEndTime;

  TextEditingController _startDaysController;
  TextEditingController _startHoursController;
  TextEditingController _startMinutesController;
  TextEditingController _startSecondsController;

  @override
  void initState() {
    super.initState();
    _currentStartTime = Duration();
    _currentEndTime = Duration();

    _startDaysController = TextEditingController(text: _currentStartTime.inDays.toString());
    _startHoursController = TextEditingController(text: _currentStartTime.inHours.remainder(24).toString());
    _startMinutesController = TextEditingController(text: _currentStartTime.inMinutes.remainder(60).toString());
    _startSecondsController = TextEditingController(text: _currentStartTime.inSeconds.remainder(60).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'dates_timecalculator_starttime')),
        GCWDateTimePicker(
          config: {DateTimePickerConfig.DAY, DateTimePickerConfig.TIME, DateTimePickerConfig.SECOND_AS_INT},
          dayController: _startDaysController,
          hoursController: _startHoursController,
          minutesController: _startMinutesController,
          secondsController: _startSecondsController,
          minDays: 0,
          maxDays: null,
          duration: _currentStartTime,
          onChanged: (value) {
            setState(() {
              _currentStartTime = value['duration'];
            });
          },
        ),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'dates_timecalculator_operation'),
          leftValue: '+',
          rightValue: '-',
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'dates_timecalculator_endtime')),
        GCWDateTimePicker(
          config: {DateTimePickerConfig.DAY, DateTimePickerConfig.TIME, DateTimePickerConfig.SECOND_AS_INT},
          minDays: 0,
          maxDays: null,
          duration: _currentEndTime,
          onChanged: (value) {
            setState(() {
              _currentEndTime = value['duration'];
            });
          },
        ),
        GCWDefaultOutput(
          child: _buildOutput(),
        )
      ],
    );
  }

  _buildOutput() {
    Duration finalTime;
    if (_currentMode == GCWSwitchPosition.left)
      finalTime = _currentStartTime + _currentEndTime;
    else
      finalTime = _currentStartTime - _currentEndTime;

    var output = formatDurationToHHmmss(finalTime, milliseconds: false);

    return Column(
      children: [
        GCWOutputText(
          text: output,
        ),
        GCWButton(
          text: i18n(context, 'dates_timecalculator_resulttoinput'),
          onPressed: () {
            setState(() {
              _currentStartTime = finalTime;

              _startDaysController.text = finalTime.inDays.toString();
              _startHoursController.text = finalTime.inHours.remainder(24).toString();
              _startMinutesController.text = finalTime.inMinutes.remainder(60).toString();
              _startSecondsController.text = finalTime.inSeconds.remainder(60).toString();
            });
          },
        )
      ],
    );
  }
}
