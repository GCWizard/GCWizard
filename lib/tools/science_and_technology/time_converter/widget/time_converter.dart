import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/time_converter/logic/time_converter.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';

class TimeConverter extends StatefulWidget {
  const TimeConverter({super.key});

  @override
  _TimeConverterState createState() => _TimeConverterState();
}

class _TimeConverterState extends State<TimeConverter> {
  late TextEditingController _controllerWeek;
  late TextEditingController _controllerDay;
  late TextEditingController _controllerHour;
  late TextEditingController _controllerMinute;
  late TextEditingController _controllerSecond;

  DoubleText _currentInputWeek = defaultDoubleText;
  DoubleText _currentInputDay = defaultDoubleText;
  DoubleText _currentInputHour = defaultDoubleText;
  DoubleText _currentInputMinute = defaultDoubleText;
  DoubleText _currentInputSecond = defaultDoubleText;


  @override
  void initState() {
    super.initState();
    _controllerWeek = TextEditingController(text: _currentInputWeek.text);
    _controllerDay = TextEditingController(text: _currentInputDay.text);
    _controllerHour = TextEditingController(text: _currentInputHour.text);
    _controllerMinute = TextEditingController(text: _currentInputMinute.text);
    _controllerSecond = TextEditingController(text: _currentInputSecond.text);
  }

  @override
  void dispose() {
    _controllerWeek.dispose();
    _controllerDay.dispose();
    _controllerHour.dispose();
    _controllerMinute.dispose();
    _controllerSecond.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: GCWDoubleTextField(
                  controller: _controllerWeek,
                  hintText: i18n(context, 'common_weeks'),
                  onChanged: (text) {
                    setState(() {
                      _currentInputWeek = text;
                    });
                  },
                ),
              ),
            ),
            Expanded(child: Container(
                padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                child: GCWDoubleTextField(
                  controller: _controllerDay,
                  hintText: i18n(context, 'common_days'),
                  onChanged: (text) {
                    setState(() {
                      _currentInputDay = text;
                    });
                  },
                ),
              ),
            ),
            Expanded(child: Container(
                padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                child: GCWDoubleTextField(
                  controller: _controllerHour,
                  hintText: i18n(context, 'common_hours'),
                  onChanged: (text) {
                    setState(() {
                      _currentInputHour = text;
                    });
                  },
                ),
              ),
            ),
            Expanded(child: Container(
                padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                child: GCWDoubleTextField(
                  controller: _controllerMinute,
                  hintText: i18n(context, 'common_minutes'),
                  onChanged: (text) {
                    setState(() {
                      _currentInputMinute = text;
                    });
                  },
                ),
              ),
            ),
            Expanded(child: Container(
                padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
                child: GCWDoubleTextField(
                  controller: _controllerSecond,
                  hintText: i18n(context, 'common_seconds'),
                  onChanged: (text) {
                    setState(() {
                      _currentInputSecond = text;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    ConvertTimesOutput output = convertTimes(
        _currentInputWeek.value,
        _currentInputDay.value,
        _currentInputHour.value,
        _currentInputMinute.value,
        _currentInputSecond.value);

    List<List<String>> outputValues = [
      [i18n(context, 'common_weeks'), output.weeks.toString()],
      [i18n(context, 'common_days'), output.days.toString()],
      [i18n(context, 'common_hours'), output.hours.toString()],
      [i18n(context, 'common_minutes'), output.minutes.toString()],
      [i18n(context, 'common_seconds'), output.seconds.toString()],
    ];

    return GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
          data: outputValues,
          flexValues: const [3, 3]
    );
  }
}
