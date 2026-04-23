import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/map_geometries.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

Widget ellipsoidTriangleSpecialPointOutput(BuildContext context, CoordinateFormat coordinateformat, EllipsoidTriangle triangle, SpecialPointsOfEllipsoidTriangle specialPoint) {
  const _MIN_ACCURACY = 5;

  Widget _currentOutput = Container();

  if (specialPoint.points.isEmpty) {
    _currentOutput = GCWDefaultOutput(
      child: i18n(context, 'coords_triangles_noresult'),
    );
    return _currentOutput;
  }

  var _mapPointA = GCWMapPoint(
    point: triangle.a,
    markerText: i18n(context, 'coords_centerthreepoints_coorda'),
  );

  var _mapPointB = GCWMapPoint(
    point: triangle.b,
    markerText: i18n(context, 'coords_centerthreepoints_coordb'),
  );

  var _mapPointC = GCWMapPoint(
    point: triangle.c,
    markerText: i18n(context, 'coords_centerthreepoints_coordc'),
  );

  var _mapPoints = [_mapPointA, _mapPointB, _mapPointC];

  var _mapPolylines = [
    GCWMapPolyline(points: [_mapPointA, _mapPointB], color: COLOR_MAP_POLYLINE_TRIANGLE),
    GCWMapPolyline(points: [_mapPointB, _mapPointC], color: COLOR_MAP_POLYLINE_TRIANGLE),
    GCWMapPolyline(points: [_mapPointC, _mapPointA], color: COLOR_MAP_POLYLINE_TRIANGLE),
  ];

  if (specialPoint.accuracy > _MIN_ACCURACY) {
    for (var intersection in specialPoint.points) {
      _mapPoints.add(
        GCWMapPoint(
          point: intersection,
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_common_intersection'),
        )
      );
    }

    _mapPoints.add(
      GCWMapPoint(
        point: specialPoint.centerpoint,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_triangles_specialpoint_interpolatedcenter'),
      )
    );
  } else {
    _mapPoints.add(
      GCWMapPoint(
        point: specialPoint.centerpoint,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_intersection')
      )
    );
  }

  GCWMapPoint _mapPointByLatLng(LatLng coord) {
    var mapPoint = _mapPoints.firstWhereOrNull(
      (GCWMapPoint mapPoint) => equalsLatLng(mapPoint.point, coord)
    );

    if (mapPoint != null) {
      return mapPoint;
    }

    mapPoint = GCWMapPoint(point: coord);
    _mapPoints.add(mapPoint);

    return mapPoint;
  }

  for (var constructionLine in specialPoint.constructionLines) {
    _mapPolylines.add(GCWMapPolyline(
      points: [
        _mapPointByLatLng(constructionLine.start),
        _mapPointByLatLng(constructionLine.end),
      ]
    ));
  }

  var formattedAccuracy = NumberFormat('0.##').format(specialPoint.accuracy);

  return GCWCoordsOutput(
    title: specialPoint.accuracy <= _MIN_ACCURACY
        ? i18n(context, 'coords_common_intersection')
        : i18n(context, 'coords_triangles_specialpoint_interpolatedcenter'),
    outputs: [
      buildCoordinate(coordinateformat, specialPoint.centerpoint),
      formattedAccuracy == '0' ? Container() : GCWOutput(
        child: i18n(context, 'common_accuracy') + ': \u00B1$formattedAccuracy m',
        copyText: specialPoint.accuracy.toString(),
      )
    ],
    points: _mapPoints,
    polylines: _mapPolylines,
  );
}