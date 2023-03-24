import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_rise_set/logic/sun_rise_set.dart' as logic;
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

class SunRiseSet extends StatefulWidget {
  const SunRiseSet({Key? key}) : super(key: key);

  @override
  SunRiseSetState createState() => SunRiseSetState();
}

class SunRiseSetState extends State<SunRiseSet> {
  var _currentDateTime = DateTimeTimezone(datetime: DateTime.now(), timezone: DateTime.now().timeZoneOffset);
  var _currentCoords = defaultBaseCoordinate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'common_location'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              _currentCoords = ret;
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'astronomy_riseset_date'),
        ),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.DATE, DateTimePickerConfig.TIMEZONES},
          onChanged: (datetime) {
            setState(() {
              _currentDateTime = datetime;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var sunRise = logic.SunRiseSet(
        _currentCoords.toLatLng() ?? defaultCoordinate,
        JulianDate(_currentDateTime),
        _currentDateTime.timezone,
        defaultEllipsoid);

    var outputs = [
      [
        i18n(context, 'astronomy_riseset_astronomicalmorning'),
        sunRise.astronomicalMorning.isNaN
            ? i18n(context, 'astronomy_riseset_notavailable')
            : formatHoursToHHmmss(sunRise.astronomicalMorning)
      ],
      [
        i18n(context, 'astronomy_riseset_nauticalmorning'),
        sunRise.nauticalMorning.isNaN
            ? i18n(context, 'astronomy_riseset_notavailable')
            : formatHoursToHHmmss(sunRise.nauticalMorning)
      ],
      [
        i18n(context, 'astronomy_riseset_civilmorning'),
        sunRise.civilMorning.isNaN
            ? i18n(context, 'astronomy_riseset_notavailable')
            : formatHoursToHHmmss(sunRise.civilMorning)
      ],
      [
        i18n(context, 'astronomy_riseset_sunrise'),
        sunRise.rise.isNaN ? i18n(context, 'astronomy_riseset_notavailable') : formatHoursToHHmmss(sunRise.rise)
      ],
      [
        i18n(context, 'astronomy_riseset_transit'),
        sunRise.transit.isNaN ? i18n(context, 'astronomy_riseset_notavailable') : formatHoursToHHmmss(sunRise.transit)
      ],
      [
        i18n(context, 'astronomy_riseset_sunset'),
        sunRise.set.isNaN ? i18n(context, 'astronomy_riseset_notavailable') : formatHoursToHHmmss(sunRise.set)
      ],
      [
        i18n(context, 'astronomy_riseset_civilevening'),
        sunRise.civilEvening.isNaN
            ? i18n(context, 'astronomy_riseset_notavailable')
            : formatHoursToHHmmss(sunRise.civilEvening)
      ],
      [
        i18n(context, 'astronomy_riseset_nauticalevening'),
        sunRise.nauticalEvening.isNaN
            ? i18n(context, 'astronomy_riseset_notavailable')
            : formatHoursToHHmmss(sunRise.nauticalEvening)
      ],
      [
        i18n(context, 'astronomy_riseset_astronomicalevening'),
        sunRise.astronomicalEvening.isNaN
            ? i18n(context, 'astronomy_riseset_notavailable')
            : formatHoursToHHmmss(sunRise.astronomicalEvening)
      ],
    ];

    return GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
        data: outputs
    );
  }
}
