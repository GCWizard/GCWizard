import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_bearing_and_circle/logic/intersect_geodetic_and_circle.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class IntersectGeodeticAndCircle extends StatefulWidget {
  const IntersectGeodeticAndCircle({super.key});

  @override
  _IntersectBearingAndCircleState createState() => _IntersectBearingAndCircleState();
}

class _IntersectBearingAndCircleState extends State<IntersectGeodeticAndCircle> {
  var _currentIntersections = <LatLng>[];

  var _currentCoordsStart = defaultBaseCoordinate;
  var _currentBearingStart = defaultDoubleText;

  var _currentCoordsCircle = defaultBaseCoordinate;
  var _currentRadiusCircle = 0.0;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<Object> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, "coords_intersectbearingcircle_geodetic"),
          coordsFormat: _currentCoordsStart.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoordsStart = ret;
              }
            });
          },
        ),
        GCWBearing(
          onChanged: (value) {
            setState(() {
              _currentBearingStart = value;
            });
          },
        ),
        GCWCoords(
          title: i18n(context, "coords_intersectbearingcircle_circle"),
          coordsFormat: _currentCoordsCircle.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoordsCircle = ret;
              }
            });
          },
        ),
        GCWDistance(
          hintText: i18n(context, 'common_radius'),
          onChanged: (value) {
            setState(() {
              _currentRadiusCircle = value;
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
        GCWSubmitButton(onPressed: () {
          setState(() {
            calculateOutput();
          });
        }),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints, polylines: _currentMapPolylines),
      ],
    );
  }

  GCWMapPoint _getEndPoint() {
    var mapPoint = GCWMapPoint(
        point: projection(
            _currentCoordsStart.toLatLng()!,
            _currentBearingStart.value,
            max<double>(
                    distanceBearing(_currentCoordsStart.toLatLng()!, _currentCoordsCircle.toLatLng()!, defaultEllipsoid)
                        .distance,
                    _currentRadiusCircle) *
                2.5,
            defaultEllipsoid),
        isVisible: false);

    _currentMapPoints.add(mapPoint);

    return mapPoint;
  }

  void calculateOutput() {
    _currentIntersections = intersectGeodeticAndCircle(
      _currentCoordsStart.toLatLng()!,
      _currentBearingStart.value,
      _currentCoordsCircle.toLatLng()!,
      _currentRadiusCircle,
      defaultEllipsoid
    );

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoordsStart.toLatLng()!,
          markerText: i18n(context, 'coords_intersectbearingcircle_geodetic'),
          coordinateFormat: _currentCoordsStart.format),
      GCWMapPoint(
        point: _currentCoordsCircle.toLatLng()!,
        markerText: i18n(context, 'coords_intersectbearingcircle_circle'),
        coordinateFormat: _currentCoordsCircle.format,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(radius: _currentRadiusCircle, centerPoint: _currentCoordsCircle.toLatLng()!),
      )
    ];

    if (_currentIntersections.isEmpty) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    var intersectionMapPoints = _currentIntersections
        .map((intersection) => GCWMapPoint(
        point: intersection,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_intersection'),
        coordinateFormat: _currentOutputFormat))
        .toList();

    _currentMapPoints.addAll(intersectionMapPoints);

    _currentOutput = _currentIntersections
        .map((intersection) => buildCoordinate(_currentOutputFormat, intersection))
        .toList();

    if (intersectionMapPoints.isEmpty) {
      _currentMapPolylines = [
        GCWMapPolyline(points: [_currentMapPoints[0], _getEndPoint()])
      ];
    } else {
      for (var intersection in intersectionMapPoints) {
        _currentMapPolylines.add(
            GCWMapPolyline(points: [_currentMapPoints[0], intersection])
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
