import 'dart:convert';

import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/model.dart';
import 'package:gc_wizard/utils/persistence_utils.dart';
import 'package:prefs/prefs.dart';

void refreshMapViews() {
  var rawMapViews = Prefs.getStringList(PREFERENCE_MAPVIEW_MAPVIEWS);
  if (rawMapViews == null || rawMapViews.length == 0) return;

  mapViews = rawMapViews.where((view) => view.length > 0).map((view) {
    return MapViewDAO.fromJson(jsonDecode(view));
  }).toList();
}

clearMapViewDAO(MapViewDAO view) {
  view.polylines.clear();
  view.points.clear();

  _saveData();
}

_saveData() {
  var jsonData = mapViews.map((view) => jsonEncode(view.toMap())).toList();

  Prefs.setStringList(PREFERENCE_MAPVIEW_MAPVIEWS, jsonData);
}

int insertMapViewDAO(MapViewDAO view) {
  view.name = view.name ?? '';
  var id = newID(mapViews.map((view) => view.id).toList());
  view.id = id;
  mapViews.add(view);

  _saveData();

  return id;
}

void updateMapViews() {
  _saveData();
}

void deleteMapViewDAO(int viewId) {
  mapViews.removeWhere((group) => group.id == viewId);

  _saveData();
}

void insertMapPointDAO(MapPointDAO point, MapViewDAO mapView) {
  mapView.points.add(point);

  _saveData();
}

void updateMapPointDAO(MapPointDAO point, MapViewDAO mapView) {
  mapView.points = mapView.points.map((mapPoint) {
    if (mapPoint.uuid == point.uuid) return point;

    return mapPoint;
  }).toList();

  _saveData();
}

void deleteMapPointDAO(String pointUUID, MapViewDAO mapView) {
  mapView.points.removeWhere((point) => point.uuid == pointUUID);

  _saveData();
}

void insertMapPolylineDAO(MapPolylineDAO polyline, MapViewDAO mapView) {
  mapView.polylines.add(polyline);

  _saveData();
}

void updateMapPolylineDAO(MapPolylineDAO polyline, MapViewDAO mapView) {
  mapView.polylines = mapView.polylines.map((mapPolyline) {
    if (mapPolyline.uuid == polyline.uuid) return polyline;

    return mapPolyline;
  }).toList();

  _saveData();
}

void deleteMapPolylineDAO(String polylineUUID, MapViewDAO mapView) {
  mapView.polylines.removeWhere((polyline) => polyline.uuid == polylineUUID);

  _saveData();
}

String jsonMapViewData(MapViewDAO view) {
  return jsonEncode(view.toMap());
}

MapViewDAO restoreJsonMapViewData(String view) {
  return MapViewDAO.fromJson(jsonDecode(view));
}
