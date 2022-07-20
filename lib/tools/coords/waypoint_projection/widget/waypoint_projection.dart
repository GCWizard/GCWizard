import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/coords/data/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/logic/projection.dart';
import 'package:gc_wizard/tools/coords/logic/utils.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/tools/common/gcw_distance/widget/gcw_distance.dart';
import 'package:gc_wizard/tools/common/gcw_onoff_switch/widget/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/common/gcw_submit_button/widget/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/base/gcw_coords/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/base/gcw_coords_bearing/widget/gcw_coords_bearing.dart';
import 'package:gc_wizard/tools/coords/base/gcw_coords_output/widget/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/base/gcw_coords_outputformat/widget/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/map_view/gcw_map_geometries/widget/gcw_map_geometries.dart';
import 'package:gc_wizard/tools/coords/base/utils/widget/utils.dart';

class WaypointProjection extends StatefulWidget {
  @override
  WaypointProjectionState createState() => WaypointProjectionState();
}

class WaypointProjectionState extends State<WaypointProjection> {
  var _currentCoords = defaultCoordinate;
  var _currentDistance = 0.0;
  var _currentBearing = {'text': '', 'value': 0.0};
  var _currentReverse = false;

  var _currentValues = [defaultCoordinate];
  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];
  var _currentCoordsFormat = defaultCoordFormat();

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = <String>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_waypointprojection_start'),
          coordsFormat: _currentCoordsFormat,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat = ret['coordsFormat'];
              _currentCoords = ret['value'];
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

  _calculateOutput() {
    if (_currentReverse) {
      _currentValues =
          reverseProjection(_currentCoords, _currentBearing['value'], _currentDistance, defaultEllipsoid());
      if (_currentValues == null || _currentValues.length == 0) {
        _currentOutput = [i18n(context, 'coords_waypointprojection_reverse_nocoordinatefound')];
        return;
      }

      _currentMapPoints = [
        GCWMapPoint(
            point: _currentCoords,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoordsFormat)
      ];

      _currentMapPolylines = <GCWMapPolyline>[];

      _currentValues.forEach((projection) {
        var projectionMapPoint = GCWMapPoint(
            point: projection,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_waypointprojection_end'),
            coordinateFormat: _currentOutputFormat);

        _currentMapPoints.add(projectionMapPoint);

        _currentMapPolylines.add(GCWMapPolyline(points: [projectionMapPoint, _currentMapPoints[0]]));
      });
    } else {
      _currentValues = [projection(_currentCoords, _currentBearing['value'], _currentDistance, defaultEllipsoid())];

      _currentMapPoints = [
        GCWMapPoint(
            point: _currentCoords,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoordsFormat),
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

    _currentOutput = _currentValues.map((projection) {
      return formatCoordOutput(projection, _currentOutputFormat, defaultEllipsoid());
    }).toList();
  }
}
