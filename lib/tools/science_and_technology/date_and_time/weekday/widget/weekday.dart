import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

class Weekday extends StatefulWidget {
  const Weekday({Key? key}) : super(key: key);

  @override
  _WeekdayState createState() => _WeekdayState();
}

class _WeekdayState extends State<Weekday> {
  late DateTimeTZ _currentDate;

  @override
  void initState() {
    _currentDate = DateTimeTZ.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'dates_weekday_date')),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.DATE},
          onChanged: (value) {
            setState(() {
              _currentDate = value;
            });
          },
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var weekday = _currentDate.toLocalTime().weekday;
    var output = i18n(context, WEEKDAY[weekday] ?? '');

    return GCWDefaultOutput(child: output);
  }
}
