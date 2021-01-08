import 'package:flutter/material.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/data/distance_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/distance_and_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/projection.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:latlong/latlong.dart';
import 'package:uuid/uuid.dart';

class GCWMapPoint {
  String uuid;
  LatLng point;
  String markerText;
  Color color;
  Map<String, String> coordinateFormat;
  bool isEditable;
  GCWMapCircle circle;
  bool circleColorSameAsPointColor;
  bool isVisible;

  GCWMapPoint({
    this.uuid,
    @required this.point,
    this.markerText,
    this.color: COLOR_MAP_POINT,
    this.coordinateFormat,
    this.isEditable: false,
    this.circle,
    this.circleColorSameAsPointColor: false,
    this.isVisible: true
  }) {
    if (uuid == null || uuid.length == 0)
      uuid = Uuid().v4();
    update();
  }

  hasCircle() {
    return circle != null && circle.radius != null && circle.radius > 0.0;
  }

  update() {
    if (circle != null) {
      circle.centerPoint = point;

      if (circleColorSameAsPointColor)
        circle.color = color;

      circle._update();
    }
  }
}

class GCWMapPolyline {
  String uuid;
  List<GCWMapPoint> points = [];
  Color color;
  double length;

  List<LatLng> shape;

  GCWMapPolyline({
    this.uuid,
    @required this.points,
    this.color: COLOR_MAP_POLYLINE,
  }) {
    if (uuid == null || uuid.length == 0)
      uuid = Uuid().v4();
    update();
  }

  void _calculateGeodetics(GCWMapPoint start, GCWMapPoint end) {
    DistanceBearingData _distBear = distanceBearing(start.point, end.point, defaultEllipsoid());
    length += _distBear.distance;

    const _stepLength = 5000.0;

    var _countSteps = (_distBear.distance / _stepLength).floor();

    for (int _i = 1; _i < _countSteps; _i++) {
      var _nextPoint = projection(
        start.point,
        _distBear.bearingAToB,
        _stepLength * _i,
        defaultEllipsoid()
      );
      shape.add(_nextPoint);
    }

    shape.add(end.point);
  }

  void update() {
    length = 0.0;
    shape = [];

    if (points == null) {
      return;
    }

    if (points.length > 0)
      shape.add(points[0].point);

    if (points.length < 2)
      return;

    for (int i = 1; i < points.length; i++) {
      _calculateGeodetics(points[i - 1], points[i]);
    }
  }
}

class GCWMapCircle {
  LatLng centerPoint;
  double radius;
  Color color;

  List<LatLng> shape;

  GCWMapCircle({
    this.centerPoint,
    @required this.radius,
    this.color: COLOR_MAP_CIRCLE
  }) {
    _update();
  }

  void _update() {
    if (this.centerPoint == null)
      this.centerPoint = defaultCoordinate;

    if (this.radius == null || this.radius <= 0.0) {
      shape = null;
      return;
    }

    var _degrees = 0.5;

    double _prevLongitude;
    bool shouldSort = false;

    shape = List.generate(((360.0 + _degrees) /_degrees).floor(), (index) => index * _degrees).map((e) {
      LatLng coord = projection(this.centerPoint, e, this.radius, defaultEllipsoid());

      // if there is a huge longitude step around the world (nearly 360°)
      // then one coordinate is place to the left side of the map, the next one to the right (or vice versa)
      // this yields in a nasty line right over the whole map. In that case, there is no circle
      // To avoid this the coordinate should be sorted. This works only in that case.
      // In normal cases, this would ruin your circle
      if (_prevLongitude != null) {
        if ((_prevLongitude - coord.longitude).abs() > 350)
          shouldSort = true;
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