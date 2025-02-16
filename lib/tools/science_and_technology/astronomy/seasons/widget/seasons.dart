import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/seasons.dart' as seasons;
import 'package:intl/intl.dart';

class Seasons extends StatefulWidget {
  const Seasons({Key? key}) : super(key: key);

  @override
  _SeasonsState createState() => _SeasonsState();
}

class _SeasonsState extends State<Seasons> {
  int _currentYear = DateTime.now().year;
  var _currentTimeZoneOffset = DateTime.now().timeZoneOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, 'common_year'),
        ),
        GCWIntegerSpinner(
          value: _currentYear,
          min: -1000,
          max: 3000,
          onChanged: (value) {
            setState(() {
              _currentYear = value;
            });
          },
        ),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.TIMEZONES},
          onChanged: (datetime) {
            setState(() {
              _currentTimeZoneOffset = datetime.timezone;
            });
          }
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var season = seasons.seasons(_currentYear, _currentTimeZoneOffset);
    var spring = season.spring.toLocalTime();
    var summer = season.summer.toLocalTime();
    var autumn = season.autumn.toLocalTime();
    var winter = season.winter.toLocalTime();
    var aphel = seasons.aphelion(_currentYear, _currentTimeZoneOffset);
    var perihel = seasons.perihelion(_currentYear, _currentTimeZoneOffset);

    var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());
    var timeFormat = DateFormat('HH:mm:ss.SSS');

    var outputs = [
      [
        i18n(context, 'astronomy_seasons_spring'),
        dateFormat.format(spring) + ' ' + timeFormat.format(spring)
      ],
      [
        i18n(context, 'astronomy_seasons_summer'),
        dateFormat.format(summer) + ' ' + timeFormat.format(summer)
      ],
      [
        i18n(context, 'astronomy_seasons_autumn'),
        dateFormat.format(autumn) + ' ' + timeFormat.format(autumn)
      ],
      [
        i18n(context, 'astronomy_seasons_winter'),
        dateFormat.format(winter) + ' ' + timeFormat.format(winter)
      ],
      [
        i18n(context, 'astronomy_seasons_perihelion'),
        dateFormat.format(perihel.dateTimeTZ.toLocalTime()) +
            ' ' +
            timeFormat.format(perihel.dateTimeTZ.toLocalTime()) +
            '\n' +
            i18n(context, 'astronomy_seasons_distance') +
            ' = ' +
            NumberFormat('0.0000000').format(perihel.value) +
            ' AU'
      ],
      [
        i18n(context, 'astronomy_seasons_aphelion'),
        dateFormat.format(aphel.dateTimeTZ.toLocalTime()) +
            ' ' +
            timeFormat.format(aphel.dateTimeTZ.toLocalTime()) +
            '\n' +
            i18n(context, 'astronomy_seasons_distance') +
            ' = ' +
            NumberFormat('0.0000000').format(aphel.value) +
            ' AU'
      ],
    ];

    return GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))], data: outputs, flexValues: const [1, 2]);
  }
}
