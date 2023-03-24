import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_of_the_year/logic/day_of_the_year.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

class DayOfTheYear extends StatefulWidget {
  const DayOfTheYear({Key? key}) : super(key: key);

  @override
  DayOfTheYearState createState() => DayOfTheYearState();
}

class DayOfTheYearState extends State<DayOfTheYear> {
  var _currentMode = GCWSwitchPosition.right;
  late DateTime _currentEncodeDate;
  late DateTime _currentDecodeDate;

  late FocusNode _dayFocusNode;
  var _currentYear = 0;
  var _currentDayOfTheYear = 1;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _currentEncodeDate = DateTime(now.year, now.month, now.day);
    _currentDecodeDate = DateTime(now.year, now.month, now.day);
    _dayFocusNode = FocusNode();

    _currentYear = _currentEncodeDate.year;
    _currentDayOfTheYear = dayNumber(_currentEncodeDate);

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
          },
        ),
        _currentMode == GCWSwitchPosition.right ? _decodeWidget() : _encodeWidget(),
        _buildOutput(context)
      ],
    );
  }

  Widget _decodeWidget() {
    return Column(
        children: <Widget>[GCWTextDivider(text: i18n(context, 'dates_day_of_the_year_date')), _dayOfTheYearPicker()]);
  }

  Widget _encodeWidget() {
    return Column(children: <Widget>[
      GCWTextDivider(text: i18n(context, 'dates_weekday_date')),
      GCWDateTimePicker(
        config: const {DateTimePickerConfig.DATE},
        datetime: _currentDecodeDate,
        onChanged: (value) {
          setState(() {
            _currentDecodeDate = value.datetime;
          });
        },
      ),
    ]);
  }

  Widget _dayOfTheYearPicker() {
    var widgets = <Widget, int>{}; // widget: flex
    widgets.addAll({
      GCWIntegerSpinner(
        layout: SpinnerLayout.VERTICAL,
        value: _currentYear,
        min: -5000,
        max: 5000,
        onChanged: (value) {
          setState(() {
            _currentYear = value;

            if (_currentYear.toString().length == 4) {
              FocusScope.of(context).requestFocus(_dayFocusNode);
            }
          });
        },
      ): 5
    });

    widgets.addAll({
      GCWIntegerSpinner(
        focusNode: _dayFocusNode,
        layout: SpinnerLayout.VERTICAL,
        value: _currentDayOfTheYear,
        min: 0,
        max: 9999,
        onChanged: (value) {
          setState(() {
            _currentDayOfTheYear = value;
          });
        },
      ): 4
    });

    return Column(
      children: <Widget>[
        GCWToolBar(
          flexValues: widgets.values.toList(),
          children: widgets.keys.toList(),
        ),
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    DayOfTheYearOutput? outputData;
    if (_currentMode == GCWSwitchPosition.right) {
      outputData = calculateDayInfos(_currentYear, _currentDayOfTheYear);
    } else {
      outputData = calculateDateInfos(_currentDecodeDate);
    }

    var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());

    var children = <Widget>[];

    if (_currentMode == GCWSwitchPosition.right) {
      children.add(GCWDefaultOutput(
        child: dateFormat.format(outputData.date),
      ));
    } else {
      children.add(GCWDefaultOutput(
        child: outputData.dayNumber,
      ));
    }

    children.add(GCWOutput(
      title: i18n(context, 'dates_weekday'),
      child: i18n(context, WEEKDAY[outputData.weekday]!),
    ));

    children.add(GCWOutput(
      title: 'ISO 8601',
      child: GCWColumnedMultilineOutput(
          data: [
                  [i18n(context, 'dates_weekday_number'), outputData.weekday],
                  [i18n(context, 'dates_week_number'), outputData.weekNumberIso],
                ]
          ),
    ));

    children.add(GCWOutput(
        title: i18n(context, 'dates_day_of_the_year_alternative'),
        child: GCWColumnedMultilineOutput(
            data: [
                    [i18n(context, 'dates_weekday_number'), outputData.weekdayAlternate],
                    [i18n(context, 'dates_week_number'), outputData.weekNumberAlternate],
                  ]
          ),
        ));

    return Column(children: children);
  }
}
