import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/shadow_length/logic/shadow_length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

class ShadowLength extends StatefulWidget {
  const ShadowLength({Key? key}) : super(key: key);

  @override
  _ShadowLengthState createState() => _ShadowLengthState();
}

class _ShadowLengthState extends State<ShadowLength> {
  var _currentDateTime = DateTimeTimezone(datetime: DateTime.now(), timezone: DateTime.now().timeZoneOffset);
  var _currentInputCoords = defaultBaseCoordinate;
  var _currentHeight = 0.0;

  final Length _currentInputLength = defaultLengthUnit;
  var _currentOutputFormat = GCWCoordsOutputFormatDistanceValue(defaultCoordinateFormat, defaultLengthUnit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'common_location'),
          coordsFormat: _currentInputCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentInputCoords = ret;
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
          coordFormat: _currentOutputFormat.format,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var _startCoords = _currentInputCoords.toLatLng() ?? defaultCoordinate;

    var shadowLen = shadowLength(_currentHeight, _startCoords, defaultEllipsoid, _currentDateTime);

    String lengthOutput = '';
    double _currentLength = shadowLen.length;

    NumberFormat format = NumberFormat('0.000');
    double? _currentFormattedLength;
    if (_currentLength < 0) {
      lengthOutput = i18n(context, 'shadowlength_no_shadow');
    } else {
      _currentFormattedLength = _currentOutputFormat.lengthUnit.fromMeter(_currentLength);
      lengthOutput = format.format(_currentFormattedLength) + ' ' + _currentOutputFormat.lengthUnit.symbol;
    }

    Widget outputShadow = GCWOutput(
      title: i18n(context, 'shadowlength_length'),
      child: lengthOutput,
      copyText: _currentFormattedLength == null ? null : _currentLength.toString(),
    );

    var _currentMapPoints = [
      GCWMapPoint(
          point: _startCoords,
          markerText: i18n(context, 'coords_waypointprojection_start'),
          coordinateFormat: _currentOutputFormat.format),
      GCWMapPoint(
          point: shadowLen.shadowEndPosition,
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_waypointprojection_end'),
          coordinateFormat: _currentOutputFormat.format)
    ];

    Widget outputLocation = GCWCoordsOutput(
      title: i18n(context, 'shadowlength_location'),
      outputs: [buildCoordinate(_currentOutputFormat.format, shadowLen.shadowEndPosition, defaultEllipsoid).toString()],
      points: _currentMapPoints,
      polylines: [
        GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]])
      ],
    );

    var outputsSun = [
      [i18n(context, 'astronomy_position_azimuth'), format.format(shadowLen.sunPosition.azimuth) + '°'],
      [i18n(context, 'astronomy_position_altitude'), format.format(shadowLen.sunPosition.altitude) + '°'],
    ];

    Widget rowsSunData = GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'astronomy_sunposition_title'))], data: outputsSun);

    return Column(children: [outputShadow, outputLocation, rowsSunData]);
  }
}
