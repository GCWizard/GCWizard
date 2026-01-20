part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint triangleNagel(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Nagel-Punkt

  Sides sides = triangleSides(A, B, C);

  double ac = (sides.a - sides.b + sides.c) / 2;
  double ab = (sides.a + sides.b - sides.c) / 2;

  XYPoint BexB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), ab));
  XYPoint BexA = _vectorAdd(C, _vectorMult(_vectorNormalize(_vectorAB(C, B)), ac));

  XYPoint N = intersectVectors(
      XYLine(P1: A, P2: BexA),
      XYLine(P1: B, P2: BexB)
  );
  return N;
}