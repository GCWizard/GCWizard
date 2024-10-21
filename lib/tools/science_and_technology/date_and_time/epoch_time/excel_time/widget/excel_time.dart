import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/logic/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/common/widget/epoch_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/excel_time/logic/excel_time.dart';

/*class ExcelTime extends StatefulWidget {
  const ExcelTime({Key? key}) : super(key: key);

  @override
  _ExcelTimeState createState() => _ExcelTimeState();
}*/

class ExcelTime extends EpochTime {
  const ExcelTime({Key? key})
      : super(
      key: key,
      min: 0,
      max: 100000000, //max days according to DateTime https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
      epochType: EPOCH_TIMES.EXCEL1900,
      timestampIsInt: false,
      epochToDate: ExcelTimeToDateTimeUTC,
      dateToEpoch: DateTimeUTCToExcelTime);
}


/*class _ExcelTimeState extends State<ExcelTime> {
  double _currentTimeStamp = 0;
  var _currentDateTimeEncrypt = DateTimeTZ.now();
  var _currentDateTimeDecrypt = DateTimeTZ.now();
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

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
          },
        ),
        (_currentMode == GCWSwitchPosition.right)
          ? Column(
            children: [
              GCWDoubleSpinner(
                  value: _currentTimeStamp,
                  min: 0,
                  max:
                  100000000, //max days according to DateTime https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
                  numberDecimalDigits: 11,
                  onChanged: (value) {
                    setState(() {
                      _currentTimeStamp = value;
                    });
                  }),
              GCWDateTimePicker(
                datetime: _currentDateTimeDecrypt,
                config: const {
                  DateTimePickerConfig.TIMEZONES
                },
                onChanged: (datetime) {
                  setState(() {
                    _currentDateTimeDecrypt = datetime;
                  });
                },
              ),
            ],
          )
        : GCWDateTimePicker(
            datetime: _currentDateTimeEncrypt,
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
    ExcelTimeOutput output;
    if (_currentMode == GCWSwitchPosition.left) {
      //Date to Unix
      output = DateTimeToExcelTime(_currentDateTimeEncrypt.dateTimeUtc);
    } else {
      //EXCEL to Date
      output = ExcelTimeToDateTime(_currentTimeStamp);
    }
    return GCWDefaultOutput(
      child: output.Error.startsWith('dates_')
          ? i18n(context, output.Error)
          : _currentMode == GCWSwitchPosition.left
              ? output.ExcelTimeStamp
              : _formatDate(context, DateTimeTZ(dateTimeUtc: output.GregorianDateTimeUTC, timezone: _currentDateTimeDecrypt.timezone).toLocalTime(), (output.Error == 'EXCEL_BUG')),
    );
  }


}*/
