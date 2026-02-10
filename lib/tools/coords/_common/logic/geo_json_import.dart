//https://datatracker.ietf.org/doc/html/rfc7946

import 'dart:convert';
import 'dart:core';

import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/model.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:latlong2/latlong.dart';

import 'gpx_kml_gpx_import.dart';

enum geoJsonLabel {
  type,
  geometry,
  coordinates,
  features,
  geometries,
  properties,
  bbox
}

enum geoJsonLabelTypes {
  Point,
  LineString,
  Polygon,
  MultiPoint,
  MultiLineString,
  MultiPolygon,
  Feature,
  FeatureCollection,
  GeometryCollection,
}

class GeoJsonReader {

  MapViewDAO? parse(String input) {
    try {
      if (input.isEmpty) return null;
      var jsonMap = asJsonMap(json.decode(input));

      var list = <({List<GCWMapPoint> points, List<GCWMapPolyline> lines})>[];
      if (jsonMap.containsKey(geoJsonLabel.type.name)) {

        if (jsonMap.containsKey(geoJsonLabel.features.name) &&
            jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.FeatureCollection.name) {

            asJsonArray(jsonMap[geoJsonLabel.features.name]).forEach((jsonFeature) {
              var feature = _parseFeature(jsonFeature);
              if (feature != null) {
                list.add(feature);
              }
            });

        } else if (jsonMap.containsKey(geoJsonLabel.geometry.name) &&
            jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.Feature.name) {

          var feature = _parseFeature(jsonMap);
          if (feature != null) {
            list.add(feature);
          }
        } else if (jsonMap.containsKey(geoJsonLabel.geometries.name) &&
            jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.GeometryCollection.name) {

          var label = _searchLabel(jsonMap);
          asJsonArray(jsonMap[geoJsonLabel.geometries.name]).forEach((jsonGeometry) {
            var geometry = _parseGeometry(jsonGeometry, label);
            if (geometry != null) {
              list.add(geometry);
            }
          });
        }
      }

      if (list.isEmpty) return null;

      // merge lists
      var mapViewEntry = list.first;
      for (var i = 1; i < list.length; i++) {
        mapViewEntry.points.addAll(list[i].points);
        mapViewEntry.lines.addAll(list[i].lines);
      }

      _restorePoints(mapViewEntry.points, mapViewEntry.lines);
      return convertToMapViewDAO(mapViewEntry.points, mapViewEntry.lines);
    } catch (e) {}
    return null;
  }

  void _restorePoints(List<GCWMapPoint> points, List<GCWMapPolyline> lines) {
    for (var line in lines) {
      for(var i = 0; i< line.points.length; i++) {
        for (var point in points) {
          if (equalsLatLng(line.points[i].point, point.point, tolerance: practical_epsilon)) {
            line.points[i] = point;
          }
        }
      }
    }

    var newPoints = lines
        .expand((line) => line.points)
        .where((point) => !points.contains(point))
        .toSet();

    points.addAll(newPoints);
  }

  ({List<GCWMapPoint> points, List<GCWMapPolyline> lines})? _parseFeature(Object? input) {
    var jsonMap = asJsonMap(input);
    if (!jsonMap.containsKey(geoJsonLabel.geometry.name)) return null;

    var label = _searchLabel(jsonMap);
    var geometry = _parseGeometry(jsonMap[geoJsonLabel.geometry.name], label);

    return geometry;
  }

