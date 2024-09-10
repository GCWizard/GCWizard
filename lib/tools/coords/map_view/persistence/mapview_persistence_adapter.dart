import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_definition.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/json_provider.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/model.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';
import 'package:gc_wizard/tools/coords/rhumb_line/logic/rhumb_line.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/color_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class MapViewPersistenceAdapter {
  final GCWMapView mapWidget;
  late MapViewDAO _mapViewDAO;

  MapViewPersistenceAdapter(this.mapWidget) {
    _initializeMapView();
  }

  static MapPointDAO gcwMapPointToMapPointDAO(GCWMapPoint gcwMapPoint) {
    return MapPointDAO(
        gcwMapPoint.uuid!,
        gcwMapPoint.markerText,
        gcwMapPoint.point.latitude,
        gcwMapPoint.point.longitude,
        persistenceKeyByCoordinateFormatKey(gcwMapPoint.coordinateFormat!.type),
        gcwMapPoint.isVisible,
        colorToHexString(gcwMapPoint.color),
        gcwMapPoint.hasCircle() ? gcwMapPoint.circle!.radius : null,
        gcwMapPoint.circleColorSameAsPointColor,
        gcwMapPoint.hasCircle() ? colorToHexString(gcwMapPoint.circle!.color) : null,
        gcwMapPoint.isEditable);
  }

  GCWMapPoint _mapPointDAOToGCWMapPoint(MapPointDAO mapPointDAO) {
    var coords = LatLng(mapPointDAO.latitude, mapPointDAO.longitude);

    return GCWMapPoint(
        uuid: mapPointDAO.uuid,
        markerText: mapPointDAO.name,
        point: coords,
        coordinateFormat: CoordinateFormat.fromPersistenceKey(mapPointDAO.coordinateFormat),
        isVisible: mapPointDAO.isVisible,
        color: hexStringToColor(mapPointDAO.color),
        circle: mapPointDAO.radius != null
            ? GCWMapCircle(
                centerPoint: coords,
                radius: mapPointDAO.radius!,
                color: hexStringToColor(mapPointDAO.circleColor ?? mapPointDAO.color))
            : null,
        circleColorSameAsPointColor: mapPointDAO.circleColorSameAsColor,
        isEditable: mapPointDAO.isEditable ?? false);
  }

  static MapPolylineDAO gcwMapPolylineToMapPolylineDAO(GCWMapPolyline gcwMapPolyline) {
    return MapPolylineDAO(gcwMapPolyline.uuid!, gcwMapPolyline.points.map((GCWMapPoint point) => point.uuid!).toList(),
        colorToHexString(gcwMapPolyline.color), gcwMapLineTypeFromEnumValue(gcwMapPolyline.type));
  }

  GCWMapPolyline _mapPolylineDAOToGCWMapPolyline(MapPolylineDAO mapPolylineDAO) {
    return GCWMapPolyline(
        uuid: mapPolylineDAO.uuid,
        points: mapPolylineDAO.pointUUIDs
            .where((uuid) => mapWidget.points.firstWhereOrNull((GCWMapPoint point) => point.uuid == uuid) != null)
            .map((uuid) => mapWidget.points.firstWhere((GCWMapPoint point) => point.uuid == uuid))
            .toList(),
        color: hexStringToColor(mapPolylineDAO.color),
        type: GCWMapLineType.values.firstWhere((element) => gcwMapLineTypeFromEnumValue(element) == mapPolylineDAO.type,
            orElse: () => GCWMapLineType.GEODETIC));
  }

  void _initializeMapView() {
    refreshMapViews();

    if (mapViews.isEmpty) {
      insertMapViewDAO(MapViewDAO([], []));
    }
    _mapViewDAO = mapViews.last;
    _restoreMapViewDAO();
  }

  void _restoreMapViewDAO() {
    _mapViewDAO.points.addAll(mapWidget.points
        .where((point) => !_mapViewDAO.points.map((pointDAO) => pointDAO.uuid).toList().contains(point.uuid))
        .map((point) => gcwMapPointToMapPointDAO(point))
        .toList());

    mapWidget.points.addAll(_mapViewDAO.points
        .where((pointDAO) => !mapWidget.points.map((point) => point.uuid).toList().contains(pointDAO.uuid))
        .map((pointDAO) => _mapPointDAOToGCWMapPoint(pointDAO))
        .toList());

    _mapViewDAO.polylines.addAll(mapWidget.polylines
        .where((polyline) =>
            !_mapViewDAO.polylines.map((polylineDAO) => polylineDAO.uuid).toList().contains(polyline.uuid))
        .map((polyline) => gcwMapPolylineToMapPolylineDAO(polyline))
        .toList());

    mapWidget.polylines.addAll(_mapViewDAO.polylines
        .where((polylineDAO) =>
            !mapWidget.polylines.map((polyline) => polyline.uuid).toList().contains(polylineDAO.uuid))
        .map((polylineDAO) => _mapPolylineDAOToGCWMapPolyline(polylineDAO))
        .toList());

    updateMapViews();
  }

  GCWMapPoint addMapPoint(LatLng coordinate, {CoordinateFormat? coordinateFormat}) {
    var random = Random();
    var mapPoint = GCWMapPoint(
        point: coordinate,
        coordinateFormat: coordinateFormat ?? defaultCoordinateFormat,
        isEditable: true,
        color: HSVColor.fromAHSV(1.0, random.nextDouble() * 360.0, 1.0, random.nextDouble() / 2 + 0.5).toColor(),
        circleColorSameAsPointColor: true);

    insertMapPointDAO(gcwMapPointToMapPointDAO(mapPoint), _mapViewDAO);

    mapWidget.points.add(mapPoint);
    return mapPoint;
  }

  MapPointDAO _mapPointDAOByUUID(String uuid) {
    return _mapViewDAO.points.firstWhere((point) => point.uuid == uuid);
  }

  MapPolylineDAO _mapPolylineDAOByUUID(String uuid) {
    return _mapViewDAO.polylines.firstWhere((polyline) => polyline.uuid == uuid);
  }

  void updateMapPoint(GCWMapPoint mapPoint) {
    mapPoint.update();

    var mapPointDAO = _mapPointDAOByUUID(mapPoint.uuid!);

    mapPointDAO.name = mapPoint.markerText;
    mapPointDAO.latitude = mapPoint.point.latitude;
    mapPointDAO.longitude = mapPoint.point.longitude;
    mapPointDAO.coordinateFormat = persistenceKeyByCoordinateFormatKey(mapPoint.coordinateFormat!.type);
    mapPointDAO.isVisible = mapPoint.isVisible;
    mapPointDAO.color = colorToHexString(mapPoint.color);
    mapPointDAO.radius = mapPoint.hasCircle() ? mapPoint.circle!.radius : null;
    mapPointDAO.circleColorSameAsColor = mapPoint.circleColorSameAsPointColor;
    mapPointDAO.circleColor = mapPoint.hasCircle() ? colorToHexString(mapPoint.circle!.color) : null;
    mapPointDAO.isEditable = mapPoint.isEditable;

    updateMapPointDAO(mapPointDAO, _mapViewDAO);

    mapWidget.polylines
        .where((polyline) => polyline.points.contains(mapPoint))
        .forEach((polyline) => updateMapPolyline(polyline));
  }

  void updateMapPolyline(GCWMapPolyline polyline) {
    polyline.update();

    var mapPolylineDAO = _mapPolylineDAOByUUID(polyline.uuid!);
    mapPolylineDAO.pointUUIDs = polyline.points.map((GCWMapPoint point) => point.uuid!).toList();
    mapPolylineDAO.color = colorToHexString(polyline.color);
    mapPolylineDAO.type = gcwMapLineTypeFromEnumValue(polyline.type);

    updateMapPolylineDAO(mapPolylineDAO, _mapViewDAO);
  }

  void removeMapPointFromMapPolyline(GCWMapPoint mapPoint) {
    var removablePolylines = <GCWMapPolyline>[];
    for (var polyline in mapWidget.polylines) {
      var polylineDAO = _mapPolylineDAOByUUID(polyline.uuid!);

      while (polyline.points.contains(mapPoint)) {
        polyline.points.remove(mapPoint);
        polylineDAO.pointUUIDs.remove(mapPoint.uuid);
      }

      if (polyline.points.length < 2) {
        removablePolylines.add(polyline);
      } else {
        polyline.update();
        updateMapPolylineDAO(polylineDAO, _mapViewDAO);
      }
    }

    for (var polyline in removablePolylines) {
      removeMapPolyline(polyline);
    }
  }

  void removeMapPoint(GCWMapPoint mapPoint) {
    removeMapPointFromMapPolyline(mapPoint);

    mapWidget.points.remove(mapPoint);
    deleteMapPointDAO(mapPoint.uuid!, _mapViewDAO);
  }

  void removeMapPolyline(GCWMapPolyline polyline, {bool removePoints = false}) {
    mapWidget.polylines.remove(polyline);
    deleteMapPolylineDAO(polyline.uuid!, _mapViewDAO);

    if (removePoints) {
      for (var point in polyline.points) {
        for (GCWMapPolyline anotherPolyline in mapWidget.polylines) {
          if (anotherPolyline.uuid == polyline.uuid) continue;

          if (anotherPolyline.points.contains(point)) continue;
        }

        removeMapPoint(point);
      }
    }
  }

  void clearMapView() {
    mapWidget.points.clear();
    mapWidget.polylines.clear();
    clearMapViewDAO(_mapViewDAO);
  }

  GCWMapPolyline createMapPolyline() {
    var polyline = GCWMapPolyline(points: []);
    mapWidget.polylines.add(polyline);
    insertMapPolylineDAO(gcwMapPolylineToMapPolylineDAO(polyline), _mapViewDAO);

    return polyline;
  }

  void addMapPointIntoPolyline(GCWMapPoint mapPoint, GCWMapPolyline polyline) {
    polyline.points.add(mapPoint);
    polyline.update();

    var polylineDAO = _mapPolylineDAOByUUID(polyline.uuid!);
    polylineDAO.pointUUIDs.add(mapPoint.uuid!);
    updateMapPolylineDAO(polylineDAO, _mapViewDAO);
  }

  void cleanPolyLine(GCWMapPolyline polyline) {
    if (polyline.points.length < 2) {
      removeMapPolyline(polyline);
      return;
    }

    var prevUUID = polyline.points.first.uuid;
    var deleteableIndexes = <int>[];
    for (int i = 1; i < polyline.points.length; i++) {
      if (polyline.points[i].uuid == prevUUID) {
        deleteableIndexes.add(i);
      } else {
        prevUUID = polyline.points[i].uuid;
      }
    }

    var polylineDAO = _mapPolylineDAOByUUID(polyline.uuid!);

    for (int i = deleteableIndexes.length - 1; i > 0; i--) {
      var index = deleteableIndexes[i];
      polyline.points.removeAt(index);
      polylineDAO.pointUUIDs.removeAt(index);
    }

    polyline.update();
    updateMapPolylineDAO(polylineDAO, _mapViewDAO);

    if (polyline.points.length < 2) {
      removeMapPolyline(polyline);
      return;
    }
  }

  void cleanPolylines() {
    for (var polyline in mapWidget.polylines) {
      cleanPolyLine(polyline);
    }
  }

  void switchPointInPolyline(GCWMapPolyline polyline, GCWMapPoint from, GCWMapPoint to) {
    var polylineDAO = _mapPolylineDAOByUUID(polyline.uuid!);

    for (int i = 0; i < polyline.points.length; i++) {
      if (polyline.points[i].uuid == from.uuid) {
        polyline.points.removeAt(i);
        polylineDAO.pointUUIDs.removeAt(i);

        polyline.points.insert(i, to);
        polylineDAO.pointUUIDs.insert(i, to.uuid!);
      }
    }

    polyline.update();
    updateMapPolylineDAO(polylineDAO, _mapViewDAO);
  }

  bool polylineContains(GCWMapPolyline polyline, GCWMapPoint point) {
    for (var p in polyline.points) {
      if (p.uuid == point.uuid) {
        return true;
      }
    }

    return false;
  }

  List<GCWMapPolyline> polylinesWithPoint(GCWMapPoint point) {
    return mapWidget.polylines.where((polyline) => polylineContains(polyline, point)).toList();
  }

  void mergePoint(List<GCWMapPoint> samePoints) {
    var lat = samePoints.fold(0.0, (t, point) => t + point.point.latitude) / samePoints.length;
    var lon = samePoints.fold(0.0, (t, point) => t + point.point.longitude) / samePoints.length;
    var isEditable = samePoints.fold(true, (t, point) => t && point.isEditable);
    var isVisible = samePoints.fold(false, (t, point) => t || point.isVisible);

    var newPoint = addMapPoint(LatLng(lat, lon));
    newPoint.isEditable = isEditable;
    newPoint.isVisible = isVisible;
    newPoint.color = COLOR_MAP_POINT;

    for (var point in samePoints) {
      var includingPolylines = polylinesWithPoint(point);
      for (var polyline in includingPolylines) {
        switchPointInPolyline(polyline, point, newPoint);
      }
      removeMapPoint(point);
    }
  }

  bool _isMergeableDistance(LatLng a, LatLng b) {
    // below 2 meters, there's nearly no visible difference of points
    return distanceBearing(a, b, defaultEllipsoid).distance < 1.8;
  }

  void mergePoints() {
    var checkPoints = List<GCWMapPoint>.from(mapWidget.points);
    while (checkPoints.isNotEmpty) {
      var mergeablePoints = [checkPoints.last];
      checkPoints.removeLast();
      var samePoints = checkPoints.where((point) => _isMergeableDistance(point.point, mergeablePoints.first.point)).toList();
      for (var samePoint in samePoints) {
        checkPoints.removeWhere((point) => point.uuid == samePoint.uuid);
      }
      mergeablePoints.addAll(samePoints);
      if (mergeablePoints.length > 1) {
        mergePoint(mergeablePoints);
      }
    }
  }

  String getJsonMapViewData() {
    var json = jsonMapViewData(_mapViewDAO);
    var regExp = RegExp("(\"uuid\":\")([^\"]+)(\")");
    var id = 1;
    regExp.allMatches(json).forEach((uuid) {
      if (uuid.group(2) == null) return;

      json = json.replaceAll(uuid.group(2)!, id.toString());
      id++;
    });
    json = _removeEmptyElements(json);
    return _replaceJsonMarker(json, false);
  }

  bool setJsonMapViewData(String json) {
    try {
      json = _replaceJsonMarker(json, true);
      json = _restoreUUIDs(json);
      var viewData = restoreJsonMapViewData(json);

      addViewData(viewData);
      return true;
    } on Exception {}
    return false;
  }

  void addViewData(MapViewDAO viewData) {
    _addMapViewDAO(viewData);
    _restoreMapViewDAO();
    updateMapViews();
  }

  String _replaceJsonMarker(String json, bool restore) {
    var replaceMap = {
      "\"uuid\":": "\"uid\":",
      "\"pointUUIDs\":": "\"pointIDs\":",
      "\"latitude\":": "\"lat\":",
      "\"longitude\":": "\"lon\":",
      "\"isVisible\":": "\"visible\":",
      "\"coordinateFormat\":": "\"format\":",
      "\"circleColorSameAsColor\":": "\"sameColor\":"
    };

    if (restore) replaceMap = switchMapKeyValue(replaceMap);

    return substitution(json, replaceMap);
  }

  String _removeEmptyElements(String json) {
    var regExpList = {
      "(\")([^\"]+)(\":null,)": "",
      "(,\")([^\"]+)(\":null})": "}",
      "(\"name\":\"\",)": "",
      "(\"isVisible\":true,)": "",
      "(\"isVisible\":true})": "}"
    };

    regExpList.forEach((key, value) {
      json = json.replaceAll(RegExp(key), value);
    });
    return json;
  }

  String _restoreUUIDs(String json) {
    var regExp = RegExp("(\"uuid\":\")([^\"]+)(\")");
    var regExpPoly = RegExp("(\"pointUUIDs\":\\[)([^\\]]+)(\\])");

    regExp.allMatches(json).forEach((uuid) {
      if (uuid.group(2) == null) return;

      var newId = const Uuid().v4();
      var oldUuid = "\"uuid\":\"" + uuid.group(2)! + "\"";
      var newUuid = "\"uuid\":\"" + newId + "\"";

      json = json.replaceAll(oldUuid, newUuid);

      oldUuid = "\"" + uuid.group(2)! + "\"";
      newUuid = "\"" + newId + "\"";

      regExpPoly.allMatches(json).forEach((oldPolyIDs) {
        if (oldPolyIDs.group(2) == null) return;

        var newPolyIDs = oldPolyIDs.group(2)!.replaceAll(oldUuid, newUuid);
        json = json.replaceAll(oldPolyIDs.group(2)!, newPolyIDs);
      });
    });
    return json;
  }

  void _addMapViewDAO(MapViewDAO viewData) {
    if (viewData.points.isNotEmpty) {
      _mapViewDAO.points.addAll(viewData.points
          .where((pointDAO) => !_mapViewDAO.points.map((point) => point.uuid).toList().contains(pointDAO.uuid))
          .toList());
    }

    if (viewData.polylines.isNotEmpty) {
      _mapViewDAO.polylines.addAll(viewData.polylines
          .where((polyline) =>
              !_mapViewDAO.polylines.map((polylineDAO) => polylineDAO.uuid).toList().contains(polyline.uuid))
          .toList());
    }
  }
}
