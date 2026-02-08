part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

List<XYPoint> triangleAltitudesBasePointsXY(XYPoint A, XYPoint B, XYPoint C,){
  List<XYPoint> result = [];
  XYPoint H = triangleOrthocenterXY(A, B, C);

  result.add(intersectVectors(
      XYLine(P1: B, P2: _vectorDiv(_vectorAB(B, C), _vectorLength(_vectorAB(B, C)))),
      XYLine(P1: A, P2: _vectorDiv(_vectorAB(A, H), _vectorLength(_vectorAB(A, H))))));
  result.add(intersectVectors(
      XYLine(P1: A, P2: _vectorDiv(_vectorAB(A, C), _vectorLength(_vectorAB(A, C)))),
      XYLine(P1: B, P2: _vectorDiv(_vectorAB(B, H), _vectorLength(_vectorAB(B, H))))));
  result.add(intersectVectors(
      XYLine(P1: A, P2: _vectorDiv(_vectorAB(A, B), _vectorLength(_vectorAB(A, B)))),
      XYLine(P1: C, P2: _vectorDiv(_vectorAB(C, H), _vectorLength(_vectorAB(C, H))))));
  return result;
}

