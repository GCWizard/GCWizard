import 'package:flutter/material.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing_data.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart' as geodetic;
import 'package:gc_wizard/tools/coords/rhumb_line/logic/rhumb_line.dart' as rhumbline;
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';
import 'package:uuid/uuid.dart';

enum MapPrecision {LOW, HIGH}

MapPrecision getMapPrecision() {
  var prefMapPrecision = Prefs.getString(PREFERENCE_COORD_MAP_DEFAULT_PRECISION_GEOMETRIES);
  return MapPrecision.values.firstWhere((e) => e.toString() == prefMapPrecision);
}

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

  void update({MapPrecision? precision}) {
    if (circle != null) {
      circle!.centerPoint = point;

      if (circleColorSameAsPointColor) circle!.color = color;

      circle!._update(precision: precision);
    }
  }
}

abstract class GCWMapSimpleGeometry {}

class GCWMapLine extends GCWMapSimpleGeometry {
  final GCWMapPolyline parent;
  final GCWMapPoint start;
  final GCWMapPoint? end;
  final GCWMapLineType type;

  double length = 0.0;
  late double bearingAB;
  late double bearingBA;

  List<LatLng> shape = [];

  GCWMapLine({required this.parent, required this.start, this.end, this.type = GCWMapLineType.GEODETIC, MapPrecision? precision}) {
    if (end == null) {
      shape.add(start.point);
      return;
    }

    var _precision = precision ?? getMapPrecision();

    shape.add(start.point);
    switch (type) {
      case GCWMapLineType.GEODETIC:
          _calculateGeodeticShape(_precision);
        break;
      case GCWMapLineType.RHUMB:
        _calculateRhumbShape();
        break;
    }
  }

  void _calculateRhumbShape() {
    _calculateLineShape(rhumbline.projectionRhumbline, rhumbline.distanceBearingRhumbline, 10000.0);
  }

  void _calculateGeodeticShape(MapPrecision precision) {
    _calculateLineShape(
        precision == MapPrecision.LOW ? projectionVincenty : projection,
        precision == MapPrecision.LOW ? geodetic.distanceBearingVincenty : geodetic.distanceBearing,
        precision == MapPrecision.LOW ? 5000.0 : 500.0
    );
  }

  void _calculateLineShape(LatLng Function(LatLng, double, double, Ellipsoid) projection,
      DistanceBearingData Function(LatLng, LatLng, Ellipsoid) distanceBearing, double stepLengthInM) {
    DistanceBearingData _distBear = distanceBearing(start.point, end!.point, defaultEllipsoid);
    length = _distBear.distance;
    bearingAB = _distBear.bearingAToB;
    bearingBA = _distBear.bearingBToA;

    var _countSteps = (_distBear.distance / stepLengthInM).floor();

    for (int _i = 1; _i < _countSteps; _i++) {
      var _nextPoint = projection(start.point, _distBear.bearingAToB, stepLengthInM * _i, defaultEllipsoid);
      shape.add(_nextPoint);
    }

    shape.add(end!.point);
  }
}

class GCWMapPolyline {
  String? uuid;
  List<GCWMapPoint> points;
  Color color;
  GCWMapLineType type;

  double get length => lines.fold(0.0, (previousValue, line) => previousValue + line.length);

  late List<GCWMapLine> lines;

  GCWMapPolyline(
      {this.uuid, required this.points, this.color = COLOR_MAP_POLYLINE, this.type = GCWMapLineType.GEODETIC}) {
    if (uuid == null || uuid!.isEmpty) uuid = const Uuid().v4();
    update();
  }

  void update({MapPrecision? precision}) {
    print(precision);
    lines = [];

    if (points.isEmpty) {
      return;
    }

    if (points.length == 1) {
      lines.add(GCWMapLine(parent: this, start: points[0], type: type, precision: precision));
      return;
    }

    for (int i = 1; i < points.length; i++) {
      lines.add(GCWMapLine(parent: this, start: points[i - 1], end: points[i], type: type, precision: precision));
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

  void _update({MapPrecision? precision}) {
    if (radius <= 0.0) {
      shape = [];
      return;
    }

    var _precision = precision ?? getMapPrecision();
    var _degrees = _precision == MapPrecision.LOW ? 0.5 : 0.1;

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

enum GCWMapLineType { GEODETIC, RHUMB }
