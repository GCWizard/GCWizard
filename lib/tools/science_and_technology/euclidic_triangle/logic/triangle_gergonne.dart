part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleGergonne(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Gergonne-Punkt
  // https://mathworld.wolfram.com/GergonnePoint.html
  XYCircle MC = triangleInCircleXY(A, B, C);
  XYPoint M = XYPoint(x: MC.x, y: MC.y);
  XYPoint X = intersectVectors(
      XYLine(P1: B, P2: _vectorAB(B, C)),
      XYLine(P1: M, P2: _vectorNorm(_vectorAB(B, C)))
  );
  XYPoint Z = intersectVectors(
      XYLine(P1: A, P2: _vectorAB(A, B)),
      XYLine(P1: M, P2: _vectorNorm(_vectorAB(A, B)))
  );
  return intersectVectors(
    XYLine(P1: A, P2: _vectorAB(A, X)),
    XYLine(P1: C, P2: _vectorAB(C, Z)),
  );
}