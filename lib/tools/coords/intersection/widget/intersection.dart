import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_angle.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersection/logic/intersection.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class Intersection extends StatefulWidget {
  const Intersection({Key? key}) : super(key: key);

  @override
  _IntersectionState createState() => _IntersectionState();
}

class _IntersectionState extends State<Intersection> {
  var _currentIntersections = <LatLng?>[];

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentAngle1 = defaultDoubleText;

  var _currentCoords2 = defaultBaseCoordinate;
  var _currentAngle2 = defaultDoubleText;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<String> _currentOutput = [];
  var _currentMapPoints = <GCWMapPoint>[];
  List<GCWMapPolyline> _currentMapPolylines = [];
  final Ellipsoid _ellipsoid = defaultEllipsoid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_intersection_coorda'),
          coordsFormat: _currentCoords1.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords1 = ret;
              }
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
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
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
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<List<LatLng?>>(
                isolatedFunction: intersectionAsync,
                parameter: _buildJobData,
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    });
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    return GCWAsyncExecuterParameters(IntersectionJobData(
        coord1: _currentCoords1.toLatLng()!,
        alpha: _currentAngle1.value,
        coord2: _currentCoords2.toLatLng()!,
        beta: _currentAngle2.value,
        ells: _ellipsoid));
  }

  void _showOutput(List<LatLng?> output) {
    _currentIntersections = output;

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1.toLatLng()!,
          markerText: i18n(context, 'coords_intersection_coorda'),
          coordinateFormat: _currentCoords1.format),
      GCWMapPoint(
          point: _currentCoords2.toLatLng()!,
          markerText: i18n(context, 'coords_intersection_coordb'),
          coordinateFormat: _currentCoords2.format)
    ];

    _currentMapPolylines = [
      GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]])
    ];

    DistanceBearingData crs = distanceBearing(_currentCoords1.toLatLng()!, _currentCoords2.toLatLng()!, _ellipsoid);
    _currentIntersections.asMap().forEach((index, intersection) {
      double _crsAB;
      double _crsBA;

      if (index == 0) {
        _crsAB = crs.bearingAToB + _currentAngle1.value;
        _crsBA = crs.bearingBToA - _currentAngle2.value;
      } else {
        _crsAB = crs.bearingAToB - _currentAngle1.value;
        _crsBA = crs.bearingBToA + _currentAngle2.value;
      }

      GCWMapPoint endPoint1MapPoint;
      GCWMapPoint endPoint2MapPoint;

      if (intersection == null) {
        var dist = distanceBearing(_currentCoords1.toLatLng()!, _currentCoords2.toLatLng()!, _ellipsoid).distance;
        var endPoint1 = projection(_currentCoords1.toLatLng()!, _crsAB, dist * 3, _ellipsoid);
        var endPoint2 = projection(_currentCoords2.toLatLng()!, _crsBA, dist * 3, _ellipsoid);

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
        var distance1ToIntersect = distanceBearing(_currentCoords1.toLatLng()!, intersection, _ellipsoid).distance;
        var endPoint1 = projection(_currentCoords1.toLatLng()!, _crsAB, distance1ToIntersect * 1.5, _ellipsoid);

        var distance2ToIntersect = distanceBearing(_currentCoords2.toLatLng()!, intersection, _ellipsoid).distance;
        var endPoint2 = projection(_currentCoords2.toLatLng()!, _crsBA, distance2ToIntersect * 1.5, _ellipsoid);

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

    if (_currentIntersections[0] == null && _currentIntersections[1] == null) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentMapPoints.addAll(_currentIntersections
        .where((intersection) => intersection != null)
        .map((intersection) => GCWMapPoint(
            point: intersection!,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_common_intersection'),
            coordinateFormat: _currentOutputFormat))
        .toList());

    _currentOutput = _currentIntersections
        .where((intersection) => intersection != null)
        .map((intersection) => formatCoordOutput(intersection!, _currentOutputFormat, defaultEllipsoid))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
