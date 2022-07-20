import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/coords/map_view/gcw_map_geometries/widget/gcw_map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/gcw_mapview/widget/gcw_mapview.dart';

class MapView extends StatefulWidget {
  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  var points = <GCWMapPoint>[];
  var polyGeodetics = <GCWMapPolyline>[];

  @override
  Widget build(BuildContext context) {
    return GCWMapView(
      points: points,
      polylines: polyGeodetics,
      isEditable: true,
    );
  }
}