  ({List<GCWMapPoint> points, List<GCWMapPolyline> lines})? _parseGeometry(Object? input, String? label) {
    var jsonMap = asJsonMap(input);
    if (!jsonMap.containsKey(geoJsonLabel.type.name) ||
        !jsonMap.containsKey(geoJsonLabel.coordinates.name)) {
      return null;
    }
    var coordinates =  _parseCoordinates(jsonMap[geoJsonLabel.coordinates.name]);
    if (coordinates.isEmpty) return null;

    var points = <GCWMapPoint>[];
    var lines = <GCWMapPolyline>[];

    if (jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.Point.name) {
      if (coordinates.first.isNotEmpty) {
        points.add(coordinates.first.first);
      }
    } else if (jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.MultiPoint.name) {
      for (var list in coordinates) {
        if (list.isNotEmpty) {
          points.addAll(list);
        }
      }
    } else if (jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.LineString.name)  {
      if (coordinates.first.length > 1) {
        lines.add(GCWMapPolyline(points: coordinates.first));
      }
    } else if (jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.Polygon.name ||
        jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.MultiPolygon.name ||
        jsonMap[geoJsonLabel.type.name] == geoJsonLabelTypes.MultiLineString.name)  {
        for (var list in coordinates) {
          if (list.length > 1) {
            if (equalsLatLng(list.first.point, list.last.point)) {
              list.first = list.last;
            }
            lines.add(GCWMapPolyline(points: list));
          }
      }
    }

    if (label != null) {
      for (var point in points) {
        point.markerText = label;
      }
      for (var line in lines) {
        for (var point in line.points) {
          point.markerText = label;
        }
      }
    }
    return (points: points, lines: lines);
  }

  String? _searchLabel(Map<String, Object?> jsonMap) {
    String? name;
    if (jsonMap.containsKey('name')) {
      name = jsonMap['name']?.toString();
    } else if (jsonMap.containsKey('title')) {
      name = jsonMap['title']?.toString();
    } else if (jsonMap.containsKey(geoJsonLabel.properties.name)) {
      var propertiesMap = asJsonMap(jsonMap[geoJsonLabel.properties.name]);
      if (propertiesMap.containsKey('name')) {
        name = propertiesMap['name']?.toString();
      } else if (propertiesMap.containsKey('title')) {
        name = propertiesMap['title']?.toString();
      }
    }
    return name;
  }

  List<List<GCWMapPoint>> _parseCoordinates(Object? input) {

    bool _isSinglePoint(List<Object?> array) {
      if (array.length == 2) {
        if (getJsonType(array[0]) == JsonType.SIMPLE_TYPE && getJsonType(array[1]) == JsonType.SIMPLE_TYPE) {
          return true;
        }
      }
      return false;
    }

    bool _isPointArray(List<Object?> array) {
      return array.isNotEmpty && _isSinglePoint(array.first as List);
    }

    List<GCWMapPoint> _parsePointArray(Object? _pointArray) {
      var points = asJsonArray(_pointArray).map<GCWMapPoint>((point) {
        var __pointArray = asJsonArray(point);
        if (_isSinglePoint(__pointArray)) {
          var pointString = (__pointArray[1]?.toString() ?? '') + ' ' + (__pointArray[0]?.toString() ?? '');

          var point_ = DECCoordinate.parse(pointString);
          if (point_ != null) {
            return GCWMapPoint(point: point_.toLatLng()!, coordinateFormat: DECCoordinate().format, isEditable: true);
          }
        }
        return GCWMapPoint(point: LatLng(0, 0), isVisible: false);
      }).toList();

      points.removeWhere((mapPoint) => !mapPoint.isVisible);
      return points;
    }

    var coordinates = <List<GCWMapPoint>>[];
    var pointArray = asJsonArray(input);

    void _parsePointList(Object? _pointArray) {
      var __pointArray = asJsonArray(_pointArray);
      if (_isSinglePoint(__pointArray)) {
        coordinates.add(_parsePointArray([__pointArray]));
      } else if (_isPointArray(__pointArray)) {
        coordinates.add(_parsePointArray(__pointArray));
      } else {
        for (var _pointArray in __pointArray) {
          _parsePointList(_pointArray);
        }
      }
    }

    _parsePointList(pointArray);

    coordinates.removeWhere((list) => list.isEmpty);
    return coordinates;
  }
}