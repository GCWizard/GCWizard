part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleNagel(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Nagel-Punkt

  Sides sides = triangleSidesXY(a, b, c);

  double ac = (sides.a - sides.b + sides.c) / 2;
  double ab = (sides.a + sides.b - sides.c) / 2;

  XYPoint bExB = _vectorAdd(a, _vectorMult(_vectorNormalize(_vectorAB(a, c)), ab));
  XYPoint bExA = _vectorAdd(c, _vectorMult(_vectorNormalize(_vectorAB(c, b)), ac));

  XYPoint N = intersectVectors(
      XYLine(P1: a, P2: bExA),
      XYLine(P1: b, P2: bExB)
  );
  return N;
}