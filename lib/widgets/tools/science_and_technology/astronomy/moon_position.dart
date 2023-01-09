import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/julian_date.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/moon_position.dart' as logic;
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_datetime_picker.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/utils.dart';
import 'package:intl/intl.dart';

class MoonPosition extends StatefulWidget {
  @override
  MoonPositionState createState() => MoonPositionState();
}

class MoonPositionState extends State<MoonPosition> {
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

    var moonPosition = logic.MoonPosition(_currentCoords, julianDate, defaultEllipsoid());

    var outputsMoon = [
      [i18n(context, 'astronomy_position_eclipticlongitude'), format.format(moonPosition.eclipticLongitude) + '°'],
      [i18n(context, 'astronomy_position_eclipticlatitude'), format.format(moonPosition.eclipticLatitude) + '°'],
      [i18n(context, 'astronomy_position_rightascension'), formatHoursToHHmmss(moonPosition.rightAscension)],
      [i18n(context, 'astronomy_position_declination'), format.format(moonPosition.declination) + '°'],
      [i18n(context, 'astronomy_position_azimuth'), format.format(moonPosition.azimuth) + '°'],
      [i18n(context, 'astronomy_position_altitude'), format.format(moonPosition.altitude) + '°'],
      [i18n(context, 'astronomy_position_diameter'), format.format(moonPosition.diameter) + '\''],
      [
        i18n(context, 'astronomy_position_distancetoearthcenter'),
        format.format(moonPosition.distanceToEarthCenter) + ' km'
      ],
      [i18n(context, 'astronomy_position_distancetoobserver'), format.format(moonPosition.distanceToObserver) + ' km'],
      [i18n(context, 'astronomy_position_moonage'), format.format(moonPosition.age) + ' d'],
      [i18n(context, 'astronomy_position_illumination'), format.format(moonPosition.illumination) + '%'],
      [
        i18n(context, 'astronomy_position_moonphase'),
        i18n(context, getMoonPhase(moonPosition.phaseName)) + ' (${moonPosition.phaseNumber})'
      ],
      [
        i18n(context, 'astronomy_position_astrologicalsign'),
        i18n(context, getAstrologicalSign(moonPosition.astrologicalSign))
      ],
    ];

    var rowsSunData = GCWColumnedMultilineOutput(
            firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
            data: outputsMoon
        );

    var outputsJD = [
      [i18n(context, 'astronomy_position_juliandate'), NumberFormat('0.00000').format(julianDate.julianDate)],
      ['\u0394T', format.format(julianDate.deltaT)],
      [i18n(context, 'astronomy_position_gmst'), formatHoursToHHmmss(moonPosition.greenwichSiderealTime)],
      [i18n(context, 'astronomy_position_lmst'), formatHoursToHHmmss(moonPosition.localSiderealTime)]
    ];

    var rowsJDData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'astronomy_position_juliandate'))],
        data: outputsJD
    );

    return Column( children: [rowsSunData, rowsJDData]);
  }
}
