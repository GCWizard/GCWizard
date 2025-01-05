import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar_week/logic/calendar_week.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

class CalendarWeek extends StatefulWidget {
  const CalendarWeek({Key? key}) : super(key: key);

  @override
  _CalendarWeekState createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {
  late DateTimeTZ _currentEncryptionDate;

  var _currentWeek = 1;
  late int _currentYear;

  var _currentMode = GCWSwitchPosition.right;
  var _currentISOMode = GCWSwitchPosition.left;

  @override
  void initState() {
    _currentEncryptionDate = DateTimeTZ.now();
    _currentYear = _currentEncryptionDate.toLocalTime().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
            value: _currentMode,
            onChanged: (value) {
              setState(() {
                _currentMode = value;
              });
            }),
        GCWTwoOptionsSwitch(
            title: i18n(context, 'dates_calendarweek_weektype'),
            leftValue: 'ISO',
            rightValue: 'US',
            value: _currentISOMode,
            onChanged: (value) {
              setState(() {
                _currentISOMode = value;
              });
            }),
        _currentMode == GCWSwitchPosition.left
            ? GCWDateTimePicker(
                config: const {DateTimePickerConfig.DATE},
                onChanged: (value) {
                  setState(() {
                    _currentEncryptionDate = value;
                  });
                },
              )
            : Column(
                children: [
                  GCWIntegerSpinner(
                      value: _currentYear,
                      min: -5000,
                      max: 5000,
                      onChanged: (int value) {
                        setState(() {
                          _currentYear = value;
                        });
                      }),
                  GCWIntegerSpinner(
                      value: _currentWeek,
                      min: 1,
                      max: 53,
                      onChanged: (int value) {
                        setState(() {
                          _currentWeek = value;
                        });
                      }),
                ],
              ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    Object out;

    if (_currentMode == GCWSwitchPosition.left) {
      out = calendarWeek(_currentEncryptionDate.toLocalTime(), iso: _currentISOMode == GCWSwitchPosition.left);
    } else {
      try {
        var dates = datesForCalendarWeek(_currentYear, _currentWeek, iso: _currentISOMode == GCWSwitchPosition.left);
        var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());

        out = GCWColumnedMultilineOutput(data: [
          [i18n(context, 'common_start'), dateFormat.format(dates.item1)],
          [i18n(context, 'common_end'), dateFormat.format(dates.item2)],
        ]);
      } catch (e) {
        out = i18n(context, 'dates_calendarweek_error_invalidweek');
      }
    }

    return GCWDefaultOutput(child: out);
  }
}
