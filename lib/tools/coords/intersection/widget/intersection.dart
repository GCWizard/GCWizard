import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_angle.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersection/logic/intersection.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';

class Intersection extends StatefulWidget {
  @override
  IntersectionState createState() => IntersectionState();
}

class IntersectionState extends State<Intersection> {
  var _currentIntersections = [];

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;
  var _currentAngle1 = {'text': '', 'value': 0.0};

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;
  var _currentAngle2 = {'text': '', 'value': 0.0};

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];
  var _currentMapPoints = <GCWMapPoint>[];
  List<GCWMapPolyline> _currentMapPolylines = [];
  dynamic _ells;

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
        _buildSubmitButton(),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints, polylines: _currentMapPolylines),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              child: GCWAsyncExecuter(
                isolatedFunction: intersectionAsync,
                parameter: _buildJobData(),
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
              height: 220,
              width: 150,
            ),
          );
        },
      );
    });
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    _ells = defaultEllipsoid();
    return GCWAsyncExecuterParameters(IntersectionJobData(
        coord1: _currentCoords1,
        alpha: _currentAngle1['value'],
        coord2: _currentCoords2,
        beta: _currentAngle2['value'],
        ells: defaultEllipsoid()));
  }

  _showOutput(List<LatLng> output) {
    if (output == null) {
      _currentOutput = [];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentIntersections = output;

    var ells = _ells;

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1,
          markerText: i18n(context, 'coords_intersection_coorda'),
          coordinateFormat: _currentCoordsFormat1),
      GCWMapPoint(
          point: _currentCoords2,
          markerText: i18n(context, 'coords_intersection_coordb'),
          coordinateFormat: _currentCoordsFormat2)
    ];

    _currentMapPolylines = [
      GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]])
    ];

    DistanceBearingData crs = distanceBearing(_currentCoords1, _currentCoords2, ells);
    _currentIntersections.asMap().forEach((index, intersection) {
      var _crsAB;
      var _crsBA;

      if (index == 0) {
        _crsAB = crs.bearingAToB + _currentAngle1['value'];
        _crsBA = crs.bearingBToA - _currentAngle2['value'];
      } else {
        _crsAB = crs.bearingAToB - _currentAngle1['value'];
        _crsBA = crs.bearingBToA + _currentAngle2['value'];
      }

      GCWMapPoint endPoint1MapPoint;
      GCWMapPoint endPoint2MapPoint;

      if (intersection == null) {
        var dist = distanceBearing(_currentCoords1, _currentCoords2, ells).distance;
        var endPoint1 = projection(_currentCoords1, _crsAB, dist * 3, ells);
        var endPoint2 = projection(_currentCoords2, _crsBA, dist * 3, ells);

        endPoint1MapPoint = GCWMapPoint(point: endPoint1, isVisible: false);
        endPoint2MapPoint = GCWMapPoint(point: endPoint2, isVisible: false);

        _currentMapPolylines.addAll([
          GCWMapPolyline(
              points: [_currentMapPoints[0], endPoint1MapPoint],
              color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
                  .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
                  .toColor()),
          GCWMapPolyline(
              points: [_currentMapPoints[1], endPoint2MapPoint],
              color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
                  .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
                  .toColor()),
        ]);
      } else {
        var distance1ToIntersect = distanceBearing(_currentCoords1, intersection, ells).distance;
        var endPoint1 = projection(_currentCoords1, _crsAB, distance1ToIntersect * 1.5, ells);

        var distance2ToIntersect = distanceBearing(_currentCoords2, intersection, ells).distance;
        var endPoint2 = projection(_currentCoords2, _crsBA, distance2ToIntersect * 1.5, ells);

        endPoint1MapPoint = GCWMapPoint(point: endPoint1, isVisible: false);
        endPoint2MapPoint = GCWMapPoint(point: endPoint2, isVisible: false);

        _currentMapPolylines.addAll([
          GCWMapPolyline(
              points: [_currentMapPoints[0], endPoint1MapPoint],
              color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
                  .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
                  .toColor()),
          GCWMapPolyline(
              points: [_currentMapPoints[1], endPoint2MapPoint],
              color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
                  .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
                  .toColor()),
        ]);
      }

      _currentMapPoints.addAll([endPoint1MapPoint, endPoint2MapPoint]);
    });

    if (_currentIntersections == null || (_currentIntersections[0] == null && _currentIntersections[1] == null)) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentMapPoints.addAll(_currentIntersections
        .map((intersection) => GCWMapPoint(
            point: intersection,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_common_intersection'),
            coordinateFormat: _currentOutputFormat))
        .toList());

    _currentOutput = _currentIntersections
        .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid()))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
