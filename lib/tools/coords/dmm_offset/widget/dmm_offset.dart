import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/dmm_offset/logic/dmm_offset.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class DMMOffset extends StatefulWidget {
  const DMMOffset({Key? key}) : super(key: key);

  @override
  _DMMOffsetState createState() => _DMMOffsetState();
}

class _DMMOffsetState extends State<DMMOffset> {
  var _currentCoords = defaultBaseCoordinate;

  var _currentValues = [defaultCoordinate];
  var _currentMapPoints = <GCWMapPoint>[];

  var _currentOutputFormat = defaultCoordinateFormat;
  var _currentOutput = <BaseCoordinate>[];

  var _currentAddLatitude = 0;
  var _currentAddLongitude = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_dmmoffset_start'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords = ret;
              }

              _calculateOutput();
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_dmmoffset_offset'),
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'coords_common_latitude'),
          value: _currentAddLatitude,
          onChanged: (value) {
            setState(() {
              _currentAddLatitude = value;
              _calculateOutput();
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'coords_common_longitude'),
          value: _currentAddLongitude,
          onChanged: (value) {
            setState(() {
              _currentAddLongitude = value;
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutputFormat(
          coordFormat: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value;
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
        ),
      ],
    );
  }

  void _calculateOutput() {
    var result = addIntegersToDMM(
        _currentCoords.toLatLng()!, {'latitude': _currentAddLatitude, 'longitude': _currentAddLongitude});
    if (result == null) {
      _currentValues = [];
      _currentOutput = [];
      return;
    }
    _currentValues = [result];

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords.toLatLng()!,
          markerText: i18n(context, 'coords_dmmaddintegers_start'),
          coordinateFormat: _currentCoords.format),
      GCWMapPoint(
          point: _currentValues[0],
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_dmmaddintegers_end'),
          coordinateFormat: _currentCoords.format),
    ];

    _currentOutput = _currentValues.map((projection) {
      return buildCoordinate(_currentOutputFormat, projection);
    }).toList();
  }
}
