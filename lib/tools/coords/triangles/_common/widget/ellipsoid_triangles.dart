import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';

Widget ellipsoidTriangleSpecialPointOutput(ELlipsoidTriangle triangle, SpecialPointsOfEllipsoidTriangle specialPoint) {
  if (specialPoint.points.isEmpty) {
    _currentOutput = GCWDefaultOutput(
      child: i18n(context, 'coords_triangles_noresult'),
    );
    return;
  }

  var _mapPointA = GCWMapPoint(
    point: _currentCoords1.toLatLng()!,
    markerText: i18n(context, 'coords_centerthreepoints_coorda'),
  );

  var _mapPointB = GCWMapPoint(
    point: _currentCoords2.toLatLng()!,
    markerText: i18n(context, 'coords_centerthreepoints_coordb'),
  );

  var _mapPointC = GCWMapPoint(
    point: _currentCoords3.toLatLng()!,
    markerText: i18n(context, 'coords_centerthreepoints_coordc'),
  );

  _currentMapPolylines = [
    GCWMapPolyline(points: [_mapPointA, _mapPointB]),
    GCWMapPolyline(points: [_mapPointB, _mapPointC]),
    GCWMapPolyline(points: [_mapPointC, _mapPointA]),
  ];

  return GCWDefaultOutput();
}