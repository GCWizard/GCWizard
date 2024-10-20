import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/logic/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/unix_time/logic/unix_time.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

class EpochTime extends StatefulWidget {

  final int min;
  final int max;
  final EPOCH_TIMES epochType;

  const EpochTime({Key? key, required this.min, required this.max, required this.epochType}) : super(key: key);

  @override
  _EpochTimeState createState() => _EpochTimeState();
}

class _EpochTimeState extends State<EpochTime> {
  int _currentTimeStamp = 0;
  var _currentDateTimeEncrypt = DateTimeTZ.now();
  var _currentDateTimeDecrypt = DateTimeTZ.now();
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
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
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              if (_currentMode == GCWSwitchPosition.left) {
                _currentDateTimeEncrypt = DateTimeTZ.now();
              } else {
                _currentDateTimeDecrypt = DateTimeTZ.now();
              }
            });
          },
        ),
        (_currentMode == GCWSwitchPosition.right) ?
        Column(
          children: [
            GCWIntegerSpinner(
                value: _currentTimeStamp,
                min: widget.min,
                max: widget.max,
                onChanged: (value) {
                  setState(() {
                    _currentTimeStamp = value;
                  });
                }),
          ],
        ) : GCWDateTimePicker(
          config: const {
            DateTimePickerConfig.DATE,
            DateTimePickerConfig.TIME,
            DateTimePickerConfig.SECOND_AS_INT,
            DateTimePickerConfig.TIMEZONES
          },
          onChanged: (datetime) {
            setState(() {
              _currentDateTimeEncrypt = datetime;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    EpochTimeOutput output;

    if (_currentMode == GCWSwitchPosition.left) {
      //Date to Epoch
      output = DateTimeUTCToUnixTime(_currentDateTimeEncrypt.dateTimeUtc);
    } else {
      //Epoch to Date
      output = UnixTimeToDateTimeUTC(_currentTimeStamp);
    }

    if (output.error.startsWith('dates_')) {
      return GCWDefaultOutput(
          child: i18n(context, output.error)
      );
    }
    if (_currentMode == GCWSwitchPosition.left) {
      return GCWDefaultOutput(
          child: output.timeStamp
      );
    } else {
      DateTime local = DateTimeTZ(dateTimeUtc: output.gregorianDateTimeUTC, timezone: DateTime.now().timeZoneOffset).toLocalTime();
      DateTime localPicker = DateTimeTZ(dateTimeUtc: output.gregorianDateTimeUTC, timezone: _currentDateTimeDecrypt.timezone).toLocalTime();
      String localTimezoneAllNames = DateTimeTZ(dateTimeUtc: output.gregorianDateTimeUTC, timezone: _currentDateTimeDecrypt.timezone).toLocalTimezoneAllNames();
      return GCWDefaultOutput(
        child: Column(
          children: [
            GCWColumnedMultilineOutput(
              hasHeader: false,
              flexValues: [8, 2, 4],
              data: [
                [
                  output.gregorianDateTimeUTC.timeZoneName,
                  output.gregorianDateTimeUTC.timeZoneOffset.inHours,
                  _formatDate(context, output.gregorianDateTimeUTC),
                ],
                [
                  DateTime.now().timeZoneName,
                  ((DateTime.now().timeZoneOffset.inMinutes ~/ 60).toString() + ':' + (DateTime.now().timeZoneOffset.inMinutes % 60).toString()).replaceAll(':0', ''),
                  _formatDate(context, local),
                ],
              ],
            ),
            GCWExpandableTextDivider(
              text: i18n(context, 'epoch_time_timezones'),
              expanded: false,
              child: Column(
                children: [
                  GCWDateTimePicker(
                    config: const {
                      DateTimePickerConfig.TIMEZONES
                    },
                    onChanged: (datetime) {
                      setState(() {
                        _currentDateTimeDecrypt = datetime;
                        localTimezoneAllNames = DateTimeTZ(dateTimeUtc: output.gregorianDateTimeUTC, timezone: _currentDateTimeDecrypt.timezone).toLocalTimezoneAllNames();
                      });
                    },
                  ),
                  GCWColumnedMultilineOutput(
                    hasHeader: false,
                    flexValues: [8, 2, 4],
                    data: [
                      [
                        localTimezoneAllNames,
                        ((_currentDateTimeDecrypt.timezone.inMinutes ~/ 60).toString() + ':' + (_currentDateTimeDecrypt.timezone.inMinutes % 60).toString()).replaceAll(':0', ''),
                        _formatDate(context, localPicker),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  String _formatDate(BuildContext context, DateTime datetime) {
    String loc = Localizations.localeOf(context).toString();
    return DateFormat.yMd(loc).add_jms().format(datetime).toString();
  }
}
