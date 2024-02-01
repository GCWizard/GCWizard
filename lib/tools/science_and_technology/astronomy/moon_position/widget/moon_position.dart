import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/widget/astronomy_i18n.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_position/logic/moon_position.dart' as logic;
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

class MoonPosition extends StatefulWidget {
  const MoonPosition({Key? key}) : super(key: key);

  @override
  _MoonPositionState createState() => _MoonPositionState();
}

class _MoonPositionState extends State<MoonPosition> {
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
              if (ret != null) {
                _currentCoords = ret;
              }
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'astronomy_postion_datetime'),
        ),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.DATE, DateTimePickerConfig.TIME, DateTimePickerConfig.TIMEZONES},
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

    var julianDate = JulianDate(_currentDateTime);

    var moonPosition = logic.MoonPosition(_currentCoords.toLatLng() ?? defaultCoordinate, julianDate, defaultEllipsoid);

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
        i18n(context, getMoonPhase(moonPosition.phaseName) ?? '') + ' (${moonPosition.phaseNumber})'
      ],
      [
        i18n(context, 'astronomy_position_astrologicalsign'),
        i18n(context, getAstrologicalSign(moonPosition.astrologicalSign) ?? '')
      ],
    ];

    var rowsSunData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))], data: outputsMoon);

    var outputsJD = [
      [i18n(context, 'astronomy_position_juliandate'), NumberFormat('0.00000').format(julianDate.julianDate)],
      ['\u0394T', format.format(julianDate.deltaT)],
      [i18n(context, 'astronomy_position_gmst'), formatHoursToHHmmss(moonPosition.greenwichSiderealTime)],
      [i18n(context, 'astronomy_position_lmst'), formatHoursToHHmmss(moonPosition.localSiderealTime)]
    ];

    var rowsJDData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'astronomy_position_juliandate'))], data: outputsJD);

    return Column(children: [rowsSunData, rowsJDData]);
  }
}
