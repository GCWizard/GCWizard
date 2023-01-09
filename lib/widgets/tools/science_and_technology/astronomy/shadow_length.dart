import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/units/length.dart';
import 'package:gc_wizard/logic/common/units/unit.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/shadow_length.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_datetime_picker.dart';
import 'package:gc_wizard/widgets/common/gcw_distance.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:intl/intl.dart';
import 'package:prefs/prefs.dart';

class ShadowLength extends StatefulWidget {
  @override
  ShadowLengthState createState() => ShadowLengthState();
}

class ShadowLengthState extends State<ShadowLength> {
  var _currentDateTime = {'datetime': DateTime.now(), 'timezone': DateTime.now().timeZoneOffset};
  var _currentCoords = defaultCoordinate;
  var _currentCoordsFormat = defaultCoordFormat();
  var _currentHeight = 0.0;

  Length _currentInputLength = getUnitBySymbol(allLengths(), Prefs.get(PREFERENCE_DEFAULT_LENGTH_UNIT));
  Length _currentOutputLength = getUnitBySymbol(allLengths(), Prefs.get(PREFERENCE_DEFAULT_LENGTH_UNIT));
  var _currentCoordsOutputFormat = defaultCoordFormat();

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
        GCWTextDivider(
          text: i18n(context, 'shadowlength_height'),
        ),
        GCWDistance(
          value: _currentHeight,
          unit: _currentInputLength,
          onChanged: (value) {
            setState(() {
              _currentHeight = value;
            });
          },
        ),
        GCWCoordsOutputFormatDistance(
          coordFormat: _currentCoordsOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentCoordsOutputFormat = value['coordFormat'];
              _currentOutputLength = value['unit'];
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var shadowLen = shadowLength(
        _currentHeight, _currentCoords, defaultEllipsoid(), _currentDateTime['datetime'], _currentDateTime['timezone']);

    var lengthOutput = '';
    var _currentLength = shadowLen.length;

    var format = NumberFormat('0.000');
    var _currentFormattedLength;
    if (_currentLength < 0)
      lengthOutput = i18n(context, 'shadowlength_no_shadow');
    else {
      _currentFormattedLength = _currentOutputLength.fromMeter(_currentLength);
      lengthOutput = format.format(_currentFormattedLength) + ' ' + _currentOutputLength.symbol;
    }

    var outputShadow = GCWOutput(
      title: i18n(context, 'shadowlength_length'),
      child: lengthOutput,
      copyText: _currentFormattedLength == null ? null : _currentLength.toString(),
    );

    var outputLocation = GCWCoordsOutput(
      title: i18n(context, 'shadowlength_location'),
      outputs: [formatCoordOutput(shadowLen.shadowEndPosition, _currentCoordsFormat, defaultEllipsoid())],
      points: [
        GCWMapPoint(
            point: _currentCoords,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoordsFormat),
        GCWMapPoint(
            point: shadowLen.shadowEndPosition,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_waypointprojection_end'),
            coordinateFormat: _currentCoordsFormat)
      ],
    );

    var outputsSun = [
      [i18n(context, 'astronomy_position_azimuth'), format.format(shadowLen.sunPosition.azimuth) + '°'],
      [i18n(context, 'astronomy_position_altitude'), format.format(shadowLen.sunPosition.altitude) + '°'],
    ];

    var rowsSunData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'astronomy_sunposition_title'))],
        data: outputsSun
    );

    return Column(children: [outputShadow, outputLocation, rowsSunData]);
  }
}
