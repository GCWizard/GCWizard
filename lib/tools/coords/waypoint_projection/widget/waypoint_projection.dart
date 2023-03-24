import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_bearing.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class WaypointProjection extends StatefulWidget {
  const WaypointProjection({Key? key}) : super(key: key);

  @override
  WaypointProjectionState createState() => WaypointProjectionState();
}

class WaypointProjectionState extends State<WaypointProjection> {
  var _currentCoords = defaultBaseCoordinate;
  var _currentDistance = 0.0;
  var _currentBearing = defaultDoubleText;
  var _currentReverse = false;

  var _currentValues = [defaultCoordinate];
  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  var _currentOutput = <String>[];
  var _currentOutputFormat = defaultCoordinateFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_waypointprojection_start'),
          coordsFormat: _currentCoords.format,
          onChanged: (BaseCoordinate ret) {
            setState(() {
              _currentCoords = ret;
            });
          },
        ),
        GCWDistance(
          onChanged: (value) {
            setState(() {
              _currentDistance = value;
            });
          },
        ),
        GCWBearing(
          onChanged: (value) {
            setState(() {
              _currentBearing = value;
            });
          },
        ),
        GCWOnOffSwitch(
          value: _currentReverse,
          title: i18n(context, 'coords_waypointprojection_reverse'),
          onChanged: (value) {
            setState(() {
              _currentReverse = value;
            });
          },
        ),
        GCWCoordsOutputFormat(
          coordFormat: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
          polylines: _currentMapPolylines,
        ),
      ],
    );
  }

  void _calculateOutput() {
    if (_currentReverse) {
      if (_currentCoords.toLatLng() == null) {
        return;
      }

      _currentValues = reverseProjection(_currentCoords.toLatLng()!, _currentBearing.value, _currentDistance, defaultEllipsoid);
      if (_currentValues.isEmpty) {
        _currentOutput = [i18n(context, 'coords_waypointprojection_reverse_nocoordinatefound')];
        return;
      }

      _currentMapPoints = [
        GCWMapPoint(
            point: _currentCoords.toLatLng()!,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoords.format)
      ];

      _currentMapPolylines = <GCWMapPolyline>[];

      for (var projection in _currentValues) {
        var projectionMapPoint = GCWMapPoint(
            point: projection,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_waypointprojection_end'),
            coordinateFormat: _currentOutputFormat);

        _currentMapPoints.add(projectionMapPoint);

        _currentMapPolylines.add(GCWMapPolyline(points: [projectionMapPoint, _currentMapPoints[0]]));
      }
    } else {
      _currentValues = [projection(_currentCoords.toLatLng()!, _currentBearing.value, _currentDistance, defaultEllipsoid)];

      _currentMapPoints = [
        GCWMapPoint(
            point: _currentCoords.toLatLng()!,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoords.format),
        GCWMapPoint(
            point: _currentValues[0],
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_waypointprojection_end'),
            coordinateFormat: _currentOutputFormat)
      ];

      _currentMapPolylines = [
        GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]])
      ];
    }

    _currentOutput = _currentValues.map((LatLng value) {
      return formatCoordOutput(value, _currentOutputFormat, defaultEllipsoid);
    }).toList();
  }
}
