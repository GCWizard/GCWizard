import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/widget/astronomy_i18n.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/logic/sun_position.dart' as logic;
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

class SunPosition extends StatefulWidget {
  const SunPosition({Key? key}) : super(key: key);

  @override
  _SunPositionState createState() => _SunPositionState();
}

class _SunPositionState extends State<SunPosition> {
  var _currentDateTime = DateTimeTZ.now();
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

    var sunPosition = logic.SunPosition(_currentCoords.toLatLng() ?? defaultCoordinate, julianDate, defaultEllipsoid);

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
        i18n(context, getAstrologicalSign(sunPosition.astrologicalSign) ?? '')
      ],
    ];

    var rowsSunData =
        GCWColumnedMultilineOutput(firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))], data: outputsSun);

    var outputsJD = [
      [i18n(context, 'astronomy_position_juliandate'), NumberFormat('0.00000').format(julianDate.julianDate)],
      ['\u0394T', format.format(julianDate.deltaT)],
      [i18n(context, 'astronomy_position_gmst'), formatHoursToHHmmss(sunPosition.greenwichSiderealTime)],
      [i18n(context, 'astronomy_position_lmst'), formatHoursToHHmmss(sunPosition.localSiderealTime)]
    ];

    var rowsJDData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'astronomy_position_juliandate'))], data: outputsJD);

    return Column(children: [rowsSunData, rowsJDData]);
  }
}
