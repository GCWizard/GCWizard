import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class WaypointProjection extends StatefulWidget {
  final GCWMapLineType type;
  final LatLng Function(LatLng coord, double bearingDeg, double distance, Ellipsoid ellipsoid) calculate;
  final LatLng? Function(LatLng coord, double bearingDeg, double distance, Ellipsoid ellipsoid) calculateReverse;

  const WaypointProjection({super.key, required this.type, required this.calculate, required this.calculateReverse});

  @override
  _WaypointProjectionState createState() => _WaypointProjectionState();
}

class _WaypointProjectionState extends State<WaypointProjection> {
  var _currentCoords = defaultBaseCoordinate;
  var _currentDistance = 0.0;
  var _currentBearing = defaultDoubleText;
  var _currentReverse = false;

  var _currentValues = defaultCoordinate;
  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  var _currentOutput = <Object>[];
  var _currentOutputFormat = defaultCoordinateFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_common_coordinate'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords = ret;
              }
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'coords_waypointprojection_projection')),
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

      var _currentReverseProjected = widget.calculateReverse(
          _currentCoords.toLatLng()!, _currentBearing.value, _currentDistance, defaultEllipsoid);
      if (_currentReverseProjected == null) {
        _currentOutput = [i18n(context, 'coords_waypointprojection_reverse_nocoordinatefound')];
        return;
      }

      _currentValues = _currentReverseProjected;

      _currentMapPoints = [
        GCWMapPoint(
            point: _currentCoords.toLatLng()!,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoords.format)
      ];

      _currentMapPolylines = <GCWMapPolyline>[];

      var projectionMapPoint = GCWMapPoint(
          point: _currentValues,
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_waypointprojection_end'),
          coordinateFormat: _currentOutputFormat);

      _currentMapPoints.add(projectionMapPoint);

      _currentMapPolylines.add(GCWMapPolyline(points: [projectionMapPoint, _currentMapPoints[0]]));

    } else {
      _currentValues = widget.calculate(_currentCoords.toLatLng()!, _currentBearing.value, _currentDistance, defaultEllipsoid);

      _currentMapPoints = [
        GCWMapPoint(
            point: _currentCoords.toLatLng()!,
            markerText: i18n(context, 'coords_waypointprojection_start'),
            coordinateFormat: _currentCoords.format),
        GCWMapPoint(
            point: _currentValues,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_waypointprojection_end'),
            coordinateFormat: _currentOutputFormat)
      ];

      _currentMapPolylines = [
        GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]], type: widget.type)
      ];
    }

    _currentOutput = [buildCoordinate(_currentOutputFormat, _currentValues)];
  }
}
