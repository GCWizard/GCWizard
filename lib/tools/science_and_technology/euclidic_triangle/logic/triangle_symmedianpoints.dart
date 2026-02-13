part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

List<XYPoint> triangleSymmediandPointsXY(XYPoint a, XYPoint b, XYPoint c){

  List<XYPoint> sidesMidpoint = [];
  Sides sides = triangleSidesXY(a, b, c);

  XYPoint mA = _vectorAdd(b, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(b, c))), sides.a / 2));
  XYPoint mB = _vectorAdd(a, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(a, c))), sides.b / 2));
  XYPoint mC = _vectorAdd(a, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(a, b))), sides.c / 2));

  sidesMidpoint.add(XYPoint(x: mA.x, y: mA.y));
  sidesMidpoint.add(XYPoint(x: mB.x, y: mB.y));
  sidesMidpoint.add(XYPoint(x: mC.x, y: mC.y));

  return sidesMidpoint;
}

