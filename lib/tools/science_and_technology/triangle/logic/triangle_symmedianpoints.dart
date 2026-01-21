part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

List<XYPoint> triangleSymmediandPointsXY(XYPoint A, XYPoint B, XYPoint C,){

  List<XYPoint> sidesMidpoint = [];
  Sides sides = triangleSidesXY(A, B, C);

  XYPoint MA = _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(B, C))), sides.a / 2));
  XYPoint MB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, C))), sides.b / 2));
  XYPoint MC = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, B))), sides.c / 2));

  sidesMidpoint.add(XYPoint(x: MA.x, y: MA.y));
  sidesMidpoint.add(XYPoint(x: MB.x, y: MB.y));
  sidesMidpoint.add(XYPoint(x: MC.x, y: MC.y));

  return sidesMidpoint;
}

