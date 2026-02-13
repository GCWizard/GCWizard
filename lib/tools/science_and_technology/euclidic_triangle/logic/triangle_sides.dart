part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Sides triangleSidesXY(XYPoint a, XYPoint b, XYPoint c){
  return Sides(
    c: _vectorLength(_vectorAB(a, b)),
    b: _vectorLength(_vectorAB(a, c)),
    a: _vectorLength(_vectorAB(b, c)),
  );
}

Sides? triangleSidesMap(LatLng aMap, LatLng bMap, LatLng cMap){
  return Sides(
    a: distanceBearing(bMap, cMap, defaultEllipsoid).distance,
    b: distanceBearing(aMap, cMap, defaultEllipsoid).distance,
    c: distanceBearing(bMap, aMap, defaultEllipsoid).distance,
  );
}