import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/julian_date.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/sun_position.dart' as logic;
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_datetime_picker.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/utils.dart';
import 'package:intl/intl.dart';

class SunPosition extends StatefulWidget {
  @override
  SunPositionState createState() => SunPositionState();
}

class SunPositionState extends State<SunPosition> {
  var _currentDateTime = {'datetime': DateTime.now(), 'timezone': DateTime.now().timeZoneOffset};
  var _currentCoords = defaultCoordinate;
  var _currentCoordsFormat = defaultCoordFormat();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'common_location'),
          coordsFormat: _currentCoordsFormat,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat = ret['coordsFormat'];
              _currentCoords = ret['value'];
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'astronomy_postion_datetime'),
        ),
        GCWDateTimePicker(
          config: {DateTimePickerConfig.DATE, DateTimePickerConfig.TIME, DateTimePickerConfig.TIMEZONES},
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
    var format = NumberFormat('0.000');

    var julianDate = JulianDate(_currentDateTime['datetime'], _currentDateTime['timezone']);

    var sunPosition = logic.SunPosition(_currentCoords, julianDate, defaultEllipsoid());

    var outputsSun = [
      [i18n(context, 'astronomy_position_eclipticlongitude'), format.format(sunPosition.eclipticLongitude) + '°'],
      [i18n(context, 'astronomy_position_rightascension'), formatHoursToHHmmss(sunPosition.rightAscension)],
      [i18n(context, 'astronomy_position_declination'), format.format(sunPosition.declination) + '°'],
      [i18n(context, 'astronomy_position_azimuth'), format.format(sunPosition.azimuth) + '°'],
      [i18n(context, 'astronomy_position_altitude'), format.format(sunPosition.altitude) + '°'],
      [i18n(context, 'astronomy_position_diameter'), format.format(sunPosition.diameter) + '\''],
      [
        i18n(context, 'astronomy_position_distancetoearthcenter'),
        format.format(sunPosition.distanceToEarthCenter) + ' km'
      ],
      [i18n(context, 'astronomy_position_distancetoobserver'), format.format(sunPosition.distanceToObserver) + ' km'],
      [
        i18n(context, 'astronomy_position_astrologicalsign'),
        i18n(context, getAstrologicalSign(sunPosition.astrologicalSign))
      ],
    ];

    var rowsSunData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
        data: outputsSun
    );

    var outputsJD = [
      [i18n(context, 'astronomy_position_juliandate'), NumberFormat('0.00000').format(julianDate.julianDate)],
      ['\u0394T', format.format(julianDate.deltaT)],
      [i18n(context, 'astronomy_position_gmst'), formatHoursToHHmmss(sunPosition.greenwichSiderealTime)],
      [i18n(context, 'astronomy_position_lmst'), formatHoursToHHmmss(sunPosition.localSiderealTime)]
    ];

    var rowsJDData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'astronomy_position_juliandate'))],
        data: outputsJD
    );

    return Column( children: [rowsSunData, rowsJDData]);
  }
}
