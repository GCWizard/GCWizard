import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/data/distance_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/distance_and_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/intersection.dart';
import 'package:gc_wizard/logic/tools/coords/projection.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_angle.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_outputformat.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';

class Intersection extends StatefulWidget {
  @override
  IntersectionState createState() => IntersectionState();
}

class IntersectionState extends State<Intersection> {
  var _currentIntersections = [];

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;
  var _currentAngle1 = {'text': '','value': 0.0};

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;
  var _currentAngle2 = {'text': '','value': 0.0};

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];
  var _currentMapPoints;
  List<GCWMapPolyline> _currentMapPolylines = [];

  @override
  void initState() {
    super.initState();
    _currentMapPoints = [
      GCWMapPoint(point: _currentCoords1),
      GCWMapPoint(point: _currentCoords2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_intersection_coorda'),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
            });
          },
        ),
        GCWAngle(
          hintText: i18n(context, 'coords_intersection_anglea'),
          onChanged: (value) {
            setState(() {
              _currentAngle1 = value;
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersection_coordb'),
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
            });
          },
        ),
        GCWAngle(
          hintText: i18n(context, 'coords_intersection_angleb'),
          onChanged: (value) {
            setState(() {
              _currentAngle2 = value;
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
        GCWSubmitFlatButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
          polylines: _currentMapPolylines
        ),
      ],
    );
  }

  _calculateOutput() {
    var ells = defaultEllipsoid();

    _currentIntersections = intersection(_currentCoords1, _currentAngle1['value'], _currentCoords2, _currentAngle2['value'], ells);

    _currentMapPoints = [
      GCWMapPoint(
        point: _currentCoords1,
        markerText: i18n(context, 'coords_intersection_coorda'),
        coordinateFormat: _currentCoordsFormat1
      ),
      GCWMapPoint(
        point: _currentCoords2,
        markerText: i18n(context, 'coords_intersection_coordb'),
        coordinateFormat: _currentCoordsFormat2
      )
    ];

    _currentMapPolylines = [
      GCWMapPolyline(
        points: [_currentMapPoints[0], _currentMapPoints[1]]
      )
    ];

    DistanceBearingData crs = distanceBearing(_currentCoords1, _currentCoords2, ells);
    _currentIntersections.asMap().forEach((index, intersection){
      var _crsAB;
      var _crsBA;

      if (index == 0) {
        _crsAB = crs.bearingAToB + _currentAngle1['value'];
        _crsBA = crs.bearingBToA - _currentAngle2['value'];
      } else {
        _crsAB = crs.bearingAToB - _currentAngle1['value'];
        _crsBA = crs.bearingBToA + _currentAngle2['value'];
      }

      if (intersection == null) {
        var dist = distanceBearing(_currentCoords1, _currentCoords2, ells).distance;
        var endPoint1 = projection(_currentCoords1, _crsAB, dist * 3, ells);
        var endPoint2 = projection(_currentCoords2, _crsBA, dist * 3, ells);

        _currentMapPolylines.addAll([
          GCWMapPolyline(
            points: [_currentMapPoints[0], GCWMapPoint(point: endPoint1, isVisible: false)],
            color: HSLColor
              .fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
              .toColor()
          ),
          GCWMapPolyline(
            points: [_currentMapPoints[1], GCWMapPoint(point: endPoint2, isVisible: false)],
            color: HSLColor
              .fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness -0.3)
              .toColor()
          ),
        ]);
      } else {
        var distance1ToIntersect = distanceBearing(_currentCoords1, intersection, ells).distance;
        var endPoint1 = projection(_currentCoords1, _crsAB, distance1ToIntersect * 1.5, ells);

        var distance2ToIntersect = distanceBearing(_currentCoords2, intersection, ells).distance;
        var endPoint2 = projection(_currentCoords2, _crsBA, distance2ToIntersect * 1.5, ells);

        _currentMapPolylines.addAll([
          GCWMapPolyline(
            points: [_currentMapPoints[0], GCWMapPoint(point: endPoint1, isVisible: false)],
            color: HSLColor
              .fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
              .toColor()
          ),
          GCWMapPolyline(
            points: [_currentMapPoints[1], GCWMapPoint(point: endPoint2, isVisible: false)],
            color: HSLColor
              .fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness -0.3)
              .toColor()
          ),
        ]);
      }
    });

    if (_currentIntersections[0] == null && _currentIntersections[1] == null) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      return;
    }

    _currentMapPoints.addAll(
      _currentIntersections
        .map((intersection) => GCWMapPoint(
          point: intersection,
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_common_intersection'),
          coordinateFormat: _currentOutputFormat
        ))
        .toList()
    );

    _currentOutput = _currentIntersections
      .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid()))
      .toList();
  }
}