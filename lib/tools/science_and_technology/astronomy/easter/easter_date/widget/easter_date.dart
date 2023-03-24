import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/easter/logic/easter.dart';
import 'package:intl/intl.dart';

class EasterDate extends StatefulWidget {
  const EasterDate({Key? key}) : super(key: key);

  @override
  EasterDateState createState() => EasterDateState();
}

class EasterDateState extends State<EasterDate> {
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
          min: 1583,
          max: 3042,
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
    var date = gregorianEasterDate(_currentYear);

    return GCWDefaultOutput(child: DateFormat('yMd', Localizations.localeOf(context).toString()).format(date));
  }
}
