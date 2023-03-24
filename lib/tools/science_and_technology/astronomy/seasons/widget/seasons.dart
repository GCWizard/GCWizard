import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/seasons.dart';
import 'package:intl/intl.dart';

class Seasons extends StatefulWidget {
  const Seasons({Key? key}) : super(key: key);

  @override
  SeasonsState createState() => SeasonsState();
}

class SeasonsState extends State<Seasons> {
  int _currentYear = DateTime.now().year;

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
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var season = seasons(_currentYear);
    var aphel = aphelion(_currentYear);
    var perihel = perihelion(_currentYear);

    var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());
    var timeFormat = DateFormat('HH:mm:ss.SSS');

    var outputs = [
      [
        i18n(context, 'astronomy_seasons_spring'),
        dateFormat.format(season.spring) + ' ' + timeFormat.format(season.spring) + ' GMT'
      ],
      [
        i18n(context, 'astronomy_seasons_summer'),
        dateFormat.format(season.summer) + ' ' + timeFormat.format(season.summer) + ' GMT'
      ],
      [
        i18n(context, 'astronomy_seasons_autumn'),
        dateFormat.format(season.autumn) + ' ' + timeFormat.format(season.autumn) + ' GMT'
      ],
      [
        i18n(context, 'astronomy_seasons_winter'),
        dateFormat.format(season.winter) + ' ' + timeFormat.format(season.winter) + ' GMT'
      ],
      [
        i18n(context, 'astronomy_seasons_perihelion'),
        dateFormat.format(perihel.datetime) +
            ' ' +
            timeFormat.format(perihel.datetime) +
            ' GMT\n' +
            i18n(context, 'astronomy_seasons_distance') +
            ' = ' +
            NumberFormat('0.0000000').format(perihel.value) +
            ' AU'
      ],
      [
        i18n(context, 'astronomy_seasons_aphelion'),
        dateFormat.format(aphel.datetime) +
            ' ' +
            timeFormat.format(aphel.datetime) +
            ' GMT\n' +
            i18n(context, 'astronomy_seasons_distance') +
            ' = ' +
            NumberFormat('0.0000000').format(aphel.value) +
            ' AU'
      ],
    ];

    return GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
        data: outputs,
        flexValues: const [1, 2]
    );
  }
}
