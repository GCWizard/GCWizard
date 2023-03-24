import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class GCWMapPoint {
  String? uuid;
  LatLng point;
  String? markerText;
  Color color;
  CoordinateFormat? coordinateFormat;
  bool isEditable;
  GCWMapCircle? circle;
  bool circleColorSameAsPointColor;
  bool isVisible;

  GCWMapPoint(
      {this.uuid,
      required this.point,
      this.markerText,
      this.color = COLOR_MAP_POINT,
      this.coordinateFormat,
      this.isEditable = false,
      this.circle,
      this.circleColorSameAsPointColor = true,
      this.isVisible = true}) {
    if (uuid == null || uuid!.isEmpty) uuid = const Uuid().v4();
    coordinateFormat ??= defaultCoordinateFormat;
    update();
  }

  bool hasCircle() {
    return circle != null && circle!.radius > 0.0;
  }

  void update() {
    if (circle != null) {
      circle!.centerPoint = point;

      if (circleColorSameAsPointColor) circle!.color = color;

      circle!._update();
    }
  }
}

abstract class GCWMapSimpleGeometry {}

class GCWMapLine extends GCWMapSimpleGeometry {
  final GCWMapPolyline parent;
  final GCWMapPoint start;
  final GCWMapPoint? end;

  double length = 0.0;
  late double bearingAB;
  late double bearingBA;

  List<LatLng> shape = [];

  GCWMapLine(this.parent, this.start, this.end) {
    if (end == null) {
      shape.add(start.point);
      return;
    }

    shape.add(start.point);
    _calculateGeodetic();
  }

  void _calculateGeodetic() {
    DistanceBearingData _distBear = distanceBearing(start.point, end!.point, defaultEllipsoid);
    length = _distBear.distance;
    bearingAB = _distBear.bearingAToB;
    bearingBA = _distBear.bearingBToA;

    const _stepLength = 5000.0;

    var _countSteps = (_distBear.distance / _stepLength).floor();

    for (int _i = 1; _i < _countSteps; _i++) {
      var _nextPoint = projectionVincenty(start.point, _distBear.bearingAToB, _stepLength * _i, defaultEllipsoid);
      shape.add(_nextPoint);
    }

    shape.add(end!.point);
  }
}

class GCWMapPolyline {
  String? uuid;
  List<GCWMapPoint> points;
  Color color;
  double get length => lines.fold(0.0, (previousValue, line) => previousValue + line.length);

  late List<GCWMapLine> lines;

  GCWMapPolyline({
    this.uuid,
    required this.points,
    this.color = COLOR_MAP_POLYLINE,
  }) {
    if (uuid == null || uuid!.isEmpty) uuid = const Uuid().v4();
    update();
  }

  void update() {
    lines = [];

    if (points.isEmpty) {
      return;
    }

    if (points.length == 1) {
      lines.add(GCWMapLine(this, points[0], null));
      return;
    }

    for (int i = 1; i < points.length; i++) {
      lines.add(GCWMapLine(this, points[i - 1], points[i]));
    }
  }
}

class GCWMapCircle extends GCWMapSimpleGeometry {
  LatLng centerPoint;
  double radius;
  Color color;

  late List<LatLng> shape;

  GCWMapCircle({required this.centerPoint, required this.radius, this.color = COLOR_MAP_CIRCLE}) {
    _update();
  }

  void _update() {
    if (radius <= 0.0) {
      shape = [];
      return;
    }

    var _degrees = 0.5;

    double? _prevLongitude;
    bool shouldSort = false;

    shape = List.generate(((360.0 + _degrees) / _degrees).floor(), (index) => index * _degrees).map((e) {
      LatLng coord = projectionVincenty(centerPoint, e, radius, defaultEllipsoid);

      // if there is a huge longitude step around the world (nearly 360°)
      // then one coordinate is placed to the left side of the map, the next one to the right (or vice versa)
      // this yields a nasty line across the whole map. In that case, there is no circle
      // To avoid this the coordinate should be sorted. This works only in that case.
      // In normal cases, this would ruin your circle
      if (_prevLongitude != null) {
        if ((_prevLongitude! - coord.longitude).abs() > 350) shouldSort = true;
      }
      _prevLongitude = coord.longitude;

      return coord;
    }).toList();

    if (shouldSort) {
      shape.sort((a, b) {
        return a.longitude.compareTo(b.longitude);
      });
    }
  }
}
