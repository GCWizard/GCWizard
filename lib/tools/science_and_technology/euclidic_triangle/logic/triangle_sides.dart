part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Sides triangleSidesXY(XYPoint A, XYPoint B, XYPoint C,){
  return Sides(
    c: _vectorLength(_vectorAB(A, B)),
    b: _vectorLength(_vectorAB(A, C)),
    a: _vectorLength(_vectorAB(B, C)),
  );
}

Sides? triangleSidesMap(LatLng _AMap, LatLng _BMap, LatLng _CMap){
  return Sides(
    a: distanceBearing(_BMap, _CMap, defaultEllipsoid).distance,
    b: distanceBearing(_AMap, _CMap, defaultEllipsoid).distance,
    c: distanceBearing(_BMap, _AMap, defaultEllipsoid).distance,
  );
}