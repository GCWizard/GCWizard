import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/coordinate_cell.dart';
import 'package:latlong2/latlong.dart';

abstract class IntervalCalculatorParameters {}

abstract class IntervalCalculator {
  final _MAX_CELLCOUNT = 10000;
  final _deltaResults = 1e-5;

  List<LatLng> results = [];
  List<CoordinateCell> cells = [];
  IntervalCalculatorParameters parameters;
  Ellipsoid ells;
  double eps = 1e-13;
  bool _overlap = false;

  IntervalCalculator(this.parameters, this.ells);

  bool checkCell(CoordinateCell cell, IntervalCalculatorParameters parameters);

  bool _resultExists(LatLng point) {
    for (LatLng result in results) {
      double lat = result.latitudeInRad;
      double lon = result.longitudeInRad;

      if (((lat - point.latitudeInRad).abs() <= _deltaResults) &&
          (min((lon - point.longitudeInRad).abs(), 360 - (lon - point.longitudeInRad).abs()) <= _deltaResults)) {
        return true;
      }
    }

    return false;
  }

  void _divideCell(CoordinateCell cell) {
    var lat = cell.latInterval;
    var lon = cell.lonInterval;

    //Check if interval too small
    if ((lat.b - lat.a < eps) && (lon.b - lon.a < eps)) {
      var cellCenter = cell.cellCenter;

      if (!_resultExists(cellCenter)) {
        results.add(cellCenter);
      }
    } else {
      if (checkCell(cell, parameters) && (cells.length < _MAX_CELLCOUNT)) {
        if (cell.maxHeight > cell.maxWidth) {
          double mLat = (lat.a + lat.b) / 2;
          double overlapValue = _overlap ? (lat.b - lat.a) / 10 : 0;

          cells.add(CoordinateCell(
              latInterval: Interval(a: mLat - overlapValue, b: lat.b), lonInterval: lon, ellipsoid: ells));
          cells.add(CoordinateCell(
              latInterval: Interval(a: lat.a, b: mLat + overlapValue), lonInterval: lon, ellipsoid: ells));
        } else {
          double mLon = (lon.a + lon.b) / 2;
          double overlapValue = _overlap ? (lat.b - lat.a) / 20 : 0;

          cells.add(CoordinateCell(
              latInterval: lat, lonInterval: Interval(a: mLon - overlapValue, b: lon.b), ellipsoid: ells));
          cells.add(CoordinateCell(
              latInterval: lat, lonInterval: Interval(a: lon.a, b: mLon + overlapValue), ellipsoid: ells));
        }
      }
    }
  }

  //Splitting the initial whole-world-interval smaller pieces for
  //avoiding creepy effects on bearing calculations
  void _initializeCells(CoordinateCell cell, [int depth = 0]) {
    if (depth == 2) {
      cells.add(cell);
      return;
    }

    var lat = cell.latInterval;
    var lon = cell.lonInterval;

    double mLat = (lat.a + lat.b) / 2.0;
    double mLon = (lon.a + lon.b) / 2.0;

    _initializeCells(
        CoordinateCell(
            latInterval: Interval(a: lat.a, b: mLat), lonInterval: Interval(a: lon.a, b: mLon), ellipsoid: ells),
        depth + 1);

    _initializeCells(
        CoordinateCell(
            latInterval: Interval(a: mLat, b: lat.b), lonInterval: Interval(a: lon.a, b: mLon), ellipsoid: ells),
        depth + 1);

    _initializeCells(
        CoordinateCell(
            latInterval: Interval(a: lat.a, b: mLat), lonInterval: Interval(a: mLon, b: lon.b), ellipsoid: ells),
        depth + 1);

    _initializeCells(
        CoordinateCell(
            latInterval: Interval(a: mLat, b: lat.b), lonInterval: Interval(a: mLon, b: lon.b), ellipsoid: ells),
        depth + 1);
  }

  List<LatLng> check() {
    var easternCells = CoordinateCell(
        latInterval: Interval(a: -pi / 2.0, b: pi / 2.0), lonInterval: Interval(a: 0.0, b: pi), ellipsoid: ells);

    var westernCells = CoordinateCell(
        latInterval: Interval(a: -pi / 2.0, b: pi / 2.0), lonInterval: Interval(a: -pi, b: 0.0), ellipsoid: ells);

    _initializeCells(easternCells);
    _initializeCells(westernCells);

    while (cells.isNotEmpty) {
      _divideCell(cells.first);
      cells.removeAt(0);
    }

    //when no result found, try with overlapped intervals
    // -> extremely slow for whatever purposes, but useful for edge cases
    if (results.isEmpty && _overlap == false) {
      _overlap = true;
      return check();
    }

    return results;
  }
}
